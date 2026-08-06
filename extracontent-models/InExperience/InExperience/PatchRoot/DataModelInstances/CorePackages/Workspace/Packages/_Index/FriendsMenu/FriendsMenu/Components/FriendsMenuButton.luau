local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local RoactUtils = require(FriendsMenuParent.RoactUtils)
local Signals = require(FriendsMenuParent.Signals)
local useSignalState = require(FriendsMenuParent.SignalsReact).useSignalState
local FFlagUseSignalsForGameInvitesStatus = require(FriendsMenuParent.SharedFlags).FFlagUseSignalsForGameInvitesStatus
local v10 = if not FFlagUseSignalsForGameInvitesStatus then nil else require(FriendsMenuParent.NotificationsCommon).GetGameInvitesStatusStore
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

return function(t2: {[any]: any}) -- line: 47
	-- upvalues: FFlagUseSignalsForGameInvitesStatus (copy), React (copy), Signals (copy), v10 (copy), useSignalState (copy), useSelector (copy), getLocalizedStrings (copy), t1 (copy), FriendsListContext (copy), useStyle (copy), InviteStatus (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v25

	if FFlagUseSignalsForGameInvitesStatus then
		local v23 = t2.friend and t2.friend.id
		local v24 = React.useMemo(function() -- line: 51
			-- upvalues: Signals (copy), v10 (copy), v23 (copy)
			return Signals.createComputed(function(p1) -- line: 52
				-- upvalues: v10 (copy), v23 (copy)
				return v10(false).getGameInvitesStatus(p1)[v23]
			end)
		end, { v23 })

		v25 = useSignalState(v24)
	else
		v25 = useSelector(function(p2) -- line: 58
			-- upvalues: t2 (copy)
			local friend = t2.friend

			assert(friend, "friend should be non-nil. Silence type checker.")

			return p2.GameInvitesStatus[friend.id]
		end)
	end

	local v26 = getLocalizedStrings(t1)
	local v27 = React.useContext(FriendsListContext)
	local v28 = useStyle()
	local v29 = v28 and v28.Theme
	local v30 = v28 and v28.Font
	local isFetchingFriends = v27.isFetchingFriends
	local v32 = v30.BaseSize * v30.CaptionHeader.RelativeSize

	if (not v25 or v25 == InviteStatus.Failed) and not t2.isFullRowActivatable then
		return React.createElement(Button, {
			isLoading = false,
			fitContent = true,
			buttonType = ButtonType.Secondary,
			isDisabled = isFetchingFriends,
			onActivated = t2.onInvite,
			standardSize = StandardButtonSize.XSmall,
			anchorPoint = t2.anchorPoint,
			position = t2.position,
			text = v26.inviteFriend,
			layoutOrder = t2.layoutOrder
		})
	end

	local v33 = v26[v25] or v26.inviteFriend

	return React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextWrapped = true,
		Text = v33,
		TextSize = v32,
		Size = t2.size,
		AnchorPoint = t2.anchorPoint,
		Position = t2.position,
		TextColor3 = v29.TextDefault.Color,
		Font = v30.CaptionHeader.Font,
		LayoutOrder = t2.layoutOrder
	})
end
