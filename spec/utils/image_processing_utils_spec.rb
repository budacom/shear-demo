require 'rails_helper'

RSpec.describe ImageProcessingUtils do
  let(:utils) { described_class }

  let(:url) do
    "https://upload.wikimedia.org/wikipedia/commons/f/fe/El_ejemplo_de_Cedula_identidad_Chile_2013.jpg"
  end

  describe "#image_from_url" do
    it "returns an image from a image url" do
      expect(utils.image_from_url(url)).to be_an_instance_of(Array)
    end
  end

  describe "#transformed_image" do
    let(:image) do
      [
        [[0, 0, 0], [1, 1, 1]],
        [[2, 2, 2], [3, 3, 3]],
        [[4, 4, 4], [5, 5, 5]]
      ]
    end

    context "when the matrix is an indentity" do
      let(:matrix) do
        Matrix[
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1]
        ]
      end

      context "when the scale is 1" do
        it "returns a new image with the given dimentions" do
          expect(utils.transformed_image(image, matrix, 1, 2, 3).length).to be 3
          expect(utils.transformed_image(image, matrix, 1, 2, 3)[0].length).to be 2
        end

        it "does not change the image" do
          expect(utils.transformed_image(image, matrix, 1, 2, 3)).to eq image
        end
      end

      context "when the scale is not 1" do
        it "returns a new image with the given dimentions but scaled" do
          expect(utils.transformed_image(image, matrix, 4, 2, 3).length).to be 12
          expect(utils.transformed_image(image, matrix, 4, 2, 3)[0].length).to be 8
        end
      end
    end

    context "when the matrix is not an identity" do
      let(:matrix) do
        Matrix[
          [2, 0, 0],
          [0, 1, 0],
          [0, 0, 1]
        ]
      end

      let(:expected_result) do
        [
          [[0, 0, 0], [0, 0, 0], [1, 1, 1], [1, 1, 1]],
          [[2, 2, 2], [2, 2, 2], [3, 3, 3], [3, 3, 3]],
          [[4, 4, 4], [4, 4, 4], [5, 5, 5], [5, 5, 5]]
        ]
      end

      context "when the scale is 1" do
        it "returns a new image with the given dimentions" do
          expect(utils.transformed_image(image, matrix, 1, 4, 3).length).to be 3
          expect(utils.transformed_image(image, matrix, 1, 4, 3)[0].length).to be 4
        end

        it "transforms the image" do
          expect(utils.transformed_image(image, matrix, 1, 4, 3)).to eq expected_result
        end
      end

      context "when the scale is not 1" do
        it "returns a new image with the given dimentions but scaled" do
          expect(utils.transformed_image(image, matrix, 4, 2, 3).length).to be 12
          expect(utils.transformed_image(image, matrix, 4, 2, 3)[0].length).to be 8
        end
      end
    end
  end
end
