require "mini_magick"

module ImageProcessingUtils
  extend self

  def image_from_url(_url)
    MiniMagick::Image.open(_url).get_pixels
  end

  def transformed_image(_image, _matrix, _scaling = 10, _target_width = 85, _target_height = 55)
    width = _target_width * _scaling
    height = _target_height * _scaling
    new_image = Array.new(height) { Array.new(width) { Array.new(3, 0) } }
    transform = _matrix.inverse
    fill_new_image(new_image, transform, _scaling, _image)
    new_image
  end

  private

  def fill_new_image(_new_image, _transform, _scaling, _image)
    _new_image.each_with_index do |row, y|
      row.each_with_index do |pixel, x|
        position = target_position(_transform, x, y, _scaling)

        if inside?(position, _image)
          target_pixel = _image[position[1]][position[0]]
          pixel[0] = target_pixel[0]
          pixel[1] = target_pixel[1]
          pixel[2] = target_pixel[2]
        else
          pixel[0] = 0
          pixel[1] = 255
          pixel[2] = 0
        end
      end
    end
  end

  def target_position(_transform, _origin_x, _origin_y, _scaling)
    x = _origin_x / _scaling
    y = _origin_y / _scaling
    position = _transform * Matrix.column_vector([x, y, 1.0])
    [position[0, 0].to_i, position[1, 0].to_i]
  end

  def inside?(_position, _image)
    height = _image.length
    width = _image[0].length
    return false if _position[1].negative?

    return false if _position[1] >= height

    return false if _position[0].negative?

    return false if _position[0] >= width

    true
  end
end
