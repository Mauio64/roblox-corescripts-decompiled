local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
require(GamePlayButton.PlayButtonTypes)
local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)
local PlayButtonUpsellBody = require(GamePlayButton.PlayButtonUpsellBody)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags2.AppEventIngestService
local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer
local GameHydrationReact = require(parent.GameHydrationReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local GameDetailRodux = require(parent.GameDetailRodux)
local FetchUserSettingsAndOptions = GameDetailRodux.FetchUserSettingsAndOptions
local Dash = require(parent.Dash)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux2.Thunks.NavigateBack
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenCloseOnlyInteractiveAlert = DiscoveryRouting.OpenCloseOnlyInteractiveAlert
local DiscoveryRouting2 = require(parent.DiscoveryRouting)
local OpenPlayButtonUpsellDialog = DiscoveryRouting2.OpenPlayButtonUpsellDialog
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
require(parent.AmpUpsell)
local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick
local LoggingProtocol = require(parent.LoggingProtocol)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local unlockPlayIntent = DiscoveryAnalytics.Events.unlockPlayIntent

local delayedAmpWizardCompletionCallbackOverride = require(GamePlayButton.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride)

local defineFastInt = game:DefineFastInt("UnknownUpsellErrorEventHundredthsPercent", 0)
local defineFastString = game:DefineFastString(
	"LuaAppUpsellMaturityRatingToSettingMapping",
	"mild=NinePlus,moderate=ThirteenPlus,restricted=SeventeenPlus,unrated=ThirteenPlus"
)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppParentUpsellPolicy = SharedFlags3.FFlagLuaAppParentUpsellPolicy
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = SharedFlags4.FFlagLuaAppPlayButtonAmpAgeCheckFlow

local SharedFlags5 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags5.FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local SharedFlags6 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags6.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppVpcUpsellNamespace = SharedFlags7.FFlagLuaAppVpcUpsellNamespace

local SharedFlags8 = require(parent.SharedFlags)
local FStringLuaAppVpcSettingsChangeAmpNameSpace = SharedFlags8.FStringLuaAppVpcSettingsChangeAmpNameSpace

local SharedFlags9 = require(parent.SharedFlags)
local FStringLuaAppVpcAccountManagementAmpNameSpace = SharedFlags9.FStringLuaAppVpcAccountManagementAmpNameSpace
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppParentApprovedExperiences = SharedFlags10.FFlagLuaAppParentApprovedExperiences
local AmpUpsell2 = require(parent.AmpUpsell)
local GetFFlagEnableAmpWizardVPCNavigationFix = AmpUpsell2.GetFFlagEnableAmpWizardVPCNavigationFix
local FFlagEnablePlayButtonWizardVPCPrologue = require(GamePlayButton.Flags.FFlagEnablePlayButtonWizardVPCPrologue)
local FFlagLuaAppPlayButtonOdpEventUniverseId = require(GamePlayButton.Flags.FFlagLuaAppPlayButtonOdpEventUniverseId)
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags11.FFlagLuaAppPlayButtonWizardCloseDelay
local SharedFlags12 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonWizardCloseDelayMs = SharedFlags12.FIntLuaAppPlayButtonWizardCloseDelayMs

local _ = {
	SelfUpdateSetting = "SelfUpdateSetting",
	ParentalConsent = "ParentalConsent",
	ContentAgeRestrictionVerification = "ContentAgeRestrictionVerification"
}

local function parseContentMaturityMappingString(value: string)
	if value == "" then
		return {}
	end

	local v = string.split(value, ",")
	local result = {}

	for _, v2 in v do
		local v3 = string.split(v2, "=")

		if #v3 == 2 and v3[1] ~= "" and v3[2] ~= "" then
			result[v3[1]] = v3[2]
		else
			error(`Invalid content maturity mapping string {value}`)
		end
	end

	return result
end

local function safeParseContentMaturityMappingString(defineFastString2: string)
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

local v = safeParseContentMaturityMappingString(defineFastString)

return function(universeId: string, callback, pageName: string?)
	local v2 = useRoactService(RoactNetworking)
	local v3 = useRoactService(AppEventIngestService)
	local v4 = useDispatch()

	local contentMaturityRating = useSelector(function(p)
		local ageRecommendation = p.AgeRecommendations[universeId]

		if
			ageRecommendation
			and ageRecommendation.summary
			and ageRecommendation.summary.ageRecommendation
			and ageRecommendation.summary.ageRecommendation.contentMaturity
		then
			return ageRecommendation.summary.ageRecommendation.contentMaturity
		end

		if FFlagMigrateGameInfoToStore then
			return nil
		end

		local v5 = p.Personalization[GameInfosReducer.key][universeId]

		if v5 and v5.contentMaturity then
			return v5.contentMaturity
		end

		return nil
	end)
	local contentMaturity

	if FFlagMigrateGameInfoToStore then
		local v5 = GameHydrationReact.useGameInfo(universeId)
		contentMaturity = v5 and v5.contentMaturity
	end

	if FFlagMigrateGameInfoToStore then
		contentMaturityRating = contentMaturityRating or contentMaturity
	end

	local v5 = useLocalization({
		unplayableTitleText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Label.Title",
		unplayableBodyText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Label.Body",
		unplayableButtonText = "Feature.ExperienceDetails.RestrictedUnplayableModal.Action.Ok",
		askYourParentTitleText = "Feature.ExperienceDetails.AskYourParentModal.Label.Title",
		askYourParentBodyText = "Feature.ExperienceDetails.AskYourParentModal.Label.Body",
		askYourParentToAllowGameBodyText = FFlagLuaAppParentApprovedExperiences and "Feature.ExperienceDetails.AskYourParentToAllowGameModal.Label.Body" or nil,
		askYourParentActionButtonText = "Feature.ExperienceDetails.AskYourParentModal.Action.AskNow",
		askYourParentCancelButtonText = "Feature.ExperienceDetails.AskYourParentModal.Action.Cancel",
		consoleSelfUpdateSettingTitleText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Label.Title",
		consoleSelfUpdateSettingBodyText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Label.Body",
		consoleSelfUpdateSettingButtonText = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Console.Action.Ok"
	})

	local v6 = React.useCallback(function(p, p2, p3, p4, p5, p6, p7, p8)
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then
			p5 = nil
		end

		if not (FFlagLuaAppPlayButtonAmpAgeCheckFlow or FFlagLuaAppVpcUpsellNamespace) then
			p6 = nil
		end

		if not FFlagLuaAppPlayButtonWizardCloseDelay then
			p7 = nil
		end

		local v6 = FFlagEnablePlayButtonWizardVPCPrologue and p8 and true or nil

		if not FFlagEnablePlayButtonWizardVPCPrologue then
			p8 = nil
		end

		v4(OpenAmpWizardContainer(p, p2, p3, p4, p5, p6, nil, nil, p7, v6, p8))
	end, { v4 })

	local v7 = React.useCallback(function(featureName, localizationStrings, onCloseModal, onCancelled)
		local v7 = {
			name = AppPage.AccountSettingsUpsell,
			extraProps = {
				featureName = featureName,
				localizationStrings = localizationStrings,
				onCloseModal = onCloseModal,
				onCancelled = onCancelled
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7), true)
		else
			v4(NavigateDown(v7, true))
		end
	end, { v4 })

	local v8 = React.useCallback(function(p, p2, p3, p4, p5, p6, p7)
		v4(OpenPlayButtonUpsellDialog(p, p2, p3, p4, p5, p6, p7))
	end, { v4 })

	local v9 = React.useCallback(function(p, p2, p3, p4, p5)
		v4(OpenCloseOnlyInteractiveAlert(p, p2, p3, p4, p5))
	end, { v4 })

	local v10 = React.useCallback(function()
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v4(NavigateBack(true))
		end
	end, { v4 })

	local v11 = React.useCallback(function()
		v4(CloseCentralOverlay())
	end, { v4 })

	local v12 = React.useCallback(function()
		v4(FetchGamePlayButtonData.Fetch(v2, universeId, true))
	end, { v4, v2, universeId })

	local v13 = React.useCallback(function()
		v10()

		v12()
	end, { v10, v12 })

	local onCloseModal = React.useCallback(function()
		v11()

		authButtonClick("gameJoinContentMaturityLock", "cancelAskParent")

		v12()
	end, { v11, v12 })
	local v14

	if FFlagEnablePlayButtonWizardVPCPrologue then
		local useCallback = React.useCallback
		local function fn(bodyText: string)
			local config = {
				titleText = v5.askYourParentTitleText,
				bodyText = 0,
				bodyContent = 0,
				confirmText = 0,
				cancelText = 0,
				cancelFirst = true,
				dialogSize = "Medium",
				hasBackdrop = true,
				onCloseCancels = true
			}
			local bodyText2

			if FFlagLuaAppVpcUpsellNamespace then
				bodyText2 = bodyText
			end

			config.bodyText = bodyText2
			config.bodyContent = React.createElement(PlayButtonUpsellBody, {
				bodyText = bodyText,
				onCloseModal = onCloseModal
			})

			config.confirmText = v5.askYourParentActionButtonText
			config.cancelText = v5.askYourParentCancelButtonText
			local v15 = {
				config = config,
				onConfirm = function()
					authButtonClick("gameJoinContentMaturityLock", "askParent")
				end,
				onCancel = function()
					authButtonClick("gameJoinContentMaturityLock", "cancelAskParent")
				end,
				odpEventUniverseId = 0
			}
			local odpEventUniverseId

			if FFlagLuaAppPlayButtonOdpEventUniverseId then
				odpEventUniverseId = universeId
			end

			v15.odpEventUniverseId = odpEventUniverseId
			return v15
		end

		local askYourParentTitleText = v5.askYourParentTitleText
		local askYourParentActionButtonText = v5.askYourParentActionButtonText
		local askYourParentCancelButtonText = v5.askYourParentCancelButtonText
		local v15

		if FFlagLuaAppPlayButtonOdpEventUniverseId then
			v15 = universeId
		end

		v14 = useCallback(fn, {
			askYourParentTitleText,
			askYourParentActionButtonText,
			askYourParentCancelButtonText,
			onCloseModal,
			v15
		})
	else
		v14 = nil
	end

	local useCallback = React.useCallback
	local function fn(contentAgeRestriction: string?, p)
		v11()

		if not FFlagEnablePlayButtonWizardVPCPrologue then
			authButtonClick("gameJoinContentMaturityLock", "askParent")
		end

		if FFlagLuaAppParentApprovedExperiences then
			local v15

			if GetFFlagEnableAmpWizardVPCNavigationFix() then
				v15 = v12
			else
				v15 = v10
			end

			local v16

			if FFlagLuaAppVpcUpsellNamespace then
				v16 = FStringLuaAppVpcAccountManagementAmpNameSpace
			end

			if not FFlagEnablePlayButtonWizardVPCPrologue then
				p = nil
			end

			v6(
				"CanApproveExperience",
				v15,
				{ universeId = universeId, experienceManagementAction = "Approve" },
				"gameJoinContentMaturityLock",
				nil,
				v16,
				nil,
				p
			)
		else
			local v15

			if GetFFlagEnableAmpWizardVPCNavigationFix() then
				v15 = v12
			else
				v15 = v10
			end

			local v16

			if FFlagLuaAppVpcUpsellNamespace then
				v16 = FStringLuaAppVpcSettingsChangeAmpNameSpace
			end

			if not FFlagEnablePlayButtonWizardVPCPrologue then
				p = nil
			end

			v6(
				"CanChangeSetting",
				v15,
				{ contentAgeRestriction = contentAgeRestriction },
				"gameJoinContentMaturityLock",
				nil,
				v16,
				nil,
				p
			)
		end
	end

	local v15

	if GetFFlagEnableAmpWizardVPCNavigationFix() then
		v15 = v12
	end

	local v16

	if not GetFFlagEnableAmpWizardVPCNavigationFix() then
		v16 = v10
	end

	local v17

	if
		FFlagLuaAppParentApprovedExperiences
		or FFlagEnablePlayButtonWizardVPCPrologue and FFlagLuaAppPlayButtonOdpEventUniverseId
	then
		v17 = universeId
	end

	local v18 = useCallback(fn, { v6, v15, v16, v11, v17 })

	local v19 = React.useCallback(function(upsellName: string, p: string?)
		local v19 = {
			universeId = universeId,
			upsellName = upsellName,
			playabilityStatus = 0,
			pageName = 0
		}
		local playabilityStatus

		if FFlagLuaAppParentApprovedExperiences then
			playabilityStatus = p or PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
		else
			playabilityStatus = PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
		end

		v19.playabilityStatus = playabilityStatus

		v19.pageName = pageName
		unlockPlayIntent(v3, v19)
	end, { v3, universeId, pageName })
	local v20

	if FFlagLuaAppParentUpsellPolicy then
		v20 = useAppPolicy(function(p)
			return p.getShouldShowVpcPlayButtonUpsells()
		end)
	else
		v20 = nil
	end

	local v21 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)
	local v22

	if FFlagLuaAppParentApprovedExperiences then
		local useCallback2 = React.useCallback
		local function fn2(p)
			if FFlagLuaAppParentUpsellPolicy and not v20 then
				callback(p)

				v19("GameLaunch", PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			else
				if FFlagEnablePlayButtonWizardVPCPrologue then
					v18(nil, v14(v5.askYourParentToAllowGameBodyText))
				else
					v8(
						v5.askYourParentTitleText,
						v5.askYourParentToAllowGameBodyText,
						v5.askYourParentActionButtonText,
						v5.askYourParentCancelButtonText,
						v18,
						onCloseModal,
						onCloseModal
					)
				end

				v19("ParentApprovedExperience", PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			end
		end

		local askYourParentTitleText = v5.askYourParentTitleText
		local askYourParentToAllowGameBodyText = v5.askYourParentToAllowGameBodyText
		local askYourParentActionButtonText = v5.askYourParentActionButtonText
		local askYourParentCancelButtonText = v5.askYourParentCancelButtonText
		local v23

		if FFlagEnablePlayButtonWizardVPCPrologue then
			v23 = v14
		end

		v22 = useCallback2(fn2, {
			v8,
			v18,
			onCloseModal,
			v19,
			callback,
			v20,
			askYourParentTitleText,
			askYourParentToAllowGameBodyText,
			askYourParentActionButtonText,
			askYourParentCancelButtonText,
			v23
		})
	end

	local useCallback2 = React.useCallback
	local function fn2(p)
		if FFlagLuaAppParentUpsellPolicy and not v20 then
			callback(p)

			v19("GameLaunch")
		else
			FetchUserSettingsAndOptions(v2):andThen(function(p2)
				local contentAgeRestriction = p2.contentAgeRestriction

				if contentAgeRestriction and contentMaturityRating then
					assert(contentMaturityRating, "Content maturity rating must be present to show correct upsell")

					if v[contentMaturityRating] then
						local v23 = v[contentMaturityRating]

						local v24 = Dash.find(contentAgeRestriction.options, function(p3)
							return p3 and p3.option and p3.option.optionValue == v23 and true or false
						end)

						if v24 then
							local requirement = v24.requirement

							if requirement == "SelfUpdateSetting" then
								if v21 then
									v7(
										"gameJoinContentMaturityLock",
										{
											title = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Title",
											message = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Body",
											buttonCancel = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.Cancel",
											buttonSettings = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.GoToSettings"
										},
										v13,
										v13
									)
								else
									v9(
										v5.consoleSelfUpdateSettingTitleText,
										v5.consoleSelfUpdateSettingBodyText,
										v11,
										v5.consoleSelfUpdateSettingButtonText,
										true
									)
								end
							elseif requirement == "ParentalConsent" then
								if FFlagEnablePlayButtonWizardVPCPrologue then
									v18(v24.option.optionValue, v14(v5.askYourParentBodyText))
								else
									v8(
										v5.askYourParentTitleText,
										v5.askYourParentBodyText,
										v5.askYourParentActionButtonText,
										v5.askYourParentCancelButtonText,
										function()
											v18(v24.option.optionValue)
										end,
										onCloseModal,
										onCloseModal
									)
								end
							elseif requirement == "ContentAgeRestrictionVerification" then
								local v25

								if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
									v25 = not pageName and "gameJoinContentMaturityLock"
										or `gameJoinContentMaturityLock-{pageName}`
								end

								local v26

								if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
									v26 = FStringLuaAppPlayButtonAgeCheckAmpNameSpace
								end

								local v27

								if FFlagLuaAppPlayButtonWizardCloseDelay then
									v27 = delayedAmpWizardCompletionCallbackOverride(
										v12,
										FIntLuaAppPlayButtonWizardCloseDelayMs
									)
								end

								v6(
									not FFlagLuaAppPlayButtonAmpAgeCheckFlow and "ShouldNotPromptSeventeenPlusSettingVerifications" or FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
									v12,
									nil,
									v25,
									nil,
									v26,
									v27
								)
							else
								flaggedMutedError(
									"ExperienceParentalControlsUnknownUpsellRequirement",
									`Unknown requirement {requirement} for ContentAgeRestriction option {v24} on play button click`
								)

								callback(p)
							end

							v19(requirement or "GameLaunch")
						else
							v9(v5.unplayableTitleText, v5.unplayableBodyText, v11, v5.unplayableButtonText, true)

							v19("RestrictedUnplayableOptionNotFound")
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
							contentMaturityRating = contentMaturityRating,
							universeId = universeId
						})

						callback(p)

						v19("GameLaunch")
					end
				else
					flaggedMutedError(
						"ExperienceParentalControlsUpsellUnknownContentMaturityRating",
						`Unknown content maturity rating {contentMaturityRating} or age restriction setting {contentAgeRestriction} for Contextual Parental Controls upsell on play button click`
					)

					callback(p)

					v19("GameLaunch")
				end
			end, function()
				callback(p)

				v19("GameLaunch")
			end)
		end
	end

	local v23

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		v23 = v12
	end

	local v24 = {
		v2,
		universeId,
		callback,
		contentMaturityRating,
		v4,
		v7,
		v6,
		v9,
		v8,
		v18,
		v13,
		onCloseModal,
		v11,
		v23,
		v19,
		v5.unplayableTitleText,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local unplayableBodyText = v5.unplayableBodyText
	local unplayableButtonText = v5.unplayableButtonText
	local askYourParentTitleText = v5.askYourParentTitleText
	local askYourParentBodyText = v5.askYourParentBodyText
	local askYourParentActionButtonText = v5.askYourParentActionButtonText
	local askYourParentCancelButtonText = v5.askYourParentCancelButtonText
	local consoleSelfUpdateSettingTitleText = v5.consoleSelfUpdateSettingTitleText
	local consoleSelfUpdateSettingBodyText = v5.consoleSelfUpdateSettingBodyText
	local consoleSelfUpdateSettingButtonText = v5.consoleSelfUpdateSettingButtonText
	local v25

	if FFlagEnablePlayButtonWizardVPCPrologue then
		v25 = v14
	end

	v24[17], v24[18], v24[19], v24[20], v24[21], v24[22], v24[23], v24[24], v24[25], v24[26], v24[27], v24[28], v24[29] = unplayableBodyText, unplayableButtonText, askYourParentTitleText, askYourParentBodyText, askYourParentActionButtonText, askYourParentCancelButtonText, consoleSelfUpdateSettingTitleText, consoleSelfUpdateSettingBodyText, consoleSelfUpdateSettingButtonText, v20, v21, pageName, v25
	local v26 = useCallback2(fn2, v24)

	if not FFlagLuaAppParentApprovedExperiences then
		v22 = nil
	end

	return v26, v22
end
