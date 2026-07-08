local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local GameInviteModalManager = require(CorePackages.Workspace.Packages.GameInvite).GameInviteModalManager
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local Signal = AppCommonLib.Signal
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local v17 = Signal.new()
local v18 = MappedSignal.new(v17, function() -- line: 26
	-- upvalues: GameInviteModalManager (copy)
	return GameInviteModalManager:isGameModalOpen()
end)

GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(function() -- line: 29
	-- upvalues: v17 (copy)
	v17:fire()
end)

local function shouldShowInviteFriends() -- line: 33
	-- upvalues: RunService (copy), Players (copy)
	return not RunService:IsStudio() and (Players.LocalPlayer ~= nil and Players.LocalPlayer.UserId > 0)
end

return Service:register({
	id = "invite_friends",
	initialAvailability = if not (not RunService:IsStudio() and (Players.LocalPlayer ~= nil and Players.LocalPlayer.UserId > 0)) then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	label = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.InviteConnections" or "CoreScripts.InGameMenu.PageTitle.InviteFriends",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = InGameMenuIntegrationUtils.toggleInviteFriendsPage,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 49
		-- upvalues: v18 (copy)
		return v18:get()
	end or v18,
	components = {
		Icon = function() -- line: 53
			-- upvalues: CommonIcon (copy), v18 (copy)
			return CommonIcon("PersonArrowFromBottomRight", nil, v18)
		end
	}
})
