local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local BubbleChatSettingsChanged = require(Actions.BubbleChatSettingsChanged)
local BubbleChatChildSettingChanged = require(Actions.BubbleChatChildSettingChanged)
local BubbleChatChildRemoved = require(Actions.BubbleChatChildRemoved)

local DefaultSettings = require(script.Parent.DefaultSettings)

return Rodux.createReducer(DefaultSettings, {
	[ConfigurationObjectsLoaded.name] = function(p, p2)
		return dictionary.join(p, p2.bubbleChatSettings)
	end,
	[BubbleChatSettingsChanged.name] = function(p, p2)
		return dictionary.join(p, { [p2.property] = p2.value })
	end,
	[BubbleChatChildSettingChanged.name] = function(p, data)
		return dictionary.join(p, {
			[data.childName] = dictionary.join(p[data.childName], { [data.property] = data.value })
		})
	end,
	[BubbleChatChildRemoved.name] = function(p, p2)
		return dictionary.removeKey(p, p2.childName)
	end
})
