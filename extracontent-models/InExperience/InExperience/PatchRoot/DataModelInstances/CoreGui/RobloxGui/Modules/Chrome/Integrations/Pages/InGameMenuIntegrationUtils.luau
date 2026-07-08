local Chrome = script:FindFirstAncestor("Chrome")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GameInviteAnalyticsManager = require(CorePackages.Workspace.Packages.GameInvite).GameInviteAnalyticsManager
local GameInviteModalManager = require(CorePackages.Workspace.Packages.GameInvite).GameInviteModalManager
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal

require(RobloxGui.Modules.Settings.EnumReactPage)

local ReactPageSignal = require(RobloxGui.Modules.Settings.ReactPageSignal)

return {
	createPageOpenSignal = function(s1: string) -- line: 21
		-- upvalues: Signal (copy), MappedSignal (copy), RobloxGui (copy)
		local u11 = false
		local v12 = Signal.new()
		local v13 = MappedSignal.new(v12, function() -- line: 24
			-- upvalues: u11 (ref)
			return u11
		end)

		task.defer(function() -- line: 28
			-- upvalues: RobloxGui (copy), s1 (copy), u11 (ref), v12 (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

			SettingsHub.CurrentPageSignal:connect(function(p1) -- line: 30
				-- upvalues: SettingsHub (copy), s1 (copy), u11 (ref), v12 (copy)
				local v27 = SettingsHub.Instance[s1]

				u11 = v27 ~= nil and p1 == v27.Page.Name
				v12:fire()
			end)
		end)

		return v13
	end,
	toggleIGMPage = function(s2: string, b1: boolean) -- line: 40
		-- upvalues: RobloxGui (copy)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		local v17 = SettingsHub.Instance[s2]

		if SettingsHub:GetVisibility() then
			if b1 then
				SettingsHub:SetVisibility(false)

				return
			end

			SettingsHub:SwitchToPage(v17, true)

			return
		end

		SettingsHub:SetVisibility(true, false, v17)
	end,
	toggleReactPage = function(s3: string, b2: boolean, p2) -- line: 54
		-- upvalues: RobloxGui (copy), ReactPageSignal (copy)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		local v22 = SettingsHub.Instance[s3]
		local v23 = ReactPageSignal()

		if SettingsHub:GetVisibility() then
			if b2 then
				SettingsHub:SetVisibility(false)
				v23.setCurrentReactPage(nil)

				return
			end

			SettingsHub:SwitchToPage(v22, true)
			v23.setCurrentReactPage(p2)

			return
		end

		SettingsHub:SetVisibility(true, false, v22)
		v23.setCurrentReactPage(p2)
	end,
	toggleInviteFriendsPage = function() -- line: 73
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
