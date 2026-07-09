local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local RoactUtils = require(FriendsMenuParent.RoactUtils)
local LocalizationHelper = require(FriendsMenuParent.NotificationsCommon).LocalizationHelper
local Constants = require(FriendsMenu.Constants)
local FriendsListContext = require(Context.FriendsListContext)

require(FriendsMenu.friendsMenuModalType)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useStyle = UIBlox.Core.Style.useStyle
local InviteStatus = Constants.InviteStatus
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings
local t1 = {
	inviteFriend = "Feature.SettingsHub.Action.InviteFriend",
	[InviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[InviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[InviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}

return function(t2: {[any]: any}) -- line: 39
	-- upvalues: useSelector (copy), getLocalizedStrings (copy), t1 (copy), React (copy), FriendsListContext (copy), useStyle (copy), InviteStatus (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v19 = useSelector(function(p1) -- line: 40
		-- upvalues: t2 (copy)
		local friend = t2.friend

		assert(friend, "friend should be non-nil. Silence type checker.")

		return p1.GameInvitesStatus[friend.id]
	end)
	local v20 = getLocalizedStrings(t1)
	local v21 = React.useContext(FriendsListContext)
	local v22 = useStyle()
	local v23 = v22 and v22.Theme
	local v24 = v22 and v22.Font
	local isFetchingFriends = v21.isFetchingFriends
	local v26 = v24.BaseSize * v24.CaptionHeader.RelativeSize

	if (not v19 or v19 == InviteStatus.Failed) and not t2.isFullRowActivatable then
		return React.createElement(Button, {
			isLoading = false,
			fitContent = true,
			buttonType = ButtonType.Secondary,
			isDisabled = isFetchingFriends,
			onActivated = t2.onInvite,
			standardSize = StandardButtonSize.XSmall,
			anchorPoint = t2.anchorPoint,
			position = t2.position,
			text = v20.inviteFriend,
			layoutOrder = t2.layoutOrder
		})
	end

	local v27 = v20[v19] or v20.inviteFriend

	return React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextWrapped = true,
		Text = v27,
		TextSize = v26,
		Size = t2.size,
		AnchorPoint = t2.anchorPoint,
		Position = t2.position,
		TextColor3 = v23.TextDefault.Color,
		Font = v24.CaptionHeader.Font,
		LayoutOrder = t2.layoutOrder
	})
end
