class DrivingLicenceStencil < BaseStencil
  def self.template
    @template ||= Shear::Template.build do |t|
      t.set 'REPUBLICA', at: [270, 80]
      t.set 'CHILE', at: [483, 80]
      t.set 'DIRECCION', at: [243, 302], label: :address
      t.set 'ULTIMO', at: [286, 337], label: :issue
      t.set 'APELLIDOS', at: [241, 267], label: :surnames
      t.set 'NOMBRES', at: [244, 234], label: :names
      t.set 'MUNICIPALIDAD', at: [240, 199], label: :municipality
      t.set 'CLASE', at: [243, 131], label: :class
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
      "address",
      "issue_date",
      "expiration_date"
    ]
  end

  attr_reader :license_class, :number, :municipality, :names, :surnames
  attr_reader :address, :issue_date, :expiration_date

  def process_match
    @expiration_date = read_relative_if_possible(:issue, [410, 360], [550, 390])
    @issue_date = read_relative_if_possible(:issue, [425, 325], [540, 350])
    @address = read_relative_if_possible(:address, [310, 285], [540, 320])
    @surnames = read_relative_if_possible(:surnames, [333, 253], [540, 280])
    @names = read_relative_if_possible(:names, [330, 220], [540, 248])
    @municipality = read_relative_if_possible(:municipality, [375, 185], [540, 215])
    @license_class = read_relative_if_possible(:class, [315, 115], [460, 145])
    @number = read_relative_if_possible(:class, [375, 150], [540, 180])
  end

  private

  def read_relative_if_possible(_label, _min, _max,
    _exclusion_key: :all, _delete: true, _line_height: 5)
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
