local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SocialCommon = require(parent.SocialCommon)
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum
require(UserList.Common.Types)
local Enums = require(UserList.Common.Enums)
local useUserDataValues = require(UserList.Hooks.useUserDataValues)
local BaseRow = require(script.Parent.BaseRow)
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags2.FFlagUserListCtaIntegrationEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags3.FFlagUserListSurfaceExtensions

local function UserRow(props)
	local v = useUserDataValues(props.entityId)
	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		local v2

		if props.entityId then
			v2 = props.entityId
		end

		isRobloxSubscriber = useIsRobloxSubscriber(v2)
	end

	local combinedName

	if v.combinedName ~= "" then
		combinedName = v.combinedName
	end

	local v2 = not props.configs or props.configs.showSubtitle == nil or props.configs.showSubtitle
	local text

	if v.username ~= "" then
		text = `@{v.username}`
	end

	local subtitle

	if v2 then
		subtitle = text
	end

	local v3 = not props.configs or props.configs.showPresence == nil or props.configs.showPresence

	local userPresenceType = Foundation.Enums.UserPresence.None

	if v3 and props.presence then
		userPresenceType = convertToFoundationPresenceEnum(props.presence)
	end

	local isTitleLoading

	if props.loadingState and props.loadingState.title ~= nil then
		isTitleLoading = props.loadingState.title
	else
		isTitleLoading = v.isLoading
	end

	local isSubtitleLoading

	if props.loadingState and props.loadingState.subtitle ~= nil then
		isSubtitleLoading = props.loadingState.subtitle
	else
		isSubtitleLoading = v.isLoading
	end

	local contextualInfo = props.loadingState and props.loadingState.contextualInfo
	local contextualInfo2 = props.configs
		and props.configs.showUsernameAsContextualFallback
		and not props.contextualInfo
		and { text = text }
		or props.contextualInfo

	local createElement = React.createElement
	local v4 = {
		userId = props.entityId,
		userPresenceType = userPresenceType,
		title = combinedName,
		subtitle = subtitle,
		layoutMode = props.layoutMode,
		onActivated = props.onActivated,
		isTitleLoading = isTitleLoading,
		isSubtitleLoading = isSubtitleLoading,
		isContextualInfoLoading = contextualInfo,
		contextualInfo = contextualInfo2,
		primaryCta = props.primaryCta,
		secondaryCta = props.secondaryCta,
		shouldShowNewIndicator = props.shouldShowNewIndicator,
		ctaLoading = 0,
		trailingContent = 0,
		layoutOrder = 0,
		trustedConnectionIndicatorEnabled = 0,
		isRobloxSubscriber = 0,
		disableRowActivation = 0
	}
	local ctaLoading

	if FFlagUserListCtaIntegrationEnabled then
		ctaLoading = props.ctaLoading
	end

	v4.ctaLoading = ctaLoading
	v4.trailingContent = props.trailingContent
	v4.layoutOrder = props.layoutOrder
	v4.trustedConnectionIndicatorEnabled = (not (FFlagUserListSurfaceExtensions and props.configs) or props.configs.showTrustedFriendIndicator ~= false)
		and props.layoutMode == Enums.RowLayoutMode.Wide

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	v4.isRobloxSubscriber = isRobloxSubscriber
	local disableRowActivation

	if FFlagUserListSurfaceExtensions and props.configs then
		disableRowActivation = props.configs.disableRowActivation
	end

	v4.disableRowActivation = disableRowActivation
	return createElement(BaseRow, v4)
end

return React.memo(UserRow)
