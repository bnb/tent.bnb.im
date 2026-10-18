require 'cgi'
require 'json'
require 'json-schema'
require 'redcarpet'

# Notes at the end of heading sections that point at the closest AT Protocol concept. Off
# unless ATPROTO_ANNOTATIONS is 1 or true, read when the site builds.
module AtprotoAnnotations
  DIR = File.expand_path('../../annotations', __FILE__)

  def self.enabled?
    %w[1 true].include?(ENV['ATPROTO_ANNOTATIONS'].to_s.downcase)
  end

  def self.by_page
    @by_page ||= begin
      data = JSON.parse(File.read(File.join(DIR, 'atproto.json')))
      JSON::Validator.validate!(File.join(DIR, 'atproto.schema.json'), data)
      data['annotations'].group_by { |a| a['page'] }
    end
  end

  def self.apply(html, page)
    return html unless enabled?

    by_page.fetch(page, []).reduce(html) do |out, note|
      heading = %r{<h([1-6]) id="#{Regexp.escape(note['heading'])}">.*?</h\1>}m
      # a renamed heading would otherwise drop its note without a trace
      match = out.match(heading)
      raise "atproto annotation for #{page} has no ##{note['heading']} heading" unless match

      # after the text under the heading, so the note follows what it compares
      section_end = out.index(/<h[1-6][ >]/, match.end(0)) || out.length
      out.dup.insert(section_end, render(note))
    end
  end

  def self.render(note)
    links = note['links'].map { |l| %(<a href="#{CGI.escapeHTML(l['url'])}">#{CGI.escapeHTML(l['title'])}</a>) }
    %(<aside class="alert alert-info">\n<p><strong>AT Protocol</strong></p>\n#{markdown.render(note['summary'])}<p>#{links.join(' · ')}</p>\n</aside>\n)
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
