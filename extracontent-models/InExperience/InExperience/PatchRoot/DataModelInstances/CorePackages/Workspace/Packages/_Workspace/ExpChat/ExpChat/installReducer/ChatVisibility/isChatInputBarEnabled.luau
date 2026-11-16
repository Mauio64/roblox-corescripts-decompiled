local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local DevTextBoxEnabledChanged = require(Actions.DevTextBoxEnabledChanged)

return Rodux.createReducer({
	_propertyEnabled = true,
	_coreGuiEnabled = true,
	_topBarVisibility = true,
	_devTextBoxEnabled = false,
	value = true
}, {
	[ChatInputBarConfigurationEnabled.name] = function(data, p)
		local enabled = data._topBarVisibility and data._coreGuiEnabled and not data._devTextBoxEnabled and p.enabled

		return dictionary.join(data, { _propertyEnabled = p.enabled, value = enabled })
	end,
	[ChatTopBarButtonActivated.name] = function(data, p)
		local isVisible = data._propertyEnabled and data._coreGuiEnabled and not data._devTextBoxEnabled and p.isVisible

		return dictionary.join(data, { _topBarVisibility = p.isVisible, value = isVisible })
	end,
	[SetCoreGuiEnabledChanged.name] = function(data, p)
		local enabled = data._propertyEnabled and data._topBarVisibility and not data._devTextBoxEnabled and p.enabled

		return dictionary.join(data, { _coreGuiEnabled = p.enabled, value = enabled })
	end,
	[DevTextBoxEnabledChanged.name] = function(data, p)
		return dictionary.join(data, {
			_devTextBoxEnabled = p.enabled,
			value = data._propertyEnabled and data._topBarVisibility and data._coreGuiEnabled and not p.enabled
		})
	end,
	[ClientAppLoaded.name] = function(data, p)
		local isChatCoreGuiEnabled = data._propertyEnabled
			and data._topBarVisibility
			and not data._devTextBoxEnabled
			and p.isChatCoreGuiEnabled

		return dictionary.join(data, {
			_coreGuiEnabled = p.isChatCoreGuiEnabled,
			value = isChatCoreGuiEnabled
		})
	end
})
