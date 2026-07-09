local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local t1 = {
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
	NON_COMPACT_SEARCH_BAR_SIZE = 400,
	OverlayContentPageType = {
		LandingPage = "LandingPage",
		AutocompleteSuggestions = "AutocompleteSuggestions",
		NoResults = "NoResults"
	},
	SearchBarAnimationStyle = {
		ExpandFromRight = "ExpandFromRight",
		ExpandFromCenter = "ExpandFromCenter"
	}
}

local function scaleSizeForPlatform(n1: number, t2: {[any]: any}) -- line: 43
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return n1 * if not FFlagRenameDeprecatedUIBloxTokens then t2.Global.Stroke_100 else t2.Stroke.Standard
end

function t1.getSearchTokens(t3: {[any]: any}) -- line: 48
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		searchMargin = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_300 else t3.Size.Size_600,
		backgroundContainer = {
			screenWidthScale = 0.625,
			minimumWidth = 712 * if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Stroke_100 else t3.Stroke.Standard,
			maximumWidth = 1500 * if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Stroke_100 else t3.Stroke.Standard,
			padding = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_600 else t3.Size.Size_1200,
			backgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then t3.Semantic.Color.Background.Default else t3.Color.Surface.Surface_0)).Color3,
			backgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then t3.Semantic.Color.Background.Default else t3.Color.Surface.Surface_0)).Transparency,
			shadowBoldness = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_175 else t3.Size.Size_350,
			shadowTopOffset = 5 * if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Stroke_100 else t3.Stroke.Standard,
			shadowBottomOffset = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_150 else t3.Size.Size_300
		},
		searchLandingPage = {
			topPadding = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_300 else t3.Size.Size_600,
			bottomPadding = 38 * if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Stroke_100 else t3.Stroke.Standard,
			itemPadding = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_600 else t3.Size.Size_1200,
			trendingSearches = {
				pillTextSize = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_250 else t3.Size.Size_500,
				pillVerticalPadding = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_100 else t3.Size.Size_200,
				pillHorizontalPadding = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_200 else t3.Size.Size_400,
				pillFont = if not FFlagRenameDeprecatedUIBloxTokens then t3.Semantic.Typography.Body.Font else t3.Typography.BodyLarge.Font,
				pillTextColor = ((if not FFlagRenameDeprecatedUIBloxTokens then t3.Semantic.Color.Text.Emphasis else t3.Color.Content.Emphasis)).Color3,
				pillBackgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then t3.Semantic.Color.Background.OnHover else t3.Color.State.Hover)).Color3,
				pillBackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then t3.Semantic.Color.Background.OnHover else t3.Color.State.Hover)).Transparency,
				columnGap = if not FFlagRenameDeprecatedUIBloxTokens then t3.Global.Size_125 else t3.Size.Size_250
			}
		},
		searchBarListPicker = {
			height = 540
		}
	}
end

return t1
