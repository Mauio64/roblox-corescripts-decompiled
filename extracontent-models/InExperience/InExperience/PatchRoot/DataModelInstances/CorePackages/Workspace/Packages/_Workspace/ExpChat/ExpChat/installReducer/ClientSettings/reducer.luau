local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ClientSettingsLoaded = require(Actions.ClientSettingsLoaded)
local ClientSettingsChanged = require(Actions.ClientSettingsChanged)

return Rodux.createReducer({ preferredTransparency = 1 }, {
	[ClientSettingsLoaded.name] = function(p, p2)
		return dictionary.join(p, p2.value)
	end,
	[ClientSettingsChanged.name] = function(p, p2)
		return dictionary.join(p, { [p2.property] = p2.value })
	end
})
