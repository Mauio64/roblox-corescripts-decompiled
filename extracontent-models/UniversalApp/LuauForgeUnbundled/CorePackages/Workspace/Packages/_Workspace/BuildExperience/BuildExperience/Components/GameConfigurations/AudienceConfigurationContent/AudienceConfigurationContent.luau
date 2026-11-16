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

local Debug = CreatorAgentChat.debug

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
	local v6 = React.useCallback(function()
		props.onActivated(props.value)
	end, { props.onActivated, props.value })
	local formatted = `{props.testId}-row-{string.lower(props.value)}`
	local v7

	if props.isLocked then
		v7 = React.createElement(icon, {
			LayoutOrder = 1,
			name = iconName.LockClosed,
			ref = props.lockIconRef,
			size = iconSize.Small,
			tag = "auto-xy content-default"
		})
	end

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		tag = "size-full-0 auto-y radius-medium",
		testId = 0
	}

	if props.isDisabled then
		v6 = nil
	end

	v9.onActivated = v6

	v9.testId = `{formatted}-button`
	return createElement(view, v9, {
		ListItem = React.createElement(list.Item, {
			LayoutOrder = props.LayoutOrder,
			title = props.title,
			trailing = React.createElement(view, {
				tag = "row align-y-center gap-medium auto-xy"
			}, {
				Lock = v7,
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
	local v6 = React.useMemo(function()
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

	local v7 = SignalsReact.useSignalState(v6.data)
	local v8 = SignalsReact.useSignalState(v6.status) == "Ready" and v7 ~= nil

	local v9 = React.useMemo(function()
		return universeActivationStore.getAndFetchEligibility(p2)
	end, { universeActivationStore, p2 })
	local v10 = SignalsReact.useSignalState(v9.status)
	local v11 = v10 == "Ready" or v10 == "Failed"

	local contentUnrated = ContentMaturityUtils.isContentUnrated(p2)
	local sealBroken = ContentMaturityUtils.isSealBroken(p2)
	local v12 = contentUnrated and (sealBroken and "RatingRequired" or "PublishRequired") or nil
	local v13 = {
		configurationData = v7,
		isAudiencesReady = v8,
		isConfigurationRefreshPending = state2,
		isEligibilityResolved = v11,
		isNonPrivateLocked = v12 ~= nil,
		lockReason = v12,
		selectedAudience = 0
	}

	if state == nil then
		if v8 then
			local audiences = v7.audiences
			state = if audiences ~= nil then v5[UniverseConfiguration.getPrivacyTypeForAudiences(audiences)] else nil
		else
			state = nil
		end
	end

	v13.selectedAudience = state
	return v13
end

local function useQuestionnaireHandler(p2, questionnaireStore)
	local creatorHub = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
	}).creatorHub
	local v6 = useOpenWebView()

	local v7 = React.useCallback(function()
		refreshPublishEligibility(p2)
	end, { questionnaireStore, p2 })

	return React.useCallback(function()
		v6(GameConfigurationActions.getExperienceQuestionnaireUrl(p2), creatorHub, v7)
	end, { creatorHub, v6, v7, p2 })
end

local function cancelEligibilityRecheck(p2)
	local current = p2.current
	p2.current = nil

	if current ~= nil then
		current:cancel()
	end
end

local function useAudienceController(universeId)
	local v6 = useAudienceStores()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(nil)
	local v7 = ref
	React.useEffect(function()
		return function()
			local v8 = ref
			local current = v8.current
			v8.current = nil

			if current ~= nil then
				current:cancel()
			end
		end
	end, { ref, universeId })

	local state3, setState3 = React.useState(nil)
	local v8 = React.useCallback(function()
		setState3(nil)
	end, {})

	local v9 = useAudienceData(universeId, v6.universeActivationStore, v6.universeConfigurationStore, state)
	local v10 = useQuestionnaireHandler(universeId, v6.questionnaireStore)

	local configurationData = v9.configurationData
	local isAudiencesReady = v9.isAudiencesReady
	local isConfigurationRefreshPending = v9.isConfigurationRefreshPending
	local isEligibilityResolved = v9.isEligibilityResolved
	local isNonPrivateLocked = v9.isNonPrivateLocked
	local v11 = not isAudiencesReady or state2 or isConfigurationRefreshPending
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
				if v11 then
					return
				end

				local audiencesForValue = getAudiencesForValue(p2, configurationData.audiences)

				setState3(nil)
				setState(p2)
				setState2(true)

				v6.universeActivationStore.setAudiences(universeId, audiencesForValue):andThen(function(p3)
					GameConfigurationActions.updateCachedAudience(universeId, p3.audiences)
					v6.universeActivationStore.activate(universeId):andThen(function()
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

					setState(nil)
					setState2(false)
				end)
			end

			local v12 = isNonPrivateLocked and p2 ~= "Private"

			if v12 then
				setState3(function(p3)
					if p3 == p2 then
						return nil
					end

					return p2
				end)
			end

			if v11 then
				return
			end

			if not v12 then
				setState2(true)
			end

			local v13 = v7
			local current = v13.current
			v13.current = nil

			if current ~= nil then
				current:cancel()
			end

			if p2 == "Private" then
				applyAudienceChange()
				return
			end

			if not v12 then
				setState(p2)
			end

			local v14 = v6.universeActivationStore.refreshEligibility(universeId)
			v13.current = v14

			v14:catch(function(p3)
				if v13.current == v14 then
					Debug.log("warn", "AudienceConfigurationContent eligibility recheck failed", {
						errorMessage = formatError(p3),
						universeId = universeId
					})
				end
			end):finally(function()
				if v13.current ~= v14 then
					return
				end

				v13.current = nil

				if not ContentMaturityUtils.isContentUnrated(universeId) then
					applyAudienceChange()
				elseif not v12 then
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
			v7,
			v11,
			isEligibilityResolved,
			isNonPrivateLocked,
			v6.universeActivationStore,
			v6.universeConfigurationStore,
			universeId
		}),
		handleQuestionnaire = v10,
		isMutationPending = state2,
		isNonPrivateLocked = v9.isNonPrivateLocked,
		lockReason = v9.lockReason,
		onTooltipPressedOutside = v8,
		selectedAudience = v9.selectedAudience,
		tooltipTarget = state3
	}
end

local function AudienceHeader()
	local v6 = useLocalization({
		body = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BODY,
		title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PAGE_TITLE
	})

	local body = v6.body
	local title = v6.title

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
	local v6 = useLocalization({
		friends = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS,
		private = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE,
		public = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
	})

	local friends = v6.friends
	local private = v6.private
	local public = v6.public
	local v7 = React.useCallback(function(p2)
		props.onAudienceActivated(p2)
	end, { props.onAudienceActivated })

	return React.createElement(radioGroup.Root, {
		LayoutOrder = 2,
		onValueChanged = v7,
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
	local v6 = useLocalization({
		notEligible = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE,
		notEligibleDescription = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE_DESCRIPTION,
		publishRequired = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED,
		publishRequiredDescription = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED_DESCRIPTION
	})

	local notEligible = v6.notEligible
	local v7 = v6.notEligibleDescription
	local v8 = v6.publishRequired
	local publishRequiredDescription = v6.publishRequiredDescription
	local v9 = useTokens()
	local v10 = useScaledValue(defineFastInt)
	local v11 = props.lockReason == "PublishRequired"

	if not v11 then
		v8 = notEligible
	end

	if v11 then
		v7 = publishRequiredDescription
	end

	local v12

	if v11 then
		v12 = `{props.testId}-eligibility-tooltip--publish`
	else
		v12 = `{props.testId}-eligibility-tooltip--not-eligible`
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
				backgroundStyle = v9.Color.System.Contrast,
				hasArrow = true,
				onPressedOutside = props.onPressedOutside,
				radius = radius.Small,
				selectionGroup = false,
				side = popoverSide.Left
			}, {
				Layout = React.createElement(view, {
					tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
					sizeConstraint = { MaxSize = Vector2.new(v10, 1e999) },
					testId = v12
				}, {
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = v8,
						tag = "auto-xy text-title-small text-wrap text-align-x-left content-inverse-emphasis",
						testId = `{props.testId}-eligibility-tooltip--header`
					}),
					Text = React.createElement(text, {
						LayoutOrder = 2,
						Text = v7,
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
	local v6 = useAudienceController(props.universeId)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v7 = if v6.tooltipTarget == "Public" then ref2 else ref

	local v8 = v6.isNonPrivateLocked and v6.lockReason == "RatingRequired"

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		testId = testId
	}

	local v11 = {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = ref,
			isDisabled = v6.isMutationPending,
			isNonPrivateLocked = v6.isNonPrivateLocked,
			onAudienceActivated = v6.handleAudienceActivated,
			publicLockIconRef = ref2,
			selectedAudience = v6.selectedAudience,
			testId = testId
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = v7,
			isOpen = v6.tooltipTarget ~= nil,
			lockReason = v6.lockReason,
			onPressedOutside = v6.onTooltipPressedOutside,
			testId = testId
		}),
		ContextBanner = 0
	}

	local v12 = if v8 then React.createElement(EligibilityBanner, {
		onActivated = v6.handleQuestionnaire,
		testId = testId
	}) else nil
	v11.ContextBanner = v12
	return createElement(view, v10, v11)
end

return AudienceConfigurationContent
