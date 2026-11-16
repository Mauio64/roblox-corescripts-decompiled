local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagGameInviteModalUnlockMouse = SharedFlags.FFlagGameInviteModalUnlockMouse
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local renderCoreScriptGameInviteModalContainer = GameInvite.renderCoreScriptGameInviteModalContainer
local GameInviteModalManager = GameInvite.GameInviteModalManager
local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)

renderCoreScriptGameInviteModalContainer(ApolloClient)
GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(function(flag: boolean)
	if flag then
		PlayerListManager:HideTemp("GameInviteMenu", true)

		if FFlagGameInviteModalUnlockMouse and UserInputService.MouseEnabled and not VRService.VREnabled then
			MouseIconOverrideService.push("GameInviteModal", Enum.OverrideMouseIconBehavior.ForceShow)
		end
	else
		PlayerListManager:HideTemp("GameInviteMenu", false)

		if FFlagGameInviteModalUnlockMouse then
			MouseIconOverrideService.pop("GameInviteModal")
		end
	end
end)
