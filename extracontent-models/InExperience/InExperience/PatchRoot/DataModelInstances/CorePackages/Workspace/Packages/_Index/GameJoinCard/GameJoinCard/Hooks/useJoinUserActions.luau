local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local SharedFlags = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

local ProfileCTAStore = DataHydration.Profile.ProfileCTAStore
local DataStatus = DataHydration.DataStatus
local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local computed = createComputed(function(): nil
	return nil
end)

local computed2 = createComputed(function()
	return DataStatus.NotReady
end)

local function useJoinUserActions(userId: string, flag: boolean?, p)
	local v = flag == true
	local ref = React.useRef(nil)

	local v2 = React.useMemo(function()
		local getJoinUserActions = FFlagJoinabilityCTARefactor
			and userId ~= ""
			and v
			and ProfileCTAStore.get().getJoinUserActions

		if getJoinUserActions then
			return getJoinUserActions(userId, true)
		end

		return nil
	end, { userId, v, p })

	if v2 then
		ref.current = { userId = userId, result = v2 }
	end

	local current = ref.current

	if v2 == nil and current and current.userId == userId then
		v2 = current.result
	end

	local v3 = if v2 then v2.data else computed
	local v4 = useSignalState(v3)
	local v5 = if v2 then v2.status else computed2
	return v4, (useSignalState(v5))
end

return useJoinUserActions
