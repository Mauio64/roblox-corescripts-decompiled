local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local react = dependencies.React

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local t = dependencies.t
local withStyle = uiBlox.Style.withStyle
local withLocalization = dependencies.withLocalization
local UserProfiles = require(parent.UserProfiles)
local userPresenceText = require(FriendsLanding.Friends.userPresenceText)
local userPresenceIcon = require(FriendsLanding.Friends.userPresenceIcon)
local getCorrectUserPresence = require(FriendsLanding.Friends.getCorrectUserPresence)

local memoize = dependencies.memoize
local createRelevancyInfo = require(script.Parent.createRelevancyInfo)

local SocialCommon = require(parent.SocialCommon)
local UserList = require(parent.UserList)
local ButtonTypes = UserList.Enums.ButtonTypes

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FriendTileWithTrustedIndicator = require(script.Parent.FriendTileWithTrustedIndicator)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsPageUserListEnabled = SharedFlags.FFlagFriendsPageUserListEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagFriendsPageViewBtnEnabled = SharedFlags2.FFlagFriendsPageViewBtnEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags3.FFlagEnableBlackbirdCheck
local FFlagFriendsPageUserListCtaEnabled = require(FriendsLanding.Flags.FFlagFriendsPageUserListCtaEnabled)

local extended = roact.PureComponent:extend("FriendTile")

extended.validateProps = t.strictInterface({
	user = t.table,
	index = t.number,
	openPlayerProfileHandle = t.callback,
	pageLoadingTimeReport = t.optional(t.callback),
	createRow = t.optional(t.callback),
	selected = t.optional(t.boolean),
	focusGuiObject = t.optional(t.callback),
	userProfile = t.optional(t.table),
	trustedConnection = t.optional(t.boolean),
	isRobloxSubscriber = t.optional(t.boolean),
	isLuobu = t.optional(t.boolean),
	buttons = t.optional(t.array(t.strictInterface({
		icon = t.optional(t.string),
		onActivated = t.optional(t.callback),
		isSecondary = t.optional(t.boolean),
		isDisabled = t.optional(t.boolean)
	})))
})

extended.defaultProps = {
	user = { username = "" },
	openPlayerProfileHandle = function() end,
	isLuobu = false,
	index = 1,
	buttons = nil,
	trustedConnection = false
}

function extended:init()
	self.state = { isFirstRender = true }
	self.makeRelevancyInfo = memoize(createRelevancyInfo)
	self.playerTileRef = roact.createRef()

	function self.checkAndSetSelected()
		local v = self.props.selected and self.props.focusGuiObject and self.playerTileRef:getValue()

		if v then
			self.props.focusGuiObject(v)
		end
	end

	self.getPresenceType = FFlagFriendsPageUserListEnabled and function(value)
		local v = tostring(value or "")
		return string.gsub(v, "PresenceType%.", "") or SocialCommon.Enums.PresenceTypes.Offline
	end or nil

	function self.openProfilePeekViewHandle()
		return self.props.openPlayerProfileHandle(self.props.user.id, self.props.index, self.props.user)
	end
end

function extended.didMount(p)
	if p.props.pageLoadingTimeReport then
		p.props.pageLoadingTimeReport()
	end

	p.checkAndSetSelected()
end

function extended.render(object)
	local user = object.props.user
	local correctUserPresence = getCorrectUserPresence(user)

	local presenceText2 = userPresenceText[correctUserPresence]
	local v = userPresenceIcon[correctUserPresence]

	if not object.playerTileRef:getValue() then
		object:setState({ isFirstRender = false })
	end

	return withStyle(function(p)
		return withLocalization({
			presenceText = presenceText2,
			accountDeletedText = "Feature.Friends.Action.AccountDeleted",
			trustedText = "Feature.Friends.TrustedConnection.Label.Trusted"
		})(function(p2)
			local presenceText = p2.presenceText or nil
			local accountDeletedText = p2.accountDeletedText

			if FFlagFriendsPageUserListEnabled then
				local relevancyInfo = object.makeRelevancyInfo(
					user,
					presenceText,
					v,
					nil,
					p.Theme,
					object.props.index,
					object.props.isLuobu,
					p.Font,
					accountDeletedText,
					true
				)

				local createRow = object.props.createRow
				local v2 = {
					onRowActivated = object.openProfilePeekViewHandle,
					contextualInfo = relevancyInfo and {
						text = relevancyInfo.text,
						icon = relevancyInfo.icon
					},
					presence = object.getPresenceType(correctUserPresence),
					primaryCta = 0
				}
				local primaryCta

				if not FFlagFriendsPageUserListCtaEnabled then
					primaryCta = FFlagFriendsPageViewBtnEnabled and {
						type = ButtonTypes.View,
						onActivated = object.openProfilePeekViewHandle,
						variant = ButtonVariant.Standard,
						minWidth = 64,
						maxWidth = 90
					} or nil
				end

				v2.primaryCta = primaryCta
				return createRow(v2)
			else
				local combinedName, v2

				if object.props.userProfile then
					combinedName = object.props.userProfile.names.combinedName
					v2 = UserProfiles.Formatters.formatUsername(object.props.userProfile.names.username)
					user.isDeleted = object.props.userProfile.isDeleted
				end

				local title = combinedName or user.displayName
				local subtitle = v2 or "@" .. user.username
				local relevancyInfo

				if combinedName then
					relevancyInfo = object.makeRelevancyInfo(
						user,
						presenceText,
						v,
						nil,
						p.Theme,
						object.props.index,
						object.props.isLuobu,
						p.Font,
						accountDeletedText,
						true
					)
				end

				local isVerified = object.props.userProfile and object.props.userProfile.isVerified
				local createElement = react.createElement
				local v3 = {
					user = user,
					userPresence = correctUserPresence,
					title = title,
					subtitle = subtitle,
					relevancyInfo = relevancyInfo,
					index = object.props.index,
					openPlayerProfile = object.openProfilePeekViewHandle,
					playerTileRef = object.playerTileRef,
					buttons = object.props.buttons,
					isTrustedConnection = object.props.trustedConnection,
					isVerified = isVerified,
					isRobloxSubscriber = 0
				}
				local isRobloxSubscriber

				if FFlagEnableBlackbirdCheck then
					isRobloxSubscriber = object.props.isRobloxSubscriber
				end

				v3.isRobloxSubscriber = isRobloxSubscriber
				return createElement(FriendTileWithTrustedIndicator, v3)
			end
		end)
	end)
end

return extended
