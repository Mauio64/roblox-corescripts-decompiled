local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local useSelector = dependencies.useSelector
local SignalsReact = require(parent2.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getContactImporterParams = require(script.Parent.getContactImporterParams)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local SharedFlags = require(parent2.SharedFlags)
local FFlagUseSignalsForIsLocalUserSoothsayer = SharedFlags.FFlagUseSignalsForIsLocalUserSoothsayer
local getIsLocalUserSoothsayerStore

if FFlagUseSignalsForIsLocalUserSoothsayer then
	local IsLocalUserSoothsayerStore = require(parent2.IsLocalUserSoothsayerStore)
	getIsLocalUserSoothsayerStore = IsLocalUserSoothsayerStore.GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

return function(p)
	local v

	if FFlagUseSignalsForIsLocalUserSoothsayer then
		v = useSignalState(getIsLocalUserSoothsayerStore(false).getIsLocalUserSoothsayer)
	else
		v = useSelector(function(p2)
			return p2.IsLocalUserSoothsayer
		end)
	end

	local v2 = useSelector(getContactImporterParams)
	local v3, v4

	if useUiModeInfo().uiMode ~= UiMode.TenFoot and v then
		v3 = true
		v4 = true
	else
		v3 = p.policyIsEnabled
		v4 = v2.shouldShowContactImporterFeature
	end

	local v5 = v3 and v4
	local shouldShowContactImporterUpsellModal = v5 and v2.shouldShowContactImporterUpsellModal

	return {
		shouldFetchContactImporterData = v3 or false,
		shouldShowContactImporter = v5 or false,
		shouldShowContactImporterModal = shouldShowContactImporterUpsellModal or false
	}
end
