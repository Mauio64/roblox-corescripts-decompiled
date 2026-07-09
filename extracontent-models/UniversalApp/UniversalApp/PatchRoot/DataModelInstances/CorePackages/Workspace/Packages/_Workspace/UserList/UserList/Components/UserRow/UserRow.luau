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

local function UserRow(t1: {[any]: any}) -- line: 41
	-- upvalues: useUserDataValues (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), FFlagFixUserRowCombinedName (copy), Foundation (copy), convertToFoundationPresenceEnum (copy), FFlagHomepagePYMKUseHorizontalUserList (copy), React (copy), BaseRow (copy), Enums (copy)
	local v15 = useUserDataValues(t1.entityId)
	local v16 = nil

	if FFlagEnableBlackbirdCheck then
		v16 = useIsRobloxSubscriber(if not t1.entityId then nil else t1.entityId)
	end

	local v17 = if not FFlagFixUserRowCombinedName then if v15.displayName == "" then nil else v15.displayName else if v15.combinedName == "" then nil else v15.combinedName
	local v18 = if not (not t1.configs or (t1.configs.showSubtitle == nil or t1.configs.showSubtitle)) or v15.username == "" then nil else `@{ v15.username }`
	local v19 = not t1.configs or (t1.configs.showPresence == nil or t1.configs.showPresence)
	local None = Foundation.Enums.UserPresence.None

	if v19 and t1.presence then
		None = convertToFoundationPresenceEnum(t1.presence)
	end

	local v21 = if not t1.loadingState or not if not FFlagHomepagePYMKUseHorizontalUserList then t1.loadingState.title else t1.loadingState.title ~= nil then v15.isLoading else t1.loadingState.title
	local v22 = if not t1.loadingState or not if not FFlagHomepagePYMKUseHorizontalUserList then t1.loadingState.subtitle else t1.loadingState.subtitle ~= nil then v15.isLoading else t1.loadingState.subtitle
	local v23 = t1.loadingState and t1.loadingState.contextualInfo

	return React.createElement(BaseRow, {
		userId = t1.entityId,
		userPresenceType = None,
		title = v17,
		subtitle = v18,
		layoutMode = t1.layoutMode,
		onActivated = t1.onActivated,
		isTitleLoading = v21,
		isSubtitleLoading = v22,
		isContextualInfoLoading = v23,
		contextualInfo = t1.contextualInfo,
		primaryCta = t1.primaryCta,
		secondaryCta = t1.secondaryCta,
		trailingContent = t1.trailingContent,
		layoutOrder = t1.layoutOrder,
		trustedConnectionIndicatorEnabled = t1.layoutMode == Enums.RowLayoutMode.Wide,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v16
	})
end

return React.memo(UserRow)
