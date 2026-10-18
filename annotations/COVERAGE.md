# AT Protocol annotation coverage

Every heading on the pages that get annotations, in site order. A checked box means `atproto.json` has a note for that heading. An unchecked box says why there's no note, or marks it TODO when a counterpart exists and nobody has written the note yet. Links go to atproto.com, or to docs.bsky.app for Bluesky record types that atproto.com doesn't document. The license, trademark, contribute, blog and office hours pages describe Tent the project, not the protocol, so they aren't tracked.

When you add, remove or rename a note, update its line here. The build catches a note whose heading is gone, but it won't notice a heading with no note.

## index.html

- [x] Choose your host (`#choose-your-host`): a Tent host maps to a PDS, and switching providers to account migration
- [x] Choose your apps (`#choose-your-apps`): swappable apps through shared post types, versus shared Lexicons
- [x] Control your life (`#control-your-life`): owning your data maps to repo export as a CAR file and a self-held rotation key
- [x] Developers (`#developers`): in both, apps talk to the user's own server; atproto apps usually read through an AppView as well
- [x] Service Providers (`#service-providers`): Tent providers map to PDS hosts, but a Tent server also answers feed queries and delivers posts
- [ ] Publishers (`#publishers`): no note. atproto has no micropayments, and gated content only exists in the Spaces alpha

## about.html

- [x] How it works (`#how-it-works`): server-to-server delivery, versus PDS event stream, relay and AppView
- [ ] What it's for (`#what-it39s-for`): no note. Repeats "Choose your apps"; private data is covered under Posts > Permissions
- [x] What's special about Tent (`#what39s-special-about-tent`): shared goals; URL identity versus a DID that survives migration

## docs/index.html (Introduction)

- [x] Entities (`#entities`): entity maps to an account identity, a DID plus a handle
- [x] Servers (`#servers`): Tent servers map to PDSes
- [x] Posts (`#posts`): posts map to records in a repository, grouped by NSID collection
- [x] Apps (`#apps`): apps map to OAuth clients
- [x] Relationships (`#relationships`): Tent's trust handshake has no counterpart, since every atproto record is signed
- [x] Subscriptions (`#subscriptions`): a subscription maps to a follow record, which triggers no delivery
- [x] Notifications (`#notifications`): Tent webhooks between servers, versus notifications AppViews compute from the firehose

## docs/thinking-with-tent.html

- [x] Principles (`#principles`): the PDS as the home of a user's data, and advice against bolting on encryption
- [ ] Examples (`#examples`): no note. Section intro only
  - [x] Microblogging (`#microblogging`): one query against your own server, versus timelines served by an AppView
  - [ ] Blogs (`#blogs`): no note. Covered by the Essay post type note
  - [x] Community News site (`#community-news-site`): the republishing discovery entity is close to an AppView or feed generator
  - [ ] Todo Lists (`#todo-lists`): no note. No useful comparison
  - [x] Collaborative Editing (`#collaborative-editing`): no direct counterpart; points at Spaces
  - [x] Polls and Surveys (`#polls-and-surveys`): response records with strong refs, collected through a backlinks query
  - [ ] Music Scrobbling (`#music-scrobbling`): no note. No useful comparison
  - [ ] Photo Filtering (`#photo-filtering`): no note. No useful comparison
  - [ ] Calendars (`#calendars`): no note. No useful comparison
  - [ ] Ride Summoning (`#ride-summoning`): no note. No useful comparison
  - [ ] Email (`#email`): no note. No useful comparison

## docs/servers-entities.html

- [x] Entity URLs (`#entity-urls`): one URL doing two jobs, versus a handle that resolves to a DID
- [x] Discovery (`#discovery`): Link header and meta post, versus handle resolution and the DID document
- [ ] Server Info (`#server-info`): no note. Tent's docs leave this section empty

## docs/posts.html

- [ ] Entity (`#entity`): no note. `original_entity` is covered by the migration notes
- [x] ID (`#id`): post id maps to the record key
- [x] Type (`#type`): post type URIs map to Lexicon NSIDs in `$type`
- [ ] Content (`#content`): no note. Free-form content has nothing specific to compare
- [x] Versions (`#versions`): per-post versions, versus repo commits and record CIDs
- [x] Timestamps (`#timestamps`): protocol timestamps, versus Lexicon-defined fields like `createdAt`
- [x] Permissions (`#permissions`): per-post permissions, versus a fully public repository plus Spaces
- [x] Mentions (`#mentions`): mentions map to DIDs, at:// URIs and mention facets
- [x] Refs (`#refs`): refs map to strong refs, an at:// URI plus a CID
- [x] Attachments (`#attachments`): attachments map to blobs referenced by CID
- [ ] Post Schema (`#post-schema`): no note. The no-floats point is folded into Canonical Post JSON
- [x] Canonical Post JSON (`#canonical-post-json`): canonical JSON for hashing, versus deterministic DRISL-CBOR

## docs/relationships.html

- [ ] Subscriptions (`#subscriptions`): no note. Tent's docs leave this section empty

## docs/apps.html

- [x] Discovery (`#discovery`): find the server from the entity, versus resolve the handle to a PDS and read its OAuth metadata
- [x] Registration (`#registration`): per-server registration, versus a `client_id` URL pointing at public client metadata
- [x] OAuth (`#oauth`): both use the authorization code grant; atproto adds PKCE, PAR and DPoP
  - [ ] App Registration Schema (`#app-registration-schema`): no note. Field-level schema, covered by Registration
- [x] Notifications (`#notifications`): pushes to registered apps, versus apps subscribing to the firehose or Jetstream

## docs/authentication.html

- [x] Hawk (`#hawk`): Hawk request signing maps to DPoP proofs
- [ ] Request Header (`#request-header`): no note. Hawk wire format
- [ ] Response Header (`#response-header`): no note. Hawk wire format
- [ ] Normalized String (`#normalized-string`): no note. Hawk wire format
- [ ] Payload Validation (`#payload-validation`): no note. Hawk wire format
- [x] Timestamp Skew (`#timestamp-skew`): loosely, DPoP server nonces
- [ ] URL Signing (`#url-signing`): no note. Hawk bewits have no counterpart
- [ ] Test Vectors (`#test-vectors`): no note. Hawk test data

## docs/api.html

- [x] Concepts (`#concepts`): URL templates from the meta post, versus fixed XRPC paths defined in Lexicon
  - [x] Pagination (`#pagination`): first/prev/next/last page links, versus an opaque cursor
  - [ ] Response Envelope (`#response-envelope`): no note. Covered by Concepts
- [x] new_post (`#newpost`): new_post maps to `com.atproto.repo.createRecord`
  - [ ] Attachments (`#attachments`): no note. Covered by the attachment and Posts > Attachments notes
- [x] posts_feed (`#postsfeed`): a cross-entity feed query, versus `listRecords` on one repo plus AppView feeds
  - [ ] Sorting (`#sorting`): no note. Covered by posts_feed
  - [ ] Parameters (`#parameters`): no note. Covered by posts_feed
  - [ ] Examples (`#examples`): no note. Covered by posts_feed
    - [ ] Refs (`#refs`): no note. Covered by Posts > Refs
    - [ ] Conditional Request (`#conditional-request`): no note. HTTP caching detail
    - [ ] HEAD Request (Count) (`#head-request-count`): no note. HTTP detail
- [ ] post (`#post`): no note. Covered by the record notes on the Posts page
  - [ ] Create New Version (`#create-new-version`): no note. Covered by Posts > Versions
  - [ ] Get (with refs) (`#get-with-refs`): no note. Covered by Posts > Refs
  - [x] Mentions (`#mentions`): listing a post's mentions, versus a backlinks query an AppView answers
  - [ ] Versions (`#versions`): no note. Covered by Posts > Versions
  - [ ] Child Versions (`#child-versions`): no note. Covered by Posts > Versions
- [x] attachment (`#attachment`): fetch by digest maps to `com.atproto.sync.getBlob`
- [ ] post_attachment (`#postattachment`): no note. Covered by attachment
- [ ] batch (`#batch`): no note. Tent's docs leave this section empty
- [ ] server_info (`#serverinfo`): no note. Tent's docs leave this section empty
- [ ] oauth_auth (`#oauthauth`): no note. Covered by Apps > OAuth
- [ ] oauth_token (`#oauthtoken`): no note. Covered by Apps > OAuth

## docs/post-types.html

- [x] Protocol Posts (`#protocol-posts`): protocol state in posts, versus the DID document, OAuth sessions and `com.atproto.*` Lexicons
  - [x] Meta (`#meta`): the meta post maps to the DID document
  - [ ] Credentials (`#credentials`): no note. Covered by Authentication > Hawk
  - [ ] Relationship (`#relationship`): no note. Covered by Introduction > Relationships
  - [ ] Subscription (`#subscription`): no note. Covered by Introduction > Subscriptions
  - [ ] Delivery Failure (`#delivery-failure`): no note. A PDS doesn't push posts, so nothing can fail to deliver
  - [x] Delete (`#delete`): delete posts, versus a delete operation in the next repo commit
  - [ ] App (`#app`): no note. Covered by Apps > Registration
  - [x] App Authorization (`#app-authorization`): app authorization maps to OAuth permission scopes
- [ ] Content Posts (`#content-posts`): no note. Section intro, covered by "Choose your apps"
  - [x] Status (`#status`): status maps to Bluesky's `app.bsky.feed.post`
    - [x] Reply fragment (`#reply-fragment`): a type fragment, versus a `reply` field with parent and root strong refs
    - [ ] Markdown (`#markdown`): no note. Bluesky posts are plain text with facets, not Markdown
      - [x] Inline Mention (`#inline-mention`): inline mention maps to a mention facet
      - [ ] Span Elements (`#span-elements`): no note. Bluesky has no inline formatting
      - [ ] Blockquotes (`#blockquotes`): no note. Bluesky has no blockquotes
    - [x] Counting Characters (`#counting-characters`): code points, versus Lexicon `maxGraphemes` and `maxLength`
    - [ ] Schema (`#schema`): no note. Field-level schema
  - [x] Repost (`#repost`): a repost post type, versus an `app.bsky.feed.repost` record with a strong ref
  - [x] Photo (`#photo`): a photo post type, versus an `app.bsky.embed.images` embed on a post
  - [x] Album (`#album`): loosely, up to four images in one embed; nothing groups existing photos
  - [x] Essay (`#essay`): essay maps to Standard.site's `site.standard.document`
  - [ ] Cursor (`#cursor`): no note. No documented counterpart for a shared read position
  - [x] Tag (`#tag`): a tag post that others mention, versus a tag facet in post text
  - [x] Favorite (`#favorite`): favorite maps to Bluesky's like record

## docs/uri-scheme.html

- [x] Format (`#format`): Tent URIs map to `at://<did>/<collection>/<rkey>`
- [x] Parameters (`#parameters`): version and attachment parameters, versus a CID in a strong ref
