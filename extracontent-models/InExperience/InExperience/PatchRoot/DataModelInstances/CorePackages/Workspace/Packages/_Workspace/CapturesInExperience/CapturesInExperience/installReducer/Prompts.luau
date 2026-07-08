local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Rodux = require(ParentParentParent.Rodux)
local PromptDismissed = require(ParentParent.Actions.PromptDismissed)
local PromptTriggered = require(ParentParent.Actions.PromptTriggered)

require(ParentParent.Types)

return Rodux.createReducer({}, {
	[PromptDismissed.name] = function(t1: {[any]: any}, p1) -- line: 16
		-- upvalues: Cryo (copy)
		return Cryo.List.filter(t1, function(p2) -- line: 17
			-- upvalues: p1 (copy)
			return p2.PromptId ~= p1.promptId
		end)
	end,
	[PromptTriggered.name] = function(t2: {[any]: any}, p3) -- line: 22
		-- upvalues: Cryo (copy)
		local t3 = {
			PromptData = p3.promptData,
			PromptType = p3.promptType,
			PromptId = p3.promptId
		}

		return Cryo.List.join(t2, { t3 })
	end
})
