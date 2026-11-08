# frozen_string_literal: true

# Small Liquid filters for the bilingual (en/ko) pages and the CV data in _data/cv.yml.
# bin/build_cv_pdf.py / cv_pdf/cv.typ apply the same rules to the PDF.
module CvFilters
  MONTHS_EN = %w[Jan. Feb. Mar. Apr. May Jun. Jul. Aug. Sep. Oct. Nov. Dec.].freeze

  # {en: "...", ko: "..."} -> the text for `lang`; plain text is returned unchanged.
  def loc(value, lang = "en")
    return value unless value.is_a?(Hash)

    value[lang.to_s] || value["en"] || value.values.first
  end

  # "2024-05" -> "May 2024" (en) / "2024.05" (ko)
  def cv_date(value, lang = "en")
    year, month = value.to_s.split("-")
    return value.to_s if month.nil?

    lang.to_s == "ko" ? "#{year}.#{month}" : "#{MONTHS_EN[month.to_i - 1]} #{year}"
  end

  # Start/end pair -> "Sep. 2019 – Aug. 2025", "Sep. 2025 – Present", "Sep. 2020 –"
  def cv_period(start, finish, lang = "en")
    from = cv_date(start, lang)
    case finish.to_s
    when "" then from
    when "present" then "#{from} – #{lang.to_s == 'ko' ? '현재' : 'Present'}"
    when "open" then "#{from} –"
    else "#{from} – #{cv_date(finish, lang)}"
    end
  end

  # ["최준혁", "김태형"] -> "최준혁, <b>김태형</b>" (names in _data/cv.yml self_names are bolded)
  def cv_authors(authors)
    selves = Array(@context.registers[:site].data.dig("cv", "self_names"))
    Array(authors).map { |a| selves.include?(a) ? "<b>#{a}</b>" : a }.join(", ")
  end
end

Liquid::Template.register_filter(CvFilters)
