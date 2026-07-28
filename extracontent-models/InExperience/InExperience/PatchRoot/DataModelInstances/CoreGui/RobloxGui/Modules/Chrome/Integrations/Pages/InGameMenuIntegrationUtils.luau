local Chrome = script:FindFirstAncestor("Chrome")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GameInviteAnalyticsManager = require(CorePackages.Workspace.Packages.GameInvite).GameInviteAnalyticsManager
local GameInviteModalManager = require(CorePackages.Workspace.Packages.GameInvite).GameInviteModalManager
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal

return {
	createPageOpenSignal = function(s1: string) -- line: 17
		-- upvalues: Signal (copy), MappedSignal (copy), RobloxGui (copy)
		local u10 = false
		local v11 = Signal.new()
		local v12 = MappedSignal.new(v11, function() -- line: 20
			-- upvalues: u10 (ref)
			return u10
		end)

		task.defer(function() -- line: 24
			-- upvalues: RobloxGui (copy), s1 (copy), u10 (ref), v11 (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

			SettingsHub.CurrentPageSignal:connect(function(p1) -- line: 26
				-- upvalues: SettingsHub (copy), s1 (copy), u10 (ref), v11 (copy)
				local v20 = SettingsHub.Instance[s1]

				u10 = v20 ~= nil and p1 == v20.Page.Name
				v11:fire()
			end)
		end)

		return v12
	end,
	toggleIGMPage = function(s2: string, b1: boolean) -- line: 36
		-- upvalues: RobloxGui (copy)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		local v16 = SettingsHub.Instance[s2]

		if SettingsHub:GetVisibility() then
			if b1 then
				SettingsHub:SetVisibility(false)

				return
			end

			SettingsHub:SwitchToPage(v16, true)

			return
		end

		SettingsHub:SetVisibility(true, false, v16)
	end,
	toggleInviteFriendsPage = function() -- line: 51
		-- upvalues: GameInviteModalManager (copy), RobloxGui (copy), GameInviteAnalyticsManager (copy)
		if GameInviteModalManager:isGameModalOpen() then
			GameInviteModalManager:closeModal()

			return
		end

		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.SettingsHub)
		SettingsHub:InviteToGame()
	end
}
