local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation").Utility.normalizeFontFace
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Localization").Hooks.useLocalization
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Responsive")
local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/ReactFocusNavigation").useFocusGuiObject
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/FocusNavigationUtils").useLastInputMode

local useStyle = UIBlox.Core.Style.useStyle

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants")
local FriendsMenuUserCard = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuUserCard")
local SelectedUsersContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContext")

return function(p2)
	local v5 = React.useContext(SelectedUsersContext)
	local v6 = Responsive.useBreakpointYOrLarger(Responsive.Keys.Medium)

	local v7 = useLastInputMode()
	local v8 = useFocusGuiObject()

	local ref = React.useRef({})
	local ref2 = React.useRef(nil)

	local v9 = useStyle()
	local theme = v9.Theme
	local font = v9.Font

	local v10 = useLocalization({
		selectedFriendsCountText = {
			"Feature.FriendsMenu.Label.SelectedFriendsCount",
			numerator = v5.selectedFriendsSize,
			denominator = p2.selectionLimit
		},
		selectedFriendsCountNoLimitText = {
			"Feature.FriendsMenu.Label.SelectedFriendsCountNoLimit",
			selectedCount = v5.selectedFriendsSize
		}
	})

	local v11 = React.useMemo(function()
		ref.current = {}
		local children = {}
		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local v12 = {}

		for k, selectedFriend in pairs(v5.selectedFriends) do
			table.insert(v12, { userId = k, userData = selectedFriend })
		end

		table.sort(v12, function(a, b): boolean
			return a.userData.layoutOrder < b.userData.layoutOrder
		end)

		for i, v13 in ipairs(v12) do
			local userId = v13.userId
			local userData = v13.userData

			children["User-" .. tostring(userId)] = React.createElement(FriendsMenuUserCard, {
				displayName = userData.displayName,
				layoutOrder = userData.layoutOrder,
				userId = userId,
				unremovable = userData.unremovable,
				onRemoved = function()
					ref2.current = i
				end,
				ref = function(p3)
					ref.current[i] = p3
				end
			})
		end

		return children
	end, { v5.selectedFriends })

	React.useEffect(function()
		if not ref2.current or v7 ~= "Focus" then
			return
		end

		local current = ref.current
		local count = #current

		if count == 0 then
			ref2.current = nil
			return
		end

		local v12 = current[math.clamp(ref2.current, 1, count)]

		if v12 and v12.Parent then
			v8(v12)
		end

		ref2.current = nil
	end, { v5.selectedFriends, v8, v7 })

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p2.layoutOrder
	}
	local v14 = {
		VerticalLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SelectedFriendsText = 0,
		SelectedUsers = 0
	}

	local createElement2 = React.createElement
	local v16 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v9.Tokens.Typography.TitleLarge.Font),
		LayoutOrder = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextTransparency = 0,
		TextXAlignment = 0
	}

	local v17 = if p2.selectionLimit then v10.selectedFriendsCountText else v10.selectedFriendsCountNoLimitText
	v16.Text = v17

	v16.TextColor3 = theme.TextEmphasis.Color
	v16.TextSize = font.BaseSize * font.Header2.RelativeSize
	v16.TextTransparency = theme.TextEmphasis.Transparency
	v16.TextXAlignment = Enum.TextXAlignment.Left
	v14.SelectedFriendsText = createElement2("TextLabel", v16)

	local v18 = if v5.selectedFriendsSize ~= 0 and not not v6 then React.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, Constants.FRIEND_MENU_CARD_SIZE),
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		Selectable = false
	}, v11) else nil
	v14.SelectedUsers = v18
	return createElement("Frame", v13, v14)
end
