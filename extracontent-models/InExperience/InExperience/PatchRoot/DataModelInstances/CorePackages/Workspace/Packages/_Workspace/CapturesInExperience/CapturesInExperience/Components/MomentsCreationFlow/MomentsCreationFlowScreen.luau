local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local FFlagCapturesInExpUseMomentsCreation = require(parent.Flags.FFlagCapturesInExpUseMomentsCreation)

if FFlagCapturesInExpUseMomentsCreation then
	local MomentsCommon = require(parent2.MomentsCommon)
	require(parent2.MomentsTypes)
	local React = require(parent2.React)
	local RoactUtils = require(parent2.RoactUtils)
	local Signals = require(parent2.Signals)
	local CoreGui = game:GetService("CoreGui")

	local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
	local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

	local Constants = require(parent.Constants)
	local FFlagCapturesInExpStickersAndVoice = require(parent.Flags.FFlagCapturesInExpStickersAndVoice)
	local MomentsCreationFlowClosed = require(parent.Actions.MomentsCreationFlowClosed)
	local useAnalytics = require(parent.Analytics.useAnalytics)

	local eventNames = MomentsCommon.Analytics.EventNames

	local set = {
		[eventNames.EditingFlowNextButtonPressed] = true,
		[eventNames.EditingFlowReturnButtonPressed] = true
	}

	local function isTextFiltered(_: string): boolean
		return false
	end

	local function MomentsCreationScreen(p)
		local MomentsCreation = require(parent2.MomentsCreation)
		local CreateMoment = require(parent.Thunks.CreateMoment)
		local creationFlowScreen = MomentsCreation.CreationFlowScreen
		local getCreationFlowStore = MomentsCreation.Stores.GetCreationFlowStore

		local state, setState = React.useState(function()
			return getCreationFlowStore(false).getSelectedCapture(false)
		end)

		React.useEffect(function()
			return Signals.createEffect(function(p2)
				setState(getCreationFlowStore(p2).getSelectedCapture(p2))
			end)
		end, { getCreationFlowStore })
		local v = state == p.expectedCapture
		local v2 = useDispatch()
		local fireEvent = useAnalytics().fireEvent
		local creationSessionId = useSelector(function(p2)
			return p2[Constants.RoduxKey].MomentsCreationFlow.SessionId
		end)

		local registerAnalyticsListener = MomentsCreation.registerAnalyticsListener

		React.useLayoutEffect(function()
			return registerAnalyticsListener(function(p2: string, options)
				local clone = table.clone(options or {})
				clone.creationSessionId = creationSessionId

				if set[p2] then
					clone.editFlowState = getCreationFlowStore(false).getStep(false)
				end

				fireEvent("XExp" .. p2, clone)
			end)
		end, { getCreationFlowStore, fireEvent, registerAnalyticsListener, creationSessionId })

		local exitCreationFlow = React.useCallback(function()
			v2(MomentsCreationFlowClosed())
		end, { v2 })

		local createMoment = React.useCallback(function(p2, p3, p4: string, p5: string?, _: number?, flag: boolean?)
			v2(CreateMoment(p2, p3, p4, p5, nil, flag))
		end, { v2, CreateMoment })

		local host = React.useMemo(function()
			local v3 = {
				createMoment = createMoment,
				disableDrafts = true,
				disableExperimentExposure = not FFlagCapturesInExpStickersAndVoice,
				exitCreationFlow = exitCreationFlow,
				isTextFiltered = isTextFiltered,
				publishDebounceSeconds = 0.5,
				toolKinds = not FFlagCapturesInExpStickersAndVoice and { "trim", "music", "text" } or nil,
				ttsAudioParent = 0
			}
			local ttsAudioParent

			if FFlagCapturesInExpStickersAndVoice then
				ttsAudioParent = CoreGui
			end

			v3.ttsAudioParent = ttsAudioParent
			return v3
		end, { createMoment, exitCreationFlow })

		React.useEffect(function()
			if not v then
				if FFlagCapturesInExpStickersAndVoice then
					MomentsCreation.resetCreationFlow(MomentsCreation.Enums.CreationFlowState.Preview)
				end

				v2(MomentsCreationFlowClosed())
			end
		end, { v, v2, MomentsCreation })

		if v then
			return React.createElement(creationFlowScreen, { excludeGallery = true, host = host })
		end

		return nil
	end

	local function MomentsCreationFlowScreen()
		local v = useSelector(function(p)
			return p[Constants.RoduxKey].MomentsCreationFlow.IsOpen
		end)

		local expectedCapture = useSelector(function(p)
			return p[Constants.RoduxKey].MomentsCreationFlow.Capture
		end)

		if v and expectedCapture ~= nil then
			return React.createElement(MomentsCreationScreen, { expectedCapture = expectedCapture })
		end

		return nil
	end

	return MomentsCreationFlowScreen
else
	local Cryo = require(parent2.Cryo)
	local Dash = require(parent2.Dash)
	local Localization = require(parent2.Localization)
	local MomentsCommon = require(parent2.MomentsCommon)
	local MomentsCreationFlow = require(parent2.MomentsCreationFlow)
	require(parent2.MomentsTypes)
	local React = require(parent2.React)
	local RoactUtils = require(parent2.RoactUtils)

	local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
	local useLocalization = Localization.Hooks.useLocalization
	local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

	local CreateMoment = require(parent.Thunks.CreateMoment)

	local Constants = require(parent.Constants)
	local MomentsCreationFlowClosed = require(parent.Actions.MomentsCreationFlowClosed)
	local useAnalytics = require(parent.Analytics.useAnalytics)

	local creationFlowContextProvider = MomentsCreationFlow.CreationFlowContextProvider
	local creationFlowLocalization = MomentsCreationFlow.CreationFlowLocalization
	local creationFlowScreen = MomentsCreationFlow.CreationFlowScreen

	local fFlagMomentsCreationBackCta = MomentsCommon.Flags.FFlagMomentsCreationBackCta

	local v = {
		[creationFlowLocalization.CommunityStandardsText] = "Feature.Moments.Description.CommunityStandards",
		[creationFlowLocalization.CreationTooltip] = "Feature.Moments.Tooltip.Creation",
		[creationFlowLocalization.EditingCtaMusic] = "Feature.Moments.Action.AddMusic",
		[creationFlowLocalization.EditingCtaTextOverlay] = "Feature.Moments.Action.AddText",
		[creationFlowLocalization.EditingCtaTrimming] = "Feature.Moments.Action.TrimVideo",
		[creationFlowLocalization.GeneralAllChipLabel] = "Feature.Moments.Label.All",
		[creationFlowLocalization.GeneralCtaBack] = "Feature.Moments.Action.Back",
		[creationFlowLocalization.GeneralCtaCancel] = "Feature.Moments.Action.Cancel",
		[creationFlowLocalization.GeneralCtaDone] = "Feature.Moments.Action.Done",
		[creationFlowLocalization.GeneralCtaLeave] = "Feature.Moments.Action.Leave",
		[creationFlowLocalization.GeneralCtaOk] = "Feature.Moments.Action.Ok",
		[creationFlowLocalization.GeneralCtaShowMore] = "Feature.Moments.Action.ShowMore",
		[creationFlowLocalization.GeneralEmptyStateText] = "Feature.Moments.Description.NothingHereYet",
		[creationFlowLocalization.GeneralPhotosChipLabel] = "Feature.Moments.Label.Photos",
		[creationFlowLocalization.GeneralSearchPlaceholder] = "Feature.Moments.Label.Search",
		[creationFlowLocalization.GeneralVideosChipLabel] = "Feature.Moments.Label.Videos",
		[creationFlowLocalization.LeaveMomentCreationBody] = "Feature.Moments.Description.LeaveMomentsCreation",
		[creationFlowLocalization.LeaveMomentCreationTitle] = "Feature.Moments.Title.LeaveMomentCreation",
		[creationFlowLocalization.MusicNoResults] = "Feature.Moments.Description.NoMusicResults",
		[creationFlowLocalization.PostRemovedTitle] = "Feature.Moments.Title.MomentRemoved",
		[creationFlowLocalization.PublishingCtaContinue] = "Feature.Moments.Action.Continue",
		[creationFlowLocalization.PublishingCtaPrimary] = "Feature.Moments.Action.Post",
		[creationFlowLocalization.PublishingCtaReturn] = fFlagMomentsCreationBackCta and "Feature.Moments.Action.Back" or "Feature.Moments.Action.Return",
		[creationFlowLocalization.PublishingCtaSecondary] = fFlagMomentsCreationBackCta and "Feature.Moments.Action.Back" or "Feature.Moments.Action.ReturnToEditing",
		[creationFlowLocalization.PublishingDescription] = "Feature.Moments.Description.PublishMoment",
		[creationFlowLocalization.StayFriendlyModeration] = "Feature.Moments.Description.StayFriendly"
	}

	local function MomentsCreationFlowScreen()
		local v2 = useAnalytics()
		local v3 = useDispatch()

		local v4 = useLocalization(v)

		local v5 = useSelector(function(p)
			return p[Constants.RoduxKey].MomentsCreationFlow.IsOpen
		end)

		local v6 = useSelector(function(p)
			return p[Constants.RoduxKey].MomentsCreationFlow.Capture
		end)

		local creationSessionId = useSelector(function(p)
			return p[Constants.RoduxKey].MomentsCreationFlow.SessionId
		end)

		local exitCreationFlow = React.useCallback(function()
			v3(MomentsCreationFlowClosed())
		end, { v3 })

		local getLocalization = React.useCallback(function(p)
			return v4[p] or nil
		end, { v4 })

		local createMoment = React.useCallback(function(p, p2, p3)
			v3(CreateMoment(p, p2, p3))
		end, { v3 })

		if v5 and v6 then
			local v7 = {
				capturesPagesIsFinished = function(): boolean
					return true
				end,
				createMoment = createMoment,
				fetchAdditionalCaptures = Dash.noop,
				fetchInitialCaptures = Dash.noop,
				fireEvent = function(p: string, options)
					v2.fireEvent(
						"XExp" .. p,
						Cryo.Dictionary.join(options or {}, {
							creationSessionId = creationSessionId
						})
					)
				end,
				getLocalization = getLocalization,
				getUserConfiguration = Dash.noop,
				isTextFiltered = function(): boolean
					return false
				end,
				setScreenOrientation = Dash.noop
			}

			return React.createElement(creationFlowContextProvider, {
				captures = { v6 },
				exitCreationFlow = exitCreationFlow,
				value = v7
			}, {
				Screen = React.createElement(creationFlowScreen, { excludeGallery = true })
			})
		end

		return nil
	end

	return MomentsCreationFlowScreen
end
