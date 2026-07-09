local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local t1 = {
	_propertyEnabled = false,
	_coreGuiEnabled = true,
	_topBarVisibility = true,
	value = false
}

return Rodux.createReducer(t1, {
	[ChannelTabsConfigurationEnabled.name] = function(t2: {[any]: any}, p1) -- line: 29
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t2, {
			_propertyEnabled = p1.enabled,
			value = t2._topBarVisibility and (t2._coreGuiEnabled and p1.enabled)
		})
	end,
	[ChatTopBarButtonActivated.name] = function(t3: {[any]: any}, p2) -- line: 36
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t3, {
			_topBarVisibility = p2.isVisible,
			value = t3._propertyEnabled and (t3._coreGuiEnabled and p2.isVisible)
		})
	end,
	[SetCoreGuiEnabledChanged.name] = function(t4: {[any]: any}, p3) -- line: 43
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t4, {
			_coreGuiEnabled = p3.enabled,
			value = t4._propertyEnabled and (t4._topBarVisibility and p3.enabled)
		})
	end,
	[ClientAppLoaded.name] = function(t5: {[any]: any}, p4) -- line: 50
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t5, {
			_coreGuiEnabled = p4.isChatCoreGuiEnabled,
			value = t5._propertyEnabled and (t5._topBarVisibility and p4.isChatCoreGuiEnabled)
		})
	end
})
