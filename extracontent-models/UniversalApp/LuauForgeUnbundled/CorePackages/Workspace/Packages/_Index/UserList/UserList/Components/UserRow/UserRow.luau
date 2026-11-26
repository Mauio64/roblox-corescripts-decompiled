local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local convertToFoundationPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialCommon").Utils.convertToFoundationPresenceEnum
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local useUserDataValues = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useUserDataValues")
local BaseRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserRow/BaseRow")
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserProfiles").Hooks.useIsRobloxSubscriber
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagEnableBlackbirdCheck

local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions

local function UserRow(props)
	local v5 = useUserDataValues(props.entityId)
	local v6

	if fFlagEnableBlackbirdCheck then
		local v8 = if props.entityId then props.entityId else nil
		v6 = useIsRobloxSubscriber(v8)
	end

	local combinedName = if v5.combinedName ~= "" then v5.combinedName else nil

	local v7 = not props.configs or props.configs.showSubtitle == nil or props.configs.showSubtitle

	local v8 = if v5.username ~= "" then `@{v5.username}` else nil
	local v9 = if v7 then v8 else nil
	local v10 = not props.configs or props.configs.showPresence == nil or props.configs.showPresence

	local v11 = Foundation.Enums.UserPresence.None

	if v10 and props.presence then
		v11 = convertToFoundationPresenceEnum(props.presence)
	end

	local v12

	if props.loadingState and props.loadingState.title ~= nil then
		v12 = props.loadingState.title
	else
		v12 = v5.isLoading
	end

	local v13

	if props.loadingState and props.loadingState.subtitle ~= nil then
		v13 = props.loadingState.subtitle
	else
		v13 = v5.isLoading
	end

	local contextualInfo = props.loadingState and props.loadingState.contextualInfo
	local v14 = props.configs
		and props.configs.showUsernameAsContextualFallback
		and not props.contextualInfo
		and { text = v8 }
		or props.contextualInfo

	local createElement = React.createElement
	local v16 = {
		userId = props.entityId,
		userPresenceType = v11,
		title = combinedName,
		subtitle = v9,
		layoutMode = props.layoutMode,
		onActivated = props.onActivated,
		isTitleLoading = v12,
		isSubtitleLoading = v13,
		isContextualInfoLoading = contextualInfo,
		contextualInfo = v14,
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
	local v17 = if fFlagUserListCtaIntegrationEnabled then props.ctaLoading else nil
	v16.ctaLoading = v17
	v16.trailingContent = props.trailingContent
	v16.layoutOrder = props.layoutOrder
	v16.trustedConnectionIndicatorEnabled = (not (fFlagUserListSurfaceExtensions and props.configs) or props.configs.showTrustedFriendIndicator ~= false)
		and props.layoutMode == Enums.RowLayoutMode.Wide

	if not fFlagEnableBlackbirdCheck then
		v6 = nil
	end

	v16.isRobloxSubscriber = v6
	local v19 = if fFlagUserListSurfaceExtensions and props.configs then props.configs.disableRowActivation else nil
	v16.disableRowActivation = v19
	return createElement(BaseRow, v16)
end

return React.memo(UserRow)
