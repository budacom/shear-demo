class DrivingLicenceStencil < BaseStencil
  def self.template
    @template ||= Guillotine::Template.build do |t|
      t.set 'LICENCIA', at: [38.057, 5.939], filter: 'big'
      t.set 'CONDUCTOR', at: [56.6, 5.939]
      t.set 'DIRECCION', at: [35.875, 34.542], label: :adress
      t.set 'ULTIMO', at: [40.966, 38.542], label: :issue
      t.set 'CLASE', at: [35.875, 15.392], label: :class
      t.set 'NOMBRES', at: [35.875, 26.785], label: :names
      t.set 'APELLIDOS', at: [35.754, 30.421], label: :surnames
      t.set 'CHILE', at: [63.751, 8.848]
      t.set 'MUNICIPALIDAD', at: [35.512, 22.543], label: :municipality
      t.set_exclusion :class, 'CLASE'
      t.set_exclusion :number, 'LICENCIA'
      t.set_exclusion :municipality, 'MUNICIPALIDAD'
      t.set_exclusion :names, 'NOMBRES'
      t.set_exclusion :surnames, 'APELLIDOS'
      t.set_exclusion :adress, 'DIRECCION'
      t.set_exclusion :adress, 'FECHA'
      t.set_exclusion :adress, 'ULTIMO'
      t.set_exclusion :adress, 'CONTROL'
    end
  end

  def fields
    @fields ||= Set[
      "class",
      "number",
      "municipality",
      "names",
      "surnames",
      "adress",
      "issue_date",
      "expiration_date"
    ]
  end

  attr_reader :class, :number, :municipality, :names, :surnames
  attr_reader :adress, :issue_date, :expiration_date

  def process_match
    @class = read_relative_if_possible(:class, [52.48, 15.392], [52.964, 17.453],
      _exclusion_key: :class).to_s
    @number = read_relative_if_possible(:class, [52.722, 19.028], [62.66, 21.089],
    _exclusion_key: :number).to_s
    @municipality = read_relative_if_possible(:municipality, [52.601, 22.907], [62.539, 24.967],
      _exclusion_key: :municipality).to_s
    @names = read_relative_if_possible(:names, [48.601, 26.664], [42.299, 28.24],
      _exclusion_key: :names).to_s
    @surnames = read_relative_if_possible(:surnames, [48.601, 30.3], [65.268, 32.239],
      _exclusion_key: :surnames).to_s
    @adress = read_relative_if_possible(:adress, [42.662, 34.178], [65.084, 38.784],
      _exclusion_key: :adress, _line_height: 2.0).to_s
    @issue_date = read_relative_if_possible(:issue, [59.509, 39.148], [69.326, 41.208]).to_s
    @expiration_date = read_relative_if_possible(:issue, [55.388, 41.693], [65.569, 46.056]).to_s
  end

  private

  def read_relative_if_possible(_label, _min, _max,
    _exclusion_key: nil, _delete: false, _line_height: 2.0)
    exclusion = _exclusion_key.present? ? DrivingLicenceStencil.template.get_exclusions(_exclusion_key) : Set[]

    if match.labels.include? _label
      reference_location = DrivingLicenceStencil.template.fixtures.find { |fixture| fixture[2] == _label }[1]
      min_relative = [_min[0] - reference_location[0], _min[1] - reference_location[1]]
      max_relative = [_max[0] - reference_location[0], _max[1] - reference_location[1]]
      match.read_relative(_label, min_relative, max_relative,
        line_height: _line_height, exclusion: exclusion, delete: _delete)
    else
      match.read(_max, _min,
        line_height: _line_height, exclusion: exclusion, delete: _delete)
    end
  end
end
