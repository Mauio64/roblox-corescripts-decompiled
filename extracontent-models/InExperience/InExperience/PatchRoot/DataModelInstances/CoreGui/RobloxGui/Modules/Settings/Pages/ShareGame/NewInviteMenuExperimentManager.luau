local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local GetFStringInExperienceNotificationsLayer = require(Modules.Flags.GetFStringInExperienceNotificationsLayer)
local GetFFlagEnableNewInviteMenuIXP = require(Modules.Flags.GetFFlagEnableNewInviteMenuIXP)
local GetFFlagInviteListRerank = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagInviteListRerank
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 20
	-- upvalues: IXPServiceWrapper (copy), GetFFlagInviteListRerank (copy), t1 (copy)
	local t2 = {
		_styleEnabled = false,
		_customizationEnabled = false,
		_newSendEndpointEnabled = false,
		_ixpServiceWrapper = p1 or IXPServiceWrapper,
		_inviteListSortOrder = if not GetFFlagInviteListRerank() then nil else 0
	}

	setmetatable(t2, t1)

	return t2
end
function t1.getStyleEnabled(p2) -- line: 32
	return p2._styleEnabled
end
function t1.getCustomizationEnabled(p3) -- line: 36
	return p3._customizationEnabled
end
function t1.getNewSendEndpointEnabled(p4) -- line: 40
	return p4._newSendEndpointEnabled
end

if GetFFlagInviteListRerank() then
	function t1.getInviteListSortOrder(p5) -- line: 45
		return p5._inviteListSortOrder
	end
end

function t1.initialize(p6) -- line: 50
	-- upvalues: GetFFlagEnableNewInviteMenuIXP (copy), GetFStringInExperienceNotificationsLayer (copy), GetFFlagInviteListRerank (copy)
	if not GetFFlagEnableNewInviteMenuIXP() then
		return
	end

	task.spawn(function() -- line: 55
		-- upvalues: p6 (copy), GetFStringInExperienceNotificationsLayer (copy), GetFFlagInviteListRerank (copy)
		p6._ixpServiceWrapper:WaitForInitialization()

		local LayerData = p6._ixpServiceWrapper:GetLayerData(GetFStringInExperienceNotificationsLayer())

		if LayerData then
			p6._styleEnabled = LayerData.NewInviteMenuStyleEnabled or false
			p6._customizationEnabled = LayerData.NewInviteMenuCustomizationEnabled or false
			p6._newSendEndpointEnabled = LayerData.NewInviteMenuEndpointEnabled or false
			p6._inviteListSortOrder = if not GetFFlagInviteListRerank() then nil else LayerData.invite_list_sort_order or 0
		end
	end)
end

t1.default = t1.new()

return t1
