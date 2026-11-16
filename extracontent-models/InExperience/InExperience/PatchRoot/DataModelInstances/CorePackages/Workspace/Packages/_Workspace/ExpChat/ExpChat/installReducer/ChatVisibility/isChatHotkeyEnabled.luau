local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local DevTextBoxEnabledChanged = require(Actions.DevTextBoxEnabledChanged)

return Rodux.createReducer(
	{ _propertyEnabled = true, _coreGuiEnabled = true, _devTextBoxEnabled = false, value = true },
	{
		[ChatInputBarConfigurationEnabled.name] = function(p, p2)
			local enabled = p._coreGuiEnabled and not p._devTextBoxEnabled and p2.enabled

			return dictionary.join(p, { _propertyEnabled = p2.enabled, value = enabled })
		end,
		[SetCoreGuiEnabledChanged.name] = function(p, p2)
			local enabled = p._propertyEnabled and not p._devTextBoxEnabled and p2.enabled

			return dictionary.join(p, { _coreGuiEnabled = p2.enabled, value = enabled })
		end,
		[DevTextBoxEnabledChanged.name] = function(p, p2)
			local enabled = p._coreGuiEnabled and p2.enabled

			return dictionary.join(p, { _devTextBoxEnabled = p2.enabled, value = enabled })
		end,
		[ClientAppLoaded.name] = function(p, p2)
			local isChatCoreGuiEnabled = (p._propertyEnabled or p._devTextBoxEnabled) and p2.isChatCoreGuiEnabled

			return dictionary.join(p, {
				_coreGuiEnabled = p2.isChatCoreGuiEnabled,
				value = isChatCoreGuiEnabled
			})
		end
	}
)
