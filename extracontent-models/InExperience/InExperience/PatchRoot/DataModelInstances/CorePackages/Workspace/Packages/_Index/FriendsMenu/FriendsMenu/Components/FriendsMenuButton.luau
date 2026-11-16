local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent
local Context = FriendsMenu.Context

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local RoactUtils = require(parent.RoactUtils)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if FFlagUseSignalsForGameInvitesStatus then
	local NotificationsCommon = require(parent.NotificationsCommon)
	getGameInvitesStatusStore = NotificationsCommon.GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

local NotificationsCommon = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon.LocalizationHelper
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

local v = {
	inviteFriend = "Feature.SettingsHub.Action.InviteFriend",
	[InviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[InviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[InviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}

return function(props)
	local v2

	if FFlagUseSignalsForGameInvitesStatus then
		local id = props.friend and props.friend.id
		v2 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p)
				return getGameInvitesStatusStore(false).getGameInvitesStatus(p)[id]
			end)
		end, { id })))
	else
		v2 = useSelector(function(p)
			local friend = props.friend
			assert(friend, "friend should be non-nil. Silence type checker.")

			return p.GameInvitesStatus[friend.id]
		end)
	end

	local localizedStrings = getLocalizedStrings(v)

	local v3 = React.useContext(FriendsListContext)

	local v4 = useStyle()
	local theme = v4 and v4.Theme
	local font = v4 and v4.Font

	local isFetchingFriends = v3.isFetchingFriends
	local textSize = font.BaseSize * font.CaptionHeader.RelativeSize
	local v5

	if v2 and v2 ~= InviteStatus.Failed then
		v5 = false
	else
		v5 = not props.isFullRowActivatable
	end

	if v5 then
		return React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			isDisabled = isFetchingFriends,
			isLoading = false,
			onActivated = props.onInvite,
			standardSize = StandardButtonSize.XSmall,
			fitContent = true,
			anchorPoint = props.anchorPoint,
			position = props.position,
			text = localizedStrings.inviteFriend,
			layoutOrder = props.layoutOrder
		})
	end

	local text = localizedStrings[v2] or localizedStrings.inviteFriend

	local createElement = React.createElement
	local v6 = {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = textSize,
		TextWrapped = true,
		Size = props.size,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		TextColor3 = theme.TextDefault.Color,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 0
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.CaptionHeader.Font
	end

	v6.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v4.Tokens.Typography.CaptionLarge.Font)
	end

	v6.FontFace = fontFace

	v6.LayoutOrder = props.layoutOrder
	return createElement("TextLabel", v6)
end
