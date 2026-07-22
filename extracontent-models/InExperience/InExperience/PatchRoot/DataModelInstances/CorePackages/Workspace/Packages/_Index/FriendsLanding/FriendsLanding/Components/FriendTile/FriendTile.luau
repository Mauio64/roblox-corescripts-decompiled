local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local React = dependencies.React
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local withStyle = UIBlox.Style.withStyle
local withLocalization = dependencies.withLocalization
local UserProfiles = require(FriendsLandingParent.UserProfiles)
local userPresenceText = require(FriendsLanding.Friends.userPresenceText)
local userPresenceIcon = require(FriendsLanding.Friends.userPresenceIcon)
local getCorrectUserPresence = require(FriendsLanding.Friends.getCorrectUserPresence)
local memoize = dependencies.memoize
local createRelevancyInfo = require(script.Parent.createRelevancyInfo)
local SocialCommon = require(FriendsLandingParent.SocialCommon)
local ButtonTypes = require(FriendsLandingParent.UserList).Enums.ButtonTypes
local ButtonVariant = require(FriendsLandingParent.Foundation).Enums.ButtonVariant
local FriendTileWithTrustedIndicator = require(script.Parent.FriendTileWithTrustedIndicator)
local FFlagFriendsPageAlwaysOpenPPV = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageAlwaysOpenPPV
local FFlagFriendsPageUserListEnabled = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageUserListEnabled
local FFlagFriendsPageViewBtnEnabled = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageViewBtnEnabled
local FFlagEnableBlackbirdCheck = require(FriendsLandingParent.SharedFlags).FFlagEnableBlackbirdCheck
local v24 = Roact.PureComponent:extend("FriendTile")

v24.validateProps = t.strictInterface({
	user = t.table,
	index = t.number,
	openPlayerProfile = t.optional(t.callback),
	openPlayerProfileHandle = t.optional(t.callback),
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
	}))),
	isPlayerContextualMenuEnabled = t.optional(t.boolean)
})
v24.defaultProps = {
	isLuobu = false,
	index = 1,
	buttons = nil,
	isPlayerContextualMenuEnabled = false,
	trustedConnection = false,
	user = {
		username = ""
	},
	openPlayerProfile = function() -- line: 37
		return function() -- line: 38
		end
	end
}

function v24.init(p1) -- line: 81
	-- upvalues: memoize (copy), createRelevancyInfo (copy), Roact (copy), FFlagFriendsPageAlwaysOpenPPV (copy), FFlagFriendsPageUserListEnabled (copy), SocialCommon (copy)
	p1.state = {
		isFirstRender = true
	}
	p1.makeRelevancyInfo = memoize(createRelevancyInfo)
	p1.playerTileRef = Roact.createRef()
	p1.openPlayerProfile = if not FFlagFriendsPageAlwaysOpenPPV then not p1.props.isPlayerContextualMenuEnabled and function(p2, p3) -- line: 92
		-- upvalues: p1 (copy)
		local user = p1.props.user

		if p2 and p3 then
			return p1.props.openPlayerProfile(user.id, p1.props.index, user, p2, p3)
		end

		return p1.props.openPlayerProfile(user.id, p1.props.index, user)
	end or function(_: Vector2?, _: Vector2?) -- line: 88
		-- upvalues: p1 (copy)
		local user = p1.props.user

		return p1.props.openPlayerProfile(user)
	end else nil
	p1.openPlayerProfileForRelevancyInfo = not FFlagFriendsPageAlwaysOpenPPV and function(p4, p5) -- line: 103
		-- upvalues: p1 (copy)
		return function() -- line: 104
			-- upvalues: p1 (copy), p4 (copy), p5 (copy)
			return p1.openPlayerProfile(p4, p5)
		end
	end or nil

	function p1.checkAndSetSelected() -- line: 109
		-- upvalues: p1 (copy)
		if p1.props.selected and p1.props.focusGuiObject then
			local v43 = p1.playerTileRef:getValue()

			if v43 then
				p1.props.focusGuiObject(v43)
			end
		end
	end

	p1.getPresenceType = if not FFlagFriendsPageUserListEnabled then nil else function(p6) -- line: 119
		-- upvalues: SocialCommon (copy)
		local str = tostring(p6 or "")

		return string.gsub(str, "PresenceType%.", "") or SocialCommon.Enums.PresenceTypes.Offline
	end
	p1.openProfilePeekViewHandle = if not FFlagFriendsPageUserListEnabled then nil else function() -- line: 126
		-- upvalues: p1 (copy)
		return p1.props.openPlayerProfileHandle(p1.props.user.id, p1.props.index)
	end
end
function v24.didMount(p7) -- line: 132
	if p7.props.pageLoadingTimeReport then
		p7.props.pageLoadingTimeReport()
	end

	p7.checkAndSetSelected()
end
function v24.render(p8) -- line: 140
	-- upvalues: getCorrectUserPresence (copy), userPresenceText (copy), userPresenceIcon (copy), withStyle (copy), withLocalization (copy), FFlagFriendsPageUserListEnabled (copy), FFlagFriendsPageAlwaysOpenPPV (copy), FFlagFriendsPageViewBtnEnabled (copy), ButtonTypes (copy), ButtonVariant (copy), UserProfiles (copy), React (copy), FriendTileWithTrustedIndicator (copy), FFlagEnableBlackbirdCheck (copy)
	local user = p8.props.user
	local v29 = getCorrectUserPresence(user)
	local v30 = userPresenceText[v29]
	local v31 = userPresenceIcon[v29]
	local AbsoluteSize = nil
	local AbsolutePosition = nil
	local v34 = p8.playerTileRef:getValue()

	if v34 then
		AbsoluteSize = v34.AbsoluteSize
		AbsolutePosition = v34.AbsolutePosition
	else
		p8:setState({
			isFirstRender = false
		})
	end

	return withStyle(function(p9) -- line: 158
		-- upvalues: withLocalization (copy), v30 (copy), FFlagFriendsPageUserListEnabled (copy), p8 (copy), user (copy), v31 (copy), FFlagFriendsPageAlwaysOpenPPV (copy), AbsoluteSize (ref), AbsolutePosition (ref), v29 (copy), FFlagFriendsPageViewBtnEnabled (copy), ButtonTypes (copy), ButtonVariant (copy), UserProfiles (copy), React (copy), FriendTileWithTrustedIndicator (copy), FFlagEnableBlackbirdCheck (copy)
		return withLocalization({
			accountDeletedText = "Feature.Friends.Action.AccountDeleted",
			trustedText = "Feature.Friends.TrustedConnection.Label.Trusted",
			presenceText = v30
		})(function(p10) -- line: 163
			-- upvalues: FFlagFriendsPageUserListEnabled (copy), p8 (copy), user (copy), v31 (copy), FFlagFriendsPageAlwaysOpenPPV (copy), AbsoluteSize (ref), AbsolutePosition (ref), p9 (copy), v29 (copy), FFlagFriendsPageViewBtnEnabled (copy), ButtonTypes (copy), ButtonVariant (copy), UserProfiles (copy), React (copy), FriendTileWithTrustedIndicator (copy), FFlagEnableBlackbirdCheck (copy)
			local v48 = p10.presenceText or nil
			local accountDeletedText = p10.accountDeletedText

			if FFlagFriendsPageUserListEnabled then
				local v50 = p8.makeRelevancyInfo(user, v48, v31, if not FFlagFriendsPageAlwaysOpenPPV then p8.openPlayerProfileForRelevancyInfo(AbsoluteSize, AbsolutePosition) else nil, p9.Theme, p8.props.index, p8.props.isLuobu, p9.Font, accountDeletedText, true)

				return p8.props.createRow({
					onRowActivated = p8.openProfilePeekViewHandle,
					contextualInfo = v50 and {
						text = v50.text,
						icon = v50.icon
					},
					presence = p8.getPresenceType(v29),
					primaryCta = if not FFlagFriendsPageViewBtnEnabled then nil else {
						minWidth = 64,
						maxWidth = 90,
						type = ButtonTypes.View,
						onActivated = p8.openProfilePeekViewHandle,
						variant = ButtonVariant.Standard
					}
				})
			end

			local combinedName = nil
			local v52 = nil

			if p8.props.userProfile then
				combinedName = p8.props.userProfile.names.combinedName
				v52 = UserProfiles.Formatters.formatUsername(p8.props.userProfile.names.username)
				user.isDeleted = p8.props.userProfile.isDeleted
			end

			local v53 = combinedName or user.displayName
			local v54 = v52 or "@" .. user.username
			local v55 = if combinedName then p8.makeRelevancyInfo(user, v48, v31, if not FFlagFriendsPageAlwaysOpenPPV then p8.openPlayerProfileForRelevancyInfo(AbsoluteSize, AbsolutePosition) else nil, p9.Theme, p8.props.index, p8.props.isLuobu, p9.Font, accountDeletedText, true) else nil
			local v56 = p8.props.userProfile and p8.props.userProfile.isVerified

			return React.createElement(FriendTileWithTrustedIndicator, {
				user = user,
				userPresence = v29,
				title = v53,
				subtitle = v54,
				relevancyInfo = v55,
				index = p8.props.index,
				openPlayerProfile = if not FFlagFriendsPageAlwaysOpenPPV then p8.openPlayerProfile(AbsoluteSize, AbsolutePosition, v53, v54, v55) else p8.props.openPlayerProfile(user.id, p8.props.index),
				playerTileRef = p8.playerTileRef,
				buttons = p8.props.buttons,
				isTrustedConnection = p8.props.trustedConnection,
				isVerified = v56,
				isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else p8.props.isRobloxSubscriber
			})
		end)
	end)
end

return v24
