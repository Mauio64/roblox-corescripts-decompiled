local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SocialService = game:GetService("SocialService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Modules = CoreGui:WaitForChild("RobloxGui").Modules
local Settings = Modules.Settings
local ShareGame = Settings.Pages.ShareGame
local GetFFlagFixSettingshubImportOrder = require(Modules.Flags.GetFFlagFixSettingshubImportOrder)
local SettingsHub = nil

if not GetFFlagFixSettingshubImportOrder() then
	SettingsHub = require(Settings.SettingsHub)
end

local GetFFlagEnableNewInviteMenuCustomization = require(Modules.Flags.GetFFlagEnableNewInviteMenuCustomization)
local GetFFlagEnableInvitePromptLoadingState = require(Modules.Flags.GetFFlagEnableInvitePromptLoadingState)
local GetFFlagLuaInExperienceCoreScriptsGameInviteUnification = require(Modules.Flags.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification)
local v14 = game:DefineFastFlag("LuaEnableGameInviteModalInvitePromptV2", false)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local Diag = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.Diag
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local GameInviteAnalytics = require(CorePackages.Workspace.Packages.GameInvite).GameInviteAnalytics
local GetFStringGameInviteMenuLayer = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringGameInviteMenuLayer
local GameInviteModalManager = nil
local GameInviteInviteExperimentVariant = nil
local GetCustomizedInvitePromptTrigger = nil
local GameInviteConstants = nil
local GameInviteAnalyticsManager = nil

if GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() then
	local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)

	GameInviteModalManager = GameInvite.GameInviteModalManager
	GameInviteInviteExperimentVariant = GameInvite.GameInviteInviteExperimentVariant
	GetCustomizedInvitePromptTrigger = GameInvite.GetCustomizedInvitePromptTrigger
	GameInviteConstants = GameInvite.GameInviteConstants
	GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager
end

local v26 = GameInviteAnalytics.new():withEventStream((EventStream.new(RbxAnalyticsService))):withDiag(Diag.new(RbxAnalyticsService)):withButtonName(GameInviteAnalytics.ButtonName.ModalPrompt)
local v27 = require(ShareGame.InviteToGamePrompt).new(CoreGui):withSocialServiceAndLocalPlayer(SocialService, Players.LocalPlayer):withAnalytics(v26)
local ApiGetCanSendAndCanCustomizeInvites = require(ShareGame.Thunks.ApiGetCanSendAndCanCustomizeInvites)
local getCustomizedInvitePromptParams = require(ShareGame.getCustomizedInvitePromptParams)

local function canSendGameInviteAsync(p1) -- line: 57
	-- upvalues: SocialService (copy)
	local ok, result = pcall(function() -- line: 58
		-- upvalues: SocialService (copy), p1 (copy)
		return SocialService:CanSendGameInviteAsync(p1)
	end)

	return ok and result
end

SocialService.PromptInviteRequested:Connect(function(p2, p3) -- line: 64
	-- upvalues: GetFStringGameInviteMenuLayer (copy), GetFFlagLuaInExperienceCoreScriptsGameInviteUnification (copy), v14 (copy), IXPServiceWrapper (copy), GameInviteInviteExperimentVariant (ref), Players (copy), GetFFlagFixSettingshubImportOrder (copy), SettingsHub (ref), Settings (copy), SocialService (copy), GameInviteModalManager (ref), GetCustomizedInvitePromptTrigger (ref), GameInviteConstants (ref), GameInviteAnalyticsManager (ref), GetFFlagEnableNewInviteMenuCustomization (copy), GetFFlagEnableInvitePromptLoadingState (copy), v27 (copy), getCustomizedInvitePromptParams (copy), ApiGetCanSendAndCanCustomizeInvites (copy)
	local v36 = false
	local v37 = GetFStringGameInviteMenuLayer()

	if GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() and v14 then
		local LayerData = IXPServiceWrapper:GetLayerData(v37)

		IXPServiceWrapper:LogUserLayerExposure(v37)
		v36 = (LayerData and (LayerData.inExperienceGameInviteUXRefresh2023 == GameInviteInviteExperimentVariant.UxRefresh or LayerData.inExperienceGameInviteUXRefresh2023 == GameInviteInviteExperimentVariant.InviteLimit)) == true
	end

	if v36 then
		if p2 ~= Players.LocalPlayer then
			return
		end

		if GetFFlagFixSettingshubImportOrder() then
			SettingsHub = require(Settings.SettingsHub)
		end

		if SettingsHub:GetVisibility() then
			if Players and Players.LocalPlayer then
				SocialService:InvokeGameInvitePromptClosed(Players.LocalPlayer, {})
			end

			return
		end

		local v39 = p3 or nil

		if GameInviteModalManager then
			local v40 = GetCustomizedInvitePromptTrigger(v39)

			if v40 == GameInviteConstants.Triggers.DeveloperMultiple then
				GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.ModalPrompt)
				GameInviteAnalyticsManager:inputShareGameEntryPoint()
				GameInviteModalManager:openModal({
					trigger = v40
				}, v39)

				return
			end
		end
	end

	if GetFFlagEnableNewInviteMenuCustomization() then
		if p2 ~= Players.LocalPlayer then
			return
		end

		local v41 = GetFFlagEnableInvitePromptLoadingState()

		if v41 then
			v27:show({
				isLoading = true
			})
		end

		local v42 = p3 or nil
		local v43 = getCustomizedInvitePromptParams(v42, ApiGetCanSendAndCanCustomizeInvites)

		if v43 then
			v27:show(v43)

			return
		end

		if v41 then
			v27:hide()

			return
		end

		return
	end

	if p2 == Players.LocalPlayer then
		local ok, result = pcall(function() -- line: 58
			-- upvalues: SocialService (copy), p2 (copy)
			return SocialService:CanSendGameInviteAsync(p2)
		end)

		if ok and result then
			v27:show()

			return
		end
	end
end)
