# frozen_string_literal: true

module GalleryHelper
  def gallery_content(gallery)
    return nil if gallery.nil?

    {
      title: gallery.title,
      link: gallery_path(gallery),
      count: gallery.images.size,
      images: gallery_images_content(gallery),
      info: gallery.description,
      label: gallery_label(gallery)
    }
  end

  def gallery_label(gallery)
    gallery.topics.map(&:label).sort.join(' | ').presence
  end

  def gallery_images_content(gallery)
    gallery.images.first(3).map { |image| gallery_image_content(image) }
  end

  def gallery_image_content(image)
    {
      index: image.position,
      url: gallery_image_thumbnail(image)
    }
  end

  def gallery_image_thumbnail(image)
    api_thumbnail_url(uri: image.url, size: 400)
  end
end
