module WorkshopsHelper
  def continent_select_options
    I18n.t('workshop.continents').map do |continent|
      continent
    end
  end

  def timezone_codes
    [
     "ACST",
     "ACWST",
     "AEST",
     "AKDT",
     "ANAT",
     "ART",
     "AoE",
     "BST",
     "CDT",
     "CEST",
     "CHAST",
     "CST",
     "CVT",
     "EDT",
     "GMT",
     "GST",
     "HADT",
     "HAST",
     "IRDT",
     "IST",
     "JST",
     "LHST",
     "LINT",
     "MART",
     "MMT",
     "MSK",
     "NDT",
     "NPT",
     "NUT",
     "PDT",
     "PYT",
     "SBT",
     "TOT",
     "UZT",
     "WGST",
     "WIB"
    ]
  end

  def workshop_text_field(form, attribute, label_text=nil)
    displayed_label_text = label_text.nil? ? form.object.class.human_attribute_name(attribute) : label_text
    result = <<-HTML
        <div class="field">
          #{form.label attribute, label_text}
          #{form.text_field attribute}
        </div>
        <br/>
    HTML

    result.html_safe
  end

  def workshop_text_area(form, attribute, label_text=nil)
    displayed_label_text = label_text.nil? ? form.object.class.human_attribute_name(attribute) : label_text
    result = <<-HTML
        <div class="field">
          #{form.label attribute, displayed_label_text}
          #{form.text_area attribute}
        </div>
        <br/>
    HTML

    result.html_safe
  end

  def workshop_check_box(form, field, label_text)
    result = <<-HTML
      <div class="field">
        #{form.label field, label_text}
        #{form.check_box field}
      </div>
    HTML

    result.html_safe
  end

  def workshop_check_box_with_notes(form, field, checkbox_label_text, notes_label_text = "Notes")
    checkbox = workshop_check_box(form, field, checkbox_label_text)
    notes_text_area = show_workshop_text_attribute_notes(form.object, "#{field}_notes")

    checkbox + notes_text_area
  end

  def workshop_check_box_with_notes_yml(form, attribute)
    checkbox_label_text = form.object.class.human_attribute_name(attribute)
    notes_label_text = form.object.class.human_attribute_name("#{attribute}_notes")

    workshop_check_box_with_notes form, attribute, checkbox_label_text, notes_label_text
  end

  def show_workshop_yes_no(workshop, attribute, label=nil)
    displayed_label_text = label.nil? ? workshop.class.human_attribute_name(attribute) : label
    result = <<-HTML
      <p>
        <strong>#{displayed_label_text}</strong>
        #{ yes_no_html workshop.send(:public_transport_near_venue) }
      </p>
    HTML

    result.html_safe
  end

  def show_workshop_attribute_and_notes(workshop, attribute)
    yes_no = show_workshop_yes_no workshop, attribute
    initial_notes_value = workshop.send("#{attribute}_notes")

    if initial_notes_value.blank?
      yes_no
    else
      yes_no + show_workshop_text_attribute_notes(workshop, "#{attribute}_notes")
    end
  end

  def show_workshop_text_attribute(workshop, attribute)
    displayed_label_text = workshop.class.human_attribute_name(attribute)
    value = workshop.send(attribute)

    result = <<-HTML
      <p>
        <strong>#{displayed_label_text}</strong>
        #{ simple_format value.to_s }
      </p>
    HTML

    result.html_safe
  end

  def show_workshop_text_attribute_notes(workshop, attribute)
    displayed_label_text = "Notes"
    value = workshop.send(attribute)

    result = <<-HTML
      <p>
        <strong>#{displayed_label_text}:</strong>
        #{ simple_format value.to_s }
      </p>
      <br/>
    HTML

    result.html_safe
  end

  def yes_no_html(value)
    value == true ? "Yes" : "No"
  end
end
