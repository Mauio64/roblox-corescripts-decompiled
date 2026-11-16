require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")
local FetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/FetchGamePlayButtonData")
local PlayButtonUpsellBody = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonUpsellBody")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useSelector
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppEventIngestService
local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Loggers").flaggedMutedError
local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameInfosRodux").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameHydrationReact")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagMigrateGameInfoToStore
local fetchUserSettingsAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").FetchUserSettingsAndOptions
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Dash")
local appPage = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").Thunks.NavigateDown
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppNavigation").NavigationCommands else nil

local openCloseOnlyInteractiveAlert = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryRouting").OpenCloseOnlyInteractiveAlert
local openPlayButtonUpsellDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryRouting").OpenPlayButtonUpsellDialog
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay").Thunks.CloseCentralOverlay
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").useAppPolicy
local openAmpWizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell").OpenAmpWizardContainer
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell")
local authButtonClick = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AuthAnalytics").Events.authButtonClick
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/LoggingProtocol")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum
local unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.unlockPlayIntent

local delayedAmpWizardCompletionCallbackOverride = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/delayedAmpWizardCompletionCallbackOverride")

local defineFastInt = game:DefineFastInt("UnknownUpsellErrorEventHundredthsPercent", 0)
local defineFastString = game:DefineFastString(
	"LuaAppUpsellMaturityRatingToSettingMapping",
	"mild=NinePlus,moderate=ThirteenPlus,restricted=SeventeenPlus,unrated=ThirteenPlus"
)

local fFlagLuaAppParentUpsellPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppParentUpsellPolicy
local fFlagLuaAppPlayButtonAmpAgeCheckFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonAmpAgeCheckFlow

local fStringLuaAppPlayButtonAgeCheckAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local fStringLuaAppPlayButtonAgeCheckAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local fFlagLuaAppVpcUpsellNamespace = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppVpcUpsellNamespace

local fStringLuaAppVpcSettingsChangeAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppVpcSettingsChangeAmpNameSpace

local fStringLuaAppVpcAccountManagementAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppVpcAccountManagementAmpNameSpace
local fFlagLuaAppParentApprovedExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppParentApprovedExperiences
local getFFlagEnableAmpWizardVPCNavigationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell").GetFFlagEnableAmpWizardVPCNavigationFix
local FFlagEnablePlayButtonWizardVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags/FFlagEnablePlayButtonWizardVPCPrologue")
local FFlagLuaAppPlayButtonOdpEventUniverseId = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags/FFlagLuaAppPlayButtonOdpEventUniverseId")
local fFlagLuaAppPlayButtonWizardCloseDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonWizardCloseDelay
local fIntLuaAppPlayButtonWizardCloseDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FIntLuaAppPlayButtonWizardCloseDelayMs

local v5 = {
	SelfUpdateSetting = "SelfUpdateSetting",
	ParentalConsent = "ParentalConsent",
	ContentAgeRestrictionVerification = "ContentAgeRestrictionVerification"
}

local function parseContentMaturityMappingString(value)
	if value == "" then
		return {}
	end

	local v6 = string.split(value, ",")
	local result = {}

	for k, v7 in v6 do
		local v8 = string.split(v7, "=")

		if #v8 == 2 and v8[1] ~= "" and v8[2] ~= "" then
			result[v8[1]] = v8[2]
		else
			error(`Invalid content maturity mapping string {value}`)
		end
	end

	return result
end

local function safeParseContentMaturityMappingString(defineFastString2)
	local success, result = pcall(function()
		return parseContentMaturityMappingString(defineFastString2)
	end)

	if success then
		return result
	end

	flaggedMutedError(
		"ExperienceParentalControlsUpsellContentMaturityMappingParsingError",
		`Error parsing content maturity mapping string {defineFastString2}, error is: {result}`
	)

	return {}
end

local v6 = safeParseContentMaturityMappingString(defineFastString)

return function(p2, callback, pageName)
	local v7 = useRoactService(roactNetworking)
	local v8 = useRoactService(appEventIngestService)
	local v9 = useDispatch()

	local v10 = useSelector(function(p3)
		local ageRecommendation = p3.AgeRecommendations[p2]

		if
			ageRecommendation
			and ageRecommendation.summary
			and ageRecommendation.summary.ageRecommendation
			and ageRecommendation.summary.ageRecommendation.contentMaturity
		then
			return ageRecommendation.summary.ageRecommendation.contentMaturity
		end

		if fFlagMigrateGameInfoToStore then
			return nil
		end

		local v11 = p3.Personalization[gameInfosReducer.key][p2]

		if v11 and v11.contentMaturity then
			return v11.contentMaturity
		end

		return nil
	end)
	local contentMaturity

	if fFlagMigrateGameInfoToStore then
		local v11 = GameHydrationReact.useGameInfo(p2)
		contentMaturity = v11 and v11.contentMaturity
	end

	if fFlagMigrateGameInfoToStore then
		v10 = v10 or contentMaturity
	end

	local v11 = useLocalization({
		unplayableTitleText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Label.Title",
		unplayableBodyText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Label.Body",
		unplayableButtonText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Action.Ok",
		askYourParentTitleText = "Feature.ExperienceDetails.AskYourParentModal.Label.Title",
		askYourParentBodyText = "Feature.ExperienceDetails.AskYourParentModal.Label.Body",
		askYourParentToAllowGameBodyText = fFlagLuaAppParentApprovedExperiences and "Feature.ExperienceDetails.AskYourParentToAllowGameModal.Label.Body" or nil,
		askYourParentActionButtonText = "Feature.ExperienceDetails.AskYourParentModal.Action.AskNow",
		askYourParentCancelButtonText = "Feature.ExperienceDetails.AskYourParentModal.Action.Cancel",
		consoleSelfUpdateSettingTitleText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Label.Title",
		consoleSelfUpdateSettingBodyText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Label.Body",
		consoleSelfUpdateSettingButtonText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Action.Ok"
	})

	local v12 = React.useCallback(function(p3, p4, p5, p6, p7, p8, p9, p10)
		if not fFlagLuaAppPlayButtonAmpAgeCheckFlow then
			p7 = nil
		end

		if not (fFlagLuaAppPlayButtonAmpAgeCheckFlow or fFlagLuaAppVpcUpsellNamespace) then
			p8 = nil
		end

		if not fFlagLuaAppPlayButtonWizardCloseDelay then
			p9 = nil
		end

		local v17 = FFlagEnablePlayButtonWizardVPCPrologue and p10 and true or nil

		if not FFlagEnablePlayButtonWizardVPCPrologue then
			p10 = nil
		end

		v9(openAmpWizardContainer(p3, p4, p5, p6, p7, p8, nil, nil, p9, v17, p10))
	end, { v9 })

	local v13 = React.useCallback(function(p3, p4, onCloseModal, onCancelled)
		local v14 = {
			name = appPage.AccountSettingsUpsell,
			extraProps = {
				featureName = p3,
				localizationStrings = p4,
				onCloseModal = onCloseModal,
				onCancelled = onCancelled
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14), true)
		else
			v9(navigateDown(v14, true))
		end
	end, { v9 })

	local v14 = React.useCallback(function(p3, p4, p5, p6, p7, p8, p9)
		v9(openPlayButtonUpsellDialog(p3, p4, p5, p6, p7, p8, p9))
	end, { v9 })

	local v15 = React.useCallback(function(p3, p4, p5, p6, p7)
		v9(openCloseOnlyInteractiveAlert(p3, p4, p5, p6, p7))
	end, { v9 })

	local v16 = React.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v9(navigateBack(true))
		end
	end, { v9 })

	local v17 = React.useCallback(function()
		v9(closeCentralOverlay())
	end, { v9 })

	local v18 = React.useCallback(function()
		v9(FetchGamePlayButtonData.Fetch(v7, p2, true))
	end, { v9, v7, p2 })

	local v19 = React.useCallback(function()
		v16()

		v18()
	end, { v16, v18 })

	local v20 = React.useCallback(function()
		v17()

		authButtonClick("gameJoinContentMaturityLock", "cancelAskParent")

		v18()
	end, { v17, v18 })
	local v21

	if FFlagEnablePlayButtonWizardVPCPrologue then
		local function fn(p3)
			return {
				config = {
					titleText = v11.askYourParentTitleText,
					bodyText = if fFlagLuaAppVpcUpsellNamespace then p3 else nil,
					bodyContent = React.createElement(PlayButtonUpsellBody, {
						bodyText = p3,
						onCloseModal = v20
					}),
					confirmText = v11.askYourParentActionButtonText,
					cancelText = v11.askYourParentCancelButtonText,
					cancelFirst = true,
					dialogSize = "Medium",
					hasBackdrop = true,
					onCloseCancels = true
				},
				onConfirm = function()
					authButtonClick("gameJoinContentMaturityLock", "askParent")
				end,
				onCancel = function()
					authButtonClick("gameJoinContentMaturityLock", "cancelAskParent")
				end,
				odpEventUniverseId = if FFlagLuaAppPlayButtonOdpEventUniverseId then p2 else nil
			}
		end

		v21 = React.useCallback(fn, {
			v11.askYourParentTitleText,
			v11.askYourParentActionButtonText,
			v11.askYourParentCancelButtonText,
			v20,
			if FFlagLuaAppPlayButtonOdpEventUniverseId then p2 else nil
		})
	else
		v21 = nil
	end

	local useCallback = React.useCallback
	local function fn(p3, p4)
		v17()

		if not FFlagEnablePlayButtonWizardVPCPrologue then
			authButtonClick("gameJoinContentMaturityLock", "askParent")
		end

		if fFlagLuaAppParentApprovedExperiences then
			local v24 = if getFFlagEnableAmpWizardVPCNavigationFix() then v18 else v16
			local v28

			if fFlagLuaAppVpcUpsellNamespace then
				v28 = fStringLuaAppVpcAccountManagementAmpNameSpace
			end

			if not FFlagEnablePlayButtonWizardVPCPrologue then
				p4 = nil
			end

			v12(
				"CanApproveExperience",
				v24,
				{ universeId = p2, experienceManagementAction = "Approve" },
				"gameJoinContentMaturityLock",
				nil,
				v28,
				nil,
				p4
			)
		else
			local v24 = if getFFlagEnableAmpWizardVPCNavigationFix() then v18 else v16
			local v28 = if fFlagLuaAppVpcUpsellNamespace then fStringLuaAppVpcSettingsChangeAmpNameSpace else nil

			if not FFlagEnablePlayButtonWizardVPCPrologue then
				p4 = nil
			end

			v12(
				"CanChangeSetting",
				v24,
				{ contentAgeRestriction = p3 },
				"gameJoinContentMaturityLock",
				nil,
				v28,
				nil,
				p4
			)
		end
	end

	local v23 = if getFFlagEnableAmpWizardVPCNavigationFix() then v18 else nil
	local v24 = if not getFFlagEnableAmpWizardVPCNavigationFix() then v16 else nil
	local v25 = if fFlagLuaAppParentApprovedExperiences or FFlagEnablePlayButtonWizardVPCPrologue and FFlagLuaAppPlayButtonOdpEventUniverseId then p2 else nil
	local v26 = useCallback(fn, { v12, v23, v24, v17, v25 })

	local v27 = React.useCallback(function(p3, p4)
		local v30 = {
			universeId = p2,
			upsellName = p3,
			playabilityStatus = 0,
			pageName = 0
		}

		local v31 = if fFlagLuaAppParentApprovedExperiences then p4 or playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls else playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
		v30.playabilityStatus = v31

		v30.pageName = pageName
		unlockPlayIntent(v8, v30)
	end, { v8, p2, pageName })
	local v28

	if fFlagLuaAppParentUpsellPolicy then
		v28 = useAppPolicy(function(p3)
			return p3.getShouldShowVpcPlayButtonUpsells()
		end)
	else
		v28 = nil
	end

	local v29 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)
	local v30

	if fFlagLuaAppParentApprovedExperiences then
		local function fn2(p3)
			if fFlagLuaAppParentUpsellPolicy and not v28 then
				callback(p3)

				v27("GameLaunch", playabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			else
				if FFlagEnablePlayButtonWizardVPCPrologue then
					v26(nil, v21(v11.askYourParentToAllowGameBodyText))
				else
					v14(
						v11.askYourParentTitleText,
						v11.askYourParentToAllowGameBodyText,
						v11.askYourParentActionButtonText,
						v11.askYourParentCancelButtonText,
						v26,
						v20,
						v20
					)
				end

				v27(
					"ParentApprovedExperience",
					playabilityStatusEnum.ContextualPlayabilityRequireParentApproval
				)
			end
		end

		v30 = React.useCallback(fn2, {
			v14,
			v26,
			v20,
			v27,
			callback,
			v28,
			v11.askYourParentTitleText,
			v11.askYourParentToAllowGameBodyText,
			v11.askYourParentActionButtonText,
			v11.askYourParentCancelButtonText,
			if FFlagEnablePlayButtonWizardVPCPrologue then v21 else nil
		})
	end

	local function fn2(p3)
		if fFlagLuaAppParentUpsellPolicy and not v28 then
			callback(p3)

			v27("GameLaunch")
		else
			fetchUserSettingsAndOptions(v7):andThen(function(p4)
				local contentAgeRestriction = p4.contentAgeRestriction

				if contentAgeRestriction and v10 then
					assert(v10, "Content maturity rating must be present to show correct upsell")

					if v6[v10] then
						local v31 = v6[v10]

						local v32 = Dash.find(contentAgeRestriction.options, function(p5)
							return p5 and p5.option and p5.option.optionValue == v31 and true or false
						end)

						if v32 then
							local requirement = v32.requirement

							if requirement == "SelfUpdateSetting" then
								if v29 then
									v13(
										"gameJoinContentMaturityLock",
										{
											title = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Title",
											message = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Body",
											buttonCancel = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.Cancel",
											buttonSettings = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.GoToSettings"
										},
										v19,
										v19
									)
								else
									v15(
										v11.consoleSelfUpdateSettingTitleText,
										v11.consoleSelfUpdateSettingBodyText,
										v17,
										v11.consoleSelfUpdateSettingButtonText,
										true
									)
								end
							elseif requirement == "ParentalConsent" then
								if FFlagEnablePlayButtonWizardVPCPrologue then
									v26(v32.option.optionValue, v21(v11.askYourParentBodyText))
								else
									v14(
										v11.askYourParentTitleText,
										v11.askYourParentBodyText,
										v11.askYourParentActionButtonText,
										v11.askYourParentCancelButtonText,
										function()
											v26(v32.option.optionValue)
										end,
										v20,
										v20
									)
								end
							elseif requirement == "ContentAgeRestrictionVerification" then
								local v37

								if fFlagLuaAppPlayButtonAmpAgeCheckFlow then
									v37 = not pageName and "gameJoinContentMaturityLock"
										or `gameJoinContentMaturityLock-{pageName}`
								end

								local v39

								if fFlagLuaAppPlayButtonAmpAgeCheckFlow then
									v39 = fStringLuaAppPlayButtonAgeCheckAmpNameSpace
								end

								local v40 = if fFlagLuaAppPlayButtonWizardCloseDelay then delayedAmpWizardCompletionCallbackOverride(v18, fIntLuaAppPlayButtonWizardCloseDelayMs) else nil
								v12(
									not fFlagLuaAppPlayButtonAmpAgeCheckFlow and "ShouldNotPromptSeventeenPlusSettingVerifications" or fStringLuaAppPlayButtonAgeCheckAmpFeatureName,
									v18,
									nil,
									v37,
									nil,
									v39,
									v40
								)
							else
								flaggedMutedError(
									"ExperienceParentalControlsUnknownUpsellRequirement",
									`Unknown requirement {requirement} for ContentAgeRestriction option {v32} on play button click`
								)

								callback(p3)
							end

							v27(requirement or "GameLaunch")
						else
							v15(
								v11.unplayableTitleText,
								v11.unplayableBodyText,
								v17,
								v11.unplayableButtonText,
								true
							)

							v27("RestrictedUnplayableOptionNotFound")
						end
					else
						LoggingProtocol.default:logRobloxTelemetryEvent({
							eventName = "ExperienceParentalControlsUpsellUnexpectedContentMaturityRating",
							backends = { LoggingProtocol.TelemetryBackends.Points },
							throttlingPercentage = defineFastInt,
							lastUpdated = { 25, 8, 26 },
							description = "Unexpected content maturity rating for Contextual Parental Controls upsell on play button click"
						}, { LoggingProtocol.default.StandardizedFields.addOsInfo }, {
							eventName = "ExperienceParentalControlsUpsellUnexpectedContentMaturityRating",
							contentMaturityRating = v10,
							universeId = p2
						})

						callback(p3)

						v27("GameLaunch")
					end
				else
					flaggedMutedError(
						"ExperienceParentalControlsUpsellUnknownContentMaturityRating",
						`Unknown content maturity rating {v10} or age restriction setting {contentAgeRestriction} for Contextual Parental Controls upsell on play button click`
					)

					callback(p3)

					v27("GameLaunch")
				end
			end, function()
				callback(p3)

				v27("GameLaunch")
			end)
		end
	end

	local v35 = React.useCallback(fn2, {
		v7,
		p2,
		callback,
		v10,
		v9,
		v13,
		v12,
		v15,
		v14,
		v26,
		v19,
		v20,
		v17,
		if fFlagLuaAppPlayButtonAmpAgeCheckFlow then v18 else nil,
		v27,
		v11.unplayableTitleText,
		v11.unplayableBodyText,
		v11.unplayableButtonText,
		v11.askYourParentTitleText,
		v11.askYourParentBodyText,
		v11.askYourParentActionButtonText,
		v11.askYourParentCancelButtonText,
		v11.consoleSelfUpdateSettingTitleText,
		v11.consoleSelfUpdateSettingBodyText,
		v11.consoleSelfUpdateSettingButtonText,
		v28,
		v29,
		pageName,
		if FFlagEnablePlayButtonWizardVPCPrologue then v21 else nil
	})

	if not fFlagLuaAppParentApprovedExperiences then
		v30 = nil
	end

	return v35, v30
end
