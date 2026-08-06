local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local ExperienceQuestionnaire = require(BuildExperienceParent.DataHydration.ExperienceQuestionnaire)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)
local debug = CreatorAgentChat.debug
local Icon = Foundation.Icon
local List = Foundation.List
local Popover = Foundation.Popover
local RadioGroup = Foundation.RadioGroup
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local EnumsRadius = Foundation.Enums.Radius
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local v32 = game:DefineFastInt("BuildExperienceAudienceTooltipMaxWidth", 220)

local function getSelectedAudience(t1: {[any]: any}?) -- line: 56
	-- upvalues: UniverseActivation (copy)
	if t1 == nil then
		return nil
	end

	if t1 then
		for _, v53 in t1 do
			if v53 == UniverseActivation.Audience.Public then
				return "Public"
			end
		end

		for _, v55 in t1 do
			if v55 == UniverseActivation.Audience.Friends then
				return "Friends"
			end
		end
	end

	return "Private"
end
local function isVisibilityAudience(p1) -- line: 78
	-- upvalues: UniverseActivation (copy)
	return p1 == UniverseActivation.Audience.Public or p1 == UniverseActivation.Audience.Friends
end
local function getAudiencesForValue(s1: string, t2: {[any]: any}) -- line: 82
	-- upvalues: UniverseActivation (copy)
	local t3 = {}

	for _, v61 in t2 do
		if v61 ~= UniverseActivation.Audience.Public and v61 ~= UniverseActivation.Audience.Friends then
			table.insert(t3, v61)
		end
	end

	if s1 == "Public" then
		table.insert(t3, UniverseActivation.Audience.Public)

		return t3
	end

	if s1 == "Friends" then
		table.insert(t3, UniverseActivation.Audience.Friends)
	end

	return t3
end
local function AudienceRow(t4: {[any]: any}) -- line: 112
	-- upvalues: React (copy), Icon (copy), IconName (copy), IconSize (copy), View (copy), List (copy), RadioGroup (copy), InputSize (copy)
	local v63 = React.useCallback(function() -- line: 113
		-- upvalues: t4 (copy)
		t4.onActivated(t4.value)
	end, {
		t4.onActivated,
		t4.value
	})
	local v64 = if not t4.isLocked then nil else React.createElement(Icon, {
		LayoutOrder = 1,
		tag = "auto-xy content-default",
		name = IconName.LockClosed,
		ref = t4.lockIconRef,
		size = IconSize.Small
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y radius-medium",
		LayoutOrder = t4.LayoutOrder,
		onActivated = v63
	}, {
		ListItem = React.createElement(List.Item, {
			LayoutOrder = t4.LayoutOrder,
			title = t4.title,
			trailing = React.createElement(View, {
				tag = "row align-y-center gap-medium auto-xy"
			}, {
				Lock = v64,
				Radio = React.createElement(RadioGroup.Item, {
					LayoutOrder = 2,
					label = "",
					isDisabled = t4.isLocked,
					size = InputSize.Medium,
					testId = `{ t4.testId }-row-{ string.lower(t4.value) }-radio`,
					value = t4.value
				})
			}),
			testId = `{ t4.testId }-row-{ string.lower(t4.value) }`
		})
	})
end
local function getSelectedAudienceFromState(s2: string?, b1: boolean, p2) -- line: 176
	-- upvalues: getSelectedAudience (copy)
	if s2 ~= nil then
		return s2
	end

	if b1 then
		return (getSelectedAudience(p2.audiences))
	end

	return nil
end
local function getIsNonPrivateLocked(p3, b2: boolean, b3: boolean) -- line: 188
	return b2 and (p3.eligibility == "Required" or b3)
end
local function getUniverseActivationStore(p4) -- line: 196
	-- upvalues: UniverseActivation (copy)
	return UniverseActivation.getUniverseActivationStore(p4)
end
local function getQuestionnaireStore(p5) -- line: 200
	-- upvalues: ExperienceQuestionnaire (copy)
	return ExperienceQuestionnaire.getExperienceQuestionnaireStore(p5)
end
local function getUniverseConfigurationStore(p6) -- line: 204
	-- upvalues: UniverseConfiguration (copy)
	return UniverseConfiguration.getUniverseConfigurationStore(p6)
end
local function useAudienceStores() -- line: 208
	-- upvalues: SignalsReact (copy), getUniverseActivationStore (copy), getQuestionnaireStore (copy), getUniverseConfigurationStore (copy)
	local v74 = SignalsReact.useSignalState(getUniverseActivationStore)
	local v75 = SignalsReact.useSignalState(getQuestionnaireStore)
	local v76 = SignalsReact.useSignalState(getUniverseConfigurationStore)

	return {
		universeActivationStore = v74,
		questionnaireStore = v75,
		universeConfigurationStore = v76
	}
end
local function useAudienceData(n1: number, p7, p8, p9, s3: string?) -- line: 220
	-- upvalues: React (copy), FFlagBuildRehydrateOnPublish (copy), debug (copy), SignalsReact (copy), ContentMaturityUtils (copy), getSelectedAudience (copy)
	local v82 = React.useMemo(function() -- line: 227
		-- upvalues: p9 (copy), n1 (copy)
		return p9.getAndFetchConfiguration(n1)
	end, {
		n1,
		p9
	})
	local v83, v84 = React.useState(FFlagBuildRehydrateOnPublish)

	if FFlagBuildRehydrateOnPublish then
		React.useEffect(function() -- line: 234
			-- upvalues: v84 (copy), p9 (copy), n1 (copy), debug (copy)
			local u136 = true

			v84(true)
			p9.refreshConfiguration(n1):catch(function(p10) -- line: 239
				-- upvalues: debug (copy), n1 (copy)
				debug.log("warn", "AudienceConfigurationContent configuration refresh failed", {
					errorMessage = tostring(p10),
					universeId = n1
				})
			end):finally(function() -- line: 245
				-- upvalues: u136 (ref), v84 (copy)
				if u136 then
					v84(false)
				end
			end)

			return function() -- line: 251
				-- upvalues: u136 (ref)
				u136 = false
			end
		end, {
			p9,
			n1
		})
	end

	local v85 = React.useMemo(function() -- line: 256
		-- upvalues: p7 (copy), n1 (copy)
		return p7.getAndFetchEligibility(n1)
	end, {
		p7,
		n1
	})
	local v86 = React.useMemo(function() -- line: 259
		-- upvalues: p7 (copy), n1 (copy)
		return p7.getAndFetchLatestSubmission(n1)
	end, {
		p7,
		n1
	})
	local v87 = SignalsReact.useSignalState(v82.data)
	local v88 = SignalsReact.useSignalState(v82.status)
	local v89 = SignalsReact.useSignalState(v85.data)
	local v90 = SignalsReact.useSignalState(v85.status)
	local v91 = SignalsReact.useSignalState(v86.data)
	local v92 = SignalsReact.useSignalState(v86.status)
	local v93 = v88 == "Ready" and v87 ~= nil
	local v94 = v90 == "Ready" and v89 ~= nil
	local v95 = v92 == "Ready" and v91 ~= nil
	local v96 = v92 == "Failed"
	local v97 = v94 and (v95 or v96)
	local v102

	if FFlagBuildRehydrateOnPublish then
		local v98 = React.useMemo(function() -- line: 279
			-- upvalues: p8 (copy), n1 (copy)
			return p8.getAndFetchEligibility(n1)
		end, {
			p8,
			n1
		})
		local v99 = SignalsReact.useSignalState(v98.data)
		local v100 = SignalsReact.useSignalState(v98.status)
		local v101 = v94 and (v89.eligibility == "Required" or v96)

		v102 = React.useMemo(function() -- line: 291
			-- upvalues: ContentMaturityUtils (copy), n1 (copy), v101 (copy)
			if not ContentMaturityUtils.isSealBroken(n1) then
				return false
			end

			return ContentMaturityUtils.isContentUnrated(n1) or v101
		end, {
			v99,
			v101,
			n1
		})

		local v103 = v100 == "Ready" or v100 == "Failed"
		local v104 = (v90 == "Ready" or v90 == "Failed") and (v92 == "Ready" or v92 == "Failed")

		v97 = v103 and v104
	else
		v102 = v94 and (v89.eligibility == "Required" or v96)
	end

	return {
		configurationData = v87,
		isAudiencesReady = v93,
		isConfigurationRefreshPending = v83,
		isEligibilityResolved = v97,
		isNonPrivateLocked = v102,
		selectedAudience = if s3 == nil then if not v93 then nil else getSelectedAudience(v87.audiences) else s3
	}
end
local function useQuestionnaireHandler(n2: number, p11) -- line: 320
	-- upvalues: useOpenWebView (copy), React (copy), FFlagBuildRehydrateOnPublish (copy), refreshPublishEligibility (copy), GameConfigurationActions (copy), LocalizationStrings (copy)
	local v107 = useOpenWebView()
	local v108 = React.useCallback(function() -- line: 323
		-- upvalues: FFlagBuildRehydrateOnPublish (copy), refreshPublishEligibility (copy), n2 (copy), p11 (copy)
		if FFlagBuildRehydrateOnPublish then
			refreshPublishEligibility(n2)

			return
		end

		p11.fetchEligibility(n2)
		p11.fetchLatestSubmission(n2)
	end, {
		p11,
		n2
	})

	return React.useCallback(function() -- line: 334
		-- upvalues: v107 (copy), GameConfigurationActions (copy), n2 (copy), LocalizationStrings (copy), v108 (copy)
		v107(GameConfigurationActions.getExperienceQuestionnaireUrl(n2), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, v108)
	end, {
		v107,
		v108,
		n2
	})
end
local function useAudienceController(n3: number) -- line: 343
	-- upvalues: useAudienceStores (copy), React (copy), useAudienceData (copy), useQuestionnaireHandler (copy), getAudiencesForValue (copy), FFlagBuildRehydrateOnPublish (copy), GameConfigurationActions (copy), GameConfigurationLabels (copy), debug (copy)
	local v110 = useAudienceStores()
	local v111, v112 = React.useState(nil)
	local v113, v114 = React.useState(false)
	local v115, v116 = React.useState(nil)
	local v117 = useAudienceData(n3, v110.questionnaireStore, v110.universeActivationStore, v110.universeConfigurationStore, v111)
	local v118 = useQuestionnaireHandler(n3, v110.questionnaireStore)
	local configurationData = v117.configurationData
	local isAudiencesReady = v117.isAudiencesReady
	local isConfigurationRefreshPending = v117.isConfigurationRefreshPending
	local isEligibilityResolved = v117.isEligibilityResolved
	local isNonPrivateLocked = v117.isNonPrivateLocked

	return {
		handleAudienceActivated = React.useCallback(function(s4: string) -- line: 364
			-- upvalues: isNonPrivateLocked (copy), v116 (copy), isAudiencesReady (copy), isEligibilityResolved (copy), v113 (copy), isConfigurationRefreshPending (copy), getAudiencesForValue (copy), configurationData (copy), v112 (copy), v114 (copy), v110 (copy), n3 (copy), FFlagBuildRehydrateOnPublish (copy), GameConfigurationActions (copy), GameConfigurationLabels (copy), debug (copy)
			if isNonPrivateLocked and s4 ~= "Private" then
				v116(function(p12) -- line: 366
					-- upvalues: s4 (copy)
					if p12 == s4 then
						return nil
					end

					return s4
				end)

				return
			end

			if not isAudiencesReady or not isEligibilityResolved or v113 or isConfigurationRefreshPending then
				return
			end

			local v138 = getAudiencesForValue(s4, configurationData.audiences)

			v116(nil)
			v112(s4)
			v114(true)
			v110.universeActivationStore.setAudiences(n3, v138):andThen(function(p13) -- line: 392
				-- upvalues: FFlagBuildRehydrateOnPublish (copy), GameConfigurationActions (copy), n3 (copy), v110 (copy), GameConfigurationLabels (copy), v138 (copy), debug (copy), v112 (copy), v114 (copy)
				if FFlagBuildRehydrateOnPublish then
					GameConfigurationActions.updateCachedAudience(n3, p13.audiences)
				else
					v110.universeConfigurationStore.updateSummary(n3, {
						privacyType = GameConfigurationLabels.getAudience({
							audiences = v138
						}),
						audiences = v138
					})
				end

				v110.universeActivationStore.activate(n3):andThen(function() -- line: 403
					-- upvalues: FFlagBuildRehydrateOnPublish (copy), v110 (copy), n3 (copy)
					if not FFlagBuildRehydrateOnPublish then
						v110.universeConfigurationStore.fetchConfiguration(n3)
					end
				end):catch(function(p14) -- line: 408
					-- upvalues: debug (copy), n3 (copy), v112 (copy)
					debug.log("warn", "AudienceConfigurationContent activate after audience update failed", {
						errorMessage = tostring(p14),
						universeId = n3
					})
					v112(nil)
				end):finally(function() -- line: 419
					-- upvalues: v114 (copy)
					v114(false)
				end)
			end):catch(function(p15) -- line: 423
				-- upvalues: debug (copy), n3 (copy), v112 (copy), v114 (copy)
				debug.log("warn", "AudienceConfigurationContent set audiences failed", {
					errorMessage = tostring(p15),
					universeId = n3
				})
				v112(nil)
				v114(false)
			end)
		end, {
			configurationData,
			isAudiencesReady,
			isConfigurationRefreshPending,
			isEligibilityResolved,
			v113,
			isNonPrivateLocked,
			v110.universeActivationStore,
			v110.universeConfigurationStore,
			n3
		}),
		handleQuestionnaire = v118,
		isNonPrivateLocked = v117.isNonPrivateLocked,
		selectedAudience = v117.selectedAudience,
		tooltipTarget = v115
	}
end
local function AudienceHeader() -- line: 454
	-- upvalues: React (copy), View (copy), FoundationText (copy), LocalizationStrings (copy)
	return React.createElement(View, {
		LayoutOrder = 1,
		tag = "col gap-xsmall size-full-0 auto-y"
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default",
			Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PAGE_TITLE
		}),
		Body = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
			Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BODY
		})
	})
end
local function AudienceList(t5: {[any]: any}) -- line: 481
	-- upvalues: React (copy), RadioGroup (copy), List (copy), InputSize (copy), AudienceRow (copy), LocalizationStrings (copy)
	local v125 = React.useCallback(function(s5: string) -- line: 482
		-- upvalues: t5 (copy)
		t5.onAudienceActivated(s5)
	end, { t5.onAudienceActivated })

	return React.createElement(RadioGroup.Root, {
		LayoutOrder = 2,
		Selectable = false,
		tag = "size-full-0 auto-y",
		onValueChanged = v125,
		value = t5.selectedAudience == nil and "" or t5.selectedAudience
	}, {
		List = React.createElement(List.Root, {
			isContained = true,
			hasDivider = {
				hasDivider = true,
				isInset = false
			},
			size = InputSize.Medium,
			testId = `{ t5.testId }-list`
		}, {
			Private = React.createElement(AudienceRow, {
				LayoutOrder = 1,
				isLocked = false,
				lockIconRef = nil,
				value = "Private",
				onActivated = t5.onAudienceActivated,
				testId = t5.testId,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE
			}),
			Friends = React.createElement(AudienceRow, {
				LayoutOrder = 2,
				value = "Friends",
				isLocked = t5.isNonPrivateLocked,
				lockIconRef = t5.friendsLockIconRef,
				onActivated = t5.onAudienceActivated,
				testId = t5.testId,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS
			}),
			Public = React.createElement(AudienceRow, {
				LayoutOrder = 3,
				value = "Public",
				isLocked = t5.isNonPrivateLocked,
				lockIconRef = t5.publicLockIconRef,
				onActivated = t5.onAudienceActivated,
				testId = t5.testId,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
			})
		})
	})
end
local function EligibilityTooltip(t6: {[any]: any}) -- line: 539
	-- upvalues: useTokens (copy), useScaledValue (copy), v32 (copy), React (copy), Popover (copy), PopoverAlign (copy), EnumsRadius (copy), PopoverSide (copy), View (copy), FoundationText (copy), LocalizationStrings (copy)
	local v127 = useTokens()
	local v128 = useScaledValue(v32)

	return React.createElement(Popover.Root, {
		isOpen = t6.isOpen,
		testId = `{ t6.testId }-eligibility-tooltip`
	}, {
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = t6.anchorRef
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			selectionGroup = false,
			align = PopoverAlign.Center,
			backgroundStyle = v127.Color.System.Contrast,
			radius = EnumsRadius.Small,
			side = PopoverSide.Left
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
				sizeConstraint = {
					MaxSize = Vector2.new(v128, 1e999)
				}
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-title-small text-wrap text-align-x-left content-inverse-emphasis",
					Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE,
					testId = `{ t6.testId }-eligibility-tooltip--header`
				}),
				Text = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
					Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE_DESCRIPTION,
					testId = `{ t6.testId }-eligibility-tooltip--text`
				})
			})
		})
	})
end
local function EligibilityBanner(t7: {[any]: any}) -- line: 586
	-- upvalues: React (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy), LocalizationStrings (copy)
	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "row align-y-center gap-small size-full-0 auto-y padding-medium radius-medium bg-shift-200",
		onActivated = t7.onActivated,
		stateLayer = {},
		testId = `{ t7.testId }-eligibility-banner`
	}, {
		Lock = React.createElement(Icon, {
			LayoutOrder = 1,
			tag = "auto-xy content-emphasis",
			name = IconName.LockClosed,
			size = IconSize.Small
		}),
		Text = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis",
			Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BANNER
		}),
		ExternalLink = React.createElement(Icon, {
			LayoutOrder = 3,
			tag = "auto-xy content-emphasis",
			name = IconName.ArrowUpRightFromSquare,
			size = IconSize.Small
		})
	})
end
local function AudienceConfigurationContent(t8: {[any]: any}) -- line: 614
	-- upvalues: useAudienceController (copy), React (copy), View (copy), AudienceHeader (copy), AudienceList (copy), EligibilityTooltip (copy), EligibilityBanner (copy)
	local v131 = t8.testId or "audience-configuration-content"
	local v132 = useAudienceController(t8.universeId)
	local v133 = React.useRef(nil)
	local v134 = React.useRef(nil)
	local v135 = if v132.tooltipTarget ~= "Public" then v133 else v134

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		LayoutOrder = t8.layoutOrder,
		testId = v131
	}, {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = v133,
			isNonPrivateLocked = v132.isNonPrivateLocked,
			onAudienceActivated = v132.handleAudienceActivated,
			publicLockIconRef = v134,
			selectedAudience = v132.selectedAudience,
			testId = v131
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = v135,
			isOpen = v132.tooltipTarget ~= nil,
			testId = v131
		}),
		ContextBanner = if not v132.isNonPrivateLocked then nil else React.createElement(EligibilityBanner, {
			onActivated = v132.handleQuestionnaire,
			testId = v131
		})
	})
end

return AudienceConfigurationContent
