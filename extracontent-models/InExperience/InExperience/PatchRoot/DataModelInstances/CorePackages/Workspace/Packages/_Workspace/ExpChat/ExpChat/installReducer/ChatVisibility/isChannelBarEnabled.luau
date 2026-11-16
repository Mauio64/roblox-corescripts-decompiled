local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)

local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded

return Rodux.createReducer(
	{ _propertyEnabled = false, _coreGuiEnabled = true, _topBarVisibility = true, value = false },
	{
		[ChannelTabsConfigurationEnabled.name] = function(p, p2)
			return dictionary.join(p, {
				_propertyEnabled = p2.enabled,
				value = p._topBarVisibility and p._coreGuiEnabled and p2.enabled
			})
		end,
		[ChatTopBarButtonActivated.name] = function(p, p2)
			return dictionary.join(p, {
				_topBarVisibility = p2.isVisible,
				value = p._propertyEnabled and p._coreGuiEnabled and p2.isVisible
			})
		end,
		[SetCoreGuiEnabledChanged.name] = function(p, p2)
			return dictionary.join(p, {
				_coreGuiEnabled = p2.enabled,
				value = p._propertyEnabled and p._topBarVisibility and p2.enabled
			})
		end,
		[ClientAppLoaded.name] = function(p, p2)
			return dictionary.join(p, {
				_coreGuiEnabled = p2.isChatCoreGuiEnabled,
				value = p._propertyEnabled and p._topBarVisibility and p2.isChatCoreGuiEnabled
			})
		end
	}
)
