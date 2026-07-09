local HttpService = game:GetService("HttpService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Logger = require(BuildExperienceParent.Loggers).Logger
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
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
local v27 = game:DefineFastInt("BuildExperienceAudienceTooltipMaxWidth", 220)
local u28 = nil

local function formatDebugTable(t1: {[any]: any}, n1: number) -- line: 59
	-- upvalues: u28 (ref)
	if n1 >= 2 then
		return "{ ... }"
	end

	local t2 = {}

	for v51, v52 in t1 do
		table.insert(t2, `{ tostring(v51) } = { u28(v52, n1 + 1) }`)
	end

	return "{ " .. table.concat(t2, ", ") .. " }"
end

function u28(p1, n2: number?) -- line: 72
	-- upvalues: HttpService (copy), formatDebugTable (copy)
	if typeof(p1) ~= "table" then
		return (tostring(p1))
	end

	local ok, result = pcall(function() -- line: 77
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONEncode(p1)
	end)

	if ok and result ~= nil then
		return result
	end

	return (formatDebugTable(p1, n2 or 0))
end

local function getSelectedAudience(t3: {[any]: any}?) -- line: 87
	-- upvalues: UniverseActivation (copy)
	if t3 == nil then
		return nil
	end

	if t3 then
		for _, v59 in t3 do
			if v59 == UniverseActivation.Audience.Public then
				return "Public"
			end
		end

		for _, v61 in t3 do
			if v61 == UniverseActivation.Audience.Friends then
				return "Friends"
			end
		end
	end

	return "Private"
end
local function isVisibilityAudience(p2) -- line: 109
	-- upvalues: UniverseActivation (copy)
	return p2 == UniverseActivation.Audience.Public or p2 == UniverseActivation.Audience.Friends
end
local function getAudiencesForValue(s1: string, t4: {[any]: any}) -- line: 113
	-- upvalues: UniverseActivation (copy)
	local t5 = {}

	for _, v67 in t4 do
		if v67 ~= UniverseActivation.Audience.Public and v67 ~= UniverseActivation.Audience.Friends then
			table.insert(t5, v67)
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
local function AudienceRow(t6: {[any]: any}) -- line: 143
	-- upvalues: React (copy), Icon (copy), IconName (copy), IconSize (copy), View (copy), List (copy), RadioGroup (copy), InputSize (copy)
	local v69 = React.useCallback(function() -- line: 144
		-- upvalues: t6 (copy)
		t6.onActivated(t6.value)
	end, {
		t6.onActivated,
		t6.value
	})
	local v70 = if not t6.isLocked then nil else React.createElement(Icon, {
		LayoutOrder = 1,
		tag = "auto-xy content-default",
		name = IconName.LockClosed,
		ref = t6.lockIconRef,
		size = IconSize.Small
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y radius-medium",
		LayoutOrder = t6.LayoutOrder,
		onActivated = v69
	}, {
		ListItem = React.createElement(List.Item, {
			LayoutOrder = t6.LayoutOrder,
			title = t6.title,
			trailing = React.createElement(View, {
				tag = "row align-y-center gap-medium auto-xy"
			}, {
				Lock = v70,
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
local function getSelectedAudienceFromState(s2: string?, b1: boolean, p3) -- line: 206
	-- upvalues: getSelectedAudience (copy)
	if s2 ~= nil then
		return s2
	end

	if b1 then
		return (getSelectedAudience(p3.audiences))
	end

	return nil
end
local function getIsNonPrivateLocked(p4, b2: boolean, b3: boolean) -- line: 218
	return b2 and (p4.eligibility == "Required" or b3)
end
local function getUniverseActivationStore(p5) -- line: 226
	-- upvalues: UniverseActivation (copy)
	return UniverseActivation.getUniverseActivationStore(p5)
end
local function getQuestionnaireStore(p6) -- line: 230
	-- upvalues: ExperienceQuestionnaire (copy)
	return ExperienceQuestionnaire.getExperienceQuestionnaireStore(p6)
end
local function getUniverseConfigurationStore(p7) -- line: 234
	-- upvalues: UniverseConfiguration (copy)
	return UniverseConfiguration.getUniverseConfigurationStore(p7)
end
local function useAudienceStores() -- line: 238
	-- upvalues: SignalsReact (copy), getUniverseActivationStore (copy), getQuestionnaireStore (copy), getUniverseConfigurationStore (copy)
	local v80 = SignalsReact.useSignalState(getUniverseActivationStore)
	local v81 = SignalsReact.useSignalState(getQuestionnaireStore)
	local v82 = SignalsReact.useSignalState(getUniverseConfigurationStore)

	return {
		universeActivationStore = v80,
		questionnaireStore = v81,
		universeConfigurationStore = v82
	}
end
local function useAudienceData(n3: number, p8, p9, s3: string?) -- line: 250
	-- upvalues: React (copy), SignalsReact (copy), getSelectedAudience (copy)
	local v87 = React.useMemo(function() -- line: 256
		-- upvalues: p9 (copy), n3 (copy)
		return p9.getAndFetchConfiguration(n3)
	end, {
		n3,
		p9
	})
	local v88 = React.useMemo(function() -- line: 259
		-- upvalues: p8 (copy), n3 (copy)
		return p8.getAndFetchEligibility(n3)
	end, {
		p8,
		n3
	})
	local v89 = React.useMemo(function() -- line: 262
		-- upvalues: p8 (copy), n3 (copy)
		return p8.getAndFetchLatestSubmission(n3)
	end, {
		p8,
		n3
	})
	local v90 = SignalsReact.useSignalState(v87.data)
	local v91 = SignalsReact.useSignalState(v87.status)
	local v92 = SignalsReact.useSignalState(v88.data)
	local v93 = SignalsReact.useSignalState(v88.status)
	local v94 = SignalsReact.useSignalState(v89.data)
	local v95 = SignalsReact.useSignalState(v89.status)
	local v96 = v91 == "Ready" and v90 ~= nil
	local v97 = v93 == "Ready" and v92 ~= nil
	local v98 = v95 == "Ready" and v94 ~= nil
	local v99 = v95 == "Failed"
	local v100 = v97 and (v98 or v99)

	return {
		configurationData = v90,
		isAudiencesReady = v96,
		isNonPrivateLocked = v97 and (v92.eligibility == "Required" or v99),
		isQuestionnaireEligibilityResolved = v100,
		selectedAudience = if s3 == nil then if not v96 then nil else getSelectedAudience(v90.audiences) else s3
	}
end
local function useQuestionnaireHandler(n4: number, p10) -- line: 288
	-- upvalues: useOpenWebView (copy), React (copy), GameConfigurationActions (copy)
	local v103 = useOpenWebView()
	local v104 = React.useCallback(function() -- line: 291
		-- upvalues: p10 (copy), n4 (copy)
		p10.fetchEligibility(n4)
		p10.fetchLatestSubmission(n4)
	end, {
		p10,
		n4
	})

	return React.useCallback(function() -- line: 296
		-- upvalues: v103 (copy), GameConfigurationActions (copy), n4 (copy), v104 (copy)
		v103(GameConfigurationActions.getExperienceQuestionnaireUrl(n4), "Creator Hub", v104)
	end, {
		v103,
		v104,
		n4
	})
end
local function useAudienceController(n5: number) -- line: 305
	-- upvalues: useAudienceStores (copy), React (copy), useAudienceData (copy), useQuestionnaireHandler (copy), getAudiencesForValue (copy), Logger (copy), u28 (ref)
	local v106 = useAudienceStores()
	local v107, v108 = React.useState(nil)
	local v109, v110 = React.useState(false)
	local v111, v112 = React.useState(nil)
	local v113 = useAudienceData(n5, v106.questionnaireStore, v106.universeConfigurationStore, v107)
	local v114 = useQuestionnaireHandler(n5, v106.questionnaireStore)
	local configurationData = v113.configurationData
	local isAudiencesReady = v113.isAudiencesReady
	local isNonPrivateLocked = v113.isNonPrivateLocked
	local isQuestionnaireEligibilityResolved = v113.isQuestionnaireEligibilityResolved

	return {
		handleAudienceActivated = React.useCallback(function(s4: string) -- line: 320
			-- upvalues: isNonPrivateLocked (copy), v112 (copy), isAudiencesReady (copy), isQuestionnaireEligibilityResolved (copy), v109 (copy), getAudiencesForValue (copy), configurationData (copy), v108 (copy), v110 (copy), v106 (copy), n5 (copy), Logger (copy), u28 (ref)
			if isNonPrivateLocked and s4 ~= "Private" then
				v112(function(p11) -- line: 322
					-- upvalues: s4 (copy)
					if p11 == s4 then
						return nil
					end

					return s4
				end)

				return
			end

			if not isAudiencesReady or not isQuestionnaireEligibilityResolved or v109 then
				return
			end

			local v132 = getAudiencesForValue(s4, configurationData.audiences)

			v112(nil)
			v108(s4)
			v110(true)
			v106.universeActivationStore.setAudiences(n5, v132):andThen(function() -- line: 340
				-- upvalues: v106 (copy), n5 (copy), Logger (copy), u28 (ref), v108 (copy), v110 (copy)
				v106.universeActivationStore.activate(n5):andThen(function() -- line: 343
					-- upvalues: v106 (copy), n5 (copy)
					v106.universeConfigurationStore.fetchConfiguration(n5)
				end):catch(function(p12) -- line: 346
					-- upvalues: Logger (copy), n5 (copy), u28 (ref), v108 (copy)
					Logger:warning("AudienceConfigurationContent: failed to activate universe {} after audience update: {}", n5, u28(p12))
					v108(nil)
				end):finally(function() -- line: 354
					-- upvalues: v110 (copy)
					v110(false)
				end)
			end):catch(function(p13) -- line: 358
				-- upvalues: Logger (copy), n5 (copy), u28 (ref), v108 (copy), v110 (copy)
				Logger:warning("AudienceConfigurationContent: failed to set audiences for universe {}: {}", n5, u28(p13))
				v108(nil)
				v110(false)
			end)
		end, {
			configurationData,
			isAudiencesReady,
			v109,
			isNonPrivateLocked,
			isQuestionnaireEligibilityResolved,
			v106.universeActivationStore,
			v106.universeConfigurationStore,
			n5
		}),
		handleQuestionnaire = v114,
		isNonPrivateLocked = v113.isNonPrivateLocked,
		selectedAudience = v113.selectedAudience,
		tooltipTarget = v111
	}
end
local function AudienceHeader() -- line: 389
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	return React.createElement(View, {
		LayoutOrder = 1,
		tag = "col gap-xsmall size-full-0 auto-y"
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = "Experience Audience",
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default"
		}),
		Body = React.createElement(FoundationText, {
			LayoutOrder = 2,
			Text = "Choose who can play after you publish this experience.",
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
		})
	})
end
local function AudienceList(t7: {[any]: any}) -- line: 416
	-- upvalues: React (copy), RadioGroup (copy), List (copy), InputSize (copy), AudienceRow (copy)
	local v120 = React.useCallback(function(s5: string) -- line: 417
		-- upvalues: t7 (copy)
		t7.onAudienceActivated(s5)
	end, { t7.onAudienceActivated })

	return React.createElement(RadioGroup.Root, {
		LayoutOrder = 2,
		Selectable = false,
		tag = "size-full-0 auto-y",
		onValueChanged = v120,
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
				title = "Private",
				value = "Private",
				onActivated = t7.onAudienceActivated,
				testId = t7.testId
			}),
			Friends = React.createElement(AudienceRow, {
				LayoutOrder = 2,
				title = "Friends",
				value = "Friends",
				isLocked = t7.isNonPrivateLocked,
				lockIconRef = t7.friendsLockIconRef,
				onActivated = t7.onAudienceActivated,
				testId = t7.testId
			}),
			Public = React.createElement(AudienceRow, {
				LayoutOrder = 3,
				title = "Public",
				value = "Public",
				isLocked = t7.isNonPrivateLocked,
				lockIconRef = t7.publicLockIconRef,
				onActivated = t7.onAudienceActivated,
				testId = t7.testId
			})
		})
	})
end
local function EligibilityTooltip(t8: {[any]: any}) -- line: 474
	-- upvalues: useTokens (copy), useScaledValue (copy), v27 (copy), React (copy), Popover (copy), PopoverAlign (copy), EnumsRadius (copy), PopoverSide (copy), View (copy), FoundationText (copy)
	local v122 = useTokens()
	local v123 = useScaledValue(v27)

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
			backgroundStyle = v122.Color.System.Contrast,
			radius = EnumsRadius.Small,
			side = PopoverSide.Left
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-xy padding-x-small padding-y-small",
				sizeConstraint = {
					MaxSize = Vector2.new(v123, 1e999)
				}
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					Text = "Not eligible for this audience",
					tag = "auto-xy text-title-small text-wrap text-align-x-left content-inverse-emphasis",
					testId = `{ t8.testId }-eligibility-tooltip--header`
				}),
				Text = React.createElement(FoundationText, {
					LayoutOrder = 2,
					Text = "Expand your audience eligibility on Creator Hub.",
					tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
					testId = `{ t8.testId }-eligibility-tooltip--text`
				})
			})
		})
	})
end
local function EligibilityBanner(t9: {[any]: any}) -- line: 521
	-- upvalues: React (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
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
			Text = "Expand your audience eligibility on Creator Hub",
			tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis"
		}),
		ExternalLink = React.createElement(Icon, {
			LayoutOrder = 3,
			tag = "auto-xy content-emphasis",
			name = IconName.ArrowUpRightFromSquare,
			size = IconSize.Small
		})
	})
end
local function AudienceConfigurationContent(t10: {[any]: any}) -- line: 549
	-- upvalues: useAudienceController (copy), React (copy), View (copy), AudienceHeader (copy), AudienceList (copy), EligibilityTooltip (copy), EligibilityBanner (copy)
	local v126 = t10.testId or "audience-configuration-content"
	local v127 = useAudienceController(t10.universeId)
	local v128 = React.useRef(nil)
	local v129 = React.useRef(nil)
	local v130 = if v127.tooltipTarget ~= "Public" then v128 else v129

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-large",
		LayoutOrder = t10.layoutOrder,
		testId = v126
	}, {
		Header = React.createElement(AudienceHeader),
		List = React.createElement(AudienceList, {
			friendsLockIconRef = v128,
			isNonPrivateLocked = v127.isNonPrivateLocked,
			onAudienceActivated = v127.handleAudienceActivated,
			publicLockIconRef = v129,
			selectedAudience = v127.selectedAudience,
			testId = v126
		}),
		Tooltip = React.createElement(EligibilityTooltip, {
			anchorRef = v130,
			isOpen = v127.tooltipTarget ~= nil,
			testId = v126
		}),
		ContextBanner = if not v127.isNonPrivateLocked then nil else React.createElement(EligibilityBanner, {
			onActivated = v127.handleQuestionnaire,
			testId = v126
		})
	})
end

return AudienceConfigurationContent
