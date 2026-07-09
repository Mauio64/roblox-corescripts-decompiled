local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local GameGetGameInfoStore = require(Parent.DataHydration.GameGetGameInfoStore)
local useSignalState = SignalsReact.useSignalState
local v6 = Signals.createComputed(function() -- line: 21
	return nil
end)

local function useExperienceName(n1: number?) -- line: 25
	-- upvalues: GameGetGameInfoStore (copy), v6 (copy), useSignalState (copy)
	local v9 = if n1 == nil or n1 == 0 then nil else tostring(n1)
	local v10 = if v9 == nil then v6 else GameGetGameInfoStore(false).getAndFetchGameInfo(v9).data
	local v11 = useSignalState(v10)

	if v11 ~= nil then
		return v11.name
	end

	return nil
end

return useExperienceName
