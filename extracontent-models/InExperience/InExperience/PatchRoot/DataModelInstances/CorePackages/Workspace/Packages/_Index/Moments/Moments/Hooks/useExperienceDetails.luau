local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local GameGetGameInfoStore = require(Parent.DataHydration.GameGetGameInfoStore)
local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed
local t1 = {
	name = nil,
	creatorName = nil,
	isCreatorVerified = false
}
local v8 = createComputed(function() -- line: 32
	return nil
end)

return function(n1: number?) -- line: 36
	-- upvalues: GameGetGameInfoStore (copy), v8 (copy), useSignalState (copy), t1 (copy)
	local v10 = if not n1 or n1 == 0 then nil else tostring(n1)
	local v11 = if not v10 then v8 else GameGetGameInfoStore(false).getAndFetchGameInfo(v10).data
	local v12 = useSignalState(v11)

	if v12 == nil then
		return t1
	end

	local creator = v12.creator

	return {
		name = v12.name,
		creatorName = if not creator then nil else creator.name,
		isCreatorVerified = not not creator and creator.hasVerifiedBadge == true
	}
end
