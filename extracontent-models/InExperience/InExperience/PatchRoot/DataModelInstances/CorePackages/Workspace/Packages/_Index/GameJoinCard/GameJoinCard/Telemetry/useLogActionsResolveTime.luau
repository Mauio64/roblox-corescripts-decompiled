local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local DataHydration = require(parent.DataHydration)
local SharedFlags = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

local DataStatus = DataHydration.DataStatus
local GameJoinCardTelemetry = require(script.Parent.GameJoinCardTelemetry)

local function useLogActionsResolveTime(p: string?, flag: boolean, p2: string)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if FFlagJoinabilityCTARefactor and flag then
			if p == DataStatus.NotReady then
				if ref.current == nil or ref2.current then
					ref.current = tick()
					ref2.current = false
				end
			else
				if ref2.current or ref.current == nil or p ~= DataStatus.Ready and p ~= DataStatus.Failed then
					return
				end

				ref2.current = true
				GameJoinCardTelemetry.logActionsResolved((tick() - ref.current) * 1000, p, p2)
			end
		else
			ref.current = nil
			ref2.current = false
		end
	end, { p, flag, p2 })
end

return useLogActionsResolveTime
