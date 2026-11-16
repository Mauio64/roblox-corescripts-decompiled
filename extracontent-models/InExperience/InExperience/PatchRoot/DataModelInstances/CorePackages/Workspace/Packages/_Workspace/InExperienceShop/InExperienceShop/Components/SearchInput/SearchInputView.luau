local parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local v = {
	searchPlaceholder = "Feature.Catalog.Label.Search",
	clear = "Feature.Avatar.Action.Clear"
}

local function SearchInputView(props)
	local v2 = useTokens()
	local v3 = useLocalization(v)
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Typography.BodyMedium.Font)
	else
		fontFace = Font.fromEnum(v2.Typography.BodyMedium.Font)
	end

	local fontSize = v2.Typography.BodyMedium.FontSize

	return React.createElement(
		Foundation.View,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge radius-medium",
			testId = "SearchInputView"
		},
		{
			BackButton = React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.ChevronLargeLeft,
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.ButtonSize.Small,
				onActivated = props.onBack,
				LayoutOrder = 0
			}),
			SearchField = React.createElement(
				Foundation.View,
				{
					tag = "fill radius-medium bg-surface-200",
					Size = UDim2.fromOffset(0, 36),
					LayoutOrder = 1
				},
				{
					SearchIcon = React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.MagnifyingGlass,
						size = Foundation.Enums.IconSize.Small,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 12, 0.5, 0)
					}),
					TextBox = React.createElement("TextBox", {
						ref = props.textBoxRef,
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ClearTextOnFocus = false,
						ClipsDescendants = true,
						FontFace = fontFace,
						PlaceholderText = v3.searchPlaceholder,
						PlaceholderColor3 = v2.Color.Content.Default.Color3,
						Position = UDim2.new(0, 40, 0.5, 0),
						Size = UDim2.new(1, -40, 1, 0),
						Text = props.text,
						TextColor3 = v2.Color.Content.Emphasis.Color3,
						TextSize = fontSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = false,
						[React.Change.Text] = props.onTextChanged,
						[React.Event.FocusLost] = props.onFocusLost
					})
				}
			),
			ClearButton = React.createElement(Foundation.Button, {
				text = v3.clear,
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.InputSize.XSmall,
				onActivated = props.onClear,
				LayoutOrder = 2
			})
		}
	)
end

return SearchInputView
