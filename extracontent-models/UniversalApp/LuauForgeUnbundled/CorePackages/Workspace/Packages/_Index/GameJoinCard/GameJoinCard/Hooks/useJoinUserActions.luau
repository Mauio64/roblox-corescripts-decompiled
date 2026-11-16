local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")

local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagJoinabilityCTARefactor

local profileCTAStore = DataHydration.Profile.ProfileCTAStore
local dataStatus = DataHydration.DataStatus
local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local computed = createComputed(function(): nil
	return nil
end)

local computed2 = createComputed(function()
	return dataStatus.NotReady
end)

local function useJoinUserActions(p2, p3, p4)
	local v5 = p3 == true
	local ref = React.useRef(nil)

	local v6 = React.useMemo(function()
		local getJoinUserActions = fFlagJoinabilityCTARefactor
			and p2 ~= ""
			and v5
			and profileCTAStore.get().getJoinUserActions

		if getJoinUserActions then
			return getJoinUserActions(p2, true)
		end

		return nil
	end, { p2, v5, p4 })

	if v6 then
		ref.current = { userId = p2, result = v6 }
	end

	local current = ref.current

	if v6 == nil and current and current.userId == p2 then
		v6 = current.result
	end

	local v8 = if v6 then v6.data else computed
	local v9 = useSignalState(v8)
	local v11 = if v6 then v6.status else computed2
	return v9, (useSignalState(v11))
end

return useJoinUserActions
