local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local Foundation = require(UserListParent.Foundation)
local convertToFoundationPresenceEnum = require(UserListParent.SocialCommon).Utils.convertToFoundationPresenceEnum

require(UserList.Common.Types)

local Enums = require(UserList.Common.Enums)
local useUserDataValues = require(UserList.Hooks.useUserDataValues)
local BaseRow = require(script.Parent.BaseRow)
local useIsRobloxSubscriber = require(UserListParent.UserProfiles).Hooks.useIsRobloxSubscriber
local FFlagEnableBlackbirdCheck = require(UserListParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagHomepagePYMKUseHorizontalUserList = require(UserListParent.SharedFlags).FFlagHomepagePYMKUseHorizontalUserList
local FFlagFixUserRowCombinedName = require(UserListParent.SharedFlags).FFlagFixUserRowCombinedName
local FFlagUserListCtaIntegrationEnabled = require(UserListParent.SharedFlags).FFlagUserListCtaIntegrationEnabled
local FFlagUserListUsernameFallbackConfig = require(UserListParent.SharedFlags).FFlagUserListUsernameFallbackConfig

local function UserRow(t1: {[any]: any}) -- line: 46
	-- upvalues: useUserDataValues (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), FFlagFixUserRowCombinedName (copy), FFlagUserListUsernameFallbackConfig (copy), Foundation (copy), convertToFoundationPresenceEnum (copy), FFlagHomepagePYMKUseHorizontalUserList (copy), React (copy), BaseRow (copy), FFlagUserListCtaIntegrationEnabled (copy), Enums (copy)
	local v17 = useUserDataValues(t1.entityId)
	local v18 = nil

	if FFlagEnableBlackbirdCheck then
		v18 = useIsRobloxSubscriber(if not t1.entityId then nil else t1.entityId)
	end

	local v19 = if not FFlagFixUserRowCombinedName then if v17.displayName == "" then nil else v17.displayName else if v17.combinedName == "" then nil else v17.combinedName
	local v20 = not t1.configs or (t1.configs.showSubtitle == nil or t1.configs.showSubtitle)
	local v21 = if not FFlagUserListUsernameFallbackConfig then nil else if v17.username == "" then nil else `@{ v17.username }`
	local v22 = if not FFlagUserListUsernameFallbackConfig then if not v20 or v17.username == "" then nil else `@{ v17.username }` else if not v20 then nil else v21
	local v23 = not t1.configs or (t1.configs.showPresence == nil or t1.configs.showPresence)
	local None = Foundation.Enums.UserPresence.None

	if v23 and t1.presence then
		None = convertToFoundationPresenceEnum(t1.presence)
	end

	local v25 = if not t1.loadingState or not if not FFlagHomepagePYMKUseHorizontalUserList then t1.loadingState.title else t1.loadingState.title ~= nil then v17.isLoading else t1.loadingState.title
	local v26 = if not t1.loadingState or not if not FFlagHomepagePYMKUseHorizontalUserList then t1.loadingState.subtitle else t1.loadingState.subtitle ~= nil then v17.isLoading else t1.loadingState.subtitle
	local v27 = t1.loadingState and t1.loadingState.contextualInfo
	local v28 = if not FFlagUserListUsernameFallbackConfig then nil else if not t1.configs or (not t1.configs.showUsernameAsContextualFallback or t1.contextualInfo) then t1.contextualInfo else {
		text = v21
	}

	return React.createElement(BaseRow, {
		userId = t1.entityId,
		userPresenceType = None,
		title = v19,
		subtitle = v22,
		layoutMode = t1.layoutMode,
		onActivated = t1.onActivated,
		isTitleLoading = v25,
		isSubtitleLoading = v26,
		isContextualInfoLoading = v27,
		contextualInfo = if not FFlagUserListUsernameFallbackConfig then t1.contextualInfo else v28,
		primaryCta = t1.primaryCta,
		secondaryCta = t1.secondaryCta,
		ctaLoading = if not FFlagUserListCtaIntegrationEnabled then nil else t1.ctaLoading,
		trailingContent = t1.trailingContent,
		layoutOrder = t1.layoutOrder,
		trustedConnectionIndicatorEnabled = t1.layoutMode == Enums.RowLayoutMode.Wide,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v18
	})
end

return React.memo(UserRow)
