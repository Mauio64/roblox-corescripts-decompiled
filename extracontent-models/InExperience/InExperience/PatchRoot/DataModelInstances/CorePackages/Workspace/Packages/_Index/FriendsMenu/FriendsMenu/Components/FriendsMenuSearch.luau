local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local NotificationsCommon = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon.LocalizationHelper
local NotificationsCommon2 = require(parent.NotificationsCommon)
local Debounce = NotificationsCommon2.Debounce
local SharedFlags = require(parent.SharedFlags)
local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local GetFFlagEnableFriendsListSearchNormalizationErrorFix = SharedFlags.GetFFlagEnableFriendsListSearchNormalizationErrorFix

local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings

local FriendsListContext = require(FriendsMenu.Context.FriendsListContext)

local iconsmenusearch = Images["icons/menu/search"]
local iconsactionseditclear = Images["icons/actions/edit/clear"]
local v = 8
local v2 = 6
local v3 = 18
local v4 = 4
local v5 = 24
local textSize = 16
local v6 = v3 + v5 + v4
local v7 = 4

local v8 = {
	searchPlaceHolder = "Feature.SettingsHub.Label.SearchForFriendsPlaceholder.FriendsRename"
}

local function fn(props, p)
	local v9 = useStyle()
	local v10 = useTokens()
	local v11 = React.useContext(FriendsListContext)
	local localizedStrings = getLocalizedStrings(v8)
	local ref = React.useRef(nil)

	if v10 then
		v = v10.Size.Size_200
		v2 = v10.Size.Size_150
		v3 = v10.Size.Size_400
		v5 = v10.Size.Size_600
		v4 = v10.Size.Size_100
		textSize = v10.FontSize.FontSize_300
		v7 = v10.Radius.Small
		v6 = v3 + v5 + v4
	end

	local selectionImageObject = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local ref2 = p or ref
	local searchFriendsString = v11.searchFriendsString
	local searchFriends = v11.searchFriends
	local v12 = #searchFriendsString > 0

	local fn2 = not GetFFlagEnableFriendsListSearchNormalizationErrorFix() and function(p2)
		searchFriends(p2.Text)
	end or React.useCallback(Debounce(function(p2)
		searchFriends(p2.Text:lower())
	end, 0.5), { searchFriends })

	React.useEffect(function()
		if ref2.current and props.focusElement then
			ref2.current:CaptureFocus()
		end
	end, { ref2.current })

	local createElement = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = props.size,
		LayoutOrder = props.layoutOrder
	}
	local v14 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v4)
		}),
		UIStroke = React.createElement("UIStroke", {
			Thickness = 1,
			Color = v9.Theme.UIDefault.Color,
			Transparency = v9.Theme.UIDefault.Transparency
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v7) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v),
			PaddingRight = UDim.new(0, v),
			PaddingTop = UDim.new(0, v2),
			PaddingBottom = UDim.new(0, v2)
		}),
		SearchIcon = React.createElement(ImageSetLabel, {
			LayoutOrder = 0,
			Size = UDim2.fromOffset(v3, v3),
			BackgroundTransparency = 1,
			Image = iconsmenusearch,
			ImageColor3 = v9.Theme.IconEmphasis.Color,
			ImageTransparency = v9.Theme.IconEmphasis.Transparency
		}),
		SearchField = 0,
		ClearButton = 0
	}

	local createElement2 = React.createElement
	local v15 = {
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, v6 * -1, 1, 0),
		ClearTextOnFocus = false,
		PlaceholderColor3 = v9.Theme.TextDefault.Color,
		PlaceholderText = localizedStrings.searchPlaceHolder,
		Text = searchFriendsString,
		TextColor3 = v9.Theme.TextDefault.Color,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = textSize
	}
	local font

	if not FoundationFontFaceMigration then
		font = v9.Font.Body.Font
	end

	v15.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v10.Typography.BodyLarge.Font)
	end

	v15.FontFace = fontFace

	v15.ref = ref2
	v15[React.Event.Focused] = props.onFocus
	v15[React.Change.Text] = fn2
	v15.SelectionImageObject = selectionImageObject
	v14.SearchField = createElement2("TextBox", v15)
	local clearButton

	if v12 then
		clearButton = React.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, v5, 0, v5),
			Image = iconsactionseditclear,
			ImageColor3 = v9.Theme.IconEmphasis.Color,
			ImageTransparency = v9.Theme.IconEmphasis.Transparency,
			[React.Event.Activated] = function()
				searchFriends("")
			end,
			SelectionImageObject = selectionImageObject
		}) or nil
	end

	v14.ClearButton = clearButton
	return createElement("Frame", v13, v14)
end

return (React.memo(React.forwardRef(fn)))
