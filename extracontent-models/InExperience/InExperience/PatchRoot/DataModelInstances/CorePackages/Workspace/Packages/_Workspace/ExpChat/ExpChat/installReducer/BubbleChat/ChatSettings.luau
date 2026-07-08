local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local BubbleChatSettingsChanged = require(Actions.BubbleChatSettingsChanged)
local BubbleChatChildSettingChanged = require(Actions.BubbleChatChildSettingChanged)
local BubbleChatChildRemoved = require(Actions.BubbleChatChildRemoved)
local DefaultSettings = require(script.Parent.DefaultSettings)

return Rodux.createReducer(DefaultSettings, {
	[ConfigurationObjectsLoaded.name] = function(p1, p2) -- line: 16
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, p2.bubbleChatSettings)
	end,
	[BubbleChatSettingsChanged.name] = function(p3, p4) -- line: 20
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p3, {
			[p4.property] = p4.value
		})
	end,
	[BubbleChatChildSettingChanged.name] = function(p5, p6) -- line: 26
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p5, {
			[p6.childName] = Dictionary.join(p5[p6.childName], {
				[p6.property] = p6.value
			})
		})
	end,
	[BubbleChatChildRemoved.name] = function(p7, p8) -- line: 34
		-- upvalues: Dictionary (copy)
		return Dictionary.removeKey(p7, p8.childName)
	end
})
