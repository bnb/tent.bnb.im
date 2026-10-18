require 'cgi'
require 'json'
require 'json-schema'
require 'redcarpet'
require 'uri'

# Cards that point at the closest AT Protocol concept, placed beside heading
# sections without moving the original text. Built only when
# ATPROTO_ANNOTATIONS is 1 or true; readers then turn them on with a switch in
# the page corner (source/javascripts/atproto-notes.js).
module AtprotoAnnotations
  DIR = File.expand_path('../../annotations', __FILE__)
  STORAGE_KEY = 'tent-atproto-notes'.freeze

  # the tag each "read more" link gets, from the first segment of its path
  LINK_KINDS = { 'specs' => 'Spec', 'guides' => 'Guide', 'blog' => 'Blog', 'articles' => 'Article' }.freeze

  ARROW = '<svg class="atproto-card-arrow" width="14" height="14" viewBox="0 0 14 14" aria-hidden="true">' \
          '<path d="M2 7h10M8 3l4 4-4 4"/></svg>'.freeze
  EXTERNAL = '<svg class="atproto-link-external" width="14" height="14" viewBox="0 0 14 14" aria-hidden="true">' \
             '<path d="M5 3h6v6M11 3L4 10"/></svg>'.freeze

  def self.enabled?
    %w[1 true].include?(ENV['ATPROTO_ANNOTATIONS'].to_s.downcase)
  end

  def self.page?(page)
    enabled? && by_page.key?(page)
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

      # right after the heading; both elements are positioned out of the flow
      out.dup.insert(match.end(0), render(note))
    end
  end

  # the switch, plus the saved choice applied before the page paints so the
  # cards don't flash on or off
  def self.toggle(page)
    return unless page?(page)

    <<-HTML
<script>try{if(localStorage.getItem('#{STORAGE_KEY}')==='on')document.documentElement.className+=' atproto-on'}catch(e){}</script>
<button type="button" class="atproto-toggle" role="switch" aria-checked="false" hidden><span class="atproto-toggle-track" aria-hidden="true"><span class="atproto-toggle-knob"></span></span>AT Protocol notes</button>
    HTML
  end

  def self.render(note)
    id = "atproto-note-#{note['heading']}"
    <<-HTML
<button type="button" class="atproto-marker" aria-expanded="false" aria-controls="#{id}" aria-label="AT Protocol note: #{h note['atproto']}">at://</button>
<aside class="atproto-card" id="#{id}" data-heading="#{h note['heading']}" aria-label="AT Protocol note">
<div class="atproto-card-inner">
<span class="atproto-card-mark" aria-hidden="true">at://</span>
<div class="atproto-card-body">
<p class="atproto-card-map"><span class="atproto-chip-tent">Tent: #{h note['tent']}</span>#{ARROW}<span class="atproto-chip-atproto">atproto: #{h note['atproto']}</span></p>
#{markdown.render(note['summary'])}</div>
<nav class="atproto-card-links" aria-label="Read more about #{h note['atproto']}">
<p class="atproto-card-links-label">Read more</p>
<ul>
#{note['links'].map { |l| link(l) }.join}</ul>
</nav>
</div>
</aside>
    HTML
  end

  def self.link(l)
    uri = URI(l['url'])
    kind = uri.host == 'docs.bsky.app' ? 'Bluesky' : LINK_KINDS.fetch(uri.path.split('/')[1]) { raise "no link kind for #{l['url']}" }
    %(<li><a href="#{h l['url']}"><span class="atproto-link-kind atproto-link-kind-#{kind.downcase}">#{kind}</span>) +
      %(<span class="atproto-link-text"><span class="atproto-link-title">#{h l['title']}</span>) +
      %(<span class="atproto-link-url">#{h uri.host + uri.path}</span></span>#{EXTERNAL}</a></li>\n)
  end

  def self.h(text)
    CGI.escapeHTML(text)
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
