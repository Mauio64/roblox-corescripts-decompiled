local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local DevTextBoxEnabledChanged = require(Actions.DevTextBoxEnabledChanged)
local t1 = {
	_propertyEnabled = true,
	_coreGuiEnabled = true,
	_devTextBoxEnabled = false,
	value = true
}

return Rodux.createReducer(t1, {
	[ChatInputBarConfigurationEnabled.name] = function(t2: {[any]: any}, p1) -- line: 28
		-- upvalues: Dictionary (copy)
		local v14 = t2._coreGuiEnabled and (not t2._devTextBoxEnabled and p1.enabled)

		return Dictionary.join(t2, {
			_propertyEnabled = p1.enabled,
			value = v14
		})
	end,
	[SetCoreGuiEnabledChanged.name] = function(t3: {[any]: any}, p2) -- line: 37
		-- upvalues: Dictionary (copy)
		local v17 = t3._propertyEnabled and (not t3._devTextBoxEnabled and p2.enabled)

		return Dictionary.join(t3, {
			_coreGuiEnabled = p2.enabled,
			value = v17
		})
	end,
	[DevTextBoxEnabledChanged.name] = function(t4: {[any]: any}, p3) -- line: 46
		-- upvalues: Dictionary (copy)
		local v20 = t4._coreGuiEnabled and p3.enabled

		return Dictionary.join(t4, {
			_devTextBoxEnabled = p3.enabled,
			value = v20
		})
	end,
	[ClientAppLoaded.name] = function(t5: {[any]: any}, p4) -- line: 55
		-- upvalues: Dictionary (copy)
		local v23 = (t5._propertyEnabled or t5._devTextBoxEnabled) and p4.isChatCoreGuiEnabled

		return Dictionary.join(t5, {
			_coreGuiEnabled = p4.isChatCoreGuiEnabled,
			value = v23
		})
	end
})
