local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local FFlagGameInviteModalUnlockMouse = require(CorePackages.Workspace.Packages.SharedFlags).FFlagGameInviteModalUnlockMouse
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local renderCoreScriptGameInviteModalContainer = GameInvite.renderCoreScriptGameInviteModalContainer
local GameInviteModalManager = GameInvite.GameInviteModalManager

renderCoreScriptGameInviteModalContainer((require(CoreGui.RobloxGui.Modules.ApolloClient)))
GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(function(b1: boolean) -- line: 19
	-- upvalues: PlayerListManager (copy), FFlagGameInviteModalUnlockMouse (copy), UserInputService (copy), VRService (copy), MouseIconOverrideService (copy)
	if b1 then
		PlayerListManager:HideTemp("GameInviteMenu", true)

		if FFlagGameInviteModalUnlockMouse and UserInputService.MouseEnabled and not VRService.VREnabled then
			MouseIconOverrideService.push("GameInviteModal", Enum.OverrideMouseIconBehavior.ForceShow)

			return
		end
	else
		PlayerListManager:HideTemp("GameInviteMenu", false)

		if FFlagGameInviteModalUnlockMouse then
			MouseIconOverrideService.pop("GameInviteModal")
		end
	end
end)
