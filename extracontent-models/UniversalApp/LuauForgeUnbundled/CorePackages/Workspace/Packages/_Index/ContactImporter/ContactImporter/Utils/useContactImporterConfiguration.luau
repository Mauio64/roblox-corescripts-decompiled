local useSelector = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SignalsReact").useSignalState
local getContactImporterParams = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/getContactImporterParams")
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppEnums").UiMode
local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local getIsLocalUserSoothsayerStore

if fFlagUseSignalsForIsLocalUserSoothsayer then
	getIsLocalUserSoothsayerStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/IsLocalUserSoothsayerStore").GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

return function(p2)
	local v5

	if fFlagUseSignalsForIsLocalUserSoothsayer then
		v5 = useSignalState(getIsLocalUserSoothsayerStore(false).getIsLocalUserSoothsayer)
	else
		v5 = useSelector(function(p3)
			return p3.IsLocalUserSoothsayer
		end)
	end

	local v6 = useSelector(getContactImporterParams)
	local v7, v8

	if useUiModeInfo().uiMode ~= uiMode.TenFoot and v5 then
		v7 = true
		v8 = true
	else
		v7 = p2.policyIsEnabled
		v8 = v6.shouldShowContactImporterFeature
	end

	local v9 = v7 and v8
	local shouldShowContactImporterUpsellModal = v9 and v6.shouldShowContactImporterUpsellModal

	return {
		shouldFetchContactImporterData = v7 or false,
		shouldShowContactImporter = v9 or false,
		shouldShowContactImporterModal = shouldShowContactImporterUpsellModal or false
	}
end
