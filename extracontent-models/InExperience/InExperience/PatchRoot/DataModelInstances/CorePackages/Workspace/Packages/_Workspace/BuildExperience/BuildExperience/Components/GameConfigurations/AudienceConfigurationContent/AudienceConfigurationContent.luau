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
local v28 = game:DefineFastInt("BuildExperienceAudienceTooltipMaxWidth", 220)
local u29 = nil

local function formatDebugTable(t1: {[any]: any}, n1: number) -- line: 53
	-- upvalues: u29 (ref)
	if n1 >= 2 then
		return "{ ... }"
	end

	local t2 = {}

	for v52, v53 in t1 do
		table.insert(t2, `{ tostring(v52) } = { u29(v53, n1 + 1) }`)
	end

	return "{ " .. table.concat(t2, ", ") .. " }"
end

function u29(p1, n2: number?) -- line: 66
	-- upvalues: HttpService (copy), formatDebugTable (copy)
	if typeof(p1) ~= "table" then
		return (tostring(p1))
	end

	local ok, result = pcall(function() -- line: 71
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONEncode(p1)
	end)

	if ok and result ~= nil then
		return result
	end

	return (formatDebugTable(p1, n2 or 0))
end

local function getSelectedAudience(t3: {[any]: any}?) -- line: 81
	-- upvalues: UniverseActivation (copy)
	if t3 == nil then
		return nil
	end

	if t3 then
		for _, v60 in t3 do
			if v60 == UniverseActivation.Audience.Public then
				return "Public"
			end
		end

		for _, v62 in t3 do
			if v62 == UniverseActivation.Audience.Friends then
				return "Friends"
			end
		end
	end

	return "Private"
end
local function isVisibilityAudience(p2) -- line: 103
	-- upvalues: UniverseActivation (copy)
	return p2 == UniverseActivation.Audience.Public or p2 == UniverseActivation.Audience.Friends
end
local function getAudiencesForValue(s1: string, t4: {[any]: any}) -- line: 107
	-- upvalues: UniverseActivation (copy)
	local t5 = {}

	for _, v68 in t4 do
		if v68 ~= UniverseActivation.Audience.Public and v68 ~= UniverseActivation.Audience.Friends then
			table.insert(t5, v68)
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
local function AudienceRow(t6: {[any]: any}) -- line: 137
	-- upvalues: React (copy), Icon (copy), IconName (copy), IconSize (copy), View (copy), List (copy), RadioGroup (copy), InputSize (copy)
	local v70 = React.useCallback(function() -- line: 138
		-- upvalues: t6 (copy)
		t6.onActivated(t6.value)
	end, {
		t6.onActivated,
		t6.value
	})
	local v71 = if not t6.isLocked then nil else React.createElement(Icon, {
		LayoutOrder = 1,
		tag = "auto-xy content-default",
		name = IconName.LockClosed,
		ref = t6.lockIconRef,
		size = IconSize.Small
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y radius-medium",
		LayoutOrder = t6.LayoutOrder,
		onActivated = v70
	}, {
		ListItem = React.createElement(List.Item, {
			LayoutOrder = t6.LayoutOrder,
			title = t6.title,
			trailing = React.createElement(View, {
				tag = "row align-y-center gap-medium auto-xy"
			}, {
				Lock = v71,
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
local function getSelectedAudienceFromState(s2: string?, b1: boolean, p3) -- line: 200
	-- upvalues: getSelectedAudience (copy)
	if s2 ~= nil then
		return s2
	end

	if b1 then
		return (getSelectedAudience(p3.audiences))
	end

	return nil
end
local function getIsNonPrivateLocked(p4, b2: boolean, b3: boolean) -- line: 212
	return b2 and (p4.eligibility == "Required" or b3)
end
local function getUniverseActivationStore(p5) -- line: 220
	-- upvalues: UniverseActivation (copy)
	return UniverseActivation.getUniverseActivationStore(p5)
end
local function getQuestionnaireStore(p6) -- line: 224
	-- upvalues: ExperienceQuestionnaire (copy)
	return ExperienceQuestionnaire.getExperienceQuestionnaireStore(p6)
end
local function getUniverseConfigurationStore(p7) -- line: 228
	-- upvalues: UniverseConfiguration (copy)
	return UniverseConfiguration.getUniverseConfigurationStore(p7)
end
local function useAudienceStores() -- line: 232
	-- upvalues: SignalsReact (copy), getUniverseActivationStore (copy), getQuestionnaireStore (copy), getUniverseConfigurationStore (copy)
	local v81 = SignalsReact.useSignalState(getUniverseActivationStore)
	local v82 = SignalsReact.useSignalState(getQuestionnaireStore)
	local v83 = SignalsReact.useSignalState(getUniverseConfigurationStore)

	return {
		universeActivationStore = v81,
		questionnaireStore = v82,
		universeConfigurationStore = v83
	}
end
local function useAudienceData(n3: number, p8, p9, s3: string?) -- line: 244
	-- upvalues: React (copy), SignalsReact (copy), getSelectedAudience (copy)
	local v88 = React.useMemo(function() -- line: 250
		-- upvalues: p9 (copy), n3 (copy)
		return p9.getAndFetchConfiguration(n3)
	end, {
		n3,
		p9
	})
	local v89 = React.useMemo(function() -- line: 253
		-- upvalues: p8 (copy), n3 (copy)
		return p8.getAndFetchEligibility(n3)
	end, {
		p8,
		n3
	})
	local v90 = React.useMemo(function() -- line: 256
		-- upvalues: p8 (copy), n3 (copy)
		return p8.getAndFetchLatestSubmission(n3)
	end, {
		p8,
		n3
	})
	local v91 = SignalsReact.useSignalState(v88.data)
	local v92 = SignalsReact.useSignalState(v88.status)
	local v93 = SignalsReact.useSignalState(v89.data)
	local v94 = SignalsReact.useSignalState(v89.status)
	local v95 = SignalsReact.useSignalState(v90.data)
	local v96 = SignalsReact.useSignalState(v90.status)
	local v97 = v92 == "Ready" and v91 ~= nil
	local v98 = v94 == "Ready" and v93 ~= nil
	local v99 = v96 == "Ready" and v95 ~= nil
	local v100 = v96 == "Failed"
	local v101 = v98 and (v99 or v100)

	return {
		configurationData = v91,
		isAudiencesReady = v97,
		isNonPrivateLocked = v98 and (v93.eligibility == "Required" or v100),
		isQuestionnaireEligibilityResolved = v101,
		selectedAudience = if s3 == nil then if not v97 then nil else getSelectedAudience(v91.audiences) else s3
	}
end
local function useQuestionnaireHandler(n4: number, p10) -- line: 282
	-- upvalues: useOpenWebView (copy), React (copy), GameConfigurationActions (copy), LocalizationStrings (copy)
	local v104 = useOpenWebView()
	local v105 = React.useCallback(function() -- line: 285
		-- upvalues: p10 (copy), n4 (copy)
		p10.fetchEligibility(n4)
		p10.fetchLatestSubmission(n4)
	end, {
		p10,
		n4
	})

	return React.useCallback(function() -- line: 290
		-- upvalues: v104 (copy), GameConfigurationActions (copy), n4 (copy), LocalizationStrings (copy), v105 (copy)
		v104(GameConfigurationActions.getExperienceQuestionnaireUrl(n4), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, v105)
	end, {
		v104,
		v105,
		n4
	})
end
local function useAudienceController(n5: number) -- line: 299
	-- upvalues: useAudienceStores (copy), React (copy), useAudienceData (copy), useQuestionnaireHandler (copy), getAudiencesForValue (copy), Logger (copy), u29 (ref)
	local v107 = useAudienceStores()
	local v108, v109 = React.useState(nil)
	local v110, v111 = React.useState(false)
	local v112, v113 = React.useState(nil)
	local v114 = useAudienceData(n5, v107.questionnaireStore, v107.universeConfigurationStore, v108)
	local v115 = useQuestionnaireHandler(n5, v107.questionnaireStore)
	local configurationData = v114.configurationData
	local isAudiencesReady = v114.isAudiencesReady
	local isNonPrivateLocked = v114.isNonPrivateLocked
	local isQuestionnaireEligibilityResolved = v114.isQuestionnaireEligibilityResolved

	return {
		handleAudienceActivated = React.useCallback(function(s4: string) -- line: 314
			-- upvalues: isNonPrivateLocked (copy), v113 (copy), isAudiencesReady (copy), isQuestionnaireEligibilityResolved (copy), v110 (copy), getAudiencesForValue (copy), configurationData (copy), v109 (copy), v111 (copy), v107 (copy), n5 (copy), Logger (copy), u29 (ref)
			if isNonPrivateLocked and s4 ~= "Private" then
				v113(function(p11) -- line: 316
					-- upvalues: s4 (copy)
					if p11 == s4 then
						return nil
					end

					return s4
				end)

				return
			end

			if not isAudiencesReady or not isQuestionnaireEligibilityResolved or v110 then
				return
			end

			local v133 = getAudiencesForValue(s4, configurationData.audiences)

			v113(nil)
			v109(s4)
			v111(true)
			v107.universeActivationStore.setAudiences(n5, v133):andThen(function() -- line: 334
				-- upvalues: v107 (copy), n5 (copy), Logger (copy), u29 (ref), v109 (copy), v111 (copy)
				v107.universeActivationStore.activate(n5):andThen(function() -- line: 337
					-- upvalues: v107 (copy), n5 (copy)
					v107.universeConfigurationStore.fetchConfiguration(n5)
				end):catch(function(p12) -- line: 340
					-- upvalues: Logger (copy), n5 (copy), u29 (ref), v109 (copy)
					Logger:warning("AudienceConfigurationContent: failed to activate universe {} after audience update: {}", n5, u29(p12))
					v109(nil)
				end):finally(function() -- line: 348
					-- upvalues: v111 (copy)
					v111(false)
				end)
			end):catch(function(p13) -- line: 352
				-- upvalues: Logger (copy), n5 (copy), u29 (ref), v109 (copy), v111 (copy)
				Logger:warning("AudienceConfigurationContent: failed to set audiences for universe {}: {}", n5, u29(p13))
				v109(nil)
				v111(false)
			end)
		end, {
			configurationData,
			isAudiencesReady,
			v110,
			isNonPrivateLocked,
			isQuestionnaireEligibilityResolved,
			v107.universeActivationStore,
			v107.universeConfigurationStore,
			n5
		}),
		handleQuestionnaire = v115,
		isNonPrivateLocked = v114.isNonPrivateLocked,
		selectedAudience = v114.selectedAudience,
		tooltipTarget = v112
	}
end
local function AudienceHeader() -- line: 383
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
local function AudienceList(t7: {[any]: any}) -- line: 410
	-- upvalues: React (copy), RadioGroup (copy), List (copy), InputSize (copy), AudienceRow (copy), LocalizationStrings (copy)
	local v121 = React.useCallback(function(s5: string) -- line: 411
		-- upvalues: t7 (copy)
		t7.onAudienceActivated(s5)
	end, { t7.onAudienceActivated })

	return React.createElement(RadioGroup.Root, {
		LayoutOrder = 2,
		Selectable = false,
		tag = "size-full-0 auto-y",
		onValueChanged = v121,
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
local function EligibilityTooltip(t8: {[any]: any}) -- line: 468
	-- upvalues: useTokens (copy), useScaledValue (copy), v28 (copy), React (copy), Popover (copy), PopoverAlign (copy), EnumsRadius (copy), PopoverSide (copy), View (copy), FoundationText (copy), LocalizationStrings (copy)
	local v123 = useTokens()
	local v124 = useScaledValue(v28)

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
			backgroundStyle = v123.Color.System.Contrast,
			radius = EnumsRadius.Small,
			side = PopoverSide.Left
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
				sizeConstraint = {
					MaxSize = Vector2.new(v124, 1e999)
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
local function EligibilityBanner(t9: {[any]: any}) -- line: 515
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
local function AudienceConfigurationContent(t10: {[any]: any}) -- line: 543
	-- upvalues: useAudienceController (copy), React (copy), View (copy), AudienceHeader (copy), AudienceList (copy), EligibilityTooltip (copy), EligibilityBanner (copy)
	local v127 = t10.testId or "audience-configuration-content"
	local v128 = useAudienceController(t10.universeId)
	local v129 = React.useRef(nil)
	local v130 = React.useRef(nil)
	local v131 = if v128.tooltipTarget ~= "Public" then v129 else v130

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		LayoutOrder = t10.layoutOrder,
		testId = v127
	}, {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = v129,
			isNonPrivateLocked = v128.isNonPrivateLocked,
			onAudienceActivated = v128.handleAudienceActivated,
			publicLockIconRef = v130,
			selectedAudience = v128.selectedAudience,
			testId = v127
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = v131,
			isOpen = v128.tooltipTarget ~= nil,
			testId = v127
		}),
		ContextBanner = if not v128.isNonPrivateLocked then nil else React.createElement(EligibilityBanner, {
			onActivated = v128.handleQuestionnaire,
			testId = v127
		})
	})
end

return AudienceConfigurationContent
