local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local GetFStringInExperienceNotificationsLayer = require(Modules.Flags.GetFStringInExperienceNotificationsLayer)

local GetFFlagEnableNewInviteMenuIXP = require(Modules.Flags.GetFFlagEnableNewInviteMenuIXP)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagInviteListRerank = SharedFlags.GetFFlagInviteListRerank

local NewInviteMenuExperimentManager = {}
NewInviteMenuExperimentManager.__index = NewInviteMenuExperimentManager

function NewInviteMenuExperimentManager.new(p)
	local v = {
		_ixpServiceWrapper = p or IXPServiceWrapper,
		_styleEnabled = false,
		_customizationEnabled = false,
		_newSendEndpointEnabled = false,
		_inviteListSortOrder = GetFFlagInviteListRerank() and 0 or nil
	}

	setmetatable(v, NewInviteMenuExperimentManager)
	return v
end

function NewInviteMenuExperimentManager:getStyleEnabled()
	return self._styleEnabled
end

function NewInviteMenuExperimentManager:getCustomizationEnabled()
	return self._customizationEnabled
end

function NewInviteMenuExperimentManager:getNewSendEndpointEnabled()
	return self._newSendEndpointEnabled
end

if GetFFlagInviteListRerank() then
	function NewInviteMenuExperimentManager:getInviteListSortOrder()
		return self._inviteListSortOrder
	end
end

function NewInviteMenuExperimentManager:initialize()
	if not GetFFlagEnableNewInviteMenuIXP() then
		return
	end

	task.spawn(function()
		self._ixpServiceWrapper:WaitForInitialization()
		local layerData = self._ixpServiceWrapper:GetLayerData(GetFStringInExperienceNotificationsLayer())

		if layerData then
			self._styleEnabled = layerData.NewInviteMenuStyleEnabled or false
			self._customizationEnabled = layerData.NewInviteMenuCustomizationEnabled or false
			self._newSendEndpointEnabled = layerData.NewInviteMenuEndpointEnabled or false
			self._inviteListSortOrder = GetFFlagInviteListRerank() and (layerData.invite_list_sort_order or 0) or nil
		end
	end)
end

NewInviteMenuExperimentManager.default = NewInviteMenuExperimentManager.new()
return NewInviteMenuExperimentManager
