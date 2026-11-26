local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local ExperienceQuestionnaire = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceQuestionnaire")
local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local ContentMaturityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/ContentMaturityUtils")
local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")
local formatError = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/formatError")
local refreshPublishEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshPublishEligibility")
local refreshAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshAdCampaignEligibility")
local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")
local FFlagBuildExperienceActionOutcomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceActionOutcomeTelemetry")
local ConfigurationActionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/ConfigurationActionTelemetry")

local Debug = CreatorAgentChat.debug
local action = ConfigurationActionTelemetry.Action
local failureReason = ConfigurationActionTelemetry.FailureReason
local stage = ConfigurationActionTelemetry.Stage

local icon = Foundation.Icon
local list = Foundation.List
local popover = Foundation.Popover
local radioGroup = Foundation.RadioGroup
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local radius = Foundation.Enums.Radius
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local privacyType = UniverseConfiguration.PrivacyType

local v5 = {
	[privacyType.Private] = "Private",
	[privacyType.FriendsOnly] = "Friends",
	[privacyType.Public] = "Public"
}

local defineFastInt = game:DefineFastInt("BuildExperienceAudienceTooltipMaxWidth", 220)

local function getSelectedAudience(p2)
	if p2 == nil then
		return nil
	end

	return v5[UniverseConfiguration.getPrivacyTypeForAudiences(p2)]
end

local v6 = {
	["Private"] = privacyType.Private,
	Friends = privacyType.FriendsOnly,
	Public = privacyType.Public
}

local function getAudienceChangeParameters(p2, p3)
	local audiences = if p2 ~= nil then p2.audiences else nil
	return {
		fromAudience = audiences == nil and "unknown" or UniverseConfiguration.getPrivacyTypeForAudiences(audiences),
		toAudience = v6[p3]
	}
end

local function isVisibilityAudience(p2): boolean
	return p2 == UniverseActivation.Audience.Public or p2 == UniverseActivation.Audience.Friends
end

local function getAudiencesForValue(p2, audiences)
	local audiencesForValue = {}

	for k, item in audiences do
		if item ~= UniverseActivation.Audience.Public and item ~= UniverseActivation.Audience.Friends then
			table.insert(audiencesForValue, item)
		end
	end

	if p2 == "Public" then
		table.insert(audiencesForValue, UniverseActivation.Audience.Public)
		return audiencesForValue
	end

	if p2 == "Friends" then
		table.insert(audiencesForValue, UniverseActivation.Audience.Friends)
	end

	return audiencesForValue
end

local function AudienceRow(props)
	local v7 = React.useCallback(function()
		props.onActivated(props.value)
	end, { props.onActivated, props.value })
	local formatted = `{props.testId}-row-{string.lower(props.value)}`
	local v8

	if props.isLocked then
		v8 = React.createElement(icon, {
			LayoutOrder = 1,
			name = iconName.LockClosed,
			ref = props.lockIconRef,
			size = iconSize.Small,
			tag = "auto-xy content-default"
		})
	end

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		tag = "size-full-0 auto-y radius-medium",
		testId = 0
	}

	if props.isDisabled then
		v7 = nil
	end

	v10.onActivated = v7

	v10.testId = `{formatted}-button`
	return createElement(view, v10, {
		ListItem = React.createElement(list.Item, {
			LayoutOrder = props.LayoutOrder,
			title = props.title,
			trailing = React.createElement(view, {
				tag = "row align-y-center gap-medium auto-xy"
			}, {
				Lock = v8,
				Radio = React.createElement(radioGroup.Item, {
					LayoutOrder = 2,
					isDisabled = props.isDisabled or props.isLocked,
					label = "",
					size = inputSize.Medium,
					testId = `{formatted}-radio`,
					value = props.value
				})
			}),
			testId = formatted
		})
	})
end

local function getSelectedAudienceFromState(p2, p3, p4)
	if p2 ~= nil then
		return p2
	end

	if not p3 then
		return nil
	end

	local audiences = p4.audiences

	if audiences == nil then
		return nil
	end

	return v5[UniverseConfiguration.getPrivacyTypeForAudiences(audiences)]
end

local function getUniverseActivationStore(p2)
	return UniverseActivation.getUniverseActivationStore(p2)
end

local function getQuestionnaireStore(p2)
	return ExperienceQuestionnaire.getExperienceQuestionnaireStore(p2)
end

local function getUniverseConfigurationStore(p2)
	return UniverseConfiguration.getUniverseConfigurationStore(p2)
end

local function useAudienceStores()
	return {
		universeActivationStore = SignalsReact.useSignalState(getUniverseActivationStore),
		questionnaireStore = SignalsReact.useSignalState(getQuestionnaireStore),
		universeConfigurationStore = SignalsReact.useSignalState(getUniverseConfigurationStore)
	}
end

local function useAudienceData(p2, universeActivationStore, universeConfigurationStore, state)
	local v7 = React.useMemo(function()
		return universeConfigurationStore.getAndFetchConfiguration(p2)
	end, { p2, universeConfigurationStore })
	local state2, setState = React.useState(true)

	React.useEffect(function()
		local flag = true
		setState(true)

		universeConfigurationStore.refreshConfiguration(p2):catch(function(p3)
			Debug.log("warn", "AudienceConfigurationContent configuration refresh failed", {
				errorMessage = formatError(p3),
				universeId = p2
			})
		end):finally(function()
			if flag then
				setState(false)
			end
		end)

		return function()
			flag = false
		end
	end, { universeConfigurationStore, p2 })

	local v8 = SignalsReact.useSignalState(v7.data)
	local v9 = SignalsReact.useSignalState(v7.status) == "Ready" and v8 ~= nil

	local v10 = React.useMemo(function()
		return universeActivationStore.getAndFetchEligibility(p2)
	end, { universeActivationStore, p2 })
	local v11 = SignalsReact.useSignalState(v10.status)
	local v12 = v11 == "Ready" or v11 == "Failed"

	local contentUnrated = ContentMaturityUtils.isContentUnrated(p2)
	local sealBroken = ContentMaturityUtils.isSealBroken(p2)
	local v13 = contentUnrated and (sealBroken and "RatingRequired" or "PublishRequired") or nil
	local v14 = {
		configurationData = v8,
		isAudiencesReady = v9,
		isConfigurationRefreshPending = state2,
		isEligibilityResolved = v12,
		isNonPrivateLocked = v13 ~= nil,
		lockReason = v13,
		selectedAudience = 0
	}

	if state == nil then
		if v9 then
			local audiences = v8.audiences
			state = if audiences ~= nil then v5[UniverseConfiguration.getPrivacyTypeForAudiences(audiences)] else nil
		else
			state = nil
		end
	end

	v14.selectedAudience = state
	return v14
end

local function useQuestionnaireHandler(p2, questionnaireStore)
	local creatorHub = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
	}).creatorHub
	local v7 = useOpenWebView()

	local v8 = React.useCallback(function()
		refreshPublishEligibility(p2)
	end, { questionnaireStore, p2 })

	return React.useCallback(function(p3)
		if FFlagBuildExperienceActionOutcomeTelemetry then
			local sendClick = ConfigurationActionTelemetry.sendClick
			local updateRating = action.UpdateRating

			local v10 = if p3 ~= nil then p3.context else nil
			sendClick(updateRating, { universeId = p2 }, v10)
		end

		v7(GameConfigurationActions.getExperienceQuestionnaireUrl(p2), creatorHub, v8)
	end, { creatorHub, v7, v8, p2 })
end

local function cancelEligibilityRecheck(p2)
	local current = p2.current
	p2.current = nil

	if current ~= nil then
		current:cancel()
	end
end

local function useAudienceController(universeId)
	local v7 = useAudienceStores()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(nil)
	local v8 = ref
	React.useEffect(function()
		return function()
			local v9 = ref
			local current = v9.current
			v9.current = nil

			if current ~= nil then
				current:cancel()
			end
		end
	end, { ref, universeId })

	local state3, setState3 = React.useState(nil)
	local v9 = React.useCallback(function()
		setState3(nil)
	end, {})

	local v10 = useAudienceData(
		universeId,
		v7.universeActivationStore,
		v7.universeConfigurationStore,
		state
	)
	local v11 = useQuestionnaireHandler(universeId, v7.questionnaireStore)

	local configurationData = v10.configurationData
	local isAudiencesReady = v10.isAudiencesReady
	local isConfigurationRefreshPending = v10.isConfigurationRefreshPending
	local isEligibilityResolved = v10.isEligibilityResolved
	local isNonPrivateLocked = v10.isNonPrivateLocked
	local v12 = not isAudiencesReady or state2 or isConfigurationRefreshPending
	return {
		handleAudienceActivated = React.useCallback(function(p2)
			local function showLockedTooltip()
				setState3(function(p3)
					if p3 == p2 then
						return nil
					end

					return p2
				end)
			end

			local function applyAudienceChange()
				if v12 then
					return
				end

				local audiencesForValue = getAudiencesForValue(p2, configurationData.audiences)

				setState3(nil)
				setState(p2)
				setState2(true)

				v7.universeActivationStore.setAudiences(universeId, audiencesForValue):andThen(function(p3)
					GameConfigurationActions.updateCachedAudience(universeId, p3.audiences)

					if FFlagBuildExperienceActionOutcomeTelemetry then
						local sendSuccess = ConfigurationActionTelemetry.sendSuccess
						local audienceChange = action.AudienceChange

						local v15 = configurationData
						local audiences = if v15 ~= nil then v15.audiences else nil
						sendSuccess(audienceChange, { universeId = universeId }, nil, {
							fromAudience = audiences == nil and "unknown" or UniverseConfiguration.getPrivacyTypeForAudiences(audiences),
							toAudience = v6[p2]
						})
					end

					v7.universeActivationStore.activate(universeId):andThen(function()
						if FFlagEnableBuildAdPromotion then
							refreshAdCampaignEligibility(universeId)
						end
					end):catch(function(p4)
						Debug.log(
							"warn",
							"AudienceConfigurationContent activate after audience update failed",
							{ errorMessage = formatError(p4), universeId = universeId }
						)

						setState(nil)
					end):finally(function()
						setState2(false)
					end)
				end):catch(function(p3)
					Debug.log("warn", "AudienceConfigurationContent set audiences failed", {
						errorMessage = formatError(p3),
						universeId = universeId
					})

					if FFlagBuildExperienceActionOutcomeTelemetry then
						local sendFailure = ConfigurationActionTelemetry.sendFailure
						local audienceChange = action.AudienceChange

						local v14 = {
							reason = failureReason.RequestFailed,
							stage = stage.SetAudience,
							error = p3
						}

						local v16 = configurationData
						local audiences = if v16 ~= nil then v16.audiences else nil
						sendFailure(audienceChange, { universeId = universeId }, v14, nil, {
							fromAudience = audiences == nil and "unknown" or UniverseConfiguration.getPrivacyTypeForAudiences(audiences),
							toAudience = v6[p2]
						})
					end

					setState(nil)
					setState2(false)
				end)
			end

			local v13 = isNonPrivateLocked and p2 ~= "Private"

			if v13 then
				setState3(function(p3)
					if p3 == p2 then
						return nil
					end

					return p2
				end)
			end

			if v12 then
				return
			end

			if not v13 then
				setState2(true)
			end

			local v14 = v8
			local current = v14.current
			v14.current = nil

			if current ~= nil then
				current:cancel()
			end

			if p2 == "Private" then
				applyAudienceChange()
				return
			end

			if not v13 then
				setState(p2)
			end

			local v15 = v7.universeActivationStore.refreshEligibility(universeId)
			v14.current = v15

			v15:catch(function(p3)
				if v14.current == v15 then
					Debug.log("warn", "AudienceConfigurationContent eligibility recheck failed", {
						errorMessage = formatError(p3),
						universeId = universeId
					})
				end
			end):finally(function()
				if v14.current ~= v15 then
					return
				end

				v14.current = nil

				if not ContentMaturityUtils.isContentUnrated(universeId) then
					applyAudienceChange()
				elseif not v13 then
					if FFlagBuildExperienceActionOutcomeTelemetry then
						local sendFailure = ConfigurationActionTelemetry.sendFailure
						local audienceChange = action.AudienceChange

						local v17 = {
							reason = failureReason.ContentUnrated,
							stage = stage.RefreshEligibility,
							error = nil
						}

						local v19 = configurationData
						local audiences = if v19 ~= nil then v19.audiences else nil
						sendFailure(audienceChange, { universeId = universeId }, v17, nil, {
							fromAudience = audiences == nil and "unknown" or UniverseConfiguration.getPrivacyTypeForAudiences(audiences),
							toAudience = v6[p2]
						})
					end

					setState(nil)
					setState2(false)
					setState3(function(p3)
						if p3 == p2 then
							return nil
						end

						return p2
					end)
				end
			end)
		end, {
			configurationData,
			v8,
			v12,
			isEligibilityResolved,
			isNonPrivateLocked,
			v7.universeActivationStore,
			v7.universeConfigurationStore,
			universeId
		}),
		handleQuestionnaire = v11,
		isMutationPending = state2,
		isNonPrivateLocked = v10.isNonPrivateLocked,
		lockReason = v10.lockReason,
		onTooltipPressedOutside = v9,
		selectedAudience = v10.selectedAudience,
		tooltipTarget = state3
	}
end

local function AudienceHeader()
	local v7 = useLocalization({
		body = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BODY,
		title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PAGE_TITLE
	})

	local body = v7.body
	local title = v7.title

	return React.createElement(view, {
		LayoutOrder = 1,
		tag = "col gap-xsmall size-full-0 auto-y"
	}, {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = title,
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default"
		}),
		Body = React.createElement(text, {
			LayoutOrder = 2,
			Text = body,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
		})
	})
end

local function AudienceList(props)
	local v7 = useLocalization({
		friends = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS,
		private = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE,
		public = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
	})

	local friends = v7.friends
	local private = v7.private
	local public = v7.public
	local v8 = React.useCallback(function(p2)
		props.onAudienceActivated(p2)
	end, { props.onAudienceActivated })

	return React.createElement(radioGroup.Root, {
		LayoutOrder = 2,
		onValueChanged = v8,
		Selectable = false,
		tag = "size-full-0 auto-y",
		value = props.selectedAudience == nil and "" or props.selectedAudience
	}, {
		List = React.createElement(list.Root, {
			hasDivider = { hasDivider = true, isInset = false },
			isContained = true,
			size = inputSize.Medium,
			testId = `{props.testId}-list`
		}, {
			Private = React.createElement(AudienceRow, {
				LayoutOrder = 1,
				isDisabled = props.isDisabled,
				isLocked = false,
				lockIconRef = nil,
				onActivated = props.onAudienceActivated,
				testId = props.testId,
				title = private,
				value = "Private"
			}),
			Friends = React.createElement(AudienceRow, {
				LayoutOrder = 2,
				isDisabled = props.isDisabled,
				isLocked = props.isNonPrivateLocked,
				lockIconRef = props.friendsLockIconRef,
				onActivated = props.onAudienceActivated,
				testId = props.testId,
				title = friends,
				value = "Friends"
			}),
			Public = React.createElement(AudienceRow, {
				LayoutOrder = 3,
				isDisabled = props.isDisabled,
				isLocked = props.isNonPrivateLocked,
				lockIconRef = props.publicLockIconRef,
				onActivated = props.onAudienceActivated,
				testId = props.testId,
				title = public,
				value = "Public"
			})
		})
	})
end

local function EligibilityTooltip(props)
	local v7 = useLocalization({
		notEligible = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE,
		notEligibleDescription = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE_DESCRIPTION,
		publishRequired = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED,
		publishRequiredDescription = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED_DESCRIPTION
	})

	local notEligible = v7.notEligible
	local v8 = v7.notEligibleDescription
	local v9 = v7.publishRequired
	local publishRequiredDescription = v7.publishRequiredDescription
	local v10 = useTokens()
	local v11 = useScaledValue(defineFastInt)
	local v12 = props.lockReason == "PublishRequired"

	if not v12 then
		v9 = notEligible
	end

	if v12 then
		v8 = publishRequiredDescription
	end

	local v13

	if v12 then
		v13 = `{props.testId}-eligibility-tooltip--publish`
	else
		v13 = `{props.testId}-eligibility-tooltip--not-eligible`
	end

	return React.createElement(
		popover.Root,
		{
			isOpen = props.isOpen,
			testId = `{props.testId}-eligibility-tooltip`
		},
		{
			Anchor = React.createElement(popover.Anchor, {
				anchorRef = props.anchorRef
			}),
			Content = React.createElement(popover.Content, {
				align = popoverAlign.Center,
				backgroundStyle = v10.Color.System.Contrast,
				hasArrow = true,
				onPressedOutside = props.onPressedOutside,
				radius = radius.Small,
				selectionGroup = false,
				side = popoverSide.Left
			}, {
				Layout = React.createElement(view, {
					tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
					sizeConstraint = { MaxSize = Vector2.new(v11, 1e999) },
					testId = v13
				}, {
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = v9,
						tag = "auto-xy text-title-small text-wrap text-align-x-left content-inverse-emphasis",
						testId = `{props.testId}-eligibility-tooltip--header`
					}),
					Text = React.createElement(text, {
						LayoutOrder = 2,
						Text = v8,
						tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
						testId = `{props.testId}-eligibility-tooltip--text`
					})
				})
			})
		}
	)
end

local function EligibilityBanner(p2)
	local banner = useLocalization({
		banner = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BANNER
	}).banner

	return React.createElement(view, {
		LayoutOrder = 3,
		onActivated = p2.onActivated,
		stateLayer = {},
		tag = "row align-y-center gap-small size-full-0 auto-y padding-medium radius-medium bg-shift-200",
		testId = `{p2.testId}-eligibility-banner`
	}, {
		Lock = React.createElement(icon, {
			LayoutOrder = 1,
			name = iconName.LockClosed,
			size = iconSize.Small,
			tag = "auto-xy content-emphasis"
		}),
		Text = React.createElement(text, {
			LayoutOrder = 2,
			Text = banner,
			tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis"
		}),
		ExternalLink = React.createElement(icon, {
			LayoutOrder = 3,
			name = iconName.ArrowUpRightFromSquare,
			size = iconSize.Small,
			tag = "auto-xy content-emphasis"
		})
	})
end

local function AudienceConfigurationContent(props)
	local testId = props.testId or "audience-configuration-content"
	local v7 = useAudienceController(props.universeId)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v8 = if v7.tooltipTarget == "Public" then ref2 else ref

	local v9 = v7.isNonPrivateLocked and v7.lockReason == "RatingRequired"
	local handleQuestionnaire = v7.handleQuestionnaire
	local v10

	if FFlagBuildExperienceActionOutcomeTelemetry then
		v10 = React.useCallback(function()
			handleQuestionnaire({ context = ConfigurationActionTelemetry.Context.AudienceBanner })
		end, { handleQuestionnaire })
	else
		v10 = handleQuestionnaire
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		testId = testId
	}

	local v13 = {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = ref,
			isDisabled = v7.isMutationPending,
			isNonPrivateLocked = v7.isNonPrivateLocked,
			onAudienceActivated = v7.handleAudienceActivated,
			publicLockIconRef = ref2,
			selectedAudience = v7.selectedAudience,
			testId = testId
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = v8,
			isOpen = v7.tooltipTarget ~= nil,
			lockReason = v7.lockReason,
			onPressedOutside = v7.onTooltipPressedOutside,
			testId = testId
		}),
		ContextBanner = 0
	}

	local v14 = if v9 then React.createElement(EligibilityBanner, {
		onActivated = v10,
		testId = testId
	}) else nil
	v13.ContextBanner = v14
	return createElement(view, v12, v13)
end

return AudienceConfigurationContent
