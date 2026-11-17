local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local ExperienceQuestionnaire = require(parent.DataHydration.ExperienceQuestionnaire)
local UniverseActivation = require(parent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local formatError = require(BuildExperience.utils.formatError)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local refreshAdCampaignEligibility = require(BuildExperience.utils.refreshAdCampaignEligibility)
local FFlagEnableBuildAdPromotion = require(BuildExperience.Flags.FFlagEnableBuildAdPromotion)
local FFlagBuildExperienceActionOutcomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceActionOutcomeTelemetry)
local ConfigurationActionTelemetry = require(BuildExperience.Telemetry.ConfigurationActionTelemetry)

local Debug = CreatorAgentChat.debug
local Action = ConfigurationActionTelemetry.Action
local FailureReason = ConfigurationActionTelemetry.FailureReason
local Stage = ConfigurationActionTelemetry.Stage

local Icon = Foundation.Icon
local List = Foundation.List
local Popover = Foundation.Popover
local RadioGroup = Foundation.RadioGroup
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Radius = Foundation.Enums.Radius
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local PrivacyType = UniverseConfiguration.PrivacyType

local v = {
	[PrivacyType.Private] = "Private",
	[PrivacyType.FriendsOnly] = "Friends",
	[PrivacyType.Public] = "Public"
}

local defineFastInt = game:DefineFastInt("BuildExperienceAudienceTooltipMaxWidth", 220)

local function getSelectedAudience(audiences) -- 1 equivalent call inferred from this helper
	if audiences == nil then
		return nil
	end

	return v[UniverseConfiguration.getPrivacyTypeForAudiences(audiences)]
end

local v2 = {
	["Private"] = PrivacyType.Private,
	Friends = PrivacyType.FriendsOnly,
	Public = PrivacyType.Public
}

local function getAudienceChangeParameters(configurationData, p: string) -- 3 equivalent calls inferred from this helper
	local audiences

	if configurationData ~= nil then
		audiences = configurationData.audiences
	end

	return {
		fromAudience = audiences == nil and "unknown" or UniverseConfiguration.getPrivacyTypeForAudiences(audiences),
		toAudience = v2[p]
	}
end

local function isVisibilityAudience(p): boolean
	return p == UniverseActivation.Audience.Public or p == UniverseActivation.Audience.Friends
end

local function getAudiencesForValue(p: string, audiences)
	local audiencesForValue = {}

	for _, item in audiences do
		if item ~= UniverseActivation.Audience.Public and item ~= UniverseActivation.Audience.Friends then
			table.insert(audiencesForValue, item)
		end
	end

	if p == "Public" then
		table.insert(audiencesForValue, UniverseActivation.Audience.Public)
		return audiencesForValue
	end

	if p == "Friends" then
		table.insert(audiencesForValue, UniverseActivation.Audience.Friends)
	end

	return audiencesForValue
end

local function AudienceRow(props)
	local onActivated = React.useCallback(function()
		props.onActivated(props.value)
	end, { props.onActivated, props.value })
	local formatted = `{props.testId}-row-{string.lower(props.value)}`
	local lock

	if props.isLocked then
		lock = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.LockClosed,
			ref = props.lockIconRef,
			size = IconSize.Small,
			tag = "auto-xy content-default"
		})
	end

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		tag = "size-full-0 auto-y radius-medium",
		testId = 0
	}

	if props.isDisabled then
		onActivated = nil
	end

	v3.onActivated = onActivated

	v3.testId = `{formatted}-button`
	return createElement(View, v3, {
		ListItem = React.createElement(List.Item, {
			LayoutOrder = props.LayoutOrder,
			title = props.title,
			trailing = React.createElement(View, { tag = "row align-y-center gap-medium auto-xy" }, {
				Lock = lock,
				Radio = React.createElement(RadioGroup.Item, {
					LayoutOrder = 2,
					isDisabled = props.isDisabled or props.isLocked,
					label = "",
					size = InputSize.Medium,
					testId = `{formatted}-radio`,
					value = props.value
				})
			}),
			testId = formatted
		})
	})
end

local function getSelectedAudienceFromState(selectedAudience: string?, flag: boolean, p) -- 1 equivalent call inferred from this helper
	if selectedAudience ~= nil then
		return selectedAudience
	end

	if not flag then
		return nil
	end

	return getSelectedAudience(p.audiences) -- inferred equivalent call
end

local function getUniverseActivationStore(p)
	return UniverseActivation.getUniverseActivationStore(p)
end

local function getQuestionnaireStore(p)
	return ExperienceQuestionnaire.getExperienceQuestionnaireStore(p)
end

local function getUniverseConfigurationStore(p)
	return UniverseConfiguration.getUniverseConfigurationStore(p)
end

local function useAudienceStores()
	return {
		universeActivationStore = SignalsReact.useSignalState(getUniverseActivationStore),
		questionnaireStore = SignalsReact.useSignalState(getQuestionnaireStore),
		universeConfigurationStore = SignalsReact.useSignalState(getUniverseConfigurationStore)
	}
end

local function useAudienceData(universeId: number, universeActivationStore, universeConfigurationStore, state: string?)
	local v3 = React.useMemo(function()
		return universeConfigurationStore.getAndFetchConfiguration(universeId)
	end, { universeId, universeConfigurationStore })
	local state2, setState = React.useState(true)

	React.useEffect(function()
		local flag = true
		setState(true)

		universeConfigurationStore.refreshConfiguration(universeId):catch(function(p)
			Debug.log("warn", "AudienceConfigurationContent configuration refresh failed", {
				errorMessage = formatError(p),
				universeId = universeId
			})
		end):finally(function()
			if flag then
				setState(false)
			end
		end)

		return function()
			flag = false
		end
	end, { universeConfigurationStore, universeId })

	local configurationData = SignalsReact.useSignalState(v3.data)
	local isAudiencesReady

	if SignalsReact.useSignalState(v3.status) == "Ready" then
		isAudiencesReady = configurationData ~= nil
	else
		isAudiencesReady = false
	end

	local v4 = React.useMemo(function()
		return universeActivationStore.getAndFetchEligibility(universeId)
	end, { universeActivationStore, universeId })
	local v5 = SignalsReact.useSignalState(v4.status)
	local isEligibilityResolved = v5 == "Ready" or v5 == "Failed"

	local contentUnrated = ContentMaturityUtils.isContentUnrated(universeId)
	local sealBroken = ContentMaturityUtils.isSealBroken(universeId)
	local lockReason = contentUnrated and (sealBroken and "RatingRequired" or "PublishRequired") or nil
	local v6 = {
		configurationData = configurationData,
		isAudiencesReady = isAudiencesReady,
		isConfigurationRefreshPending = state2,
		isEligibilityResolved = isEligibilityResolved,
		isNonPrivateLocked = lockReason ~= nil,
		lockReason = lockReason,
		selectedAudience = 0
	}
	state = getSelectedAudienceFromState(state, isAudiencesReady, configurationData) -- inferred equivalent call
	v6.selectedAudience = state
	return v6
end

local function useQuestionnaireHandler(universeId: number, questionnaireStore)
	local creatorHub = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
	}).creatorHub
	local v3 = useOpenWebView()

	local v4 = React.useCallback(function()
		refreshPublishEligibility(universeId)
	end, { questionnaireStore, universeId })

	return React.useCallback(function(p)
		if FFlagBuildExperienceActionOutcomeTelemetry then
			local sendClick = ConfigurationActionTelemetry.sendClick
			local updateRating = Action.UpdateRating
			local v5

			if p ~= nil then
				v5 = p.context
			end

			sendClick(updateRating, { universeId = universeId }, v5)
		end

		v3(GameConfigurationActions.getExperienceQuestionnaireUrl(universeId), creatorHub, v4)
	end, { creatorHub, v3, v4, universeId })
end

local function cancelEligibilityRecheck(p) -- 2 equivalent calls inferred from this helper
	local current = p.current
	p.current = nil

	if current ~= nil then
		current:cancel()
	end
end

local function useAudienceController(universeId: number)
	local v3 = useAudienceStores()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(nil)
	local v4 = ref
	React.useEffect(function()
		return function()
			cancelEligibilityRecheck(ref) -- inferred equivalent call
		end
	end, { ref, universeId })

	local state3, setState3 = React.useState(nil)
	local onTooltipPressedOutside = React.useCallback(function()
		setState3(nil)
	end, {})

	local v5 = useAudienceData(universeId, v3.universeActivationStore, v3.universeConfigurationStore, state)
	local handleQuestionnaire = useQuestionnaireHandler(universeId, v3.questionnaireStore)

	local configurationData = v5.configurationData
	local isAudiencesReady = v5.isAudiencesReady
	local isConfigurationRefreshPending = v5.isConfigurationRefreshPending
	local isEligibilityResolved = v5.isEligibilityResolved
	local isNonPrivateLocked = v5.isNonPrivateLocked
	local v6 = not isAudiencesReady or state2 or isConfigurationRefreshPending
	return {
		handleAudienceActivated = React.useCallback(function(p: string)
			local function showLockedTooltip() -- 2 equivalent calls inferred from this helper
				setState3(function(p2)
					return if p2 ~= p then p else nil
				end)
			end

			local function applyAudienceChange()
				if v6 then
					return
				end

				local audiencesForValue = getAudiencesForValue(p, configurationData.audiences)

				setState3(nil)
				setState(p)
				setState2(true)

				v3.universeActivationStore.setAudiences(universeId, audiencesForValue):andThen(function(p2)
					GameConfigurationActions.updateCachedAudience(universeId, p2.audiences)

					if FFlagBuildExperienceActionOutcomeTelemetry then
						ConfigurationActionTelemetry.sendSuccess(
							Action.AudienceChange,
							{ universeId = universeId },
							nil,
							getAudienceChangeParameters(configurationData, p) -- inferred equivalent call
						)
					end

					v3.universeActivationStore.activate(universeId):andThen(function()
						if FFlagEnableBuildAdPromotion then
							refreshAdCampaignEligibility(universeId)
						end
					end):catch(function(p3)
						Debug.log("warn", "AudienceConfigurationContent activate after audience update failed", {
							errorMessage = formatError(p3),
							universeId = universeId
						})

						setState(nil)
					end):finally(function()
						setState2(false)
					end)
				end):catch(function(err)
					Debug.log("warn", "AudienceConfigurationContent set audiences failed", {
						errorMessage = formatError(err),
						universeId = universeId
					})

					if FFlagBuildExperienceActionOutcomeTelemetry then
						ConfigurationActionTelemetry.sendFailure(
							Action.AudienceChange,
							{ universeId = universeId },
							{
								reason = FailureReason.RequestFailed,
								stage = Stage.SetAudience,
								error = err
							},
							nil,
							getAudienceChangeParameters(configurationData, p) -- inferred equivalent call
						)
					end

					setState(nil)
					setState2(false)
				end)
			end

			local v7 = isNonPrivateLocked and p ~= "Private"

			if v7 then
				showLockedTooltip() -- inferred equivalent call
			end

			if v6 then
				return
			end

			if not v7 then
				setState2(true)
			end

			local v8 = v4
			cancelEligibilityRecheck(v8) -- inferred equivalent call

			if p == "Private" then
				applyAudienceChange()
				return
			end

			if not v7 then
				setState(p)
			end

			local current = v3.universeActivationStore.refreshEligibility(universeId)
			v8.current = current

			current:catch(function(p2)
				if v8.current == current then
					Debug.log("warn", "AudienceConfigurationContent eligibility recheck failed", {
						errorMessage = formatError(p2),
						universeId = universeId
					})
				end
			end):finally(function()
				if v8.current ~= current then
					return
				end

				v8.current = nil

				if not ContentMaturityUtils.isContentUnrated(universeId) then
					applyAudienceChange()
				elseif not v7 then
					if FFlagBuildExperienceActionOutcomeTelemetry then
						ConfigurationActionTelemetry.sendFailure(
							Action.AudienceChange,
							{ universeId = universeId },
							{
								reason = FailureReason.ContentUnrated,
								stage = Stage.RefreshEligibility,
								error = nil
							},
							nil,
							getAudienceChangeParameters(configurationData, p) -- inferred equivalent call
						)
					end

					setState(nil)
					setState2(false)
					showLockedTooltip() -- inferred equivalent call
				end
			end)
		end, {
			configurationData,
			v4,
			v6,
			isEligibilityResolved,
			isNonPrivateLocked,
			v3.universeActivationStore,
			v3.universeConfigurationStore,
			universeId
		}),
		handleQuestionnaire = handleQuestionnaire,
		isMutationPending = state2,
		isNonPrivateLocked = v5.isNonPrivateLocked,
		lockReason = v5.lockReason,
		onTooltipPressedOutside = onTooltipPressedOutside,
		selectedAudience = v5.selectedAudience,
		tooltipTarget = state3
	}
end

local function AudienceHeader()
	local v3 = useLocalization({
		body = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BODY,
		title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PAGE_TITLE
	})

	local body = v3.body
	local title = v3.title

	return React.createElement(View, { LayoutOrder = 1, tag = "col gap-xsmall size-full-0 auto-y" }, {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = title,
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default"
		}),
		Body = React.createElement(Text, {
			LayoutOrder = 2,
			Text = body,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
		})
	})
end

local function AudienceList(props)
	local v3 = useLocalization({
		friends = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS,
		private = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE,
		public = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
	})

	local friends = v3.friends
	local private = v3.private
	local public = v3.public
	local onValueChanged = React.useCallback(function(p: string)
		props.onAudienceActivated(p)
	end, { props.onAudienceActivated })

	return React.createElement(RadioGroup.Root, {
		LayoutOrder = 2,
		onValueChanged = onValueChanged,
		Selectable = false,
		tag = "size-full-0 auto-y",
		value = props.selectedAudience == nil and "" or props.selectedAudience
	}, {
		List = React.createElement(List.Root, {
			hasDivider = { hasDivider = true, isInset = false },
			isContained = true,
			size = InputSize.Medium,
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
	local v3 = useLocalization({
		notEligible = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE,
		notEligibleDescription = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE_DESCRIPTION,
		publishRequired = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED,
		publishRequiredDescription = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED_DESCRIPTION
	})

	local notEligible = v3.notEligible
	local text = v3.notEligibleDescription
	local text2 = v3.publishRequired
	local publishRequiredDescription = v3.publishRequiredDescription
	local v4 = useTokens()
	local v5 = useScaledValue(defineFastInt)
	local v6 = props.lockReason == "PublishRequired"

	if not v6 then
		text2 = notEligible
	end

	if v6 then
		text = publishRequiredDescription
	end

	local testId

	if v6 then
		testId = `{props.testId}-eligibility-tooltip--publish`
	else
		testId = `{props.testId}-eligibility-tooltip--not-eligible`
	end

	return React.createElement(Popover.Root, {
		isOpen = props.isOpen,
		testId = `{props.testId}-eligibility-tooltip`
	}, {
		Anchor = React.createElement(Popover.Anchor, { anchorRef = props.anchorRef }),
		Content = React.createElement(Popover.Content, {
			align = PopoverAlign.Center,
			backgroundStyle = v4.Color.System.Contrast,
			hasArrow = true,
			onPressedOutside = props.onPressedOutside,
			radius = Radius.Small,
			selectionGroup = false,
			side = PopoverSide.Left
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
				sizeConstraint = { MaxSize = Vector2.new(v5, 1e999) },
				testId = testId
			}, {
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = text2,
					tag = "auto-xy text-title-small text-wrap text-align-x-left content-inverse-emphasis",
					testId = `{props.testId}-eligibility-tooltip--header`
				}),
				Text = React.createElement(Text, {
					LayoutOrder = 2,
					Text = text,
					tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
					testId = `{props.testId}-eligibility-tooltip--text`
				})
			})
		})
	})
end

local function EligibilityBanner(p)
	local banner = useLocalization({
		banner = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BANNER
	}).banner

	return React.createElement(View, {
		LayoutOrder = 3,
		onActivated = p.onActivated,
		stateLayer = {},
		tag = "row align-y-center gap-small size-full-0 auto-y padding-medium radius-medium bg-shift-200",
		testId = `{p.testId}-eligibility-banner`
	}, {
		Lock = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.LockClosed,
			size = IconSize.Small,
			tag = "auto-xy content-emphasis"
		}),
		Text = React.createElement(Text, {
			LayoutOrder = 2,
			Text = banner,
			tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis"
		}),
		ExternalLink = React.createElement(Icon, {
			LayoutOrder = 3,
			name = IconName.ArrowUpRightFromSquare,
			size = IconSize.Small,
			tag = "auto-xy content-emphasis"
		})
	})
end

local function AudienceConfigurationContent(props)
	local testId = props.testId or "audience-configuration-content"
	local v3 = useAudienceController(props.universeId)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local anchorRef = if v3.tooltipTarget == "Public" then ref2 else ref

	local v4 = v3.isNonPrivateLocked and v3.lockReason == "RatingRequired"
	local handleQuestionnaire = v3.handleQuestionnaire
	local onActivated

	if FFlagBuildExperienceActionOutcomeTelemetry then
		onActivated = React.useCallback(function()
			handleQuestionnaire({ context = ConfigurationActionTelemetry.Context.AudienceBanner })
		end, { handleQuestionnaire })
	else
		onActivated = handleQuestionnaire
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		testId = testId
	}

	local v6 = {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = ref,
			isDisabled = v3.isMutationPending,
			isNonPrivateLocked = v3.isNonPrivateLocked,
			onAudienceActivated = v3.handleAudienceActivated,
			publicLockIconRef = ref2,
			selectedAudience = v3.selectedAudience,
			testId = testId
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = anchorRef,
			isOpen = v3.tooltipTarget ~= nil,
			lockReason = v3.lockReason,
			onPressedOutside = v3.onTooltipPressedOutside,
			testId = testId
		}),
		ContextBanner = 0
	}
	local contextBanner

	if v4 then
		contextBanner = React.createElement(EligibilityBanner, {
			onActivated = onActivated,
			testId = testId
		})
	end

	v6.ContextBanner = contextBanner
	return createElement(View, v5, v6)
end

return AudienceConfigurationContent
