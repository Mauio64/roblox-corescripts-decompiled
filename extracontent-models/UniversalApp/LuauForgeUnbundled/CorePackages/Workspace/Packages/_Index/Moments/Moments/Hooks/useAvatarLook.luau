local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local MomentsGetOutfitLookStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetOutfitLookStore")
local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local v5 = {
	data = createComputed(function(): nil
		return nil
	end),
	status = createComputed(function(): string
		return "NotReady"
	end)
}

local function useAvatarLook(p2)
	local v6 = not (p2 == nil) and p2 > 0

	local v7 = if v6 then MomentsGetOutfitLookStore(false).getAndFetchLookByOutfit(p2) else v5

	local v8 = useSignalState(v7.data)
	local v9 = useSignalState(v7.status)

	local look = if v8 ~= nil then v8.look else nil

	local v10 = v6
		and v9 ~= "Failed"
		and (v9 ~= "Ready" or look ~= nil)
		and (look == nil and "Loading" or "Ready")
		or "Unavailable"

	if v10 ~= "Ready" then
		look = nil
	end

	return { status = v10, look = look }
end

return useAvatarLook
