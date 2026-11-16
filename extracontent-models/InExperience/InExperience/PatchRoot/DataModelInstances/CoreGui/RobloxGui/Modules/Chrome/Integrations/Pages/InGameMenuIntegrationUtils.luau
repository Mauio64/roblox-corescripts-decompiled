local Chrome = script:FindFirstAncestor("Chrome")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager
local GameInvite2 = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModalManager = GameInvite2.GameInviteModalManager
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local InGameMenuIntegrationUtils = {}

function InGameMenuIntegrationUtils.createPageOpenSignal(p: string)
	local v = false
	local v2 = Signal.new()
	local pageOpenSignal = MappedSignal.new(v2, function()
		return v
	end)

	task.defer(function()
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		SettingsHub.CurrentPageSignal:connect(function(p2)
			local v3 = SettingsHub.Instance[p]
			v = v3 ~= nil and p2 == v3.Page.Name
			v2:fire()
		end)
	end)

	return pageOpenSignal
end

function InGameMenuIntegrationUtils.toggleIGMPage(p: string, flag: boolean)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	local v = SettingsHub.Instance[p]

	if not SettingsHub:GetVisibility() then
		SettingsHub:SetVisibility(true, false, v)
	elseif flag then
		SettingsHub:SetVisibility(false)
	else
		SettingsHub:SwitchToPage(v, true)
	end
end

function InGameMenuIntegrationUtils.toggleInviteFriendsPage()
	if GameInviteModalManager:isGameModalOpen() then
		GameInviteModalManager:closeModal()
		return
	end

	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.SettingsHub)
	SettingsHub:InviteToGame()
end

return InGameMenuIntegrationUtils
