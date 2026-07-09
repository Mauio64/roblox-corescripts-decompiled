local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local Rodux = require(RoduxSquadsParent.Rodux)

require(RoduxSquads.RoduxSquadsTypes)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		payload = {
			channelId = p1
		}
	}
end)
