local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local react = dependencies.React

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local t = dependencies.t
local withStyle = uiBlox.Style.withStyle
local withLocalization = dependencies.withLocalization
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/UserProfiles")
local userPresenceText = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/userPresenceText")
local userPresenceIcon = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/userPresenceIcon")
local getCorrectUserPresence = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/getCorrectUserPresence")

local memoize = dependencies.memoize
local createRelevancyInfo = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendTile/createRelevancyInfo")

local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialCommon")
local buttonTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UserList").Enums.ButtonTypes

local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation").Enums.ButtonVariant
local FriendTileWithTrustedIndicator = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendTile/FriendTileWithTrustedIndicator")

local fFlagFriendsPageUserListEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageUserListEnabled
local fFlagFriendsPageViewBtnEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageViewBtnEnabled
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagEnableBlackbirdCheck
local FFlagFriendsPageUserListCtaEnabled = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFriendsPageUserListCtaEnabled")

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
		local v5 = self.props.selected and self.props.focusGuiObject and self.playerTileRef:getValue()

		if v5 then
			self.props.focusGuiObject(v5)
		end
	end

	self.getPresenceType = fFlagFriendsPageUserListEnabled and function(value)
		local v5 = tostring(value or "")
		return string.gsub(v5, "PresenceType%.", "") or SocialCommon.Enums.PresenceTypes.Offline
	end or nil

	function self.openProfilePeekViewHandle()
		return self.props.openPlayerProfileHandle(self.props.user.id, self.props.index, self.props.user)
	end
end

function extended.didMount(p2)
	if p2.props.pageLoadingTimeReport then
		p2.props.pageLoadingTimeReport()
	end

	p2.checkAndSetSelected()
end

function extended.render(object)
	local user = object.props.user
	local v5 = getCorrectUserPresence(user)

	local v6 = userPresenceText[v5]
	local v7 = userPresenceIcon[v5]

	if not object.playerTileRef:getValue() then
		object:setState({ isFirstRender = false })
	end

	return withStyle(function(p2)
		return withLocalization({
			presenceText = v6,
			accountDeletedText = "Feature.Friends.Action.AccountDeleted",
			trustedText = "Feature.Friends.TrustedConnection.Label.Trusted"
		})(function(p3)
			local presenceText = p3.presenceText or nil
			local accountDeletedText = p3.accountDeletedText

			if fFlagFriendsPageUserListEnabled then
				local relevancyInfo = object.makeRelevancyInfo(
					user,
					presenceText,
					v7,
					nil,
					p2.Theme,
					object.props.index,
					object.props.isLuobu,
					p2.Font,
					accountDeletedText,
					true
				)

				local createRow = object.props.createRow
				local v8 = {
					onRowActivated = object.openProfilePeekViewHandle,
					contextualInfo = relevancyInfo and {
						text = relevancyInfo.text,
						icon = relevancyInfo.icon
					},
					presence = object.getPresenceType(v5),
					primaryCta = 0
				}

				local v9 = if not FFlagFriendsPageUserListCtaEnabled then fFlagFriendsPageViewBtnEnabled and {
					type = buttonTypes.View,
					onActivated = object.openProfilePeekViewHandle,
					variant = buttonVariant.Standard,
					minWidth = 64,
					maxWidth = 90
				} or nil else nil
				v8.primaryCta = v9
				return createRow(v8)
			else
				local combinedName, v8

				if object.props.userProfile then
					combinedName = object.props.userProfile.names.combinedName
					v8 = UserProfiles.Formatters.formatUsername(object.props.userProfile.names.username)
					user.isDeleted = object.props.userProfile.isDeleted
				end

				local v9 = combinedName or user.displayName
				local v10 = v8 or "@" .. user.username
				local v11

				if combinedName then
					v11 = object.makeRelevancyInfo(
						user,
						presenceText,
						v7,
						nil,
						p2.Theme,
						object.props.index,
						object.props.isLuobu,
						p2.Font,
						accountDeletedText,
						true
					)
				end

				local isVerified = object.props.userProfile and object.props.userProfile.isVerified
				local createElement = react.createElement
				local v13 = {
					user = user,
					userPresence = v5,
					title = v9,
					subtitle = v10,
					relevancyInfo = v11,
					index = object.props.index,
					openPlayerProfile = object.openProfilePeekViewHandle,
					playerTileRef = object.playerTileRef,
					buttons = object.props.buttons,
					isTrustedConnection = object.props.trustedConnection,
					isVerified = isVerified,
					isRobloxSubscriber = 0
				}

				local v14 = if fFlagEnableBlackbirdCheck then object.props.isRobloxSubscriber else nil
				v13.isRobloxSubscriber = v14
				return createElement(FriendTileWithTrustedIndicator, v13)
			end
		end)
	end)
end

return extended
