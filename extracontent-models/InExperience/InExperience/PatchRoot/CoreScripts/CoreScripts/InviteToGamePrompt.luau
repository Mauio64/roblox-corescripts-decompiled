local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SocialService = game:GetService("SocialService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local modules = CoreGui:WaitForChild("RobloxGui").Modules
local settings = modules.Settings
local shareGame = settings.Pages.ShareGame

local GetFFlagFixSettingshubImportOrder = require(modules.Flags.GetFFlagFixSettingshubImportOrder)
local v

if GetFFlagFixSettingshubImportOrder() then
	v = nil
else
	v = require(settings.SettingsHub)
end

local GetFFlagEnableNewInviteMenuCustomization = require(modules.Flags.GetFFlagEnableNewInviteMenuCustomization)
local GetFFlagEnableInvitePromptLoadingState = require(modules.Flags.GetFFlagEnableInvitePromptLoadingState)

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local Diag = Analytics.AnalyticsReporters.Diag

local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics2.AnalyticsReporters.EventStream

local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteAnalytics = GameInvite.GameInviteAnalytics

local GameInvite2 = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModalManager = GameInvite2.GameInviteModalManager
local GetCustomizedInvitePromptTrigger = GameInvite2.GetCustomizedInvitePromptTrigger
local GameInviteConstants = GameInvite2.GameInviteConstants
local GameInviteAnalyticsManager = GameInvite2.GameInviteAnalyticsManager

local v2 = GameInviteAnalytics.new():withEventStream((EventStream.new(RbxAnalyticsService))):withDiag(Diag.new(RbxAnalyticsService)):withButtonName(GameInviteAnalytics.ButtonName.ModalPrompt)

local InviteToGamePrompt = require(shareGame.InviteToGamePrompt)
local v3 = InviteToGamePrompt.new(CoreGui):withSocialServiceAndLocalPlayer(SocialService, Players.LocalPlayer):withAnalytics(v2)

local ApiGetCanSendAndCanCustomizeInvites = require(shareGame.Thunks.ApiGetCanSendAndCanCustomizeInvites)
local getCustomizedInvitePromptParams = require(shareGame.getCustomizedInvitePromptParams)

local function canSendGameInviteAsync(p) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return SocialService:CanSendGameInviteAsync(p)
	end)

	return success and result
end

SocialService.PromptInviteRequested:Connect(function(p, p2)
	if p ~= Players.LocalPlayer then
		return
	end

	if GetFFlagFixSettingshubImportOrder() then
		local SettingsHub = require(settings.SettingsHub)
		v = SettingsHub
	end

	if v:GetVisibility() then
		if Players and Players.LocalPlayer then
			SocialService:InvokeGameInvitePromptClosed(Players.LocalPlayer, {})
		end
	else
		local v4 = p2 or nil

		local customizedInvitePromptTrigger = GetCustomizedInvitePromptTrigger(v4)

		if customizedInvitePromptTrigger == GameInviteConstants.Triggers.DeveloperMultiple then
			GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.ModalPrompt)
			GameInviteAnalyticsManager:inputShareGameEntryPoint()

			GameInviteModalManager:openModal({ trigger = customizedInvitePromptTrigger }, v4)
		elseif GetFFlagEnableNewInviteMenuCustomization() then
			local fFlagEnableInvitePromptLoadingState = GetFFlagEnableInvitePromptLoadingState()

			if fFlagEnableInvitePromptLoadingState then
				v3:show({ isLoading = true })
			end

			local customizedInvitePromptParams = getCustomizedInvitePromptParams(
				v4,
				ApiGetCanSendAndCanCustomizeInvites
			)

			if customizedInvitePromptParams then
				v3:show(customizedInvitePromptParams)
			elseif fFlagEnableInvitePromptLoadingState then
				v3:hide()
			end
		elseif canSendGameInviteAsync(p) then -- inferred equivalent call
			v3:show()
		end
	end
end)
