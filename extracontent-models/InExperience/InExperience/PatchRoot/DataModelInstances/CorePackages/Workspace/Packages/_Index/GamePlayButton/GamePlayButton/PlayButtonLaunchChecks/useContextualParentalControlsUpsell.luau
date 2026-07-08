local GamePlayButton = script:FindFirstAncestor("GamePlayButton")

require(GamePlayButton.PlayButtonTypes)

local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)
local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local useDispatch = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useSelector
local useRoactService = require(GamePlayButtonParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(GamePlayButtonParent.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(GamePlayButtonParent.RoactServiceTags).AppEventIngestService
local flaggedMutedError = require(GamePlayButtonParent.Loggers).flaggedMutedError
local GameInfosReducer = require(GamePlayButtonParent.GameInfosRodux).GameInfosReducer
local FetchUserSettingsAndOptions = require(GamePlayButtonParent.GameDetailRodux).FetchUserSettingsAndOptions
local Dash = require(GamePlayButtonParent.Dash)
local AppPage = require(GamePlayButtonParent.RobloxAppEnums).AppPage
local NavigateDown = require(GamePlayButtonParent.NavigationRodux).Thunks.NavigateDown
local NavigateBack = require(GamePlayButtonParent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(GamePlayButtonParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(GamePlayButtonParent.RobloxAppNavigation).NavigationCommands
local OpenCloseOnlyInteractiveAlert = require(GamePlayButtonParent.DiscoveryRouting).OpenCloseOnlyInteractiveAlert
local OpenUpsellModal = require(GamePlayButtonParent.DiscoveryRouting).OpenUpsellModal
local OpenPlayButtonUpsellDialog = require(GamePlayButtonParent.DiscoveryRouting).OpenPlayButtonUpsellDialog
local CloseCentralOverlay = require(GamePlayButtonParent.CentralOverlay).Thunks.CloseCentralOverlay
local useLocalization = require(GamePlayButtonParent.Localization).Hooks.useLocalization
local useAppPolicy = require(GamePlayButtonParent.UniversalAppPolicy).useAppPolicy
local OpenAmpWizardContainer = require(GamePlayButtonParent.AmpUpsell).OpenAmpWizardContainer
local authButtonClick = require(GamePlayButtonParent.AuthAnalytics).Events.authButtonClick
local LoggingProtocol = require(GamePlayButtonParent.LoggingProtocol)
local PlayabilityStatusEnum = require(GamePlayButtonParent.DiscoveryTypes).PlayabilityStatusEnum
local unlockPlayIntent = require(GamePlayButtonParent.DiscoveryAnalytics).Events.unlockPlayIntent
local delayedAmpWizardCompletionCallbackOverride = require(GamePlayButton.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride)
local v31 = game:DefineFastInt("UnknownUpsellErrorEventHundredthsPercent", 0)
local v32 = game:DefineFastString("LuaAppUpsellMaturityRatingToSettingMapping", "mild=NinePlus,moderate=ThirteenPlus,restricted=SeventeenPlus,unrated=ThirteenPlus")
local FFlagLuaAppParentUpsellPolicy = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppParentUpsellPolicy
local FFlagLuaAppPlayButtonUpsellLinking = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonUpsellLinking
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonAmpAgeCheckFlow
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = require(GamePlayButtonParent.SharedFlags).FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = require(GamePlayButtonParent.SharedFlags).FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local FFlagLuaAppParentApprovedExperiences = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppParentApprovedExperiences
local GetFFlagEnableAmpWizardVPCNavigationFix = require(GamePlayButtonParent.AmpUpsell).GetFFlagEnableAmpWizardVPCNavigationFix
local FFlagLuaAppPlayButtonWizardCloseDelay = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonWizardCloseDelay
local FIntLuaAppPlayButtonWizardCloseDelayMs = require(GamePlayButtonParent.SharedFlags).FIntLuaAppPlayButtonWizardCloseDelayMs
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local _ = {
	SelfUpdateSetting = "SelfUpdateSetting",
	ParentalConsent = "ParentalConsent",
	ContentAgeRestrictionVerification = "ContentAgeRestrictionVerification"
}

local function parseContentMaturityMappingString(s1: string) -- line: 67
	if s1 == "" then
		return {}
	end

	local t1 = {}

	for _, v50 in (string.split(s1, ",")) do
		local parts = string.split(v50, "=")

		if #parts == 2 and parts[1] ~= "" and parts[2] ~= "" then
			t1[parts[1]] = parts[2]
		else
			error(`Invalid content maturity mapping string { s1 }`)
		end
	end

	return t1
end
local function safeParseContentMaturityMappingString(s2: string) -- line: 88
	-- upvalues: parseContentMaturityMappingString (copy), flaggedMutedError (copy)
	local ok, result = pcall(function() -- line: 89
		-- upvalues: parseContentMaturityMappingString (copy), s2 (copy)
		return (parseContentMaturityMappingString(s2))
	end)

	if not ok then
		flaggedMutedError("ExperienceParentalControlsUpsellContentMaturityMappingParsingError", `Error parsing content maturity mapping string { s2 }, error is: { result }`)

		return {}
	end

	return result
end

local v46 = safeParseContentMaturityMappingString(v32)

return function(s3: string, p1, s4: string?) -- line: 109
	-- upvalues: useRoactService (copy), RoactNetworking (copy), AppEventIngestService (copy), useDispatch (copy), useSelector (copy), GameInfosReducer (copy), useLocalization (copy), FFlagLuaAppParentApprovedExperiences (copy), React (copy), OpenAmpWizardContainer (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateDown (copy), FFlagLuaAppPlayButtonUpsellLinking (copy), OpenPlayButtonUpsellDialog (copy), OpenUpsellModal (copy), OpenCloseOnlyInteractiveAlert (copy), NavigateBack (copy), CloseCentralOverlay (copy), FetchGamePlayButtonData (copy), authButtonClick (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), unlockPlayIntent (copy), PlayabilityStatusEnum (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), FFlagLuaAppParentUpsellPolicy (copy), useAppPolicy (copy), FetchUserSettingsAndOptions (copy), flaggedMutedError (copy), v46 (copy), LoggingProtocol (copy), v31 (copy), Dash (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy)
	local v58 = useRoactService(RoactNetworking)
	local v59 = useRoactService(AppEventIngestService)
	local v60 = useDispatch()
	local v61 = useSelector(function(p2) -- line: 118
		-- upvalues: s3 (copy), GameInfosReducer (copy)
		local v78 = p2.AgeRecommendations[s3]

		if v78 and (v78.summary and v78.summary.ageRecommendation and v78.summary.ageRecommendation.contentMaturity) then
			return v78.summary.ageRecommendation.contentMaturity
		end

		local v79 = p2.Personalization[GameInfosReducer.key][s3]

		if v79 and v79.contentMaturity then
			return v79.contentMaturity
		end

		return nil
	end)
	local v62 = useLocalization({
		unplayableTitleText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Label.Title",
		unplayableBodyText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Label.Body",
		unplayableButtonText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Action.Ok",
		askYourParentTitleText = "Feature.ExperienceDetails.AskYourParentModal.Label.Title",
		askYourParentBodyText = "Feature.ExperienceDetails.AskYourParentModal.Label.Body",
		askYourParentActionButtonText = "Feature.ExperienceDetails.AskYourParentModal.Action.AskNow",
		askYourParentCancelButtonText = "Feature.ExperienceDetails.AskYourParentModal.Action.Cancel",
		consoleSelfUpdateSettingTitleText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Label.Title",
		consoleSelfUpdateSettingBodyText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Label.Body",
		consoleSelfUpdateSettingButtonText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Action.Ok",
		askYourParentToAllowGameBodyText = if not FFlagLuaAppParentApprovedExperiences then nil else "Feature.ExperienceDetails.AskYourParentToAllowGameModal.Label.Body"
	})
	local v63 = React.useCallback(function(p3, p4, p5, p6, p7, p8, p9) -- line: 157
		-- upvalues: v60 (copy), OpenAmpWizardContainer (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy)
		v60(OpenAmpWizardContainer(p3, p4, p5, p6, if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else p7, if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else p8, nil, nil, if not FFlagLuaAppPlayButtonWizardCloseDelay then nil else p9))
	end, { v60 })
	local v64 = React.useCallback(function(p10, p11, p12, p13) -- line: 184
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v60 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.AccountSettingsUpsell,
			extraProps = {
				featureName = p10,
				localizationStrings = p11,
				onCloseModal = p12,
				onCancelled = p13
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v18.down(v18.fromLegacyPage(t2), true)

			return
		end

		v60(NavigateDown(t2, true))
	end, { v60 })
	local v65 = React.useCallback(function(p14, p15, p16, p17, p18, p19, p20) -- line: 204
		-- upvalues: FFlagLuaAppPlayButtonUpsellLinking (copy), v60 (copy), OpenPlayButtonUpsellDialog (copy), OpenUpsellModal (copy)
		if FFlagLuaAppPlayButtonUpsellLinking then
			v60(OpenPlayButtonUpsellDialog(p14, p15, p16, p17, p18, p19, p20))

			return
		end

		v60(OpenUpsellModal(p14, p15, p16, p17, p18, p19, p20))
	end, { v60 })
	local v66 = React.useCallback(function(p21, p22, p23, p24, p25) -- line: 242
		-- upvalues: v60 (copy), OpenCloseOnlyInteractiveAlert (copy)
		v60(OpenCloseOnlyInteractiveAlert(p21, p22, p23, p24, p25))
	end, { v60 })
	local v67 = React.useCallback(function() -- line: 246
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v18 (copy), v60 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v18.back(true)

			return
		end

		v60(NavigateBack(true))
	end, { v60 })
	local v68 = React.useCallback(function() -- line: 254
		-- upvalues: v60 (copy), CloseCentralOverlay (copy)
		v60(CloseCentralOverlay())
	end, { v60 })
	local v69 = React.useCallback(function() -- line: 258
		-- upvalues: v60 (copy), FetchGamePlayButtonData (copy), v58 (copy), s3 (copy)
		v60(FetchGamePlayButtonData.Fetch(v58, s3, true))
	end, {
		v60,
		v58,
		s3
	})
	local v70 = React.useCallback(function() -- line: 262
		-- upvalues: v67 (copy), v69 (copy)
		v67()
		v69()
	end, {
		v67,
		v69
	})
	local v71 = React.useCallback(function() -- line: 269
		-- upvalues: v68 (copy), authButtonClick (copy), v69 (copy)
		v68()
		authButtonClick("gameJoinContentMaturityLock", "cancelAskParent")
		v69()
	end, {
		v68,
		v69
	})
	local v72 = React.useCallback(function(p26) -- line: 279
		-- upvalues: v68 (copy), authButtonClick (copy), FFlagLuaAppParentApprovedExperiences (copy), v63 (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), v69 (copy), v67 (copy), s3 (copy)
		v68()
		authButtonClick("gameJoinContentMaturityLock", "askParent")

		if FFlagLuaAppParentApprovedExperiences then
			v63("CanApproveExperience", if not GetFFlagEnableAmpWizardVPCNavigationFix() then v67 else v69, {
				experienceManagementAction = "Approve",
				universeId = s3
			}, "gameJoinContentMaturityLock", nil, nil, nil)

			return
		end

		v63("CanChangeSetting", if not GetFFlagEnableAmpWizardVPCNavigationFix() then v67 else v69, {
			contentAgeRestriction = p26
		}, "gameJoinContentMaturityLock", nil, nil, nil)
	end, {
		v63,
		if not GetFFlagEnableAmpWizardVPCNavigationFix() then nil else v69,
		if GetFFlagEnableAmpWizardVPCNavigationFix() then nil else v67,
		v68,
		if not FFlagLuaAppParentApprovedExperiences then nil else s3
	})
	local v73 = React.useCallback(function(s5: string, s6: string?) -- line: 321
		-- upvalues: unlockPlayIntent (copy), v59 (copy), s3 (copy), FFlagLuaAppParentApprovedExperiences (copy), PlayabilityStatusEnum (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s4 (copy)
		unlockPlayIntent(v59, {
			universeId = s3,
			upsellName = s5,
			playabilityStatus = if not FFlagLuaAppParentApprovedExperiences then PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls else s6 or PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls,
			pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s4
		})
	end, {
		v59,
		s3,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s4
	})
	local u74 = nil

	if FFlagLuaAppParentUpsellPolicy then
		u74 = useAppPolicy(function(p27) -- line: 334
			return p27.getShouldShowVpcPlayButtonUpsells()
		end)
	end

	local v75 = useAppPolicy(function(p28) -- line: 339
		return p28.getWebViewSupport()
	end)
	local v76 = nil

	if FFlagLuaAppParentApprovedExperiences then
		v76 = React.useCallback(function(p29) -- line: 345
			-- upvalues: FFlagLuaAppParentUpsellPolicy (copy), u74 (ref), p1 (copy), v73 (copy), PlayabilityStatusEnum (copy), v65 (copy), v62 (copy), v72 (copy), v71 (copy)
			if FFlagLuaAppParentUpsellPolicy and not u74 then
				p1(p29)
				v73("GameLaunch", PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)

				return
			end

			v65(v62.askYourParentTitleText, v62.askYourParentToAllowGameBodyText, v62.askYourParentActionButtonText, v62.askYourParentCancelButtonText, v72, v71, v71)
			v73("ParentApprovedExperience", PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
		end, {
			v65,
			v72,
			v71,
			v73,
			p1,
			u74,
			v62.askYourParentTitleText,
			v62.askYourParentToAllowGameBodyText,
			v62.askYourParentActionButtonText,
			v62.askYourParentCancelButtonText
		})
	end

	return React.useCallback(function(p30) -- line: 385
		-- upvalues: FFlagLuaAppParentUpsellPolicy (copy), u74 (ref), p1 (copy), v73 (copy), FetchUserSettingsAndOptions (copy), v58 (copy), v61 (copy), flaggedMutedError (copy), v46 (copy), LoggingProtocol (copy), v31 (copy), s3 (copy), Dash (copy), v75 (copy), v66 (copy), v62 (copy), v68 (copy), v64 (copy), v70 (copy), v65 (copy), v72 (copy), v71 (copy), v63 (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), v69 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s4 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy)
		if FFlagLuaAppParentUpsellPolicy and not u74 then
			p1(p30)
			v73("GameLaunch")

			return
		end

		FetchUserSettingsAndOptions(v58):andThen(function(p31) -- line: 394
			-- upvalues: v61 (copy), flaggedMutedError (copy), p1 (copy), p30 (copy), v73 (copy), v46 (copy), LoggingProtocol (copy), v31 (copy), s3 (copy), Dash (copy), v75 (copy), v66 (copy), v62 (copy), v68 (copy), v64 (copy), v70 (copy), v65 (copy), v72 (copy), v71 (copy), v63 (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), v69 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s4 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy)
			local contentAgeRestriction = p31.contentAgeRestriction

			if not contentAgeRestriction or not v61 then
				flaggedMutedError("ExperienceParentalControlsUpsellUnknownContentMaturityRating", `Unknown content maturity rating { v61 } or age restriction setting { contentAgeRestriction } for Contextual Parental Controls upsell on play button click`)
				p1(p30)
				v73("GameLaunch")

				return
			end

			assert(v61, "Content maturity rating must be present to show correct upsell")

			if not v46[v61] then
				LoggingProtocol.default:logRobloxTelemetryEvent({
					eventName = "ExperienceParentalControlsUpsellUnexpectedContentMaturityRating",
					description = "Unexpected content maturity rating for Contextual Parental Controls upsell on play button click",
					backends = { LoggingProtocol.TelemetryBackends.Points },
					throttlingPercentage = v31,
					lastUpdated = {
						25,
						8,
						26
					}
				}, { LoggingProtocol.default.StandardizedFields.addOsInfo }, {
					eventName = "ExperienceParentalControlsUpsellUnexpectedContentMaturityRating",
					contentMaturityRating = v61,
					universeId = s3
				})
				p1(p30)
				v73("GameLaunch")

				return
			end

			local v113 = v46[v61]
			local v114 = Dash.find(contentAgeRestriction.options, function(p32) -- line: 437
				-- upvalues: v113 (copy)
				return not not p32 and (not not p32.option and (p32.option.optionValue == v113 or false))
			end)

			if v114 then
				local requirement = v114.requirement

				if requirement == "SelfUpdateSetting" then
					if not v75 then
						v66(v62.consoleSelfUpdateSettingTitleText, v62.consoleSelfUpdateSettingBodyText, v68, v62.consoleSelfUpdateSettingButtonText, true)
					else
						v64("gameJoinContentMaturityLock", {
							title = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Title",
							message = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Body",
							buttonCancel = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.Cancel",
							buttonSettings = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.GoToSettings"
						}, v70, v70)
					end
				elseif requirement == "ParentalConsent" then
					v65(v62.askYourParentTitleText, v62.askYourParentBodyText, v62.askYourParentActionButtonText, v62.askYourParentCancelButtonText, function() -- line: 468
						-- upvalues: v72 (copy), v114 (copy)
						v72(v114.option.optionValue)
					end, v71, v71)
				elseif requirement == "ContentAgeRestrictionVerification" then
					v63(not FFlagLuaAppPlayButtonAmpAgeCheckFlow and "ShouldNotPromptSeventeenPlusSettingVerifications" or FStringLuaAppPlayButtonAgeCheckAmpFeatureName, v69, nil, if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else (not FFlagLuaAppLogPageContextUnlockPlayIntent or not s4) and "gameJoinContentMaturityLock" or `gameJoinContentMaturityLock-{ s4 }`, nil, if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else FStringLuaAppPlayButtonAgeCheckAmpNameSpace, if not FFlagLuaAppPlayButtonWizardCloseDelay then nil else delayedAmpWizardCompletionCallbackOverride(v69, FIntLuaAppPlayButtonWizardCloseDelayMs))
				else
					flaggedMutedError("ExperienceParentalControlsUnknownUpsellRequirement", `Unknown requirement { requirement } for ContentAgeRestriction option { v114 } on play button click`)
					p1(p30)
				end

				v73(requirement or "GameLaunch")

				return
			end

			v66(v62.unplayableTitleText, v62.unplayableBodyText, v68, v62.unplayableButtonText, true)
			v73("RestrictedUnplayableOptionNotFound")
		end, function() -- line: 522
			-- upvalues: p1 (copy), p30 (copy), v73 (copy)
			p1(p30)
			v73("GameLaunch")
		end)
	end, {
		v58,
		s3,
		p1,
		v61,
		v60,
		v64,
		v63,
		v66,
		v65,
		v72,
		v70,
		v71,
		v68,
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else v69,
		v73,
		v62.unplayableTitleText,
		v62.unplayableBodyText,
		v62.unplayableButtonText,
		v62.askYourParentTitleText,
		v62.askYourParentBodyText,
		v62.askYourParentActionButtonText,
		v62.askYourParentCancelButtonText,
		v62.consoleSelfUpdateSettingTitleText,
		v62.consoleSelfUpdateSettingBodyText,
		v62.consoleSelfUpdateSettingButtonText,
		u74,
		v75,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s4
	}), if not FFlagLuaAppParentApprovedExperiences then nil else v76
end
