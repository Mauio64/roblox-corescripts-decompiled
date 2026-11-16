local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModalManager = GameInvite.GameInviteModalManager

local FFlagGameInviteInExpJoinOrInviteLabel = require(CorePackages.Workspace.Packages.GameInvite.FFlagGameInviteInExpJoinOrInviteLabel)
local isPlatformInviteUIEnabled = require(CorePackages.Workspace.Packages.GameInvite.isPlatformInviteUIEnabled)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local Signal = AppCommonLib.Signal

local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)

local v = Signal.new()
local isActivated = MappedSignal.new(v, function()
	return GameInviteModalManager:isGameModalOpen()
end)

GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(function()
	v:fire()
end)

local function shouldShowInviteFriends() -- 1 equivalent call inferred from this helper
	local v2 = not RunService:IsStudio()

	if v2 then
		if Players.LocalPlayer == nil then
			return false
		end

		return Players.LocalPlayer.UserId > 0
	end

	return v2
end

local initialAvailability

if shouldShowInviteFriends() then -- inferred equivalent call
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

return Service:register({
	initialAvailability = initialAvailability,
	id = "invite_friends",
	label = FFlagGameInviteInExpJoinOrInviteLabel and not isPlatformInviteUIEnabled() and "CoreScripts.InGameMenu.PageTitle.JoinOrInvite" or "CoreScripts.InGameMenu.PageTitle.InviteFriends",
	sideSheetPlacement = SideSheetPlacement.AboveFold,
	activated = InGameMenuIntegrationUtils.toggleInviteFriendsPage,
	isActivated = isActivated,
	components = {
		Icon = function()
			return CommonIcon("PersonArrowFromBottomRight", nil, isActivated)
		end
	}
})
