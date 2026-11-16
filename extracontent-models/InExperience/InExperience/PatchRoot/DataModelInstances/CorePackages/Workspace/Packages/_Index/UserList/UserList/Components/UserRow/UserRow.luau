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
local FFlagFixUserRowCombinedName = SharedFlags2.FFlagFixUserRowCombinedName
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags3.FFlagUserListCtaIntegrationEnabled
local SharedFlags4 = require(parent.SharedFlags)
local FFlagUserListUsernameFallbackConfig = SharedFlags4.FFlagUserListUsernameFallbackConfig
local SharedFlags5 = require(parent.SharedFlags)
local FFlagAddStatusIndicatorToBaseRow = SharedFlags5.FFlagAddStatusIndicatorToBaseRow
local SharedFlags6 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags6.FFlagUserListSurfaceExtensions

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

	local title

	if FFlagFixUserRowCombinedName then
		if v.combinedName ~= "" then
			title = v.combinedName
		end
	elseif v.displayName ~= "" then
		title = v.displayName
	end

	local v2 = not props.configs or props.configs.showSubtitle == nil or props.configs.showSubtitle
	local text

	if FFlagUserListUsernameFallbackConfig and v.username ~= "" then
		text = `@{v.username}`
	end

	local subtitle

	if FFlagUserListUsernameFallbackConfig then
		if v2 then
			subtitle = text
		end
	elseif v2 and v.username ~= "" then
		subtitle = `@{v.username}`
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
	local contextualInfo2

	if FFlagUserListUsernameFallbackConfig then
		contextualInfo2 = props.configs
			and props.configs.showUsernameAsContextualFallback
			and not props.contextualInfo
			and { text = text }
			or props.contextualInfo
	end

	local createElement = React.createElement
	local v4 = {
		userId = props.entityId,
		userPresenceType = userPresenceType,
		title = title,
		subtitle = subtitle,
		layoutMode = props.layoutMode,
		onActivated = props.onActivated,
		isTitleLoading = isTitleLoading,
		isSubtitleLoading = isSubtitleLoading,
		isContextualInfoLoading = contextualInfo,
		contextualInfo = 0,
		primaryCta = 0,
		secondaryCta = 0,
		shouldShowNewIndicator = 0,
		ctaLoading = 0,
		trailingContent = 0,
		layoutOrder = 0,
		trustedConnectionIndicatorEnabled = 0,
		isRobloxSubscriber = 0,
		disableRowActivation = 0
	}

	if not FFlagUserListUsernameFallbackConfig then
		contextualInfo2 = props.contextualInfo
	end

	v4.contextualInfo = contextualInfo2

	v4.primaryCta = props.primaryCta
	v4.secondaryCta = props.secondaryCta
	local shouldShowNewIndicator

	if FFlagAddStatusIndicatorToBaseRow then
		shouldShowNewIndicator = props.shouldShowNewIndicator
	end

	v4.shouldShowNewIndicator = shouldShowNewIndicator
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
