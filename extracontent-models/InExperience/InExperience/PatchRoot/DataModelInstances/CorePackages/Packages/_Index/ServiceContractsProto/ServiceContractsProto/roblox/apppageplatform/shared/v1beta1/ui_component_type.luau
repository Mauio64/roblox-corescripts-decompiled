require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

return {
	UiComponentType = ({
		UiComponentType = {
			fromNumber = function(n1: number) -- line: 104
				if n1 == 0 then
					return "UI_COMPONENT_TYPE_INVALID"
				end

				if n1 == 1 then
					return "UI_COMPONENT_TYPE_FEED"
				end

				if n1 == 10 then
					return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL"
				end

				if n1 == 11 then
					return "UI_COMPONENT_TYPE_COLLECTION_GRID"
				end

				if n1 == 12 then
					return "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION"
				end

				if n1 == 13 then
					return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER"
				end

				if n1 == 14 then
					return "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL"
				end

				if n1 == 15 then
					return "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION"
				end

				if n1 == 100 then
					return "UI_COMPONENT_TYPE_TILE"
				end

				if n1 == 101 then
					return "UI_COMPONENT_TYPE_GAME_TILE"
				end

				if n1 == 102 then
					return "UI_COMPONENT_TYPE_SEE_ALL_TILE"
				end

				if n1 == 103 then
					return "UI_COMPONENT_TYPE_BADGE_TILE"
				end

				if n1 == 104 then
					return "UI_COMPONENT_TYPE_SONG_TILE"
				end

				if n1 == 105 then
					return "UI_COMPONENT_TYPE_EVENT_TILE"
				end

				if n1 == 106 then
					return "UI_COMPONENT_TYPE_PLACEHOLDER_TILE"
				end

				if n1 == 200 then
					return "UI_COMPONENT_TYPE_BUTTON"
				end

				if n1 == 201 then
					return "UI_COMPONENT_TYPE_IMAGE"
				end

				if n1 == 202 then
					return "UI_COMPONENT_TYPE_TEXT"
				end

				if n1 == 203 then
					return "UI_COMPONENT_TYPE_VIEW"
				end

				if n1 == 204 then
					return "UI_COMPONENT_TYPE_DIVIDER"
				end

				if n1 == 205 then
					return "UI_COMPONENT_TYPE_DIALOG"
				end

				if n1 == 206 then
					return "UI_COMPONENT_TYPE_TEXT_ICON_ROW"
				end

				if n1 == 207 then
					return "UI_COMPONENT_TYPE_TEXT_PILL"
				end

				if n1 == 208 then
					return "UI_COMPONENT_TYPE_SECTION_HEADER"
				end

				if n1 == 209 then
					return "UI_COMPONENT_TYPE_SLOT_OVERLAY"
				end

				if n1 == 210 then
					return "UI_COMPONENT_TYPE_TILE_FOOTER"
				end

				if n1 == 211 then
					return "UI_COMPONENT_TYPE_ATTRIBUTION_ROW"
				end

				if n1 == 212 then
					return "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER"
				end

				if n1 == 213 then
					return "UI_COMPONENT_TYPE_HERO_UNIT"
				end

				if n1 == 214 then
					return "UI_COMPONENT_TYPE_HOLD_TO_PLAY"
				end

				if n1 == 215 then
					return "UI_COMPONENT_TYPE_PLAY_BUTTON"
				end

				if n1 == 216 then
					return "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW"
				end

				if n1 == 217 then
					return "UI_COMPONENT_TYPE_INFO_TABLE"
				end

				if n1 == 218 then
					return "UI_COMPONENT_TYPE_INFO_TABLE_CELL"
				end

				if n1 == 219 then
					return "UI_COMPONENT_TYPE_CHIP"
				end

				if n1 == 220 then
					return "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP"
				end

				if n1 == 221 then
					return "UI_COMPONENT_TYPE_EXPANDABLE_TEXT"
				end

				if n1 == 222 then
					return "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW"
				end

				if n1 == 223 then
					return "UI_COMPONENT_TYPE_OVERFLOW_MENU"
				end

				if n1 == 224 then
					return "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER"
				end

				if n1 == 225 then
					return "UI_COMPONENT_TYPE_CARD"
				end

				if n1 == 226 then
					return "UI_COMPONENT_TYPE_TABS"
				end

				if n1 == 227 then
					return "UI_COMPONENT_TYPE_ACTION_BAR"
				end

				if n1 == 228 then
					return "UI_COMPONENT_TYPE_ICON"
				end

				if n1 == 229 then
					return "UI_COMPONENT_TYPE_CIRCLE_ICON"
				end

				if n1 == 230 then
					return "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL"
				end

				if n1 == 231 then
					return "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE"
				end

				if n1 == 232 then
					return "UI_COMPONENT_TYPE_MEDIA_GALLERY"
				end

				if n1 == 233 then
					return "UI_COMPONENT_TYPE_CONTENT_ROW"
				end

				if n1 == 234 then
					return "UI_COMPONENT_TYPE_LINK_TEXT"
				end

				if n1 == 235 then
					return "UI_COMPONENT_TYPE_COACHMARK"
				end

				if n1 == 236 then
					return "UI_COMPONENT_TYPE_BADGE"
				end

				if n1 == 237 then
					return "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL"
				end

				if n1 == 238 then
					return "UI_COMPONENT_TYPE_SHEET_FULL_BLEED"
				end

				if n1 == 239 then
					return "UI_COMPONENT_TYPE_SYSTEM_BANNER"
				end

				if n1 == 240 then
					return "UI_COMPONENT_TYPE_PLAY_WITH_REWARD"
				end

				if n1 == 241 then
					return "UI_COMPONENT_TYPE_ICON_BUTTON"
				end

				if n1 == 242 then
					return "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW"
				end

				if n1 == 243 then
					return "UI_COMPONENT_TYPE_PAGE_HEADER"
				end

				if n1 == 244 then
					return "UI_COMPONENT_TYPE_AVATAR_GROUP"
				end

				if n1 == 245 then
					return "UI_COMPONENT_TYPE_TOOLTIP"
				end

				if n1 == 246 then
					return "UI_COMPONENT_TYPE_AI_OVERVIEW"
				end

				if n1 == 247 then
					return "UI_COMPONENT_TYPE_SKELETON"
				end

				if n1 == 248 then
					return "UI_COMPONENT_TYPE_PLACEHOLDER"
				end

				if n1 == 249 then
					return "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER"
				end

				if n1 == 250 then
					return "UI_COMPONENT_TYPE_REVEAL_TEXT"
				end

				if n1 == 251 then
					return "UI_COMPONENT_TYPE_SHIMMER_TEXT"
				end

				if n1 == 252 then
					return "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON"
				end

				if n1 == 253 then
					return "UI_COMPONENT_TYPE_LOGO"
				end

				if n1 == 254 then
					return "UI_COMPONENT_TYPE_FEEDBACK_BANNER"
				end

				if n1 == 255 then
					return "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN"
				end

				if n1 == 300 then
					return "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS"
				end

				if n1 == 400 then
					return "UI_COMPONENT_TYPE_FRAGMENT"
				end

				if n1 == 500 then
					return "UI_COMPONENT_TYPE_VERTICAL_FEED"
				end

				if n1 == 600 then
					return "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED"
				end

				if n1 == 601 then
					return "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP"
				end

				if n1 == 602 then
					return "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL"
				end

				if n1 == 603 then
					return "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU"
				end

				if n1 == 604 then
					return "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT"
				end

				if n1 == 605 then
					return "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU"
				end

				if n1 == 606 then
					return "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID"
				end

				if n1 == 700 then
					return "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL"
				end

				if n1 == 800 then
					return "UI_COMPONENT_TYPE_USER_LIST"
				end

				if n1 == 801 then
					return "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON"
				end

				if n1 == 9999 then
					return "UI_COMPONENT_TYPE_MOCK_COMPONENT"
				end

				return nil
			end,
			toNumber = function(p1) -- line: 280
				if p1 == "UI_COMPONENT_TYPE_INVALID" then
					return 0
				end

				if p1 == "UI_COMPONENT_TYPE_FEED" then
					return 1
				end

				if p1 == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL" then
					return 10
				end

				if p1 == "UI_COMPONENT_TYPE_COLLECTION_GRID" then
					return 11
				end

				if p1 == "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION" then
					return 12
				end

				if p1 == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER" then
					return 13
				end

				if p1 == "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL" then
					return 14
				end

				if p1 == "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION" then
					return 15
				end

				if p1 == "UI_COMPONENT_TYPE_TILE" then
					return 100
				end

				if p1 == "UI_COMPONENT_TYPE_GAME_TILE" then
					return 101
				end

				if p1 == "UI_COMPONENT_TYPE_SEE_ALL_TILE" then
					return 102
				end

				if p1 == "UI_COMPONENT_TYPE_BADGE_TILE" then
					return 103
				end

				if p1 == "UI_COMPONENT_TYPE_SONG_TILE" then
					return 104
				end

				if p1 == "UI_COMPONENT_TYPE_EVENT_TILE" then
					return 105
				end

				if p1 == "UI_COMPONENT_TYPE_PLACEHOLDER_TILE" then
					return 106
				end

				if p1 == "UI_COMPONENT_TYPE_BUTTON" then
					return 200
				end

				if p1 == "UI_COMPONENT_TYPE_IMAGE" then
					return 201
				end

				if p1 == "UI_COMPONENT_TYPE_TEXT" then
					return 202
				end

				if p1 == "UI_COMPONENT_TYPE_VIEW" then
					return 203
				end

				if p1 == "UI_COMPONENT_TYPE_DIVIDER" then
					return 204
				end

				if p1 == "UI_COMPONENT_TYPE_DIALOG" then
					return 205
				end

				if p1 == "UI_COMPONENT_TYPE_TEXT_ICON_ROW" then
					return 206
				end

				if p1 == "UI_COMPONENT_TYPE_TEXT_PILL" then
					return 207
				end

				if p1 == "UI_COMPONENT_TYPE_SECTION_HEADER" then
					return 208
				end

				if p1 == "UI_COMPONENT_TYPE_SLOT_OVERLAY" then
					return 209
				end

				if p1 == "UI_COMPONENT_TYPE_TILE_FOOTER" then
					return 210
				end

				if p1 == "UI_COMPONENT_TYPE_ATTRIBUTION_ROW" then
					return 211
				end

				if p1 == "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER" then
					return 212
				end

				if p1 == "UI_COMPONENT_TYPE_HERO_UNIT" then
					return 213
				end

				if p1 == "UI_COMPONENT_TYPE_HOLD_TO_PLAY" then
					return 214
				end

				if p1 == "UI_COMPONENT_TYPE_PLAY_BUTTON" then
					return 215
				end

				if p1 == "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW" then
					return 216
				end

				if p1 == "UI_COMPONENT_TYPE_INFO_TABLE" then
					return 217
				end

				if p1 == "UI_COMPONENT_TYPE_INFO_TABLE_CELL" then
					return 218
				end

				if p1 == "UI_COMPONENT_TYPE_CHIP" then
					return 219
				end

				if p1 == "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP" then
					return 220
				end

				if p1 == "UI_COMPONENT_TYPE_EXPANDABLE_TEXT" then
					return 221
				end

				if p1 == "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW" then
					return 222
				end

				if p1 == "UI_COMPONENT_TYPE_OVERFLOW_MENU" then
					return 223
				end

				if p1 == "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER" then
					return 224
				end

				if p1 == "UI_COMPONENT_TYPE_CARD" then
					return 225
				end

				if p1 == "UI_COMPONENT_TYPE_TABS" then
					return 226
				end

				if p1 == "UI_COMPONENT_TYPE_ACTION_BAR" then
					return 227
				end

				if p1 == "UI_COMPONENT_TYPE_ICON" then
					return 228
				end

				if p1 == "UI_COMPONENT_TYPE_CIRCLE_ICON" then
					return 229
				end

				if p1 == "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL" then
					return 230
				end

				if p1 == "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE" then
					return 231
				end

				if p1 == "UI_COMPONENT_TYPE_MEDIA_GALLERY" then
					return 232
				end

				if p1 == "UI_COMPONENT_TYPE_CONTENT_ROW" then
					return 233
				end

				if p1 == "UI_COMPONENT_TYPE_LINK_TEXT" then
					return 234
				end

				if p1 == "UI_COMPONENT_TYPE_COACHMARK" then
					return 235
				end

				if p1 == "UI_COMPONENT_TYPE_BADGE" then
					return 236
				end

				if p1 == "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL" then
					return 237
				end

				if p1 == "UI_COMPONENT_TYPE_SHEET_FULL_BLEED" then
					return 238
				end

				if p1 == "UI_COMPONENT_TYPE_SYSTEM_BANNER" then
					return 239
				end

				if p1 == "UI_COMPONENT_TYPE_PLAY_WITH_REWARD" then
					return 240
				end

				if p1 == "UI_COMPONENT_TYPE_ICON_BUTTON" then
					return 241
				end

				if p1 == "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW" then
					return 242
				end

				if p1 == "UI_COMPONENT_TYPE_PAGE_HEADER" then
					return 243
				end

				if p1 == "UI_COMPONENT_TYPE_AVATAR_GROUP" then
					return 244
				end

				if p1 == "UI_COMPONENT_TYPE_TOOLTIP" then
					return 245
				end

				if p1 == "UI_COMPONENT_TYPE_AI_OVERVIEW" then
					return 246
				end

				if p1 == "UI_COMPONENT_TYPE_SKELETON" then
					return 247
				end

				if p1 == "UI_COMPONENT_TYPE_PLACEHOLDER" then
					return 248
				end

				if p1 == "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER" then
					return 249
				end

				if p1 == "UI_COMPONENT_TYPE_REVEAL_TEXT" then
					return 250
				end

				if p1 == "UI_COMPONENT_TYPE_SHIMMER_TEXT" then
					return 251
				end

				if p1 == "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON" then
					return 252
				end

				if p1 == "UI_COMPONENT_TYPE_LOGO" then
					return 253
				end

				if p1 == "UI_COMPONENT_TYPE_FEEDBACK_BANNER" then
					return 254
				end

				if p1 == "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN" then
					return 255
				end

				if p1 == "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS" then
					return 300
				end

				if p1 == "UI_COMPONENT_TYPE_FRAGMENT" then
					return 400
				end

				if p1 == "UI_COMPONENT_TYPE_VERTICAL_FEED" then
					return 500
				end

				if p1 == "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED" then
					return 600
				end

				if p1 == "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP" then
					return 601
				end

				if p1 == "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL" then
					return 602
				end

				if p1 == "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU" then
					return 603
				end

				if p1 == "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT" then
					return 604
				end

				if p1 == "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU" then
					return 605
				end

				if p1 == "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID" then
					return 606
				end

				if p1 == "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL" then
					return 700
				end

				if p1 == "UI_COMPONENT_TYPE_USER_LIST" then
					return 800
				end

				if p1 == "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON" then
					return 801
				end

				if p1 == "UI_COMPONENT_TYPE_MOCK_COMPONENT" then
					return 9999
				end

				return p1
			end,
			fromName = function(s1: string) -- line: 456
				if s1 == "UI_COMPONENT_TYPE_INVALID" then
					return "UI_COMPONENT_TYPE_INVALID"
				end

				if s1 == "UI_COMPONENT_TYPE_FEED" then
					return "UI_COMPONENT_TYPE_FEED"
				end

				if s1 == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL" then
					return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL"
				end

				if s1 == "UI_COMPONENT_TYPE_COLLECTION_GRID" then
					return "UI_COMPONENT_TYPE_COLLECTION_GRID"
				end

				if s1 == "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION" then
					return "UI_COMPONENT_TYPE_SINGLE_ITEM_COLLECTION"
				end

				if s1 == "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER" then
					return "UI_COMPONENT_TYPE_COLLECTION_CAROUSEL_PLACEHOLDER"
				end

				if s1 == "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL" then
					return "UI_COMPONENT_TYPE_VARIABLE_ITEM_WIDTH_CAROUSEL"
				end

				if s1 == "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION" then
					return "UI_COMPONENT_TYPE_OPTION_SELECTOR_COLLECTION"
				end

				if s1 == "UI_COMPONENT_TYPE_TILE" then
					return "UI_COMPONENT_TYPE_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_GAME_TILE" then
					return "UI_COMPONENT_TYPE_GAME_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_SEE_ALL_TILE" then
					return "UI_COMPONENT_TYPE_SEE_ALL_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_BADGE_TILE" then
					return "UI_COMPONENT_TYPE_BADGE_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_SONG_TILE" then
					return "UI_COMPONENT_TYPE_SONG_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_EVENT_TILE" then
					return "UI_COMPONENT_TYPE_EVENT_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_PLACEHOLDER_TILE" then
					return "UI_COMPONENT_TYPE_PLACEHOLDER_TILE"
				end

				if s1 == "UI_COMPONENT_TYPE_BUTTON" then
					return "UI_COMPONENT_TYPE_BUTTON"
				end

				if s1 == "UI_COMPONENT_TYPE_IMAGE" then
					return "UI_COMPONENT_TYPE_IMAGE"
				end

				if s1 == "UI_COMPONENT_TYPE_TEXT" then
					return "UI_COMPONENT_TYPE_TEXT"
				end

				if s1 == "UI_COMPONENT_TYPE_VIEW" then
					return "UI_COMPONENT_TYPE_VIEW"
				end

				if s1 == "UI_COMPONENT_TYPE_DIVIDER" then
					return "UI_COMPONENT_TYPE_DIVIDER"
				end

				if s1 == "UI_COMPONENT_TYPE_DIALOG" then
					return "UI_COMPONENT_TYPE_DIALOG"
				end

				if s1 == "UI_COMPONENT_TYPE_TEXT_ICON_ROW" then
					return "UI_COMPONENT_TYPE_TEXT_ICON_ROW"
				end

				if s1 == "UI_COMPONENT_TYPE_TEXT_PILL" then
					return "UI_COMPONENT_TYPE_TEXT_PILL"
				end

				if s1 == "UI_COMPONENT_TYPE_SECTION_HEADER" then
					return "UI_COMPONENT_TYPE_SECTION_HEADER"
				end

				if s1 == "UI_COMPONENT_TYPE_SLOT_OVERLAY" then
					return "UI_COMPONENT_TYPE_SLOT_OVERLAY"
				end

				if s1 == "UI_COMPONENT_TYPE_TILE_FOOTER" then
					return "UI_COMPONENT_TYPE_TILE_FOOTER"
				end

				if s1 == "UI_COMPONENT_TYPE_ATTRIBUTION_ROW" then
					return "UI_COMPONENT_TYPE_ATTRIBUTION_ROW"
				end

				if s1 == "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER" then
					return "UI_COMPONENT_TYPE_GAME_TILE_ACTIVE_FRIENDS_FOOTER"
				end

				if s1 == "UI_COMPONENT_TYPE_HERO_UNIT" then
					return "UI_COMPONENT_TYPE_HERO_UNIT"
				end

				if s1 == "UI_COMPONENT_TYPE_HOLD_TO_PLAY" then
					return "UI_COMPONENT_TYPE_HOLD_TO_PLAY"
				end

				if s1 == "UI_COMPONENT_TYPE_PLAY_BUTTON" then
					return "UI_COMPONENT_TYPE_PLAY_BUTTON"
				end

				if s1 == "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW" then
					return "UI_COMPONENT_TYPE_COUNTDOWN_TEXT_ICON_ROW"
				end

				if s1 == "UI_COMPONENT_TYPE_INFO_TABLE" then
					return "UI_COMPONENT_TYPE_INFO_TABLE"
				end

				if s1 == "UI_COMPONENT_TYPE_INFO_TABLE_CELL" then
					return "UI_COMPONENT_TYPE_INFO_TABLE_CELL"
				end

				if s1 == "UI_COMPONENT_TYPE_CHIP" then
					return "UI_COMPONENT_TYPE_CHIP"
				end

				if s1 == "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP" then
					return "UI_COMPONENT_TYPE_DUAL_ACTION_CHIP"
				end

				if s1 == "UI_COMPONENT_TYPE_EXPANDABLE_TEXT" then
					return "UI_COMPONENT_TYPE_EXPANDABLE_TEXT"
				end

				if s1 == "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW" then
					return "UI_COMPONENT_TYPE_ASSOCIATED_ITEMS_ROW"
				end

				if s1 == "UI_COMPONENT_TYPE_OVERFLOW_MENU" then
					return "UI_COMPONENT_TYPE_OVERFLOW_MENU"
				end

				if s1 == "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER" then
					return "UI_COMPONENT_TYPE_DETAILS_PAGE_IMAGE_HEADER"
				end

				if s1 == "UI_COMPONENT_TYPE_CARD" then
					return "UI_COMPONENT_TYPE_CARD"
				end

				if s1 == "UI_COMPONENT_TYPE_TABS" then
					return "UI_COMPONENT_TYPE_TABS"
				end

				if s1 == "UI_COMPONENT_TYPE_ACTION_BAR" then
					return "UI_COMPONENT_TYPE_ACTION_BAR"
				end

				if s1 == "UI_COMPONENT_TYPE_ICON" then
					return "UI_COMPONENT_TYPE_ICON"
				end

				if s1 == "UI_COMPONENT_TYPE_CIRCLE_ICON" then
					return "UI_COMPONENT_TYPE_CIRCLE_ICON"
				end

				if s1 == "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL" then
					return "UI_COMPONENT_TYPE_CONTENT_RATING_LABEL"
				end

				if s1 == "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE" then
					return "UI_COMPONENT_TYPE_PLAY_BUTTON_CONTEXTUAL_MESSAGE"
				end

				if s1 == "UI_COMPONENT_TYPE_MEDIA_GALLERY" then
					return "UI_COMPONENT_TYPE_MEDIA_GALLERY"
				end

				if s1 == "UI_COMPONENT_TYPE_CONTENT_ROW" then
					return "UI_COMPONENT_TYPE_CONTENT_ROW"
				end

				if s1 == "UI_COMPONENT_TYPE_LINK_TEXT" then
					return "UI_COMPONENT_TYPE_LINK_TEXT"
				end

				if s1 == "UI_COMPONENT_TYPE_COACHMARK" then
					return "UI_COMPONENT_TYPE_COACHMARK"
				end

				if s1 == "UI_COMPONENT_TYPE_BADGE" then
					return "UI_COMPONENT_TYPE_BADGE"
				end

				if s1 == "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL" then
					return "UI_COMPONENT_TYPE_SUBSCRIPTION_CELL"
				end

				if s1 == "UI_COMPONENT_TYPE_SHEET_FULL_BLEED" then
					return "UI_COMPONENT_TYPE_SHEET_FULL_BLEED"
				end

				if s1 == "UI_COMPONENT_TYPE_SYSTEM_BANNER" then
					return "UI_COMPONENT_TYPE_SYSTEM_BANNER"
				end

				if s1 == "UI_COMPONENT_TYPE_PLAY_WITH_REWARD" then
					return "UI_COMPONENT_TYPE_PLAY_WITH_REWARD"
				end

				if s1 == "UI_COMPONENT_TYPE_ICON_BUTTON" then
					return "UI_COMPONENT_TYPE_ICON_BUTTON"
				end

				if s1 == "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW" then
					return "UI_COMPONENT_TYPE_AGE_CHECK_UPSELL_ROW"
				end

				if s1 == "UI_COMPONENT_TYPE_PAGE_HEADER" then
					return "UI_COMPONENT_TYPE_PAGE_HEADER"
				end

				if s1 == "UI_COMPONENT_TYPE_AVATAR_GROUP" then
					return "UI_COMPONENT_TYPE_AVATAR_GROUP"
				end

				if s1 == "UI_COMPONENT_TYPE_TOOLTIP" then
					return "UI_COMPONENT_TYPE_TOOLTIP"
				end

				if s1 == "UI_COMPONENT_TYPE_AI_OVERVIEW" then
					return "UI_COMPONENT_TYPE_AI_OVERVIEW"
				end

				if s1 == "UI_COMPONENT_TYPE_SKELETON" then
					return "UI_COMPONENT_TYPE_SKELETON"
				end

				if s1 == "UI_COMPONENT_TYPE_PLACEHOLDER" then
					return "UI_COMPONENT_TYPE_PLACEHOLDER"
				end

				if s1 == "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER" then
					return "UI_COMPONENT_TYPE_PLACEHOLDER_WRAPPER"
				end

				if s1 == "UI_COMPONENT_TYPE_REVEAL_TEXT" then
					return "UI_COMPONENT_TYPE_REVEAL_TEXT"
				end

				if s1 == "UI_COMPONENT_TYPE_SHIMMER_TEXT" then
					return "UI_COMPONENT_TYPE_SHIMMER_TEXT"
				end

				if s1 == "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON" then
					return "UI_COMPONENT_TYPE_APP_DOWNLOAD_BUTTON"
				end

				if s1 == "UI_COMPONENT_TYPE_LOGO" then
					return "UI_COMPONENT_TYPE_LOGO"
				end

				if s1 == "UI_COMPONENT_TYPE_FEEDBACK_BANNER" then
					return "UI_COMPONENT_TYPE_FEEDBACK_BANNER"
				end

				if s1 == "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN" then
					return "UI_COMPONENT_TYPE_GAME_SORT_DROP_DOWN"
				end

				if s1 == "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS" then
					return "UI_COMPONENT_TYPE_FOCUS_NAV_ACTIONS"
				end

				if s1 == "UI_COMPONENT_TYPE_FRAGMENT" then
					return "UI_COMPONENT_TYPE_FRAGMENT"
				end

				if s1 == "UI_COMPONENT_TYPE_VERTICAL_FEED" then
					return "UI_COMPONENT_TYPE_VERTICAL_FEED"
				end

				if s1 == "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED" then
					return "UI_COMPONENT_TYPE_CATALOG_VIRTUALIZED_FEED"
				end

				if s1 == "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP" then
					return "UI_COMPONENT_TYPE_CATALOG_ITEM_GROUP"
				end

				if s1 == "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL" then
					return "UI_COMPONENT_TYPE_CATALOG_ITEM_CAROUSEL"
				end

				if s1 == "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU" then
					return "UI_COMPONENT_TYPE_CATALOG_CATEGORY_MENU"
				end

				if s1 == "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT" then
					return "UI_COMPONENT_TYPE_CATALOG_HERO_UNIT"
				end

				if s1 == "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU" then
					return "UI_COMPONENT_TYPE_MARKETPLACE_FAVORITES_CATEGORY_MENU"
				end

				if s1 == "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID" then
					return "UI_COMPONENT_TYPE_CATALOG_ITEM_GRID"
				end

				if s1 == "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL" then
					return "UI_COMPONENT_TYPE_FILTER_PILLS_CAROUSEL"
				end

				if s1 == "UI_COMPONENT_TYPE_USER_LIST" then
					return "UI_COMPONENT_TYPE_USER_LIST"
				end

				if s1 == "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON" then
					return "UI_COMPONENT_TYPE_FRIEND_REQUEST_BUTTON"
				end

				if s1 == "UI_COMPONENT_TYPE_MOCK_COMPONENT" then
					return "UI_COMPONENT_TYPE_MOCK_COMPONENT"
				end

				return nil
			end
		}
	}).UiComponentType
}
