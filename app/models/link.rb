class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def read_gist
    client = Octokit::Client.new
    client.gist(URI.parse(url).path.split('/').last).files
  end
end