require 'rails_helper'

RSpec.describe DemoController do
  let(:demo) { described_class.new }

  describe "#image_url" do
    context "when there is no uploaded url" do
      before do
        allow_any_instance_of(described_class).to receive(:upload_image_url).and_return(nil)
      end

      it "returns the default url" do
        expect(demo.send(:image_url)).to eq demo.send(:default_image_url)
      end
    end

    context "when there is an uploaded url" do
      before do
        allow_any_instance_of(described_class).to receive(:upload_image_url).and_return("foo")
      end

      it "returns the default url" do
        expect(demo.send(:image_url)).to eq "foo"
      end
    end
  end

  describe "#process_image" do
    let(:word_collection) do
      Shear::WordCollection.new.tap do |w|
        w.push_word('LICENCIA', bounding_box: [[314, 49], [420, 49], [420, 71], [314, 71]])
        w.push_word('DE', bounding_box: [[430, 49], [458, 49], [458, 71], [430, 71]])
        w.push_word('CONDUCTOR', bounding_box: [[467, 49], [614, 49], [614, 71], [467, 71]])
        w.push_word('REPUBLICA', bounding_box: [[323, 73], [472, 73], [472, 90], [323, 90]])
        w.push_word('DE', bounding_box: [[483, 73], [515, 73], [515, 90], [483, 90]])
        w.push_word('CHILE', bounding_box: [[526, 73], [607, 73], [607, 90], [526, 90]])
        w.push_word('B', bounding_box: [[433, 127], [437, 127], [437, 144], [433, 144]])
        w.push_word('18936676-0', bounding_box: [[435, 157], [517, 157], [517, 174], [435, 174]])
        w.push_word('N', bounding_box: [[297, 154], [300, 154], [300, 167], [297, 167]])
        w.push_word('DE', bounding_box: [[309, 154], [324, 154], [324, 167], [309, 167]])
        w.push_word('LICENCIA', bounding_box: [[330, 154], [377, 154], [377, 167], [330, 167]])
        w.push_word('MUNICIPIUDAD', bounding_box: [[293, 186], [383, 187], [383, 201], [293, 200]])
        w.push_word('LAS', bounding_box: [[434, 189], [455, 189], [455, 205], [434, 205]])
        w.push_word('CONDES', bounding_box: [[464, 189], [516, 189], [516, 206], [464, 206]])
        w.push_word('NOMBRES', bounding_box: [[296, 221], [349, 221], [349, 233], [296, 233]])
        w.push_word('ANTONIO', bounding_box: [[401, 220], [458, 221], [458, 237], [401, 236]])
        w.push_word('APELLIDOS', bounding_box: [[295, 251], [357, 251], [357, 266], [295, 266]])
        w.push_word('LOPEZ', bounding_box: [[401, 250], [443, 250], [443, 267], [401, 267]])
        w.push_word('LARRAECHEA', bounding_box: [[452, 250], [537, 250], [537, 268], [452, 268]])
        w.push_word('LOPEZ', bounding_box: [[107, 277], [152, 277], [152, 295], [107, 295]])
        w.push_word('LARRAECHEA', bounding_box: [[162, 277], [249, 277], [249, 295], [162, 295]])
        w.push_word('ANTONIO', bounding_box: [[147, 302], [206, 302], [206, 319], [147, 319]])
        w.push_word('18936676-0', bounding_box: [[134, 326], [220, 326], [220, 343], [134, 343]])
        w.push_word('DIRECCION', bounding_box: [[296, 285], [356, 285], [356, 300], [296, 300]])
        w.push_word('MANANTIALES', bounding_box: [[408, 282], [504, 283], [504, 301], [408, 300]])
        w.push_word('304', bounding_box: [[513, 283], [537, 283], [537, 300], [513, 300]])
        w.push_word('LAS', bounding_box: [[352, 301], [374, 301], [374, 320], [352, 320]])
        w.push_word('CONDES', bounding_box: [[382, 301], [434, 301], [434, 320], [382, 320]])
        w.push_word('FECHA', bounding_box: [[295, 318], [333, 318], [333, 333], [295, 333]])
        w.push_word('ULTIMO', bounding_box: [[338, 318], [380, 318], [380, 333], [338, 333]])
        w.push_word('CONTROL', bounding_box: [[386, 318], [440, 318], [440, 334], [386, 334]])
        w.push_word('13/03/2019', bounding_box: [[491, 323], [572, 323], [572, 340], [491, 340]])
        w.push_word('FECHA', bounding_box: [[295, 352], [334, 352], [334, 367], [295, 367]])
        w.push_word('DE', bounding_box: [[337, 352], [353, 352], [353, 367], [337, 367]])
        w.push_word('CONTROL', bounding_box: [[357, 352], [411, 352], [411, 367], [357, 367]])
        w.push_word('033', bounding_box: [[412, 343], [436, 344], [435, 377], [411, 376]])
        w.push_word('20/01/2025', bounding_box: [[457, 344], [542, 346], [541, 380], [456, 378]])
      end
    end

    before do
      allow(Shear::WordCollection).to receive(:build_from_url).and_return(word_collection)
    end

    it "reads all the fields from the image" do
      demo.send(:process_image)
      expect(demo.license_class).to eq "B"
      expect(demo.number).to eq "18936676-0"
      expect(demo.municipality).to eq "LAS CONDES"
      expect(demo.names).to eq "ANTONIO"
      expect(demo.surnames).to eq "LOPEZ LARRAECHEA"
      expect(demo.address).to eq "MANANTIALES 304\nLAS CONDES"
      expect(demo.issue_date).to eq "13/03/2019"
      expect(demo.expiration_date).to eq "20/01/2025"
    end

    it "gets a transformation and an error" do
      demo.send(:process_image)
      expect(demo.transform).to be_an_instance_of(Matrix)
      expect(demo.error).to be >= 0
    end
  end
end
