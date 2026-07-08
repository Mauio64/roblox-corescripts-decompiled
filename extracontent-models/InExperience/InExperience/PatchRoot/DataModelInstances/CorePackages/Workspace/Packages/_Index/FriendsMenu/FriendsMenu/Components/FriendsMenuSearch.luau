local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local LocalizationHelper = require(FriendsMenuParent.NotificationsCommon).LocalizationHelper
local Debounce = require(FriendsMenuParent.NotificationsCommon).Debounce
local SharedFlags = require(FriendsMenuParent.SharedFlags)
local Foundation = require(FriendsMenuParent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local useTokens = Foundation.Hooks.useTokens
local GetFFlagEnableFriendsListSearchNormalizationErrorFix = SharedFlags.GetFFlagEnableFriendsListSearchNormalizationErrorFix
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings
local FriendsListContext = require(FriendsMenu.Context.FriendsListContext)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local v19 = Images["icons/menu/search"]
local v20 = Images["icons/actions/edit/clear"]
local n1 = 8
local n2 = 6
local n3 = 18
local n4 = 4
local n5 = 24
local n6 = 16
local u27 = n3 + n5 + n4
local n7 = 4
local t1 = {
	searchPlaceHolder = not FFlagConnectionsToFriendsRename and "Feature.FriendsMenu.Label.SearchForConnections" or "Feature.SettingsHub.Label.SearchForFriendsPlaceholder.FriendsRename"
}

return (React.memo(React.forwardRef(function(t2: {[any]: any}, p1) -- line: 49
	-- upvalues: useStyle (copy), useTokens (copy), React (copy), FriendsListContext (copy), getLocalizedStrings (copy), t1 (copy), n1 (ref), n2 (ref), n3 (ref), n5 (ref), n4 (ref), n6 (ref), n7 (ref), u27 (ref), useCursor (copy), Foundation (copy), GetFFlagEnableFriendsListSearchNormalizationErrorFix (copy), Debounce (copy), ImageSetLabel (copy), v19 (copy), ImageSetButton (copy), v20 (copy)
	local v32 = useStyle()
	local v33 = useTokens()
	local v34 = React.useContext(FriendsListContext)
	local v35 = getLocalizedStrings(t1)
	local u36 = React.useRef(nil)

	if v33 then
		n1 = v33.Size.Size_200
		n2 = v33.Size.Size_150
		n3 = v33.Size.Size_400
		n5 = v33.Size.Size_600
		n4 = v33.Size.Size_100
		n6 = v33.FontSize.FontSize_300
		n7 = v33.Radius.Small
		u27 = n3 + n5 + n4
	end

	local v37 = useCursor(Foundation.Enums.CursorType.RoundedRect)

	if p1 then
		u36 = p1
	end

	local searchFriendsString = v34.searchFriendsString
	local searchFriends = v34.searchFriends
	local v40 = #searchFriendsString > 0
	local v41 = not GetFFlagEnableFriendsListSearchNormalizationErrorFix() and function(t3: {[any]: any}) -- line: 88
		-- upvalues: searchFriends (copy)
		searchFriends(t3.Text)
	end or React.useCallback(Debounce(function(t4: {[any]: any}) -- line: 80
		-- upvalues: searchFriends (copy)
		searchFriends(t4.Text:lower())
	end, 0.5), { searchFriends })

	React.useEffect(function() -- line: 95
		-- upvalues: u36 (ref), t2 (copy)
		if u36.current and t2.focusElement then
			u36.current:CaptureFocus()
		end
	end, { u36.current })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = t2.size,
		LayoutOrder = t2.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, n4)
		}),
		UIStroke = React.createElement("UIStroke", {
			Thickness = 1,
			Color = v32.Theme.UIDefault.Color,
			Transparency = v32.Theme.UIDefault.Transparency
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, n7)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, n1),
			PaddingRight = UDim.new(0, n1),
			PaddingTop = UDim.new(0, n2),
			PaddingBottom = UDim.new(0, n2)
		}),
		SearchIcon = React.createElement(ImageSetLabel, {
			LayoutOrder = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(n3, n3),
			Image = v19,
			ImageColor3 = v32.Theme.IconEmphasis.Color,
			ImageTransparency = v32.Theme.IconEmphasis.Transparency
		}),
		SearchField = React.createElement("TextBox", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, u27 * -1, 1, 0),
			ClearTextOnFocus = false,
			PlaceholderColor3 = v32.Theme.TextDefault.Color,
			PlaceholderText = v35.searchPlaceHolder,
			Text = searchFriendsString,
			TextColor3 = v32.Theme.TextDefault.Color,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = n6,
			Font = v32.Font.Body.Font,
			ref = u36,
			[React.Event.Focused] = t2.onFocus,
			[React.Change.Text] = v41,
			SelectionImageObject = v37
		}),
		ClearButton = v40 and React.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, n5, 0, n5),
			Image = v20,
			ImageColor3 = v32.Theme.IconEmphasis.Color,
			ImageTransparency = v32.Theme.IconEmphasis.Transparency,
			[React.Event.Activated] = function() -- line: 161
				-- upvalues: searchFriends (copy)
				searchFriends("")
			end,
			SelectionImageObject = v37
		}) or nil
	})
end)))
