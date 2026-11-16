local callbackInputBox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/LuaSocialLibrariesDeps").SocialLibraries.config({}).Components.CallbackInputBox

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/RoactAppExperiment")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/AppCommonLib").Text
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Dash")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local iconSize = UIBlox.App.Constant.IconSize

local textButton = UIBlox.App.Button.TextButton
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")

local fFlagAppThemeHalloween2026FriendsBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/ThemeBackground").useThemeBackground
local icon = Foundation.Icon
local enums = Foundation.Enums
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local iconsactionseditclear_small = images["icons/actions/edit/clear_small"]

local fFlagDisableAutocorrectSocialUserSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagDisableAutocorrectSocialUserSearch
local fFlagLuaAppLogSocialUserSearchUXExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagLuaAppLogSocialUserSearchUXExposure

local defineFastString = game:DefineFastString("DisableAutocorrectExperimentLayer", "Social.UserSearchUX")

local v5 = {
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
	local v6

	if fFlagDisableAutocorrectSocialUserSearch then
		v6 = RoactAppExperiment.useUserExperiment({ defineFastString }, function(p2)
			return (p2[defineFastString] or {}).disableAutocorrectSocialUserSearch
		end, not fFlagLuaAppLogSocialUserSearchUXExposure)
	end

	local joined = Dash.join(v5, options or {})
	local v7 = useStyle()

	local v8 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

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

	local header2 = v7.Font.Header2
	local v9 = v7.Font.BaseSize * header2.RelativeSize
	local v10

	if foundationFontFaceMigration then
		v10 = getTextSize(
			joined.cancelText,
			v9,
			v7.Tokens.Typography.TitleLarge.Font,
			Vector2.new(10000, 10000)
		).X
	else
		v10 = text.GetTextWidth(joined.cancelText, header2.Font, v9)
	end

	local udim = UDim.new(0, 4)

	local udim2 = if joined.isDisabled then UDim2.new(1, 0, 1, 0) else UDim2.new(1, -v10 - 12, 1, 0)

	local body = v7.Font.Body
	local v11 = v7.Font.BaseSize * body.RelativeSize

	local function fn(p2, p3)
		if joined.focusChangedCallback then
			joined.focusChangedCallback(p2, p3)
		end

		if p2 then
			setState(v7.Theme.SecondaryOnHover.Color)
			setState2(v7.Theme.SecondaryOnHover.Transparency)
		else
			setState(v7.Theme.Divider.Color)
			setState2(v7.Theme.Divider.Transparency)
		end
	end

	local createElement = React.createElement
	local v13 = {
		BackgroundTransparency = v8 and 1 or v7.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = joined.LayoutOrder
	}
	local v14 = {
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

	local v15 = if not joined.isDisabled then joined.cancelCallback and React.createElement(textButton, {
		text = joined.cancelText,
		layoutOrder = 2,
		onActivated = joined.cancelCallback
	}) else nil
	v14.CancelTextButton = v15

	local createElement2 = React.createElement
	local v17 = {
		Size = udim2,
		BackgroundColor3 = v7.Theme.UIMuted.Color,
		BackgroundTransparency = v7.Theme.UIMuted.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 1
	}

	local v18 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
		UIStroke = React.createElement("UIStroke", {
			Color = state or v7.Theme.Divider.Color,
			Transparency = state2 or v7.Theme.Divider.Transparency,
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
		SearchIcon = React.createElement(icon, {
			name = enums.IconName.MagnifyingGlass,
			size = enums.IconSize.Medium
		}),
		FilterBoxContainer = 0
	}

	local createElement3 = React.createElement
	local v20 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -28, 1, 0),
		LayoutOrder = 2
	}
	local v22

	if joined.isDisabled then
		local createElement4 = React.createElement
		local v24 = {
			Text = joined.searchPlaceholderText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			TextSize = v11,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}

		local v25 = if not foundationFontFaceMigration then body.Font else nil
		v24.Font = v25

		local v26 = if foundationFontFaceMigration then normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font) else nil
		v24.FontFace = v26

		v24.TextColor3 = v7.Theme.TextDefault.Color
		v24.TextTransparency = v7.Theme.TextMuted.Transparency
		v22 = createElement4("TextLabel", v24)
	else
		local createElement4 = React.createElement
		local v24 = {
			initialInputText = joined.initialInputText,
			inputTextColor3 = v7.Theme.TextEmphasis.Color,
			inputTextFont = body.Font,
			inputTextSize = v11,
			inputTextTransparency = v7.Theme.TextEmphasis.Transparency,
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

		local v25 = if fFlagDisableAutocorrectSocialUserSearch and v6 then Enum.TextInputType.NoSuggestions else nil
		v24.textInputType = v25

		local v26 = if fFlagDisableAutocorrectSocialUserSearch and v6 then Enum.ReturnKeyType.Search else nil
		v24.returnKeyType = v26

		v24.placeholderText = joined.searchPlaceholderText
		v24.placeholderTextColor3 = v7.Theme.TextDefault.Color
		v24.placeholderTextTransparency = v7.Theme.TextMuted.Transparency

		v24.captureFocusOnMount = joined.captureFocusOnMount

		v24.clearIcon = iconsactionseditclear_small
		v24.clearIconColor3 = v7.Theme.IconEmphasis.Color
		v24.clearIconTransparency = v7.Theme.IconEmphasis.Transparency
		v24.clearButtonSize = iconSize.Small

		v24.textChangedCallback = joined.textChangedCallback
		v24.onSelectCallback = joined.onSelectCallback
		v24.focusChangedCallback = fn
		v24.returnPressedFromOnScreenKeyboardCallback = joined.returnPressedFromOnScreenKeyboardCallback

		v24.inputBoxRef = ref
		v22 = createElement4(callbackInputBox, v24)
	end

	v18.FilterBoxContainer = createElement3("Frame", v20, { filterBox = v22 })
	v14.FilterBoxBackground = createElement2(imageSetLabel, v17, v18)
	return createElement("Frame", v13, v14)
end
