local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GameGetGameInfoStore = require(parent.DataHydration.GameGetGameInfoStore)

local useSignalState = SignalsReact.useSignalState
local computed = Signals.createComputed(function(): nil
	return nil
end)

local function useExperienceName(p: number?)
	local v

	if not (p == nil or p == 0) then
		v = tostring(p)
	end

	local v2

	if v == nil then
		v2 = computed
	else
		v2 = GameGetGameInfoStore(false).getAndFetchGameInfo(v).data
	end

	local v3 = useSignalState(v2)
	return if v3 ~= nil then v3.name else nil
end

return useExperienceName
