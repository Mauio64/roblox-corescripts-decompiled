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
local v13 = game:DefineFastFlag("UserListUsernameFallbackConfig", false)

local function UserRow(t1: {[any]: any}) -- line: 43
	-- upvalues: useUserDataValues (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), FFlagFixUserRowCombinedName (copy), v13 (copy), Foundation (copy), convertToFoundationPresenceEnum (copy), FFlagHomepagePYMKUseHorizontalUserList (copy), React (copy), BaseRow (copy), Enums (copy)
	local v16 = useUserDataValues(t1.entityId)
	local v17 = nil

	if FFlagEnableBlackbirdCheck then
		v17 = useIsRobloxSubscriber(if not t1.entityId then nil else t1.entityId)
	end

	local v18 = if not FFlagFixUserRowCombinedName then if v16.displayName == "" then nil else v16.displayName else if v16.combinedName == "" then nil else v16.combinedName
	local v19 = not t1.configs or (t1.configs.showSubtitle == nil or t1.configs.showSubtitle)
	local v20 = if not v13 then nil else if v16.username == "" then nil else `@{ v16.username }`
	local v21 = if not v13 then if not v19 or v16.username == "" then nil else `@{ v16.username }` else if not v19 then nil else v20
	local v22 = not t1.configs or (t1.configs.showPresence == nil or t1.configs.showPresence)
	local None = Foundation.Enums.UserPresence.None

	if v22 and t1.presence then
		None = convertToFoundationPresenceEnum(t1.presence)
	end

	local v24 = if not t1.loadingState or not if not FFlagHomepagePYMKUseHorizontalUserList then t1.loadingState.title else t1.loadingState.title ~= nil then v16.isLoading else t1.loadingState.title
	local v25 = if not t1.loadingState or not if not FFlagHomepagePYMKUseHorizontalUserList then t1.loadingState.subtitle else t1.loadingState.subtitle ~= nil then v16.isLoading else t1.loadingState.subtitle
	local v26 = t1.loadingState and t1.loadingState.contextualInfo
	local v27 = if not v13 then nil else if not t1.configs or (not t1.configs.showUsernameAsContextualFallback or t1.contextualInfo) then t1.contextualInfo else {
		text = v20
	}

	return React.createElement(BaseRow, {
		userId = t1.entityId,
		userPresenceType = None,
		title = v18,
		subtitle = v21,
		layoutMode = t1.layoutMode,
		onActivated = t1.onActivated,
		isTitleLoading = v24,
		isSubtitleLoading = v25,
		isContextualInfoLoading = v26,
		contextualInfo = if not v13 then t1.contextualInfo else v27,
		primaryCta = t1.primaryCta,
		secondaryCta = t1.secondaryCta,
		trailingContent = t1.trailingContent,
		layoutOrder = t1.layoutOrder,
		trustedConnectionIndicatorEnabled = t1.layoutMode == Enums.RowLayoutMode.Wide,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v17
	})
end

return React.memo(UserRow)
