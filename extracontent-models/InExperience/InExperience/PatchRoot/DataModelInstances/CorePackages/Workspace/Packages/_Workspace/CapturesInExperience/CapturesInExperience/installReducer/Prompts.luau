local parent = script.Parent.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Rodux = require(parent2.Rodux)

local PromptDismissed = require(parent.Actions.PromptDismissed)
local PromptTriggered = require(parent.Actions.PromptTriggered)
require(parent.Types)

return Rodux.createReducer({}, {
	[PromptDismissed.name] = function(p, p2)
		return Cryo.List.filter(p, function(p3): boolean
			return p3.PromptId ~= p2.promptId
		end)
	end,
	[PromptTriggered.name] = function(p, data)
		local v = {
			{ PromptData = data.promptData, PromptType = data.promptType, PromptId = data.promptId }
		}
		return Cryo.List.join(p, v)
	end
})
