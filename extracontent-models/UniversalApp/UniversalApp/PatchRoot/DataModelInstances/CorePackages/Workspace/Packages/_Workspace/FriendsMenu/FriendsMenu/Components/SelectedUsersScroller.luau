local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local useLocalization = require(FriendsMenuParent.Localization).Hooks.useLocalization
local Responsive = require(FriendsMenuParent.Responsive)
local SharedFlags = require(FriendsMenuParent.SharedFlags)
local useFocusGuiObject = require(FriendsMenuParent.ReactFocusNavigation).useFocusGuiObject
local useLastInputMode = require(FriendsMenuParent.FocusNavigationUtils).useLastInputMode
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(FriendsMenu.Constants)
local FriendsMenuUserCard = require(script.Parent.FriendsMenuUserCard)
local SelectedUsersContext = require(Context.SelectedUsersContext)
local getRenameFriendsToConnectionsEnabledFriendsMenu = require(FriendsMenu.utils.getRenameFriendsToConnectionsEnabledFriendsMenu)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), SelectedUsersContext (copy), Responsive (copy), useLastInputMode (copy), useFocusGuiObject (copy), useStyle (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), getRenameFriendsToConnectionsEnabledFriendsMenu (copy), FriendsMenuUserCard (copy), Constants (copy)
	local v18 = React.useContext(SelectedUsersContext)
	local v19 = Responsive.useBreakpointYOrLarger(Responsive.Keys.Medium)
	local v20 = useLastInputMode()
	local v21 = useFocusGuiObject()
	local v22 = React.useRef({})
	local v23 = React.useRef(nil)
	local v24 = useStyle()
	local Theme = v24.Theme
	local Font = v24.Font
	local v27 = useLocalization({
		selectedFriendsCountText = {
			if not FFlagConnectionsToFriendsRename then not getRenameFriendsToConnectionsEnabledFriendsMenu() and "Feature.FriendsMenu.Label.SelectedFriendsCount" or "Feature.FriendsMenu.Label.SelectedConnectionsCount" else "Feature.FriendsMenu.Label.SelectedFriendsCount",
			numerator = v18.selectedFriendsSize,
			denominator = t1.selectionLimit
		},
		selectedFriendsCountNoLimitText = {
			if not FFlagConnectionsToFriendsRename then not getRenameFriendsToConnectionsEnabledFriendsMenu() and "Feature.FriendsMenu.Label.SelectedFriendsCountNoLimit" or "Feature.FriendsMenu.Label.SelectedConnectionsCountNoLimit" else "Feature.FriendsMenu.Label.SelectedFriendsCountNoLimit",
			selectedCount = v18.selectedFriendsSize
		}
	})
	local v28 = React.useMemo(function() -- line: 66
		-- upvalues: v22 (copy), React (copy), v18 (copy), FriendsMenuUserCard (copy), v23 (copy)
		v22.current = {}

		local t2 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}
		local t3 = {}

		for k, v in pairs(v18.selectedFriends) do
			table.insert(t3, {
				userId = k,
				userData = v
			})
		end

		table.sort(t3, function(p1, p2) -- line: 80
			return p1.userData.layoutOrder < p2.userData.layoutOrder
		end)

		for i, v in ipairs(t3) do
			local userId = v.userId
			local userData = v.userData

			t2["User-" .. tostring(userId)] = React.createElement(FriendsMenuUserCard, {
				displayName = userData.displayName,
				layoutOrder = userData.layoutOrder,
				userId = userId,
				unremovable = userData.unremovable,
				onRemoved = function() -- line: 93
					-- upvalues: v23 (copy), i (copy)
					v23.current = i
				end,
				ref = function(p3) -- line: 96
					-- upvalues: v22 (copy), i (copy)
					v22.current[i] = p3
				end
			})
		end

		return t2
	end, { v18.selectedFriends })

	React.useEffect(function() -- line: 105
		-- upvalues: v23 (copy), v20 (copy), v22 (copy), v21 (copy)
		if not v23.current or v20 ~= "Focus" then
			return
		end

		local current = v22.current
		local v38 = #current

		if v38 == 0 then
			v23.current = nil

			return
		end

		local v39 = current[math.clamp(v23.current, 1, v38)]

		if v39 and v39.Parent then
			v21(v39)
		end

		v23.current = nil
	end, {
		v18.selectedFriends,
		v21,
		v20
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder
	}, {
		VerticalLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SelectedFriendsText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Font.Header2.Font,
			Text = if not t1.selectionLimit then v27.selectedFriendsCountNoLimitText else v27.selectedFriendsCountText,
			TextColor3 = Theme.TextEmphasis.Color,
			TextSize = Font.BaseSize * Font.Header2.RelativeSize,
			TextTransparency = Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		SelectedUsers = if v18.selectedFriendsSize == 0 or not v19 then nil else React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ScrollBarThickness = 0,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, Constants.FRIEND_MENU_CARD_SIZE),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.X
		}, v28)
	})
end
