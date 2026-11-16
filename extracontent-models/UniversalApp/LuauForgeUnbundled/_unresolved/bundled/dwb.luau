local function scaleSizeForPlatform(p2, p3)
	return p2 * p3.Stroke.Standard
end

return {
	SEARCH_MARGIN = 24,
	SEARCH_BAR_HEIGHT = 28,
	SEARCH_BAR_PADDING = 12,
	SEARCH_BAR_TEXT_SIZE = 20,
	SEARCH_BAR_ICON_PADDING = 9,
	SEARCH_BAR_TEXT_PADDING_WITH_ICON = 36,
	SEARCH_BAR_TEXT_PADDING_WITHOUT_ICON = 12,
	CLEAR_IMAGE_SIZE = 16,
	CLEAR_IMAGE_PADDING = 6,
	CANCEL_BUTTON_WIDTH = 88,
	CANCEL_BUTTON_PADDING = 7,
	TABLET_LIST_PICKER_HEIGHT = 540,
	SHADOW_BOLDNESS = 14,
	SHADOW_TOP_OFFSET = 5,
	SHADOW_BOTTOM_OFFSET = 12,
	OverlayContentPageType = {
		LandingPage = "LandingPage",
		AutocompleteSuggestions = "AutocompleteSuggestions",
		NoResults = "NoResults"
	},
	SearchBarAnimationStyle = {
		ExpandFromRight = "ExpandFromRight",
		ExpandFromCenter = "ExpandFromCenter"
	},
	NON_COMPACT_SEARCH_BAR_SIZE = 400,
	getSearchTokens = function(data)
		return {
			searchMargin = data.Size.Size_600,
			backgroundContainer = {
				screenWidthScale = 0.625,
				minimumWidth = 712 * data.Stroke.Standard,
				maximumWidth = 1500 * data.Stroke.Standard,
				padding = data.Size.Size_1200,
				backgroundColor3 = data.Color.Surface.Surface_0.Color3,
				backgroundTransparency = data.Color.Surface.Surface_0.Transparency,
				shadowBoldness = data.Size.Size_350,
				shadowTopOffset = 5 * data.Stroke.Standard,
				shadowBottomOffset = data.Size.Size_300
			},
			searchLandingPage = {
				topPadding = data.Size.Size_600,
				bottomPadding = 38 * data.Stroke.Standard,
				itemPadding = data.Size.Size_1200,
				trendingSearches = {
					pillTextSize = data.Size.Size_500,
					pillVerticalPadding = data.Size.Size_200,
					pillHorizontalPadding = data.Size.Size_400,
					pillFont = data.Typography.BodyLarge.Font,
					pillTextColor = data.Color.Content.Emphasis.Color3,
					pillBackgroundColor = data.Color.State.Hover.Color3,
					pillBackgroundTransparency = data.Color.State.Hover.Transparency,
					columnGap = data.Size.Size_250
				}
			},
			searchBarListPicker = { height = 540 }
		}
	end
}
