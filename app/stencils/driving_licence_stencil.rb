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
      t.set_exclusion :all, 'CLASE'
      t.set_exclusion :all, 'LICENCIA'
      t.set_exclusion :all, 'MUNICIPALIDAD'
      t.set_exclusion :all, 'NOMBRES'
      t.set_exclusion :all, 'APELLIDOS'
      t.set_exclusion :all, 'DIRECCION'
      t.set_exclusion :all, 'FECHA'
      t.set_exclusion :all, 'ULTIMO'
      t.set_exclusion :all, 'CONTROL'
    end
  end

  def fields
    @fields ||= Set[
      "license_class",
      "number",
      "municipality",
      "names",
      "surnames",
      "adress",
      "issue_date",
      "expiration_date"
    ]
  end

  attr_reader :license_class, :number, :municipality, :names, :surnames
  attr_reader :adress, :issue_date, :expiration_date

  def process_match
    @expiration_date = read_relative_if_possible(:issue, [48.0, 41.693], [62.0, 46.056])
    @issue_date = read_relative_if_possible(:issue, [48.0, 39.148], [62.0, 41.693])
    @adress = read_relative_if_possible(:adress, [448.0, 34.178], [62.0, 39.148], _line_height: 2.0)
    @surnames = read_relative_if_possible(:surnames, [48.0, 30.3], [62.0, 34.178])
    @names = read_relative_if_possible(:names, [48.0, 26.664], [62.0, 30.3])
    @municipality = read_relative_if_possible(:municipality, [48.0, 22.907], [62.0, 26.664])
    @number = read_relative_if_possible(:class, [48.0, 19.028], [62.0, 22.907])
    @license_class = read_relative_if_possible(:class, [48.0, 15.392], [62.0, 19.028])
  end

  private

  def read_relative_if_possible(_label, _min, _max,
    _exclusion_key: :all, _delete: true, _line_height: 2.0)
    template = DrivingLicenceStencil.template
    exclusion = _exclusion_key.present? ? template.get_exclusions(_exclusion_key) : Set[]

    if match.labels.include? _label
      reference_location = DrivingLicenceStencil.template.fixtures.find do |fixture|
        fixture[2] == _label
      end[1]
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
