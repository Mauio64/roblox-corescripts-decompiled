local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent
local Context = FriendsMenu.Context

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Responsive = require(parent.Responsive)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local useStyle = UIBlox.Core.Style.useStyle

local Constants = require(FriendsMenu.Constants)
local FriendsMenuUserCard = require(script.Parent.FriendsMenuUserCard)
local SelectedUsersContext = require(Context.SelectedUsersContext)

return function(p)
	local v = React.useContext(SelectedUsersContext)
	local v2 = Responsive.useBreakpointYOrLarger(Responsive.Keys.Medium)

	local v3 = useLastInputMode()
	local v4 = useFocusGuiObject()

	local ref = React.useRef({})
	local ref2 = React.useRef(nil)

	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local v6 = useLocalization({
		selectedFriendsCountText = {
			"Feature.FriendsMenu.Label.SelectedFriendsCount",
			numerator = v.selectedFriendsSize,
			denominator = p.selectionLimit
		},
		selectedFriendsCountNoLimitText = {
			"Feature.FriendsMenu.Label.SelectedFriendsCountNoLimit",
			selectedCount = v.selectedFriendsSize
		}
	})

	local v7 = React.useMemo(function()
		ref.current = {}
		local children = {}
		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local v7 = {}

		for k, selectedFriend in pairs(v.selectedFriends) do
			table.insert(v7, { userId = k, userData = selectedFriend })
		end

		table.sort(v7, function(a, b): boolean
			return a.userData.layoutOrder < b.userData.layoutOrder
		end)

		for i, v8 in ipairs(v7) do
			local userId = v8.userId
			local userData = v8.userData

			children["User-" .. tostring(userId)] = React.createElement(FriendsMenuUserCard, {
				displayName = userData.displayName,
				layoutOrder = userData.layoutOrder,
				userId = userId,
				unremovable = userData.unremovable,
				onRemoved = function()
					ref2.current = i
				end,
				ref = function(p2)
					ref.current[i] = p2
				end
			})
		end

		return children
	end, { v.selectedFriends })

	React.useEffect(function()
		if not ref2.current or v3 ~= "Focus" then
			return
		end

		local current = ref.current
		local count = #current

		if count == 0 then
			ref2.current = nil
			return
		end

		local v8 = current[math.clamp(ref2.current, 1, count)]

		if v8 and v8.Parent then
			v4(v8)
		end

		ref2.current = nil
	end, { v.selectedFriends, v4, v3 })

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p.layoutOrder
	}
	local v9 = {
		VerticalLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SelectedFriendsText = 0,
		SelectedUsers = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
		LayoutOrder = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextTransparency = 0,
		TextXAlignment = 0
	}
	local text

	if p.selectionLimit then
		text = v6.selectedFriendsCountText
	else
		text = v6.selectedFriendsCountNoLimitText
	end

	v10.Text = text

	v10.TextColor3 = theme.TextEmphasis.Color
	v10.TextSize = font.BaseSize * font.Header2.RelativeSize
	v10.TextTransparency = theme.TextEmphasis.Transparency
	v10.TextXAlignment = Enum.TextXAlignment.Left
	v9.SelectedFriendsText = createElement2("TextLabel", v10)
	local selectedUsers

	if not (v.selectedFriendsSize == 0 or not v2) then
		selectedUsers = React.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 0, Constants.FRIEND_MENU_CARD_SIZE),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false
		}, v7)
	end

	v9.SelectedUsers = selectedUsers
	return createElement("Frame", v8, v9)
end
