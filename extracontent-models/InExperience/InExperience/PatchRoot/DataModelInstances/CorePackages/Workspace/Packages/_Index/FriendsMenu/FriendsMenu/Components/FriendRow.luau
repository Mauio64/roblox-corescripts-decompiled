local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local Components = FriendsMenu.Components
local FriendsMenuParent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local Enums = FriendsMenu.Enums
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local Cryo = require(FriendsMenuParent.Cryo)
local SharedFlags = require(FriendsMenuParent.SharedFlags)
local GetFFlagEnableCommonFriendsMenu = SharedFlags.GetFFlagEnableCommonFriendsMenu
local GetFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix
local Foundation = require(FriendsMenuParent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local FriendThumbnail = require(Components.FriendThumbnail)
local FriendsMenuButton = require(Components.FriendsMenuButton)
local FriendInfo = require(Components.FriendInfo)
local FriendsMenuCheckbox = require(Components.FriendsMenuCheckbox)
local v18 = if not GetFFlagEnableCommonFriendsMenu() then require(Context.InviteFriendContext) else require(Context.InviteCallbackContext)
local SelectedUsersContext = require(Context.SelectedUsersContext)
local FriendMenuType = require(Enums.FriendMenuType)
local useStyle = UIBlox.Core.Style.useStyle

require(FriendsMenu.friendsMenuModalType)

local uDim2 = UDim2.new(1, 0, 0.5, 0)
local vector2 = Vector2.new(1, 0.5)

local function v24() -- line: 42
end

local t1 = {
	sidePadding = 24,
	isFullRowActivatable = false,
	backgroundTransparency = nil
}

return function(t2: {[any]: any}) -- line: 62
	-- upvalues: Cryo (copy), t1 (copy), React (copy), useStyle (copy), v18 (copy), SelectedUsersContext (copy), useCursor (copy), Foundation (copy), GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), FriendMenuType (copy), v24 (copy), FriendThumbnail (copy), FriendInfo (copy), FriendsMenuCheckbox (copy), uDim2 (copy), vector2 (copy), FriendsMenuButton (copy)
	local v27 = Cryo.Dictionary.join(t1, t2)
	local v28, v29 = React.useState(false)
	local Theme = useStyle().Theme
	local friend = v27.friend

	assert(friend, "friend should be non-nil. Silence type checker.")

	local v32 = React.useContext(v18)
	local v33 = React.useContext(SelectedUsersContext)
	local sidePadding = v27.sidePadding
	local v35 = useCursor(Foundation.Enums.CursorType.RoundedSlot)
	local v36 = v27.isFullRowActivatable and not v27.isFetchingFriends
	local v37 = React.useCallback(function() -- line: 78
		-- upvalues: v32 (copy), friend (copy), v27 (copy)
		if v32 and (v32.inviteSingleFriend and not friend.isLoadingPlaceholder) then
			v32.inviteSingleFriend(friend.id, v27.layoutOrder)
		end
	end, {
		v32,
		v32.inviteSingleFriend,
		friend.id,
		friend.isLoadingPlaceholder,
		v27.layoutOrder
	})
	local v38 = React.useCallback(function() -- line: 93
		-- upvalues: v33 (copy), v27 (copy)
		if v33.isFriendSelected(v27.friend.id) then
			v33.removeFriend(v27.friend.id, v27.friend.displayName)

			return
		end

		v33.addFriend(v27.friend.id, v27.friend.displayName)
	end, {
		v33.isFriendSelected,
		v33.removeFriend,
		v33.addFriend,
		v27.friend.id
	})
	local v39 = React.useCallback(function() -- line: 109
		-- upvalues: v36 (copy), GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), friend (copy), v27 (copy), FriendMenuType (copy), v37 (copy), v38 (copy)
		if not v36 or GetFFlagFriendsMenuDummyLoadingFriendsFix() and friend.isLoadingPlaceholder then
			return
		end

		if v27.menuType ~= FriendMenuType.MultiSelect then
			v37()

			return
		end

		v38()
	end, {
		v36,
		v27.menuType,
		v37,
		v38,
		friend.isLoadingPlaceholder
	})

	return React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 0, 72),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v28 and Theme.BackgroundOnHover.Color or Theme.BackgroundDefault.Color,
		BackgroundTransparency = if not v28 then if not v27.backgroundTransparency then Theme.BackgroundDefault.Transparency else v27.backgroundTransparency else Theme.BackgroundOnHover.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = v27.layoutOrder,
		SelectionImageObject = if not v27.isFullRowActivatable then nil else v35,
		[React.Event.MouseEnter] = function() -- line: 144
			-- upvalues: v27 (copy), v29 (copy)
			if not v27.isFetchingFriends then
				v29(true)
			end
		end,
		[React.Event.MouseLeave] = function() -- line: 149
			-- upvalues: v29 (copy)
			v29(false)
		end,
		[React.Event.Activated] = if not (not not GetFFlagFriendsMenuDummyLoadingFriendsFix() and friend.isLoadingPlaceholder) and v36 then v39 else v24,
		AutoButtonColor = v36
	}, {
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
			LayoutOrder = 1,
			friend = friend,
			isHoverRow = v28,
			size = UDim2.new(0, 56, 0, 56),
			position = UDim2.new(0, 0, 0.5, 0),
			anchorPoint = Vector2.new(0, 0.5),
			isFetchingFriends = v27.isFetchingFriends
		}),
		UserInfo = React.createElement(FriendInfo, {
			LayoutOrder = 2,
			position = UDim2.new(0, 56, 0, 0),
			size = UDim2.new(1, -134, 0, 0),
			friend = friend,
			isFetchingFriendsNames = v27.isFetchingFriendsNames
		}),
		InviteButton = if v27.menuType ~= FriendMenuType.MultiSelect then React.createElement(FriendsMenuButton, {
			layoutOrder = 3,
			size = UDim2.new(0, 66, 0, 36),
			position = uDim2,
			anchorPoint = vector2,
			friend = friend,
			onInvite = v37,
			isFullRowActivatable = v27.isFullRowActivatable
		}) else React.createElement(FriendsMenuCheckbox, {
			layoutOrder = 3,
			size = UDim2.new(0, 66, 0, 36),
			position = uDim2,
			anchorPoint = vector2,
			friend = friend,
			isDisabled = v27.isFetchingFriends,
			selectable = not v27.isFullRowActivatable and nil
		})
	})
end
