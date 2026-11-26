local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").LocalizationHelper
local debounce = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").Debounce
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local useCursor = Foundation.Hooks.useCursor
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local getFFlagEnableFriendsListSearchNormalizationErrorFix = SharedFlags.GetFFlagEnableFriendsListSearchNormalizationErrorFix

local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = localizationHelper.getLocalizedStrings

local FriendsListContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContext")

local iconsmenusearch = images["icons/menu/search"]
local iconsactionseditclear = images["icons/actions/edit/clear"]
local v5 = 8
local v6 = 6
local v7 = 18
local v8 = 4
local v9 = 24
local v10 = 16
local v11 = v7 + v9 + v8
local v12 = 4

local v13 = {
	searchPlaceHolder = "Feature.SettingsHub.Label.SearchForFriendsPlaceholder.FriendsRename"
}

local function fn(props, p2)
	local v14 = useStyle()
	local v15 = useTokens()
	local v16 = React.useContext(FriendsListContext)
	local localizedStrings = getLocalizedStrings(v13)
	local ref = React.useRef(nil)

	if v15 then
		v5 = v15.Size.Size_200
		v6 = v15.Size.Size_150
		v7 = v15.Size.Size_400
		v9 = v15.Size.Size_600
		v8 = v15.Size.Size_100
		v10 = v15.FontSize.FontSize_300
		v12 = v15.Radius.Small
		v11 = v7 + v9 + v8
	end

	local v17 = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local v18 = p2 or ref
	local searchFriendsString = v16.searchFriendsString
	local searchFriends = v16.searchFriends
	local v19 = #searchFriendsString > 0

	local fn2 = not getFFlagEnableFriendsListSearchNormalizationErrorFix() and function(p3)
		searchFriends(p3.Text)
	end or React.useCallback(debounce(function(p3)
		searchFriends(p3.Text:lower())
	end, 0.5), { searchFriends })

	React.useEffect(function()
		if v18.current and props.focusElement then
			v18.current:CaptureFocus()
		end
	end, { v18.current })

	local createElement = React.createElement
	local v21 = {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = props.size,
		LayoutOrder = props.layoutOrder
	}
	local v22 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v8)
		}),
		UIStroke = React.createElement("UIStroke", {
			Thickness = 1,
			Color = v14.Theme.UIDefault.Color,
			Transparency = v14.Theme.UIDefault.Transparency
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v12) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5),
			PaddingRight = UDim.new(0, v5),
			PaddingTop = UDim.new(0, v6),
			PaddingBottom = UDim.new(0, v6)
		}),
		SearchIcon = React.createElement(imageSetLabel, {
			LayoutOrder = 0,
			Size = UDim2.fromOffset(v7, v7),
			BackgroundTransparency = 1,
			Image = iconsmenusearch,
			ImageColor3 = v14.Theme.IconEmphasis.Color,
			ImageTransparency = v14.Theme.IconEmphasis.Transparency
		}),
		SearchField = React.createElement("TextBox", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, v11 * -1, 1, 0),
			ClearTextOnFocus = false,
			PlaceholderColor3 = v14.Theme.TextDefault.Color,
			PlaceholderText = localizedStrings.searchPlaceHolder,
			Text = searchFriendsString,
			TextColor3 = v14.Theme.TextDefault.Color,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = v10,
			FontFace = normalizeFontFace(v15.Typography.BodyLarge.Font),
			ref = v18,
			[React.Event.Focused] = props.onFocus,
			[React.Change.Text] = fn2,
			SelectionImageObject = v17
		}),
		ClearButton = 0
	}
	local v24

	if v19 then
		v24 = React.createElement(imageSetButton, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, v9, 0, v9),
			Image = iconsactionseditclear,
			ImageColor3 = v14.Theme.IconEmphasis.Color,
			ImageTransparency = v14.Theme.IconEmphasis.Transparency,
			[React.Event.Activated] = function()
				searchFriends("")
			end,
			SelectionImageObject = v17
		}) or nil
	end

	v22.ClearButton = v24
	return createElement("Frame", v21, v22)
end

return React.memo(React.forwardRef(fn))
