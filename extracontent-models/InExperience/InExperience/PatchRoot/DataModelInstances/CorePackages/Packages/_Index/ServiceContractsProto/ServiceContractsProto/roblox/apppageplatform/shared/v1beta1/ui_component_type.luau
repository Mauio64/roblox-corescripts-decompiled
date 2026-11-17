require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

v.UiComponentType = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "UI_COMPONENT_TYPE_INVALID"
		elseif p == 1 then
			return "UI_COMPONENT_TYPE_FEED"
		elseif p == 10 then
			return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL"
		elseif p == 11 then
			return "UI_COMPONENT_TYPE_COLLECTION_GRID"
		elseif p == 12 then
			return "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION"
		elseif p == 13 then
			return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER"
		elseif p == 14 then
			return "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL"
		elseif p == 15 then
			return "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION"
		elseif p == 17 then
			return "UI_COMPONENT_TYPE_COLLECTION_SLOTS_LAYOUT"
		elseif p == 100 then
			return "UI_COMPONENT_TYPE_TILE"
		elseif p == 101 then
			return "UI_COMPONENT_TYPE_GAME_TILE"
		elseif p == 102 then
			return "UI_COMPONENT_TYPE_SEE_ALL_TILE"
		elseif p == 103 then
			return "UI_COMPONENT_TYPE_BADGE_TILE"
		elseif p == 104 then
			return "UI_COMPONENT_TYPE_SONG_TILE"
		elseif p == 105 then
			return "UI_COMPONENT_TYPE_EVENT_TILE"
		elseif p == 106 then
			return "UI_COMPONENT_TYPE_PLACEHOLDER_TILE"
		elseif p == 107 then
			return "UI_COMPONENT_TYPE_SPONSORED_TWO_BY_ONE_TILE"
		elseif p == 108 then
			return "UI_COMPONENT_TYPE_SPONSORED_ONE_BY_TWO_TILE"
		elseif p == 109 then
			return "UI_COMPONENT_TYPE_USER_SEARCH_TILE"
		elseif p == 110 then
			return "UI_COMPONENT_TYPE_INTERACTABLE_TILE_WRAPPER"
		elseif p == 200 then
			return "UI_COMPONENT_TYPE_BUTTON"
		elseif p == 201 then
			return "UI_COMPONENT_TYPE_IMAGE"
		elseif p == 202 then
			return "UI_COMPONENT_TYPE_TEXT"
		elseif p == 203 then
			return "UI_COMPONENT_TYPE_VIEW"
		elseif p == 204 then
			return "UI_COMPONENT_TYPE_DIVIDER"
		elseif p == 205 then
			return "UI_COMPONENT_TYPE_DIALOG"
		elseif p == 206 then
			return "UI_COMPONENT_TYPE_TEXT_ICON_ROW"
		elseif p == 207 then
			return "UI_COMPONENT_TYPE_TEXT_PILL"
		elseif p == 208 then
			return "UI_COMPONENT_TYPE_SECTION_HEADER"
		elseif p == 209 then
			return "UI_COMPONENT_TYPE_SLOT_OVERLAY"
		elseif p == 210 then
			return "UI_COMPONENT_TYPE_TILE_FOOTER"
		elseif p == 211 then
			return "UI_COMPONENT_TYPE_ATTRIBUTION_ROW"
		elseif p == 212 then
			return "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER"
		elseif p == 213 then
			return "UI_COMPONENT_TYPE_HERO_UNIT"
		elseif p == 214 then
			return "UI_COMPONENT_TYPE_HOLD_TO_PLAY"
		elseif p == 215 then
			return "UI_COMPONENT_TYPE_PLAY_BUTTON"
		elseif p == 216 then
			return "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW"
		elseif p == 217 then
			return "UI_COMPONENT_TYPE_INFO_TABLE"
		elseif p == 218 then
			return "UI_COMPONENT_TYPE_INFO_TABLE_CELL"
		elseif p == 219 then
			return "UI_COMPONENT_TYPE_CHIP"
		elseif p == 220 then
			return "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP"
		elseif p == 221 then
			return "UI_COMPONENT_TYPE_EXPANDABLE_TEXT"
		elseif p == 222 then
			return "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW"
		elseif p == 223 then
			return "UI_COMPONENT_TYPE_OVERFLOW_MENU"
		elseif p == 224 then
			return "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER"
		elseif p == 225 then
			return "UI_COMPONENT_TYPE_CARD"
		elseif p == 226 then
			return "UI_COMPONENT_TYPE_TABS"
		elseif p == 227 then
			return "UI_COMPONENT_TYPE_ACTION_BAR"
		elseif p == 228 then
			return "UI_COMPONENT_TYPE_ICON"
		elseif p == 229 then
			return "UI_COMPONENT_TYPE_CIRCLE_ICON"
		elseif p == 230 then
			return "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL"
		elseif p == 231 then
			return "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE"
		elseif p == 232 then
			return "UI_COMPONENT_TYPE_MEDIA_GALLERY"
		elseif p == 233 then
			return "UI_COMPONENT_TYPE_CONTENT_ROW"
		elseif p == 234 then
			return "UI_COMPONENT_TYPE_LINK_TEXT"
		elseif p == 235 then
			return "UI_COMPONENT_TYPE_COACHMARK"
		elseif p == 236 then
			return "UI_COMPONENT_TYPE_BADGE"
		elseif p == 237 then
			return "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL"
		elseif p == 238 then
			return "UI_COMPONENT_TYPE_SHEET_FULL_BLEED"
		elseif p == 239 then
			return "UI_COMPONENT_TYPE_SYSTEM_BANNER"
		elseif p == 240 then
			return "UI_COMPONENT_TYPE_PLAY_WITH_REWARD"
		elseif p == 241 then
			return "UI_COMPONENT_TYPE_ICON_BUTTON"
		elseif p == 242 then
			return "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW"
		elseif p == 243 then
			return "UI_COMPONENT_TYPE_PAGE_HEADER"
		elseif p == 244 then
			return "UI_COMPONENT_TYPE_AVATAR_GROUP"
		elseif p == 245 then
			return "UI_COMPONENT_TYPE_TOOLTIP"
		elseif p == 246 then
			return "UI_COMPONENT_TYPE_AI_OVERVIEW"
		elseif p == 247 then
			return "UI_COMPONENT_TYPE_SKELETON"
		elseif p == 248 then
			return "UI_COMPONENT_TYPE_PLACEHOLDER"
		elseif p == 249 then
			return "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER"
		elseif p == 250 then
			return "UI_COMPONENT_TYPE_REVEAL_TEXT"
		elseif p == 251 then
			return "UI_COMPONENT_TYPE_SHIMMER_TEXT"
		elseif p == 252 then
			return "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON"
		elseif p == 253 then
			return "UI_COMPONENT_TYPE_LOGO"
		elseif p == 254 then
			return "UI_COMPONENT_TYPE_FEEDBACK_BANNER"
		elseif p == 255 then
			return "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN"
		elseif p == 256 then
			return "UI_COMPONENT_TYPE_LAYERED_CONTAINER"
		elseif p == 257 then
			return "UI_COMPONENT_TYPE_BACKGROUND_BLUR"
		elseif p == 258 then
			return "UI_COMPONENT_TYPE_VIRTUAL_GAME_ITEM_TEXT"
		elseif p == 259 then
			return "UI_COMPONENT_TYPE_VIDEO_PLAYER"
		elseif p == 260 then
			return "UI_COMPONENT_TYPE_VERTICAL_LIST_WITH_IMPRESSIONS"
		elseif p == 261 then
			return "UI_COMPONENT_TYPE_REVEAL_ROWS_BUTTON_WITH_DIVIDER"
		elseif p == 262 then
			return "UI_COMPONENT_TYPE_HERO_UNIT_BOTTOM_ROW"
		elseif p == 263 then
			return "UI_COMPONENT_TYPE_HOME_USER_INFO_WIDGET"
		elseif p == 264 then
			return "UI_COMPONENT_TYPE_GAME_TILE_HIDDEN_STATE"
		elseif p == 265 then
			return "UI_COMPONENT_TYPE_PLUS_EARLY_ACCESS_UPSELL"
		elseif p == 266 then
			return "UI_COMPONENT_TYPE_TOGGLE"
		elseif p == 267 then
			return "UI_COMPONENT_TYPE_LIST_ROOT"
		elseif p == 268 then
			return "UI_COMPONENT_TYPE_LIST_ITEM"
		elseif p == 269 then
			return "UI_COMPONENT_TYPE_MARKDOWN_TEXT"
		elseif p == 270 then
			return "UI_COMPONENT_TYPE_SIGN_UP_FORM"
		elseif p == 271 then
			return "UI_COMPONENT_TYPE_BANNER_CONTEXT"
		elseif p == 272 then
			return "UI_COMPONENT_TYPE_VIEWPORT_VISIBILITY"
		elseif p == 273 then
			return "UI_COMPONENT_TYPE_PROGRESS"
		elseif p == 274 then
			return "UI_COMPONENT_TYPE_LINE_LIMITED_TEXT"
		elseif p == 275 then
			return "UI_COMPONENT_TYPE_CUSTOM_FORM"
		elseif p == 276 then
			return "UI_COMPONENT_TYPE_ACCORDION"
		elseif p == 277 then
			return "UI_COMPONENT_TYPE_ACCORDION_ITEM"
		elseif p == 278 then
			return "UI_COMPONENT_TYPE_CONFIG_DRIVEN_FORM"
		elseif p == 279 then
			return "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ROOT"
		elseif p == 280 then
			return "UI_COMPONENT_TYPE_SEARCH_AUTOCOMPLETE_SUGGESTION"
		elseif p == 281 then
			return "UI_COMPONENT_TYPE_REACTIONS"
		elseif p == 282 then
			return "UI_COMPONENT_TYPE_BANNER"
		elseif p == 283 then
			return "UI_COMPONENT_TYPE_SHEET"
		elseif p == 284 then
			return "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ITEM"
		elseif p == 285 then
			return "UI_COMPONENT_TYPE_STATUS_BADGE"
		elseif p == 286 then
			return "UI_COMPONENT_TYPE_MURAL_SECTION"
		elseif p == 300 then
			return "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS"
		elseif p == 400 then
			return "UI_COMPONENT_TYPE_FRAGMENT"
		elseif p == 401 then
			return "UI_COMPONENT_TYPE_EXPERIMENTAL"
		elseif p == 500 then
			return "UI_COMPONENT_TYPE_VERTICAL_FEED"
		elseif p == 600 then
			return "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED"
		elseif p == 601 then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP"
		elseif p == 602 then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL"
		elseif p == 603 then
			return "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU"
		elseif p == 604 then
			return "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT"
		elseif p == 605 then
			return "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU"
		elseif p == 606 then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID"
		elseif p == 607 then
			return "UI_COMPONENT_TYPE_ITEM_MEDIA_HEADER"
		elseif p == 608 then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_CARD"
		elseif p == 700 then
			return "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL"
		elseif p == 701 then
			return "UI_COMPONENT_TYPE_PILL_TABS_CAROUSEL"
		elseif p == 800 then
			return "UI_COMPONENT_TYPE_USER_LIST"
		elseif p == 801 then
			return "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON"
		elseif p == 802 then
			return "UI_COMPONENT_TYPE_FRIEND_CAROUSEL"
		elseif p == 803 then
			return "UI_COMPONENT_TYPE_PYMK_CAROUSEL"
		elseif p == 804 then
			return "UI_COMPONENT_TYPE_FRIENDS_OWNED_CHIP"
		elseif p == 900 then
			return "UI_COMPONENT_TYPE_GROUP_FORUM_POST_PREVIEW"
		elseif p == 901 then
			return "UI_COMPONENT_TYPE_GROUP_SIDEBAR"
		elseif p == 902 then
			return "UI_COMPONENT_TYPE_GROUP_SECTION"
		elseif p == 9999 then
			return "UI_COMPONENT_TYPE_MOCK_COMPONENT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "UI_COMPONENT_TYPE_INVALID" then
			return 0
		elseif p == "UI_COMPONENT_TYPE_FEED" then
			return 1
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL" then
			return 10
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_GRID" then
			return 11
		elseif p == "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION" then
			return 12
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER" then
			return 13
		elseif p == "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL" then
			return 14
		elseif p == "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION" then
			return 15
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_SLOTS_LAYOUT" then
			return 17
		elseif p == "UI_COMPONENT_TYPE_TILE" then
			return 100
		elseif p == "UI_COMPONENT_TYPE_GAME_TILE" then
			return 101
		elseif p == "UI_COMPONENT_TYPE_SEE_ALL_TILE" then
			return 102
		elseif p == "UI_COMPONENT_TYPE_BADGE_TILE" then
			return 103
		elseif p == "UI_COMPONENT_TYPE_SONG_TILE" then
			return 104
		elseif p == "UI_COMPONENT_TYPE_EVENT_TILE" then
			return 105
		elseif p == "UI_COMPONENT_TYPE_PLACEHOLDER_TILE" then
			return 106
		elseif p == "UI_COMPONENT_TYPE_SPONSORED_TWO_BY_ONE_TILE" then
			return 107
		elseif p == "UI_COMPONENT_TYPE_SPONSORED_ONE_BY_TWO_TILE" then
			return 108
		elseif p == "UI_COMPONENT_TYPE_USER_SEARCH_TILE" then
			return 109
		elseif p == "UI_COMPONENT_TYPE_INTERACTABLE_TILE_WRAPPER" then
			return 110
		elseif p == "UI_COMPONENT_TYPE_BUTTON" then
			return 200
		elseif p == "UI_COMPONENT_TYPE_IMAGE" then
			return 201
		elseif p == "UI_COMPONENT_TYPE_TEXT" then
			return 202
		elseif p == "UI_COMPONENT_TYPE_VIEW" then
			return 203
		elseif p == "UI_COMPONENT_TYPE_DIVIDER" then
			return 204
		elseif p == "UI_COMPONENT_TYPE_DIALOG" then
			return 205
		elseif p == "UI_COMPONENT_TYPE_TEXT_ICON_ROW" then
			return 206
		elseif p == "UI_COMPONENT_TYPE_TEXT_PILL" then
			return 207
		elseif p == "UI_COMPONENT_TYPE_SECTION_HEADER" then
			return 208
		elseif p == "UI_COMPONENT_TYPE_SLOT_OVERLAY" then
			return 209
		elseif p == "UI_COMPONENT_TYPE_TILE_FOOTER" then
			return 210
		elseif p == "UI_COMPONENT_TYPE_ATTRIBUTION_ROW" then
			return 211
		elseif p == "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER" then
			return 212
		elseif p == "UI_COMPONENT_TYPE_HERO_UNIT" then
			return 213
		elseif p == "UI_COMPONENT_TYPE_HOLD_TO_PLAY" then
			return 214
		elseif p == "UI_COMPONENT_TYPE_PLAY_BUTTON" then
			return 215
		elseif p == "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW" then
			return 216
		elseif p == "UI_COMPONENT_TYPE_INFO_TABLE" then
			return 217
		elseif p == "UI_COMPONENT_TYPE_INFO_TABLE_CELL" then
			return 218
		elseif p == "UI_COMPONENT_TYPE_CHIP" then
			return 219
		elseif p == "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP" then
			return 220
		elseif p == "UI_COMPONENT_TYPE_EXPANDABLE_TEXT" then
			return 221
		elseif p == "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW" then
			return 222
		elseif p == "UI_COMPONENT_TYPE_OVERFLOW_MENU" then
			return 223
		elseif p == "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER" then
			return 224
		elseif p == "UI_COMPONENT_TYPE_CARD" then
			return 225
		elseif p == "UI_COMPONENT_TYPE_TABS" then
			return 226
		elseif p == "UI_COMPONENT_TYPE_ACTION_BAR" then
			return 227
		elseif p == "UI_COMPONENT_TYPE_ICON" then
			return 228
		elseif p == "UI_COMPONENT_TYPE_CIRCLE_ICON" then
			return 229
		elseif p == "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL" then
			return 230
		elseif p == "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE" then
			return 231
		elseif p == "UI_COMPONENT_TYPE_MEDIA_GALLERY" then
			return 232
		elseif p == "UI_COMPONENT_TYPE_CONTENT_ROW" then
			return 233
		elseif p == "UI_COMPONENT_TYPE_LINK_TEXT" then
			return 234
		elseif p == "UI_COMPONENT_TYPE_COACHMARK" then
			return 235
		elseif p == "UI_COMPONENT_TYPE_BADGE" then
			return 236
		elseif p == "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL" then
			return 237
		elseif p == "UI_COMPONENT_TYPE_SHEET_FULL_BLEED" then
			return 238
		elseif p == "UI_COMPONENT_TYPE_SYSTEM_BANNER" then
			return 239
		elseif p == "UI_COMPONENT_TYPE_PLAY_WITH_REWARD" then
			return 240
		elseif p == "UI_COMPONENT_TYPE_ICON_BUTTON" then
			return 241
		elseif p == "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW" then
			return 242
		elseif p == "UI_COMPONENT_TYPE_PAGE_HEADER" then
			return 243
		elseif p == "UI_COMPONENT_TYPE_AVATAR_GROUP" then
			return 244
		elseif p == "UI_COMPONENT_TYPE_TOOLTIP" then
			return 245
		elseif p == "UI_COMPONENT_TYPE_AI_OVERVIEW" then
			return 246
		elseif p == "UI_COMPONENT_TYPE_SKELETON" then
			return 247
		elseif p == "UI_COMPONENT_TYPE_PLACEHOLDER" then
			return 248
		elseif p == "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER" then
			return 249
		elseif p == "UI_COMPONENT_TYPE_REVEAL_TEXT" then
			return 250
		elseif p == "UI_COMPONENT_TYPE_SHIMMER_TEXT" then
			return 251
		elseif p == "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON" then
			return 252
		elseif p == "UI_COMPONENT_TYPE_LOGO" then
			return 253
		elseif p == "UI_COMPONENT_TYPE_FEEDBACK_BANNER" then
			return 254
		elseif p == "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN" then
			return 255
		elseif p == "UI_COMPONENT_TYPE_LAYERED_CONTAINER" then
			return 256
		elseif p == "UI_COMPONENT_TYPE_BACKGROUND_BLUR" then
			return 257
		elseif p == "UI_COMPONENT_TYPE_VIRTUAL_GAME_ITEM_TEXT" then
			return 258
		elseif p == "UI_COMPONENT_TYPE_VIDEO_PLAYER" then
			return 259
		elseif p == "UI_COMPONENT_TYPE_VERTICAL_LIST_WITH_IMPRESSIONS" then
			return 260
		elseif p == "UI_COMPONENT_TYPE_REVEAL_ROWS_BUTTON_WITH_DIVIDER" then
			return 261
		elseif p == "UI_COMPONENT_TYPE_HERO_UNIT_BOTTOM_ROW" then
			return 262
		elseif p == "UI_COMPONENT_TYPE_HOME_USER_INFO_WIDGET" then
			return 263
		elseif p == "UI_COMPONENT_TYPE_GAME_TILE_HIDDEN_STATE" then
			return 264
		elseif p == "UI_COMPONENT_TYPE_PLUS_EARLY_ACCESS_UPSELL" then
			return 265
		elseif p == "UI_COMPONENT_TYPE_TOGGLE" then
			return 266
		elseif p == "UI_COMPONENT_TYPE_LIST_ROOT" then
			return 267
		elseif p == "UI_COMPONENT_TYPE_LIST_ITEM" then
			return 268
		elseif p == "UI_COMPONENT_TYPE_MARKDOWN_TEXT" then
			return 269
		elseif p == "UI_COMPONENT_TYPE_SIGN_UP_FORM" then
			return 270
		elseif p == "UI_COMPONENT_TYPE_BANNER_CONTEXT" then
			return 271
		elseif p == "UI_COMPONENT_TYPE_VIEWPORT_VISIBILITY" then
			return 272
		elseif p == "UI_COMPONENT_TYPE_PROGRESS" then
			return 273
		elseif p == "UI_COMPONENT_TYPE_LINE_LIMITED_TEXT" then
			return 274
		elseif p == "UI_COMPONENT_TYPE_CUSTOM_FORM" then
			return 275
		elseif p == "UI_COMPONENT_TYPE_ACCORDION" then
			return 276
		elseif p == "UI_COMPONENT_TYPE_ACCORDION_ITEM" then
			return 277
		elseif p == "UI_COMPONENT_TYPE_CONFIG_DRIVEN_FORM" then
			return 278
		elseif p == "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ROOT" then
			return 279
		elseif p == "UI_COMPONENT_TYPE_SEARCH_AUTOCOMPLETE_SUGGESTION" then
			return 280
		elseif p == "UI_COMPONENT_TYPE_REACTIONS" then
			return 281
		elseif p == "UI_COMPONENT_TYPE_BANNER" then
			return 282
		elseif p == "UI_COMPONENT_TYPE_SHEET" then
			return 283
		elseif p == "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ITEM" then
			return 284
		elseif p == "UI_COMPONENT_TYPE_STATUS_BADGE" then
			return 285
		elseif p == "UI_COMPONENT_TYPE_MURAL_SECTION" then
			return 286
		elseif p == "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS" then
			return 300
		elseif p == "UI_COMPONENT_TYPE_FRAGMENT" then
			return 400
		elseif p == "UI_COMPONENT_TYPE_EXPERIMENTAL" then
			return 401
		elseif p == "UI_COMPONENT_TYPE_VERTICAL_FEED" then
			return 500
		elseif p == "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED" then
			return 600
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP" then
			return 601
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL" then
			return 602
		elseif p == "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU" then
			return 603
		elseif p == "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT" then
			return 604
		elseif p == "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU" then
			return 605
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID" then
			return 606
		elseif p == "UI_COMPONENT_TYPE_ITEM_MEDIA_HEADER" then
			return 607
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_CARD" then
			return 608
		elseif p == "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL" then
			return 700
		elseif p == "UI_COMPONENT_TYPE_PILL_TABS_CAROUSEL" then
			return 701
		elseif p == "UI_COMPONENT_TYPE_USER_LIST" then
			return 800
		elseif p == "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON" then
			return 801
		elseif p == "UI_COMPONENT_TYPE_FRIEND_CAROUSEL" then
			return 802
		elseif p == "UI_COMPONENT_TYPE_PYMK_CAROUSEL" then
			return 803
		elseif p == "UI_COMPONENT_TYPE_FRIENDS_OWNED_CHIP" then
			return 804
		elseif p == "UI_COMPONENT_TYPE_GROUP_FORUM_POST_PREVIEW" then
			return 900
		elseif p == "UI_COMPONENT_TYPE_GROUP_SIDEBAR" then
			return 901
		elseif p == "UI_COMPONENT_TYPE_GROUP_SECTION" then
			return 902
		elseif p == "UI_COMPONENT_TYPE_MOCK_COMPONENT" then
			return 9999
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "UI_COMPONENT_TYPE_INVALID" then
			return "UI_COMPONENT_TYPE_INVALID"
		elseif p == "UI_COMPONENT_TYPE_FEED" then
			return "UI_COMPONENT_TYPE_FEED"
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL" then
			return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_GRID" then
			return "UI_COMPONENT_TYPE_COLLECTION_GRID"
		elseif p == "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION" then
			return "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION"
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER" then
			return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER"
		elseif p == "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL" then
			return "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION" then
			return "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION"
		elseif p == "UI_COMPONENT_TYPE_COLLECTION_SLOTS_LAYOUT" then
			return "UI_COMPONENT_TYPE_COLLECTION_SLOTS_LAYOUT"
		elseif p == "UI_COMPONENT_TYPE_TILE" then
			return "UI_COMPONENT_TYPE_TILE"
		elseif p == "UI_COMPONENT_TYPE_GAME_TILE" then
			return "UI_COMPONENT_TYPE_GAME_TILE"
		elseif p == "UI_COMPONENT_TYPE_SEE_ALL_TILE" then
			return "UI_COMPONENT_TYPE_SEE_ALL_TILE"
		elseif p == "UI_COMPONENT_TYPE_BADGE_TILE" then
			return "UI_COMPONENT_TYPE_BADGE_TILE"
		elseif p == "UI_COMPONENT_TYPE_SONG_TILE" then
			return "UI_COMPONENT_TYPE_SONG_TILE"
		elseif p == "UI_COMPONENT_TYPE_EVENT_TILE" then
			return "UI_COMPONENT_TYPE_EVENT_TILE"
		elseif p == "UI_COMPONENT_TYPE_PLACEHOLDER_TILE" then
			return "UI_COMPONENT_TYPE_PLACEHOLDER_TILE"
		elseif p == "UI_COMPONENT_TYPE_SPONSORED_TWO_BY_ONE_TILE" then
			return "UI_COMPONENT_TYPE_SPONSORED_TWO_BY_ONE_TILE"
		elseif p == "UI_COMPONENT_TYPE_SPONSORED_ONE_BY_TWO_TILE" then
			return "UI_COMPONENT_TYPE_SPONSORED_ONE_BY_TWO_TILE"
		elseif p == "UI_COMPONENT_TYPE_USER_SEARCH_TILE" then
			return "UI_COMPONENT_TYPE_USER_SEARCH_TILE"
		elseif p == "UI_COMPONENT_TYPE_INTERACTABLE_TILE_WRAPPER" then
			return "UI_COMPONENT_TYPE_INTERACTABLE_TILE_WRAPPER"
		elseif p == "UI_COMPONENT_TYPE_BUTTON" then
			return "UI_COMPONENT_TYPE_BUTTON"
		elseif p == "UI_COMPONENT_TYPE_IMAGE" then
			return "UI_COMPONENT_TYPE_IMAGE"
		elseif p == "UI_COMPONENT_TYPE_TEXT" then
			return "UI_COMPONENT_TYPE_TEXT"
		elseif p == "UI_COMPONENT_TYPE_VIEW" then
			return "UI_COMPONENT_TYPE_VIEW"
		elseif p == "UI_COMPONENT_TYPE_DIVIDER" then
			return "UI_COMPONENT_TYPE_DIVIDER"
		elseif p == "UI_COMPONENT_TYPE_DIALOG" then
			return "UI_COMPONENT_TYPE_DIALOG"
		elseif p == "UI_COMPONENT_TYPE_TEXT_ICON_ROW" then
			return "UI_COMPONENT_TYPE_TEXT_ICON_ROW"
		elseif p == "UI_COMPONENT_TYPE_TEXT_PILL" then
			return "UI_COMPONENT_TYPE_TEXT_PILL"
		elseif p == "UI_COMPONENT_TYPE_SECTION_HEADER" then
			return "UI_COMPONENT_TYPE_SECTION_HEADER"
		elseif p == "UI_COMPONENT_TYPE_SLOT_OVERLAY" then
			return "UI_COMPONENT_TYPE_SLOT_OVERLAY"
		elseif p == "UI_COMPONENT_TYPE_TILE_FOOTER" then
			return "UI_COMPONENT_TYPE_TILE_FOOTER"
		elseif p == "UI_COMPONENT_TYPE_ATTRIBUTION_ROW" then
			return "UI_COMPONENT_TYPE_ATTRIBUTION_ROW"
		elseif p == "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER" then
			return "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER"
		elseif p == "UI_COMPONENT_TYPE_HERO_UNIT" then
			return "UI_COMPONENT_TYPE_HERO_UNIT"
		elseif p == "UI_COMPONENT_TYPE_HOLD_TO_PLAY" then
			return "UI_COMPONENT_TYPE_HOLD_TO_PLAY"
		elseif p == "UI_COMPONENT_TYPE_PLAY_BUTTON" then
			return "UI_COMPONENT_TYPE_PLAY_BUTTON"
		elseif p == "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW" then
			return "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW"
		elseif p == "UI_COMPONENT_TYPE_INFO_TABLE" then
			return "UI_COMPONENT_TYPE_INFO_TABLE"
		elseif p == "UI_COMPONENT_TYPE_INFO_TABLE_CELL" then
			return "UI_COMPONENT_TYPE_INFO_TABLE_CELL"
		elseif p == "UI_COMPONENT_TYPE_CHIP" then
			return "UI_COMPONENT_TYPE_CHIP"
		elseif p == "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP" then
			return "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP"
		elseif p == "UI_COMPONENT_TYPE_EXPANDABLE_TEXT" then
			return "UI_COMPONENT_TYPE_EXPANDABLE_TEXT"
		elseif p == "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW" then
			return "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW"
		elseif p == "UI_COMPONENT_TYPE_OVERFLOW_MENU" then
			return "UI_COMPONENT_TYPE_OVERFLOW_MENU"
		elseif p == "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER" then
			return "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER"
		elseif p == "UI_COMPONENT_TYPE_CARD" then
			return "UI_COMPONENT_TYPE_CARD"
		elseif p == "UI_COMPONENT_TYPE_TABS" then
			return "UI_COMPONENT_TYPE_TABS"
		elseif p == "UI_COMPONENT_TYPE_ACTION_BAR" then
			return "UI_COMPONENT_TYPE_ACTION_BAR"
		elseif p == "UI_COMPONENT_TYPE_ICON" then
			return "UI_COMPONENT_TYPE_ICON"
		elseif p == "UI_COMPONENT_TYPE_CIRCLE_ICON" then
			return "UI_COMPONENT_TYPE_CIRCLE_ICON"
		elseif p == "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL" then
			return "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL"
		elseif p == "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE" then
			return "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE"
		elseif p == "UI_COMPONENT_TYPE_MEDIA_GALLERY" then
			return "UI_COMPONENT_TYPE_MEDIA_GALLERY"
		elseif p == "UI_COMPONENT_TYPE_CONTENT_ROW" then
			return "UI_COMPONENT_TYPE_CONTENT_ROW"
		elseif p == "UI_COMPONENT_TYPE_LINK_TEXT" then
			return "UI_COMPONENT_TYPE_LINK_TEXT"
		elseif p == "UI_COMPONENT_TYPE_COACHMARK" then
			return "UI_COMPONENT_TYPE_COACHMARK"
		elseif p == "UI_COMPONENT_TYPE_BADGE" then
			return "UI_COMPONENT_TYPE_BADGE"
		elseif p == "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL" then
			return "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL"
		elseif p == "UI_COMPONENT_TYPE_SHEET_FULL_BLEED" then
			return "UI_COMPONENT_TYPE_SHEET_FULL_BLEED"
		elseif p == "UI_COMPONENT_TYPE_SYSTEM_BANNER" then
			return "UI_COMPONENT_TYPE_SYSTEM_BANNER"
		elseif p == "UI_COMPONENT_TYPE_PLAY_WITH_REWARD" then
			return "UI_COMPONENT_TYPE_PLAY_WITH_REWARD"
		elseif p == "UI_COMPONENT_TYPE_ICON_BUTTON" then
			return "UI_COMPONENT_TYPE_ICON_BUTTON"
		elseif p == "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW" then
			return "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW"
		elseif p == "UI_COMPONENT_TYPE_PAGE_HEADER" then
			return "UI_COMPONENT_TYPE_PAGE_HEADER"
		elseif p == "UI_COMPONENT_TYPE_AVATAR_GROUP" then
			return "UI_COMPONENT_TYPE_AVATAR_GROUP"
		elseif p == "UI_COMPONENT_TYPE_TOOLTIP" then
			return "UI_COMPONENT_TYPE_TOOLTIP"
		elseif p == "UI_COMPONENT_TYPE_AI_OVERVIEW" then
			return "UI_COMPONENT_TYPE_AI_OVERVIEW"
		elseif p == "UI_COMPONENT_TYPE_SKELETON" then
			return "UI_COMPONENT_TYPE_SKELETON"
		elseif p == "UI_COMPONENT_TYPE_PLACEHOLDER" then
			return "UI_COMPONENT_TYPE_PLACEHOLDER"
		elseif p == "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER" then
			return "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER"
		elseif p == "UI_COMPONENT_TYPE_REVEAL_TEXT" then
			return "UI_COMPONENT_TYPE_REVEAL_TEXT"
		elseif p == "UI_COMPONENT_TYPE_SHIMMER_TEXT" then
			return "UI_COMPONENT_TYPE_SHIMMER_TEXT"
		elseif p == "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON" then
			return "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON"
		elseif p == "UI_COMPONENT_TYPE_LOGO" then
			return "UI_COMPONENT_TYPE_LOGO"
		elseif p == "UI_COMPONENT_TYPE_FEEDBACK_BANNER" then
			return "UI_COMPONENT_TYPE_FEEDBACK_BANNER"
		elseif p == "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN" then
			return "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN"
		elseif p == "UI_COMPONENT_TYPE_LAYERED_CONTAINER" then
			return "UI_COMPONENT_TYPE_LAYERED_CONTAINER"
		elseif p == "UI_COMPONENT_TYPE_BACKGROUND_BLUR" then
			return "UI_COMPONENT_TYPE_BACKGROUND_BLUR"
		elseif p == "UI_COMPONENT_TYPE_VIRTUAL_GAME_ITEM_TEXT" then
			return "UI_COMPONENT_TYPE_VIRTUAL_GAME_ITEM_TEXT"
		elseif p == "UI_COMPONENT_TYPE_VIDEO_PLAYER" then
			return "UI_COMPONENT_TYPE_VIDEO_PLAYER"
		elseif p == "UI_COMPONENT_TYPE_VERTICAL_LIST_WITH_IMPRESSIONS" then
			return "UI_COMPONENT_TYPE_VERTICAL_LIST_WITH_IMPRESSIONS"
		elseif p == "UI_COMPONENT_TYPE_REVEAL_ROWS_BUTTON_WITH_DIVIDER" then
			return "UI_COMPONENT_TYPE_REVEAL_ROWS_BUTTON_WITH_DIVIDER"
		elseif p == "UI_COMPONENT_TYPE_HERO_UNIT_BOTTOM_ROW" then
			return "UI_COMPONENT_TYPE_HERO_UNIT_BOTTOM_ROW"
		elseif p == "UI_COMPONENT_TYPE_HOME_USER_INFO_WIDGET" then
			return "UI_COMPONENT_TYPE_HOME_USER_INFO_WIDGET"
		elseif p == "UI_COMPONENT_TYPE_GAME_TILE_HIDDEN_STATE" then
			return "UI_COMPONENT_TYPE_GAME_TILE_HIDDEN_STATE"
		elseif p == "UI_COMPONENT_TYPE_PLUS_EARLY_ACCESS_UPSELL" then
			return "UI_COMPONENT_TYPE_PLUS_EARLY_ACCESS_UPSELL"
		elseif p == "UI_COMPONENT_TYPE_TOGGLE" then
			return "UI_COMPONENT_TYPE_TOGGLE"
		elseif p == "UI_COMPONENT_TYPE_LIST_ROOT" then
			return "UI_COMPONENT_TYPE_LIST_ROOT"
		elseif p == "UI_COMPONENT_TYPE_LIST_ITEM" then
			return "UI_COMPONENT_TYPE_LIST_ITEM"
		elseif p == "UI_COMPONENT_TYPE_MARKDOWN_TEXT" then
			return "UI_COMPONENT_TYPE_MARKDOWN_TEXT"
		elseif p == "UI_COMPONENT_TYPE_SIGN_UP_FORM" then
			return "UI_COMPONENT_TYPE_SIGN_UP_FORM"
		elseif p == "UI_COMPONENT_TYPE_BANNER_CONTEXT" then
			return "UI_COMPONENT_TYPE_BANNER_CONTEXT"
		elseif p == "UI_COMPONENT_TYPE_VIEWPORT_VISIBILITY" then
			return "UI_COMPONENT_TYPE_VIEWPORT_VISIBILITY"
		elseif p == "UI_COMPONENT_TYPE_PROGRESS" then
			return "UI_COMPONENT_TYPE_PROGRESS"
		elseif p == "UI_COMPONENT_TYPE_LINE_LIMITED_TEXT" then
			return "UI_COMPONENT_TYPE_LINE_LIMITED_TEXT"
		elseif p == "UI_COMPONENT_TYPE_CUSTOM_FORM" then
			return "UI_COMPONENT_TYPE_CUSTOM_FORM"
		elseif p == "UI_COMPONENT_TYPE_ACCORDION" then
			return "UI_COMPONENT_TYPE_ACCORDION"
		elseif p == "UI_COMPONENT_TYPE_ACCORDION_ITEM" then
			return "UI_COMPONENT_TYPE_ACCORDION_ITEM"
		elseif p == "UI_COMPONENT_TYPE_CONFIG_DRIVEN_FORM" then
			return "UI_COMPONENT_TYPE_CONFIG_DRIVEN_FORM"
		elseif p == "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ROOT" then
			return "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ROOT"
		elseif p == "UI_COMPONENT_TYPE_SEARCH_AUTOCOMPLETE_SUGGESTION" then
			return "UI_COMPONENT_TYPE_SEARCH_AUTOCOMPLETE_SUGGESTION"
		elseif p == "UI_COMPONENT_TYPE_REACTIONS" then
			return "UI_COMPONENT_TYPE_REACTIONS"
		elseif p == "UI_COMPONENT_TYPE_BANNER" then
			return "UI_COMPONENT_TYPE_BANNER"
		elseif p == "UI_COMPONENT_TYPE_SHEET" then
			return "UI_COMPONENT_TYPE_SHEET"
		elseif p == "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ITEM" then
			return "UI_COMPONENT_TYPE_EXPANDABLE_LIST_ITEM"
		elseif p == "UI_COMPONENT_TYPE_STATUS_BADGE" then
			return "UI_COMPONENT_TYPE_STATUS_BADGE"
		elseif p == "UI_COMPONENT_TYPE_MURAL_SECTION" then
			return "UI_COMPONENT_TYPE_MURAL_SECTION"
		elseif p == "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS" then
			return "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS"
		elseif p == "UI_COMPONENT_TYPE_FRAGMENT" then
			return "UI_COMPONENT_TYPE_FRAGMENT"
		elseif p == "UI_COMPONENT_TYPE_EXPERIMENTAL" then
			return "UI_COMPONENT_TYPE_EXPERIMENTAL"
		elseif p == "UI_COMPONENT_TYPE_VERTICAL_FEED" then
			return "UI_COMPONENT_TYPE_VERTICAL_FEED"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED" then
			return "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP" then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL" then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU" then
			return "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT" then
			return "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT"
		elseif p == "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU" then
			return "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID" then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID"
		elseif p == "UI_COMPONENT_TYPE_ITEM_MEDIA_HEADER" then
			return "UI_COMPONENT_TYPE_ITEM_MEDIA_HEADER"
		elseif p == "UI_COMPONENT_TYPE_CATALOG_ITEM_CARD" then
			return "UI_COMPONENT_TYPE_CATALOG_ITEM_CARD"
		elseif p == "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL" then
			return "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_PILL_TABS_CAROUSEL" then
			return "UI_COMPONENT_TYPE_PILL_TABS_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_USER_LIST" then
			return "UI_COMPONENT_TYPE_USER_LIST"
		elseif p == "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON" then
			return "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON"
		elseif p == "UI_COMPONENT_TYPE_FRIEND_CAROUSEL" then
			return "UI_COMPONENT_TYPE_FRIEND_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_PYMK_CAROUSEL" then
			return "UI_COMPONENT_TYPE_PYMK_CAROUSEL"
		elseif p == "UI_COMPONENT_TYPE_FRIENDS_OWNED_CHIP" then
			return "UI_COMPONENT_TYPE_FRIENDS_OWNED_CHIP"
		elseif p == "UI_COMPONENT_TYPE_GROUP_FORUM_POST_PREVIEW" then
			return "UI_COMPONENT_TYPE_GROUP_FORUM_POST_PREVIEW"
		elseif p == "UI_COMPONENT_TYPE_GROUP_SIDEBAR" then
			return "UI_COMPONENT_TYPE_GROUP_SIDEBAR"
		elseif p == "UI_COMPONENT_TYPE_GROUP_SECTION" then
			return "UI_COMPONENT_TYPE_GROUP_SECTION"
		elseif p == "UI_COMPONENT_TYPE_MOCK_COMPONENT" then
			return "UI_COMPONENT_TYPE_MOCK_COMPONENT"
		end

		return nil
	end
}

return { UiComponentType = v.UiComponentType }
