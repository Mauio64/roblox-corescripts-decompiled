local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local Components = FriendsMenu.Components
local parent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local Enums = FriendsMenu.Enums

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableCommonFriendsMenu = SharedFlags.GetFFlagEnableCommonFriendsMenu
local GetFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix

local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor

local FriendThumbnail = require(Components.FriendThumbnail)
local FriendsMenuButton = require(Components.FriendsMenuButton)
local FriendInfo = require(Components.FriendInfo)
local FriendsMenuCheckbox = require(Components.FriendsMenuCheckbox)
local v

if GetFFlagEnableCommonFriendsMenu() then
	v = require(Context.InviteCallbackContext)
else
	v = require(Context.InviteFriendContext)
end

local SelectedUsersContext = require(Context.SelectedUsersContext)

local FriendMenuType = require(Enums.FriendMenuType)

local useStyle = UIBlox.Core.Style.useStyle
require(FriendsMenu.friendsMenuModalType)

local udim = UDim2.new(1, 0, 0.5, 0)
local vector2 = Vector2.new(1, 0.5)

local function fn() end

local v2 = { sidePadding = 24, isFullRowActivatable = false, backgroundTransparency = nil }

return function(p)
	local joined = Cryo.Dictionary.join(v2, p)
	local state, setState = React.useState(false)
	local theme = useStyle().Theme
	local friend = joined.friend
	assert(friend, "friend should be non-nil. Silence type checker.")
	local v3 = React.useContext(v)
	local v4 = React.useContext(SelectedUsersContext)
	local sidePadding = joined.sidePadding

	local selectionImageObject = useCursor(Foundation.Enums.CursorType.RoundedSlot)

	local autoButtonColor = joined.isFullRowActivatable and not joined.isFetchingFriends

	local onInvite = React.useCallback(function()
		if v3 and v3.inviteSingleFriend and not friend.isLoadingPlaceholder then
			v3.inviteSingleFriend(friend.id, joined.layoutOrder)
		end
	end, { v3, v3.inviteSingleFriend, friend.id, friend.isLoadingPlaceholder, joined.layoutOrder })

	local v5 = React.useCallback(function()
		if v4.isFriendSelected(joined.friend.id) then
			v4.removeFriend(joined.friend.id, joined.friend.displayName)
		else
			v4.addFriend(joined.friend.id, joined.friend.displayName)
		end
	end, { v4.isFriendSelected, v4.removeFriend, v4.addFriend, joined.friend.id })

	local v6 = React.useCallback(function()
		if not autoButtonColor or GetFFlagFriendsMenuDummyLoadingFriendsFix() and friend.isLoadingPlaceholder then
			return
		end

		if joined.menuType == FriendMenuType.MultiSelect then
			v5()
		else
			onInvite()
		end
	end, { autoButtonColor, joined.menuType, onInvite, v5, friend.isLoadingPlaceholder })

	local createElement = React.createElement
	local v7 = {
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
	local backgroundTransparency

	if state then
		backgroundTransparency = theme.BackgroundOnHover.Transparency
	elseif joined.backgroundTransparency then
		backgroundTransparency = joined.backgroundTransparency
	else
		backgroundTransparency = theme.BackgroundDefault.Transparency
	end

	v7.BackgroundTransparency = backgroundTransparency

	v7.BorderSizePixel = 0
	v7.LayoutOrder = joined.layoutOrder

	if not joined.isFullRowActivatable then
		selectionImageObject = nil
	end

	v7.SelectionImageObject = selectionImageObject
	v7[React.Event.MouseEnter] = function()
		if not joined.isFetchingFriends then
			setState(true)
		end
	end
	v7[React.Event.MouseLeave] = function()
		setState(false)
	end
	local activated = React.Event.Activated

	if GetFFlagFriendsMenuDummyLoadingFriendsFix() and friend.isLoadingPlaceholder or not autoButtonColor then
		v6 = fn
	end

	v7[activated] = v6

	v7.AutoButtonColor = autoButtonColor
	local v8 = {
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
	local inviteButton

	if joined.menuType == FriendMenuType.MultiSelect then
		inviteButton = React.createElement(FriendsMenuCheckbox, {
			size = UDim2.new(0, 66, 0, 36),
			position = udim,
			anchorPoint = vector2,
			friend = friend,
			isDisabled = joined.isFetchingFriends,
			layoutOrder = 3,
			selectable = not joined.isFullRowActivatable and nil
		})
	else
		inviteButton = React.createElement(FriendsMenuButton, {
			size = UDim2.new(0, 66, 0, 36),
			position = udim,
			anchorPoint = vector2,
			friend = friend,
			onInvite = onInvite,
			isFullRowActivatable = joined.isFullRowActivatable,
			layoutOrder = 3
		})
	end

	v8.InviteButton = inviteButton
	return createElement("ImageButton", v7, v8)
end
