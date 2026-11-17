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
local GameHydrationReact = require(parent.GameHydrationReact)
local GameDetailRodux = require(parent.GameDetailRodux)
local FetchUserSettingsAndOptions = GameDetailRodux.FetchUserSettingsAndOptions
local Dash = require(parent.Dash)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux2.Thunks.NavigateBack
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
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

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppParentUpsellPolicy = SharedFlags2.FFlagLuaAppParentUpsellPolicy
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = SharedFlags3.FFlagLuaAppPlayButtonAmpAgeCheckFlow

local SharedFlags4 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags4.FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local SharedFlags5 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags5.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppVpcUpsellNamespace = SharedFlags6.FFlagLuaAppVpcUpsellNamespace

local SharedFlags7 = require(parent.SharedFlags)
local FStringLuaAppVpcSettingsChangeAmpNameSpace = SharedFlags7.FStringLuaAppVpcSettingsChangeAmpNameSpace

local SharedFlags8 = require(parent.SharedFlags)
local FStringLuaAppVpcAccountManagementAmpNameSpace = SharedFlags8.FStringLuaAppVpcAccountManagementAmpNameSpace
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppParentApprovedExperiences = SharedFlags9.FFlagLuaAppParentApprovedExperiences
local AmpUpsell2 = require(parent.AmpUpsell)
local GetFFlagEnableAmpWizardVPCNavigationFix = AmpUpsell2.GetFFlagEnableAmpWizardVPCNavigationFix
local FFlagEnablePlayButtonWizardVPCPrologue = require(GamePlayButton.Flags.FFlagEnablePlayButtonWizardVPCPrologue)
local FFlagLuaAppPlayButtonOdpEventUniverseId = require(GamePlayButton.Flags.FFlagLuaAppPlayButtonOdpEventUniverseId)
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags10.FFlagLuaAppPlayButtonWizardCloseDelay
local SharedFlags11 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonWizardCloseDelayMs = SharedFlags11.FIntLuaAppPlayButtonWizardCloseDelayMs

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

	local v5 = useSelector(function(p)
		local ageRecommendation = p.AgeRecommendations[universeId]

		if
			ageRecommendation
			and ageRecommendation.summary
			and ageRecommendation.summary.ageRecommendation
			and ageRecommendation.summary.ageRecommendation.contentMaturity
		then
			return ageRecommendation.summary.ageRecommendation.contentMaturity
		end

		return nil
	end)

	local v6 = GameHydrationReact.useGameInfo(universeId)
	local contentMaturity = v6 and v6.contentMaturity

	local contentMaturityRating = v5 or contentMaturity

	local v7 = useLocalization({
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

	local v8 = React.useCallback(function(p, p2, p3, p4, p5, p6, p7, p8)
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then
			p5 = nil
		end

		if not (FFlagLuaAppPlayButtonAmpAgeCheckFlow or FFlagLuaAppVpcUpsellNamespace) then
			p6 = nil
		end

		if not FFlagLuaAppPlayButtonWizardCloseDelay then
			p7 = nil
		end

		local v8 = FFlagEnablePlayButtonWizardVPCPrologue and p8 and true or nil

		if not FFlagEnablePlayButtonWizardVPCPrologue then
			p8 = nil
		end

		v4(OpenAmpWizardContainer(p, p2, p3, p4, p5, p6, nil, nil, p7, v8, p8))
	end, { v4 })

	local v9 = React.useCallback(function(featureName, localizationStrings, onCloseModal, onCancelled)
		local v9 = {
			name = AppPage.AccountSettingsUpsell,
			extraProps = {
				featureName = featureName,
				localizationStrings = localizationStrings,
				onCloseModal = onCloseModal,
				onCancelled = onCancelled
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9), true)
		else
			v4(NavigateDown(v9, true))
		end
	end, { v4 })

	local v10 = React.useCallback(function(p, p2, p3, p4, p5, p6, p7)
		v4(OpenPlayButtonUpsellDialog(p, p2, p3, p4, p5, p6, p7))
	end, { v4 })

	local v11 = React.useCallback(function(p, p2, p3, p4, p5)
		v4(OpenCloseOnlyInteractiveAlert(p, p2, p3, p4, p5))
	end, { v4 })

	local v12 = React.useCallback(function()
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v4(NavigateBack(true))
		end
	end, { v4 })

	local v13 = React.useCallback(function()
		v4(CloseCentralOverlay())
	end, { v4 })

	local v14 = React.useCallback(function()
		v4(FetchGamePlayButtonData.Fetch(v2, universeId, true))
	end, { v4, v2, universeId })

	local v15 = React.useCallback(function()
		v12()

		v14()
	end, { v12, v14 })

	local onCloseModal = React.useCallback(function()
		v13()

		authButtonClick("gameJoinContentMaturityLock", "cancelAskParent")

		v14()
	end, { v13, v14 })
	local v16

	if FFlagEnablePlayButtonWizardVPCPrologue then
		local useCallback = React.useCallback
		local function fn(bodyText: string)
			local config = {
				titleText = v7.askYourParentTitleText,
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

			config.confirmText = v7.askYourParentActionButtonText
			config.cancelText = v7.askYourParentCancelButtonText
			local v17 = {
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

			v17.odpEventUniverseId = odpEventUniverseId
			return v17
		end

		local askYourParentTitleText = v7.askYourParentTitleText
		local askYourParentActionButtonText = v7.askYourParentActionButtonText
		local askYourParentCancelButtonText = v7.askYourParentCancelButtonText
		local v17

		if FFlagLuaAppPlayButtonOdpEventUniverseId then
			v17 = universeId
		end

		v16 = useCallback(fn, {
			askYourParentTitleText,
			askYourParentActionButtonText,
			askYourParentCancelButtonText,
			onCloseModal,
			v17
		})
	else
		v16 = nil
	end

	local useCallback = React.useCallback
	local function fn(contentAgeRestriction: string?, p)
		v13()

		if not FFlagEnablePlayButtonWizardVPCPrologue then
			authButtonClick("gameJoinContentMaturityLock", "askParent")
		end

		if FFlagLuaAppParentApprovedExperiences then
			local v17

			if GetFFlagEnableAmpWizardVPCNavigationFix() then
				v17 = v14
			else
				v17 = v12
			end

			local v18

			if FFlagLuaAppVpcUpsellNamespace then
				v18 = FStringLuaAppVpcAccountManagementAmpNameSpace
			end

			if not FFlagEnablePlayButtonWizardVPCPrologue then
				p = nil
			end

			v8(
				"CanApproveExperience",
				v17,
				{ universeId = universeId, experienceManagementAction = "Approve" },
				"gameJoinContentMaturityLock",
				nil,
				v18,
				nil,
				p
			)
		else
			local v17

			if GetFFlagEnableAmpWizardVPCNavigationFix() then
				v17 = v14
			else
				v17 = v12
			end

			local v18

			if FFlagLuaAppVpcUpsellNamespace then
				v18 = FStringLuaAppVpcSettingsChangeAmpNameSpace
			end

			if not FFlagEnablePlayButtonWizardVPCPrologue then
				p = nil
			end

			v8(
				"CanChangeSetting",
				v17,
				{ contentAgeRestriction = contentAgeRestriction },
				"gameJoinContentMaturityLock",
				nil,
				v18,
				nil,
				p
			)
		end
	end

	local v17

	if GetFFlagEnableAmpWizardVPCNavigationFix() then
		v17 = v14
	end

	local v18

	if not GetFFlagEnableAmpWizardVPCNavigationFix() then
		v18 = v12
	end

	local v19

	if
		FFlagLuaAppParentApprovedExperiences
		or FFlagEnablePlayButtonWizardVPCPrologue and FFlagLuaAppPlayButtonOdpEventUniverseId
	then
		v19 = universeId
	end

	local v20 = useCallback(fn, { v8, v17, v18, v13, v19 })

	local v21 = React.useCallback(function(upsellName: string, p: string?)
		local v21 = {
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

		v21.playabilityStatus = playabilityStatus

		v21.pageName = pageName
		unlockPlayIntent(v3, v21)
	end, { v3, universeId, pageName })
	local v22

	if FFlagLuaAppParentUpsellPolicy then
		v22 = useAppPolicy(function(p)
			return p.getShouldShowVpcPlayButtonUpsells()
		end)
	else
		v22 = nil
	end

	local v23 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)
	local v24

	if FFlagLuaAppParentApprovedExperiences then
		local useCallback2 = React.useCallback
		local function fn2(p)
			if FFlagLuaAppParentUpsellPolicy and not v22 then
				callback(p)

				v21("GameLaunch", PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			else
				if FFlagEnablePlayButtonWizardVPCPrologue then
					v20(nil, v16(v7.askYourParentToAllowGameBodyText))
				else
					v10(
						v7.askYourParentTitleText,
						v7.askYourParentToAllowGameBodyText,
						v7.askYourParentActionButtonText,
						v7.askYourParentCancelButtonText,
						v20,
						onCloseModal,
						onCloseModal
					)
				end

				v21("ParentApprovedExperience", PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			end
		end

		local askYourParentTitleText = v7.askYourParentTitleText
		local askYourParentToAllowGameBodyText = v7.askYourParentToAllowGameBodyText
		local askYourParentActionButtonText = v7.askYourParentActionButtonText
		local askYourParentCancelButtonText = v7.askYourParentCancelButtonText
		local v25

		if FFlagEnablePlayButtonWizardVPCPrologue then
			v25 = v16
		end

		v24 = useCallback2(fn2, {
			v10,
			v20,
			onCloseModal,
			v21,
			callback,
			v22,
			askYourParentTitleText,
			askYourParentToAllowGameBodyText,
			askYourParentActionButtonText,
			askYourParentCancelButtonText,
			v25
		})
	end

	local useCallback2 = React.useCallback
	local function fn2(p)
		if FFlagLuaAppParentUpsellPolicy and not v22 then
			callback(p)

			v21("GameLaunch")
		else
			FetchUserSettingsAndOptions(v2):andThen(function(p2)
				local contentAgeRestriction = p2.contentAgeRestriction

				if contentAgeRestriction and contentMaturityRating then
					assert(contentMaturityRating, "Content maturity rating must be present to show correct upsell")

					if v[contentMaturityRating] then
						local v25 = v[contentMaturityRating]

						local v26 = Dash.find(contentAgeRestriction.options, function(p3)
							return p3 and p3.option and p3.option.optionValue == v25 and true or false
						end)

						if v26 then
							local requirement = v26.requirement

							if requirement == "SelfUpdateSetting" then
								if v23 then
									v9(
										"gameJoinContentMaturityLock",
										{
											title = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Title",
											message = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Label.Body",
											buttonCancel = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.Cancel",
											buttonSettings = "Feature.ExperienceDetails.UpdateMaturitySettingModal.Action.GoToSettings"
										},
										v15,
										v15
									)
								else
									v11(
										v7.consoleSelfUpdateSettingTitleText,
										v7.consoleSelfUpdateSettingBodyText,
										v13,
										v7.consoleSelfUpdateSettingButtonText,
										true
									)
								end
							elseif requirement == "ParentalConsent" then
								if FFlagEnablePlayButtonWizardVPCPrologue then
									v20(v26.option.optionValue, v16(v7.askYourParentBodyText))
								else
									v10(
										v7.askYourParentTitleText,
										v7.askYourParentBodyText,
										v7.askYourParentActionButtonText,
										v7.askYourParentCancelButtonText,
										function()
											v20(v26.option.optionValue)
										end,
										onCloseModal,
										onCloseModal
									)
								end
							elseif requirement == "ContentAgeRestrictionVerification" then
								local v27

								if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
									v27 = not pageName and "gameJoinContentMaturityLock"
										or `gameJoinContentMaturityLock-{pageName}`
								end

								local v28

								if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
									v28 = FStringLuaAppPlayButtonAgeCheckAmpNameSpace
								end

								local v29

								if FFlagLuaAppPlayButtonWizardCloseDelay then
									v29 = delayedAmpWizardCompletionCallbackOverride(
										v14,
										FIntLuaAppPlayButtonWizardCloseDelayMs
									)
								end

								v8(
									not FFlagLuaAppPlayButtonAmpAgeCheckFlow and "ShouldNotPromptSeventeenPlusSettingVerifications" or FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
									v14,
									nil,
									v27,
									nil,
									v28,
									v29
								)
							else
								flaggedMutedError(
									"ExperienceParentalControlsUnknownUpsellRequirement",
									`Unknown requirement {requirement} for ContentAgeRestriction option {v26} on play button click`
								)

								callback(p)
							end

							v21(requirement or "GameLaunch")
						else
							v11(v7.unplayableTitleText, v7.unplayableBodyText, v13, v7.unplayableButtonText, true)

							v21("RestrictedUnplayableOptionNotFound")
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

						v21("GameLaunch")
					end
				else
					flaggedMutedError(
						"ExperienceParentalControlsUpsellUnknownContentMaturityRating",
						`Unknown content maturity rating {contentMaturityRating} or age restriction setting {contentAgeRestriction} for Contextual Parental Controls upsell on play button click`
					)

					callback(p)

					v21("GameLaunch")
				end
			end, function()
				callback(p)

				v21("GameLaunch")
			end)
		end
	end

	local v25

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		v25 = v14
	end

	local v26 = {
		v2,
		universeId,
		callback,
		contentMaturityRating,
		v4,
		v9,
		v8,
		v11,
		v10,
		v20,
		v15,
		onCloseModal,
		v13,
		v25,
		v21,
		v7.unplayableTitleText,
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
	local unplayableBodyText = v7.unplayableBodyText
	local unplayableButtonText = v7.unplayableButtonText
	local askYourParentTitleText = v7.askYourParentTitleText
	local askYourParentBodyText = v7.askYourParentBodyText
	local askYourParentActionButtonText = v7.askYourParentActionButtonText
	local askYourParentCancelButtonText = v7.askYourParentCancelButtonText
	local consoleSelfUpdateSettingTitleText = v7.consoleSelfUpdateSettingTitleText
	local consoleSelfUpdateSettingBodyText = v7.consoleSelfUpdateSettingBodyText
	local consoleSelfUpdateSettingButtonText = v7.consoleSelfUpdateSettingButtonText
	local v27

	if FFlagEnablePlayButtonWizardVPCPrologue then
		v27 = v16
	end

	v26[17], v26[18], v26[19], v26[20], v26[21], v26[22], v26[23], v26[24], v26[25], v26[26], v26[27], v26[28], v26[29] = unplayableBodyText, unplayableButtonText, askYourParentTitleText, askYourParentBodyText, askYourParentActionButtonText, askYourParentCancelButtonText, consoleSelfUpdateSettingTitleText, consoleSelfUpdateSettingBodyText, consoleSelfUpdateSettingButtonText, v22, v23, pageName, v27
	local v28 = useCallback2(fn2, v26)

	if not FFlagLuaAppParentApprovedExperiences then
		v24 = nil
	end

	return v28, v24
end
