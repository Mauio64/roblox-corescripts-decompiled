local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Cryo")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags")
local getFFlagEnableCommonFriendsMenu = SharedFlags.GetFFlagEnableCommonFriendsMenu
local getFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local useCursor = Foundation.Hooks.useCursor

local FriendThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendThumbnail")
local FriendsMenuButton = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuButton")
local FriendInfo = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendInfo")
local FriendsMenuCheckbox = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuCheckbox")
local v5 = if getFFlagEnableCommonFriendsMenu() then require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/InviteCallbackContext") else require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/InviteFriendContext")

local SelectedUsersContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContext")

local FriendMenuType = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Enums/FriendMenuType")

local useStyle = UIBlox.Core.Style.useStyle
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")

local udim = UDim2.new(1, 0, 0.5, 0)
local vector2 = Vector2.new(1, 0.5)

local function fn() end

local v6 = {
	sidePadding = 24,
	isFullRowActivatable = false,
	backgroundTransparency = nil
}

return function(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local state, setState = React.useState(false)
	local theme = useStyle().Theme
	local friend = joined.friend
	assert(friend, "friend should be non-nil. Silence type checker.")
	local v7 = React.useContext(v5)
	local v8 = React.useContext(SelectedUsersContext)
	local sidePadding = joined.sidePadding

	local v9 = useCursor(Foundation.Enums.CursorType.RoundedSlot)

	local v10 = joined.isFullRowActivatable and not joined.isFetchingFriends

	local v11 = React.useCallback(function()
		if v7 and v7.inviteSingleFriend and not friend.isLoadingPlaceholder then
			v7.inviteSingleFriend(friend.id, joined.layoutOrder)
		end
	end, {
		v7,
		v7.inviteSingleFriend,
		friend.id,
		friend.isLoadingPlaceholder,
		joined.layoutOrder
	})

	local v12 = React.useCallback(function()
		if v8.isFriendSelected(joined.friend.id) then
			v8.removeFriend(joined.friend.id, joined.friend.displayName)
		else
			v8.addFriend(joined.friend.id, joined.friend.displayName)
		end
	end, { v8.isFriendSelected, v8.removeFriend, v8.addFriend, joined.friend.id })

	local v13 = React.useCallback(function()
		if not v10 or getFFlagFriendsMenuDummyLoadingFriendsFix() and friend.isLoadingPlaceholder then
			return
		end

		if joined.menuType == FriendMenuType.MultiSelect then
			v12()
		else
			v11()
		end
	end, { v10, joined.menuType, v11, v12, friend.isLoadingPlaceholder })

	local createElement = React.createElement
	local v15 = {
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(1, 0, 0, 72),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = state and theme.BackgroundOnHover.Color or theme.BackgroundDefault.Color
	}
	local v16

	if state then
		v16 = theme.BackgroundOnHover.Transparency
	elseif joined.backgroundTransparency then
		v16 = joined.backgroundTransparency
	else
		v16 = theme.BackgroundDefault.Transparency
	end

	v15.BackgroundTransparency = v16

	v15.BorderSizePixel = 0
	v15.LayoutOrder = joined.layoutOrder

	if not joined.isFullRowActivatable then
		v9 = nil
	end

	v15.SelectionImageObject = v9
	v15[React.Event.MouseEnter] = function()
		if not joined.isFetchingFriends then
			setState(true)
		end
	end
	v15[React.Event.MouseLeave] = function()
		setState(false)
	end
	local activated = React.Event.Activated

	if getFFlagFriendsMenuDummyLoadingFriendsFix() and friend.isLoadingPlaceholder or not v10 then
		v13 = fn
	end

	v15[activated] = v13

	v15.AutoButtonColor = v10
	local v17 = {
		UIListLayout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 12)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, sidePadding),
			PaddingLeft = UDim.new(0, sidePadding),
			PaddingBottom = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8)
		}),
		ThumbnailAndPresenceWrapper = React.createElement(FriendThumbnail, {
			friend = friend,
			isHoverRow = state,
			size = UDim2.new(0, 56, 0, 56),
			position = UDim2.new(0, 0, 0.5, 0),
			anchorPoint = Vector2.new(0, 0.5),
			isFetchingFriends = joined.isFetchingFriends,
			LayoutOrder = 1
		}),
		UserInfo = React.createElement(FriendInfo, {
			position = UDim2.new(0, 56, 0, 0),
			size = UDim2.new(1, -134, 0, 0),
			friend = friend,
			isFetchingFriendsNames = joined.isFetchingFriendsNames,
			LayoutOrder = 2
		}),
		InviteButton = 0
	}
	local v18

	if joined.menuType == FriendMenuType.MultiSelect then
		local createElement2 = React.createElement
		local v20 = {
			size = UDim2.new(0, 66, 0, 36),
			position = udim,
			anchorPoint = vector2,
			friend = friend,
			isDisabled = joined.isFetchingFriends,
			layoutOrder = 3,
			selectable = 0
		}

		local v21 = if joined.isFullRowActivatable then false else nil
		v20.selectable = v21
		v18 = createElement2(FriendsMenuCheckbox, v20)
	else
		v18 = React.createElement(FriendsMenuButton, {
			size = UDim2.new(0, 66, 0, 36),
			position = udim,
			anchorPoint = vector2,
			friend = friend,
			onInvite = v11,
			isFullRowActivatable = joined.isFullRowActivatable,
			layoutOrder = 3
		})
	end

	v17.InviteButton = v18
	return createElement("ImageButton", v15, v17)
end
