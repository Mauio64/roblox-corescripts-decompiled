local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagJoinabilityCTARefactor

local dataStatus = DataHydration.DataStatus
local GameJoinCardTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTelemetry")

local function useLogActionsResolveTime(p2, p3, p4)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if fFlagJoinabilityCTARefactor and p3 then
			if p2 == dataStatus.NotReady then
				if ref.current == nil or ref2.current then
					ref.current = tick()
					ref2.current = false
				end
			else
				if
					ref2.current
					or ref.current == nil
					or p2 ~= dataStatus.Ready and p2 ~= dataStatus.Failed
				then
					return
				end

				ref2.current = true
				GameJoinCardTelemetry.logActionsResolved((tick() - ref.current) * 1000, p2, p4)
			end
		else
			ref.current = nil
			ref2.current = false
		end
	end, { p2, p3, p4 })
end

return useLogActionsResolveTime
