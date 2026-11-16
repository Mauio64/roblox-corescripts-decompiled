local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForIsLocalUserSoothsayer = SharedFlags.FFlagUseSignalsForIsLocalUserSoothsayer
local getIsLocalUserSoothsayerStore

if FFlagUseSignalsForIsLocalUserSoothsayer then
	local IsLocalUserSoothsayerStore = require(parent.IsLocalUserSoothsayerStore)
	getIsLocalUserSoothsayerStore = IsLocalUserSoothsayerStore.GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

return function()
	if FFlagUseSignalsForIsLocalUserSoothsayer then
		return useSignalState(getIsLocalUserSoothsayerStore(false).getIsLocalUserSoothsayer)
	end

	return useSelector(function(p)
		return p.IsLocalUserSoothsayer
	end)
end
