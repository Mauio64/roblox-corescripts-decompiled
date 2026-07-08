local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local DevTextBoxEnabledChanged = require(Actions.DevTextBoxEnabledChanged)
local t1 = {
	_propertyEnabled = true,
	_coreGuiEnabled = true,
	_topBarVisibility = true,
	_devTextBoxEnabled = false,
	value = true
}

return Rodux.createReducer(t1, {
	[ChatInputBarConfigurationEnabled.name] = function(t2: {[any]: any}, p1) -- line: 31
		-- upvalues: Dictionary (copy)
		local v15 = t2._topBarVisibility and (t2._coreGuiEnabled and (not t2._devTextBoxEnabled and p1.enabled))

		return Dictionary.join(t2, {
			_propertyEnabled = p1.enabled,
			value = v15
		})
	end,
	[ChatTopBarButtonActivated.name] = function(t3: {[any]: any}, p2) -- line: 43
		-- upvalues: Dictionary (copy)
		local v18 = t3._propertyEnabled and (t3._coreGuiEnabled and (not t3._devTextBoxEnabled and p2.isVisible))

		return Dictionary.join(t3, {
			_topBarVisibility = p2.isVisible,
			value = v18
		})
	end,
	[SetCoreGuiEnabledChanged.name] = function(t4: {[any]: any}, p3) -- line: 55
		-- upvalues: Dictionary (copy)
		local v21 = t4._propertyEnabled and (t4._topBarVisibility and (not t4._devTextBoxEnabled and p3.enabled))

		return Dictionary.join(t4, {
			_coreGuiEnabled = p3.enabled,
			value = v21
		})
	end,
	[DevTextBoxEnabledChanged.name] = function(t5: {[any]: any}, p4) -- line: 67
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t5, {
			_devTextBoxEnabled = p4.enabled,
			value = t5._propertyEnabled and (t5._topBarVisibility and (t5._coreGuiEnabled and not p4.enabled))
		})
	end,
	[ClientAppLoaded.name] = function(t6: {[any]: any}, p5) -- line: 74
		-- upvalues: Dictionary (copy)
		local v26 = t6._propertyEnabled and (t6._topBarVisibility and (not t6._devTextBoxEnabled and p5.isChatCoreGuiEnabled))

		return Dictionary.join(t6, {
			_coreGuiEnabled = p5.isChatCoreGuiEnabled,
			value = v26
		})
	end
})
