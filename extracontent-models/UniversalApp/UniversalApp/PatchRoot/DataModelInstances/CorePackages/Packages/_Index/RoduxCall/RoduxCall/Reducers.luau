local Parent = script:FindFirstAncestor("RoduxCall").Parent
local Rodux = require(Parent.Rodux)
local currentCall = require(script.currentCall)
local suggestedCallees = require(script.suggestedCallees)

return function(p1) -- line: 8
	-- upvalues: Rodux (copy), currentCall (copy), suggestedCallees (copy)
	return Rodux.combineReducers({
		currentCall = currentCall(),
		suggestedCallees = suggestedCallees(p1)
	})
end
