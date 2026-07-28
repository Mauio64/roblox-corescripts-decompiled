local HttpService = game:GetService("HttpService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Logger = require(BuildExperienceParent.Loggers).Logger
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ExperienceQuestionnaire = require(BuildExperienceParent.DataHydration.ExperienceQuestionnaire)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
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
local v29 = game:DefineFastInt("BuildExperienceAudienceTooltipMaxWidth", 220)
local u30 = nil

local function formatDebugTable(t1: {[any]: any}, n1: number) -- line: 54
	-- upvalues: u30 (ref)
	if n1 >= 2 then
		return "{ ... }"
	end

	local t2 = {}

	for v53, v54 in t1 do
		table.insert(t2, `{ tostring(v53) } = { u30(v54, n1 + 1) }`)
	end

	return "{ " .. table.concat(t2, ", ") .. " }"
end

function u30(p1, n2: number?) -- line: 67
	-- upvalues: HttpService (copy), formatDebugTable (copy)
	if typeof(p1) ~= "table" then
		return (tostring(p1))
	end

	local ok, result = pcall(function() -- line: 72
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONEncode(p1)
	end)

	if ok and result ~= nil then
		return result
	end

	return (formatDebugTable(p1, n2 or 0))
end

local function getSelectedAudience(t3: {[any]: any}?) -- line: 82
	-- upvalues: UniverseActivation (copy)
	if t3 == nil then
		return nil
	end

	if t3 then
		for _, v61 in t3 do
			if v61 == UniverseActivation.Audience.Public then
				return "Public"
			end
		end

		for _, v63 in t3 do
			if v63 == UniverseActivation.Audience.Friends then
				return "Friends"
			end
		end
	end

	return "Private"
end
local function isVisibilityAudience(p2) -- line: 104
	-- upvalues: UniverseActivation (copy)
	return p2 == UniverseActivation.Audience.Public or p2 == UniverseActivation.Audience.Friends
end
local function getAudiencesForValue(s1: string, t4: {[any]: any}) -- line: 108
	-- upvalues: UniverseActivation (copy)
	local t5 = {}

	for _, v69 in t4 do
		if v69 ~= UniverseActivation.Audience.Public and v69 ~= UniverseActivation.Audience.Friends then
			table.insert(t5, v69)
		end
	end

	if s1 == "Public" then
		table.insert(t5, UniverseActivation.Audience.Public)

		return t5
	end

	if s1 == "Friends" then
		table.insert(t5, UniverseActivation.Audience.Friends)
	end

	return t5
end
local function AudienceRow(t6: {[any]: any}) -- line: 138
	-- upvalues: React (copy), Icon (copy), IconName (copy), IconSize (copy), View (copy), List (copy), RadioGroup (copy), InputSize (copy)
	local v71 = React.useCallback(function() -- line: 139
		-- upvalues: t6 (copy)
		t6.onActivated(t6.value)
	end, {
		t6.onActivated,
		t6.value
	})
	local v72 = if not t6.isLocked then nil else React.createElement(Icon, {
		LayoutOrder = 1,
		tag = "auto-xy content-default",
		name = IconName.LockClosed,
		ref = t6.lockIconRef,
		size = IconSize.Small
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y radius-medium",
		LayoutOrder = t6.LayoutOrder,
		onActivated = v71
	}, {
		ListItem = React.createElement(List.Item, {
			LayoutOrder = t6.LayoutOrder,
			title = t6.title,
			trailing = React.createElement(View, {
				tag = "row align-y-center gap-medium auto-xy"
			}, {
				Lock = v72,
				Radio = React.createElement(RadioGroup.Item, {
					LayoutOrder = 2,
					label = "",
					isDisabled = t6.isLocked,
					size = InputSize.Medium,
					testId = `{ t6.testId }-row-{ string.lower(t6.value) }-radio`,
					value = t6.value
				})
			}),
			testId = `{ t6.testId }-row-{ string.lower(t6.value) }`
		})
	})
end
local function getSelectedAudienceFromState(s2: string?, b1: boolean, p3) -- line: 201
	-- upvalues: getSelectedAudience (copy)
	if s2 ~= nil then
		return s2
	end

	if b1 then
		return (getSelectedAudience(p3.audiences))
	end

	return nil
end
local function getIsNonPrivateLocked(p4, b2: boolean, b3: boolean) -- line: 213
	return b2 and (p4.eligibility == "Required" or b3)
end
local function getUniverseActivationStore(p5) -- line: 221
	-- upvalues: UniverseActivation (copy)
	return UniverseActivation.getUniverseActivationStore(p5)
end
local function getQuestionnaireStore(p6) -- line: 225
	-- upvalues: ExperienceQuestionnaire (copy)
	return ExperienceQuestionnaire.getExperienceQuestionnaireStore(p6)
end
local function getUniverseConfigurationStore(p7) -- line: 229
	-- upvalues: UniverseConfiguration (copy)
	return UniverseConfiguration.getUniverseConfigurationStore(p7)
end
local function useAudienceStores() -- line: 233
	-- upvalues: SignalsReact (copy), getUniverseActivationStore (copy), getQuestionnaireStore (copy), getUniverseConfigurationStore (copy)
	local v82 = SignalsReact.useSignalState(getUniverseActivationStore)
	local v83 = SignalsReact.useSignalState(getQuestionnaireStore)
	local v84 = SignalsReact.useSignalState(getUniverseConfigurationStore)

	return {
		universeActivationStore = v82,
		questionnaireStore = v83,
		universeConfigurationStore = v84
	}
end
local function useAudienceData(n3: number, p8, p9, s3: string?) -- line: 245
	-- upvalues: React (copy), SignalsReact (copy), getSelectedAudience (copy)
	local v89 = React.useMemo(function() -- line: 251
		-- upvalues: p9 (copy), n3 (copy)
		return p9.getAndFetchConfiguration(n3)
	end, {
		n3,
		p9
	})
	local v90 = React.useMemo(function() -- line: 254
		-- upvalues: p8 (copy), n3 (copy)
		return p8.getAndFetchEligibility(n3)
	end, {
		p8,
		n3
	})
	local v91 = React.useMemo(function() -- line: 257
		-- upvalues: p8 (copy), n3 (copy)
		return p8.getAndFetchLatestSubmission(n3)
	end, {
		p8,
		n3
	})
	local v92 = SignalsReact.useSignalState(v89.data)
	local v93 = SignalsReact.useSignalState(v89.status)
	local v94 = SignalsReact.useSignalState(v90.data)
	local v95 = SignalsReact.useSignalState(v90.status)
	local v96 = SignalsReact.useSignalState(v91.data)
	local v97 = SignalsReact.useSignalState(v91.status)
	local v98 = v93 == "Ready" and v92 ~= nil
	local v99 = v95 == "Ready" and v94 ~= nil
	local v100 = v97 == "Ready" and v96 ~= nil
	local v101 = v97 == "Failed"
	local v102 = v99 and (v100 or v101)

	return {
		configurationData = v92,
		isAudiencesReady = v98,
		isNonPrivateLocked = v99 and (v94.eligibility == "Required" or v101),
		isQuestionnaireEligibilityResolved = v102,
		selectedAudience = if s3 == nil then if not v98 then nil else getSelectedAudience(v92.audiences) else s3
	}
end
local function useQuestionnaireHandler(n4: number, p10) -- line: 283
	-- upvalues: useOpenWebView (copy), React (copy), GameConfigurationActions (copy), LocalizationStrings (copy)
	local v105 = useOpenWebView()
	local v106 = React.useCallback(function() -- line: 286
		-- upvalues: p10 (copy), n4 (copy)
		p10.fetchEligibility(n4)
		p10.fetchLatestSubmission(n4)
	end, {
		p10,
		n4
	})

	return React.useCallback(function() -- line: 291
		-- upvalues: v105 (copy), GameConfigurationActions (copy), n4 (copy), LocalizationStrings (copy), v106 (copy)
		v105(GameConfigurationActions.getExperienceQuestionnaireUrl(n4), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, v106)
	end, {
		v105,
		v106,
		n4
	})
end
local function useAudienceController(n5: number) -- line: 300
	-- upvalues: useAudienceStores (copy), React (copy), useAudienceData (copy), useQuestionnaireHandler (copy), getAudiencesForValue (copy), GameConfigurationLabels (copy), Logger (copy), u30 (ref)
	local v108 = useAudienceStores()
	local v109, v110 = React.useState(nil)
	local v111, v112 = React.useState(false)
	local v113, v114 = React.useState(nil)
	local v115 = useAudienceData(n5, v108.questionnaireStore, v108.universeConfigurationStore, v109)
	local v116 = useQuestionnaireHandler(n5, v108.questionnaireStore)
	local configurationData = v115.configurationData
	local isAudiencesReady = v115.isAudiencesReady
	local isNonPrivateLocked = v115.isNonPrivateLocked
	local isQuestionnaireEligibilityResolved = v115.isQuestionnaireEligibilityResolved

	return {
		handleAudienceActivated = React.useCallback(function(s4: string) -- line: 315
			-- upvalues: isNonPrivateLocked (copy), v114 (copy), isAudiencesReady (copy), isQuestionnaireEligibilityResolved (copy), v111 (copy), getAudiencesForValue (copy), configurationData (copy), v110 (copy), v112 (copy), v108 (copy), n5 (copy), GameConfigurationLabels (copy), Logger (copy), u30 (ref)
			if isNonPrivateLocked and s4 ~= "Private" then
				v114(function(p11) -- line: 317
					-- upvalues: s4 (copy)
					if p11 == s4 then
						return nil
					end

					return s4
				end)

				return
			end

			if not isAudiencesReady or not isQuestionnaireEligibilityResolved or v111 then
				return
			end

			local v134 = getAudiencesForValue(s4, configurationData.audiences)

			v114(nil)
			v110(s4)
			v112(true)
			v108.universeActivationStore.setAudiences(n5, v134):andThen(function() -- line: 335
				-- upvalues: v108 (copy), n5 (copy), GameConfigurationLabels (copy), v134 (copy), Logger (copy), u30 (ref), v110 (copy), v112 (copy)
				v108.universeConfigurationStore.updateSummary(n5, {
					privacyType = GameConfigurationLabels.getAudience({
						audiences = v134
					}),
					audiences = v134
				})
				v108.universeActivationStore.activate(n5):andThen(function() -- line: 345
					-- upvalues: v108 (copy), n5 (copy)
					v108.universeConfigurationStore.fetchConfiguration(n5)
				end):catch(function(p12) -- line: 348
					-- upvalues: Logger (copy), n5 (copy), u30 (ref), v110 (copy)
					Logger:warning("AudienceConfigurationContent: failed to activate universe {} after audience update: {}", n5, u30(p12))
					v110(nil)
				end):finally(function() -- line: 356
					-- upvalues: v112 (copy)
					v112(false)
				end)
			end):catch(function(p13) -- line: 360
				-- upvalues: Logger (copy), n5 (copy), u30 (ref), v110 (copy), v112 (copy)
				Logger:warning("AudienceConfigurationContent: failed to set audiences for universe {}: {}", n5, u30(p13))
				v110(nil)
				v112(false)
			end)
		end, {
			configurationData,
			isAudiencesReady,
			v111,
			isNonPrivateLocked,
			isQuestionnaireEligibilityResolved,
			v108.universeActivationStore,
			v108.universeConfigurationStore,
			n5
		}),
		handleQuestionnaire = v116,
		isNonPrivateLocked = v115.isNonPrivateLocked,
		selectedAudience = v115.selectedAudience,
		tooltipTarget = v113
	}
end
local function AudienceHeader() -- line: 391
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
local function AudienceList(t7: {[any]: any}) -- line: 418
	-- upvalues: React (copy), RadioGroup (copy), List (copy), InputSize (copy), AudienceRow (copy), LocalizationStrings (copy)
	local v122 = React.useCallback(function(s5: string) -- line: 419
		-- upvalues: t7 (copy)
		t7.onAudienceActivated(s5)
	end, { t7.onAudienceActivated })

	return React.createElement(RadioGroup.Root, {
		LayoutOrder = 2,
		Selectable = false,
		tag = "size-full-0 auto-y",
		onValueChanged = v122,
		value = t7.selectedAudience == nil and "" or t7.selectedAudience
	}, {
		List = React.createElement(List.Root, {
			isContained = true,
			hasDivider = {
				hasDivider = true,
				isInset = false
			},
			size = InputSize.Medium,
			testId = `{ t7.testId }-list`
		}, {
			Private = React.createElement(AudienceRow, {
				LayoutOrder = 1,
				isLocked = false,
				lockIconRef = nil,
				value = "Private",
				onActivated = t7.onAudienceActivated,
				testId = t7.testId,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE
			}),
			Friends = React.createElement(AudienceRow, {
				LayoutOrder = 2,
				value = "Friends",
				isLocked = t7.isNonPrivateLocked,
				lockIconRef = t7.friendsLockIconRef,
				onActivated = t7.onAudienceActivated,
				testId = t7.testId,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS
			}),
			Public = React.createElement(AudienceRow, {
				LayoutOrder = 3,
				value = "Public",
				isLocked = t7.isNonPrivateLocked,
				lockIconRef = t7.publicLockIconRef,
				onActivated = t7.onAudienceActivated,
				testId = t7.testId,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
			})
		})
	})
end
local function EligibilityTooltip(t8: {[any]: any}) -- line: 476
	-- upvalues: useTokens (copy), useScaledValue (copy), v29 (copy), React (copy), Popover (copy), PopoverAlign (copy), EnumsRadius (copy), PopoverSide (copy), View (copy), FoundationText (copy), LocalizationStrings (copy)
	local v124 = useTokens()
	local v125 = useScaledValue(v29)

	return React.createElement(Popover.Root, {
		isOpen = t8.isOpen,
		testId = `{ t8.testId }-eligibility-tooltip`
	}, {
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = t8.anchorRef
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			selectionGroup = false,
			align = PopoverAlign.Center,
			backgroundStyle = v124.Color.System.Contrast,
			radius = EnumsRadius.Small,
			side = PopoverSide.Left
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
				sizeConstraint = {
					MaxSize = Vector2.new(v125, 1e999)
				}
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-title-small text-wrap text-align-x-left content-inverse-emphasis",
					Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE,
					testId = `{ t8.testId }-eligibility-tooltip--header`
				}),
				Text = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
					Text = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE_DESCRIPTION,
					testId = `{ t8.testId }-eligibility-tooltip--text`
				})
			})
		})
	})
end
local function EligibilityBanner(t9: {[any]: any}) -- line: 523
	-- upvalues: React (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy), LocalizationStrings (copy)
	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "row align-y-center gap-small size-full-0 auto-y padding-medium radius-medium bg-shift-200",
		onActivated = t9.onActivated,
		stateLayer = {},
		testId = `{ t9.testId }-eligibility-banner`
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
local function AudienceConfigurationContent(t10: {[any]: any}) -- line: 551
	-- upvalues: useAudienceController (copy), React (copy), View (copy), AudienceHeader (copy), AudienceList (copy), EligibilityTooltip (copy), EligibilityBanner (copy)
	local v128 = t10.testId or "audience-configuration-content"
	local v129 = useAudienceController(t10.universeId)
	local v130 = React.useRef(nil)
	local v131 = React.useRef(nil)
	local v132 = if v129.tooltipTarget ~= "Public" then v130 else v131

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		LayoutOrder = t10.layoutOrder,
		testId = v128
	}, {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = v130,
			isNonPrivateLocked = v129.isNonPrivateLocked,
			onAudienceActivated = v129.handleAudienceActivated,
			publicLockIconRef = v131,
			selectedAudience = v129.selectedAudience,
			testId = v128
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = v132,
			isOpen = v129.tooltipTarget ~= nil,
			testId = v128
		}),
		ContextBanner = if not v129.isNonPrivateLocked then nil else React.createElement(EligibilityBanner, {
			onActivated = v129.handleQuestionnaire,
			testId = v128
		})
	})
end

return AudienceConfigurationContent
