local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ClientSettingsLoaded = require(Actions.ClientSettingsLoaded)
local ClientSettingsChanged = require(Actions.ClientSettingsChanged)
local t1 = {
	preferredTransparency = 1
}

return Rodux.createReducer(t1, {
	[ClientSettingsLoaded.name] = function(p1, p2) -- line: 18
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, p2.value)
	end,
	[ClientSettingsChanged.name] = function(p3, p4) -- line: 22
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p3, {
			[p4.property] = p4.value
		})
	end
})
