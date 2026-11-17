local parent = script:FindFirstAncestor("SocialCommon").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local callbackInputBox = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.CallbackInputBox

local React = require(parent.React)
local RoactAppExperiment = require(parent.RoactAppExperiment)
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
	local x = GetTextSize(joined.cancelText, v5, v3.Tokens.Typography.TitleLarge.Font, Vector2.new(10000, 10000)).X

	local udim = UDim.new(0, 4)
	local udim2

	if joined.isDisabled then
		udim2 = UDim2.new(1, 0, 1, 0)
	else
		udim2 = UDim2.new(1, -x - 12, 1, 0)
	end

	local body = v3.Font.Body
	local v6 = v3.Font.BaseSize * body.RelativeSize

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
	local v7 = {
		BackgroundTransparency = v4 and 1 or v3.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v3.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = joined.LayoutOrder
	}
	local v8 = {
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

	v8.CancelTextButton = cancelTextButton

	local createElement2 = React.createElement
	local v9 = {
		Size = udim2,
		BackgroundColor3 = v3.Theme.UIMuted.Color,
		BackgroundTransparency = v3.Theme.UIMuted.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 1
	}

	local v10 = {
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
	local v11 = { BackgroundTransparency = 1, Size = UDim2.new(1, -28, 1, 0), LayoutOrder = 2 }
	local filterBox

	if joined.isDisabled then
		filterBox = React.createElement("TextLabel", {
			Text = joined.searchPlaceholderText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			TextSize = v6,
			FontFace = normalizeFontFace(v3.Tokens.Typography.BodyLarge.Font),
			TextColor3 = v3.Theme.TextDefault.Color,
			TextTransparency = v3.Theme.TextMuted.Transparency
		})
	else
		local createElement4 = React.createElement
		local v12 = {
			initialInputText = joined.initialInputText,
			inputTextColor3 = v3.Theme.TextEmphasis.Color,
			inputTextFont = body.Font,
			inputTextSize = v6,
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

		v12.textInputType = textInputType
		local returnKeyType

		if FFlagDisableAutocorrectSocialUserSearch and v2 then
			returnKeyType = Enum.ReturnKeyType.Search
		end

		v12.returnKeyType = returnKeyType

		v12.placeholderText = joined.searchPlaceholderText
		v12.placeholderTextColor3 = v3.Theme.TextDefault.Color
		v12.placeholderTextTransparency = v3.Theme.TextMuted.Transparency

		v12.captureFocusOnMount = joined.captureFocusOnMount

		v12.clearIcon = iconsactionseditclear_small
		v12.clearIconColor3 = v3.Theme.IconEmphasis.Color
		v12.clearIconTransparency = v3.Theme.IconEmphasis.Transparency
		v12.clearButtonSize = IconSize.Small

		v12.textChangedCallback = joined.textChangedCallback
		v12.onSelectCallback = joined.onSelectCallback
		v12.focusChangedCallback = fn
		v12.returnPressedFromOnScreenKeyboardCallback = joined.returnPressedFromOnScreenKeyboardCallback

		v12.inputBoxRef = ref
		filterBox = createElement4(callbackInputBox, v12)
	end

	v10.FilterBoxContainer = createElement3("Frame", v11, { filterBox = filterBox })
	v8.FilterBoxBackground = createElement2(ImageSetLabel, v9, v10)
	return createElement("Frame", v7, v8)
end
