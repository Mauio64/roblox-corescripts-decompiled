local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local OffPlatformFriendRequestsIXP = require(ParentParent.Flags.OffPlatformFriendRequestsIXP)
local useSelector = dependencies.useSelector
local getContactImporterParams = require(script.Parent.getContactImporterParams)
local useUiModeInfo = require(ParentParentParent.RobloxAppHooks).useUiModeInfo
local UiMode = require(ParentParentParent.RobloxAppEnums).UiMode
local FFlagContactImporterIXPCleanup = require(ParentParentParent.SharedFlags).FFlagContactImporterIXPCleanup

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: useSelector (copy), getContactImporterParams (copy), FFlagContactImporterIXPCleanup (copy), OffPlatformFriendRequestsIXP (copy), useUiModeInfo (copy), UiMode (copy)
	local v11 = useSelector(function(p1) -- line: 14
		return p1.IsLocalUserSoothsayer
	end)
	local v12 = useSelector(getContactImporterParams)
	local v13 = if not FFlagContactImporterIXPCleanup then OffPlatformFriendRequestsIXP.useOffPlatformFriendRequestsEnabled() else nil
	local v14 = useUiModeInfo().uiMode ~= UiMode.TenFoot and v11
	local v15 = if not FFlagContactImporterIXPCleanup then v13 else nil
	local v16, v17

	if v14 then
		v16 = true
		v17 = true
	else
		v16 = if not FFlagContactImporterIXPCleanup then v15 and t1.policyIsEnabled else t1.policyIsEnabled
		v17 = v12.shouldShowContactImporterFeature
	end

	local v18 = v16 and v17
	local v19 = v18 and v12.shouldShowContactImporterUpsellModal

	return {
		shouldFetchContactImporterData = v16 or false,
		shouldShowContactImporter = v18 or false,
		shouldShowContactImporterModal = v19 or false
	}
end
