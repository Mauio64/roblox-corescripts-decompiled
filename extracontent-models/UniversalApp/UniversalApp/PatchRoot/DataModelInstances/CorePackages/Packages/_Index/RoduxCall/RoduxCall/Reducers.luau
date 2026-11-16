local parent = script:FindFirstAncestor("RoduxCall").Parent
local Rodux = require(parent.Rodux)

local currentCall = require(script.currentCall)
local suggestedCallees = require(script.suggestedCallees)

return function(p)
	return Rodux.combineReducers({
		currentCall = currentCall(),
		suggestedCallees = suggestedCallees(p)
	})
end
