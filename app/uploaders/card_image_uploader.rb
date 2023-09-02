class CardImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'card1.png'
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def size_range
    (0.megabytes)..(5.megabytes)
  end

  process resize_to_fill: [1700, 1100]
end