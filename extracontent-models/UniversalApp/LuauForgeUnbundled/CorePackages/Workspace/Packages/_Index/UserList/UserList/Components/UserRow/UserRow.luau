local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local convertToFoundationPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialCommon").Utils.convertToFoundationPresenceEnum
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local useUserDataValues = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useUserDataValues")
local BaseRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserRow/BaseRow")
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserProfiles").Hooks.useIsRobloxSubscriber
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagEnableBlackbirdCheck

local fFlagFixUserRowCombinedName = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagFixUserRowCombinedName
local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagUserListUsernameFallbackConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListUsernameFallbackConfig
local fFlagAddStatusIndicatorToBaseRow = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagAddStatusIndicatorToBaseRow
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions

local function UserRow(props)
	local v5 = useUserDataValues(props.entityId)
	local v6

	if fFlagEnableBlackbirdCheck then
		local v8 = if props.entityId then props.entityId else nil
		v6 = useIsRobloxSubscriber(v8)
	end

	local v7

	if fFlagFixUserRowCombinedName then
		if v5.combinedName ~= "" then
			v7 = v5.combinedName
		end
	elseif v5.displayName ~= "" then
		v7 = v5.displayName
	end

	local v8 = not props.configs or props.configs.showSubtitle == nil or props.configs.showSubtitle
	local v9

	if fFlagUserListUsernameFallbackConfig and v5.username ~= "" then
		v9 = `@{v5.username}`
	end

	local v10

	if fFlagUserListUsernameFallbackConfig then
		if v8 then
			v10 = v9
		end
	elseif v8 and v5.username ~= "" then
		v10 = `@{v5.username}`
	end

	local v11 = not props.configs or props.configs.showPresence == nil or props.configs.showPresence

	local v12 = Foundation.Enums.UserPresence.None

	if v11 and props.presence then
		v12 = convertToFoundationPresenceEnum(props.presence)
	end

	local v13

	if props.loadingState and props.loadingState.title ~= nil then
		v13 = props.loadingState.title
	else
		v13 = v5.isLoading
	end

	local v14

	if props.loadingState and props.loadingState.subtitle ~= nil then
		v14 = props.loadingState.subtitle
	else
		v14 = v5.isLoading
	end

	local contextualInfo = props.loadingState and props.loadingState.contextualInfo
	local v15

	if fFlagUserListUsernameFallbackConfig then
		v15 = props.configs
			and props.configs.showUsernameAsContextualFallback
			and not props.contextualInfo
			and { text = v9 }
			or props.contextualInfo
	end

	local createElement = React.createElement
	local v17 = {
		userId = props.entityId,
		userPresenceType = v12,
		title = v7,
		subtitle = v10,
		layoutMode = props.layoutMode,
		onActivated = props.onActivated,
		isTitleLoading = v13,
		isSubtitleLoading = v14,
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

	if not fFlagUserListUsernameFallbackConfig then
		v15 = props.contextualInfo
	end

	v17.contextualInfo = v15

	v17.primaryCta = props.primaryCta
	v17.secondaryCta = props.secondaryCta
	local v18 = if fFlagAddStatusIndicatorToBaseRow then props.shouldShowNewIndicator else nil
	v17.shouldShowNewIndicator = v18
	local v19 = if fFlagUserListCtaIntegrationEnabled then props.ctaLoading else nil
	v17.ctaLoading = v19
	v17.trailingContent = props.trailingContent
	v17.layoutOrder = props.layoutOrder
	v17.trustedConnectionIndicatorEnabled = (not (fFlagUserListSurfaceExtensions and props.configs) or props.configs.showTrustedFriendIndicator ~= false)
		and props.layoutMode == Enums.RowLayoutMode.Wide

	if not fFlagEnableBlackbirdCheck then
		v6 = nil
	end

	v17.isRobloxSubscriber = v6
	local v21 = if fFlagUserListSurfaceExtensions and props.configs then props.configs.disableRowActivation else nil
	v17.disableRowActivation = v21
	return createElement(BaseRow, v17)
end

return React.memo(UserRow)
