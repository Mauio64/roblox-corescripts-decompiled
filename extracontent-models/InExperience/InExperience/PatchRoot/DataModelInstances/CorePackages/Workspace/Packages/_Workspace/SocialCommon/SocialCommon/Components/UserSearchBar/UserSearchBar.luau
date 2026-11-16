local parent = script:FindFirstAncestor("SocialCommon").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local callbackInputBox = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.CallbackInputBox

local React = require(parent.React)
local RoactAppExperiment = require(parent.RoactAppExperiment)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local Dash = require(parent.Dash)
local UIBlox = require(parent.UIBlox)
local IconSize = UIBlox.App.Constant.IconSize

local TextButton = UIBlox.App.Button.TextButton
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local Foundation = require(parent.Foundation)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026FriendsBackground = SharedFlags.FFlagAppThemeHalloween2026FriendsBackground
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local iconsactionseditclear_small = Images["icons/actions/edit/clear_small"]

local SharedFlags2 = require(parent.SharedFlags)
local FFlagDisableAutocorrectSocialUserSearch = SharedFlags2.FFlagDisableAutocorrectSocialUserSearch
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppLogSocialUserSearchUXExposure = SharedFlags3.FFlagLuaAppLogSocialUserSearchUXExposure

local defineFastString = game:DefineFastString("DisableAutocorrectExperimentLayer", "Social.UserSearchUX")

local v = {
	cancelText = "Cancel",
	searchPlaceholderText = "Text",
	initialInputText = nil,
	LayoutOrder = 1,
	isDisabled = false,
	captureFocusOnMount = false,
	cancelCallback = nil,
	textChangedCallback = nil,
	focusChangedCallback = function() end
}

return function(options)
	local v2

	if FFlagDisableAutocorrectSocialUserSearch then
		v2 = RoactAppExperiment.useUserExperiment({ defineFastString }, function(p)
			return (p[defineFastString] or {}).disableAutocorrectSocialUserSearch
		end, not FFlagLuaAppLogSocialUserSearchUXExposure)
	end

	local joined = Dash.join(v, options or {})
	local v3 = useStyle()
	local v4

	if FFlagAppThemeHalloween2026FriendsBackground then
		v4 = useThemeBackground() ~= nil
	else
		v4 = false
	end

	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	React.useEffect(function()
		if joined.onSelectCallback then
			joined.onSelectCallback()
		end

		if joined.resetOnMount then
			joined.resetOnMount()
		end
	end, {})

	local header2 = v3.Font.Header2
	local v5 = v3.Font.BaseSize * header2.RelativeSize
	local v6

	if FoundationFontFaceMigration then
		v6 = GetTextSize(joined.cancelText, v5, v3.Tokens.Typography.TitleLarge.Font, Vector2.new(10000, 10000)).X
	else
		v6 = Text.GetTextWidth(joined.cancelText, header2.Font, v5)
	end

	local udim = UDim.new(0, 4)
	local udim2

	if joined.isDisabled then
		udim2 = UDim2.new(1, 0, 1, 0)
	else
		udim2 = UDim2.new(1, -v6 - 12, 1, 0)
	end

	local body = v3.Font.Body
	local v7 = v3.Font.BaseSize * body.RelativeSize

	local function fn(p, p2)
		if joined.focusChangedCallback then
			joined.focusChangedCallback(p, p2)
		end

		if p then
			setState(v3.Theme.SecondaryOnHover.Color)
			setState2(v3.Theme.SecondaryOnHover.Transparency)
		else
			setState(v3.Theme.Divider.Color)
			setState2(v3.Theme.Divider.Transparency)
		end
	end

	local createElement = React.createElement
	local v8 = {
		BackgroundTransparency = v4 and 1 or v3.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v3.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = joined.LayoutOrder
	}
	local v9 = {
		Layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = udim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6)
		}),
		CancelTextButton = 0,
		FilterBoxBackground = 0
	}
	local cancelTextButton

	if not joined.isDisabled then
		cancelTextButton = joined.cancelCallback
			and React.createElement(TextButton, {
				text = joined.cancelText,
				layoutOrder = 2,
				onActivated = joined.cancelCallback
			})
	end

	v9.CancelTextButton = cancelTextButton

	local createElement2 = React.createElement
	local v10 = {
		Size = udim2,
		BackgroundColor3 = v3.Theme.UIMuted.Color,
		BackgroundTransparency = v3.Theme.UIMuted.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 1
	}

	local v11 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
		UIStroke = React.createElement("UIStroke", {
			Color = state or v3.Theme.Divider.Color,
			Transparency = state2 or v3.Theme.Divider.Transparency,
			Thickness = 1
		}),
		UIListLayout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10)
		}),
		SearchIcon = React.createElement(Icon, {
			name = Enums.IconName.MagnifyingGlass,
			size = Enums.IconSize.Medium
		}),
		FilterBoxContainer = 0
	}

	local createElement3 = React.createElement
	local v12 = { BackgroundTransparency = 1, Size = UDim2.new(1, -28, 1, 0), LayoutOrder = 2 }
	local filterBox

	if joined.isDisabled then
		local createElement4 = React.createElement
		local v13 = {
			Text = joined.searchPlaceholderText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			TextSize = v7,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = body.Font
		end

		v13.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v3.Tokens.Typography.BodyLarge.Font)
		end

		v13.FontFace = fontFace

		v13.TextColor3 = v3.Theme.TextDefault.Color
		v13.TextTransparency = v3.Theme.TextMuted.Transparency
		filterBox = createElement4("TextLabel", v13)
	else
		local createElement4 = React.createElement
		local v13 = {
			initialInputText = joined.initialInputText,
			inputTextColor3 = v3.Theme.TextEmphasis.Color,
			inputTextFont = body.Font,
			inputTextSize = v7,
			inputTextTransparency = v3.Theme.TextEmphasis.Transparency,
			inputTextXAlignment = Enum.TextXAlignment.Left,
			textInputType = 0,
			returnKeyType = 0,
			placeholderText = 0,
			placeholderTextColor3 = 0,
			placeholderTextTransparency = 0,
			captureFocusOnMount = 0,
			clearButtonDisabled = false,
			clearIcon = 0,
			clearIconColor3 = 0,
			clearIconTransparency = 0,
			clearButtonSize = 0,
			textChangedCallback = 0,
			onSelectCallback = 0,
			focusChangedCallback = 0,
			returnPressedFromOnScreenKeyboardCallback = 0,
			inputBoxRef = 0
		}
		local textInputType

		if FFlagDisableAutocorrectSocialUserSearch and v2 then
			textInputType = Enum.TextInputType.NoSuggestions
		end

		v13.textInputType = textInputType
		local returnKeyType

		if FFlagDisableAutocorrectSocialUserSearch and v2 then
			returnKeyType = Enum.ReturnKeyType.Search
		end

		v13.returnKeyType = returnKeyType

		v13.placeholderText = joined.searchPlaceholderText
		v13.placeholderTextColor3 = v3.Theme.TextDefault.Color
		v13.placeholderTextTransparency = v3.Theme.TextMuted.Transparency

		v13.captureFocusOnMount = joined.captureFocusOnMount

		v13.clearIcon = iconsactionseditclear_small
		v13.clearIconColor3 = v3.Theme.IconEmphasis.Color
		v13.clearIconTransparency = v3.Theme.IconEmphasis.Transparency
		v13.clearButtonSize = IconSize.Small

		v13.textChangedCallback = joined.textChangedCallback
		v13.onSelectCallback = joined.onSelectCallback
		v13.focusChangedCallback = fn
		v13.returnPressedFromOnScreenKeyboardCallback = joined.returnPressedFromOnScreenKeyboardCallback

		v13.inputBoxRef = ref
		filterBox = createElement4(callbackInputBox, v13)
	end

	v11.FilterBoxContainer = createElement3("Frame", v12, { filterBox = filterBox })
	v9.FilterBoxBackground = createElement2(ImageSetLabel, v10, v11)
	return createElement("Frame", v8, v9)
end
