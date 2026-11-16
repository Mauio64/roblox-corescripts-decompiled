local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local MomentsGetOutfitLookStore = require(parent.DataHydration.MomentsGetOutfitLookStore)
local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local v = {
	data = createComputed(function(): nil
		return nil
	end),
	status = createComputed(function(): string
		return "NotReady"
	end)
}

local function useAvatarLook(p: number?)
	local v2

	if p == nil then
		v2 = false
	else
		v2 = p > 0
	end

	local v3

	if v2 then
		v3 = MomentsGetOutfitLookStore(false).getAndFetchLookByOutfit(p)
	else
		v3 = v
	end

	local v4 = useSignalState(v3.data)
	local v5 = useSignalState(v3.status)
	local look

	if v4 ~= nil then
		look = v4.look
	end

	local status = v2
		and v5 ~= "Failed"
		and (v5 ~= "Ready" or look ~= nil)
		and (look == nil and "Loading" or "Ready")
		or "Unavailable"

	if status ~= "Ready" then
		look = nil
	end

	return { status = status, look = look }
end

return useAvatarLook
