class Profile < ActiveRecord::Base
  has_many   :tags
  after_save :update_tags

  def tag_name_array=(tag_name_array)
    @tag_name_array = tag_name_array
  end

  def tag_name_array
    @tag_name_array || tags.collect(&:name)
  end

  private
  def update_tags
    self.tags = tag_name_array.collect { |tag_name| Tag.new(name: tag_name) }
  end
end
