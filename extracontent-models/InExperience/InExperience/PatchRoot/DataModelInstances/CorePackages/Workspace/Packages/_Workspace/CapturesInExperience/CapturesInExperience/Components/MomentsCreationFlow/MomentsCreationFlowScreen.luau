local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Dash = require(ParentParentParent.Dash)
local Localization = require(ParentParentParent.Localization)
local MomentsCreationFlow = require(ParentParentParent.MomentsCreationFlow)

require(ParentParentParent.MomentsTypes)

local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CreateMoment = require(ParentParent.Thunks.CreateMoment)
local Constants = require(ParentParent.Constants)
local MomentsCreationFlowClosed = require(ParentParent.Actions.MomentsCreationFlowClosed)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local CreationFlowContextProvider = MomentsCreationFlow.CreationFlowContextProvider
local CreationFlowLocalization = MomentsCreationFlow.CreationFlowLocalization
local CreationFlowScreen = MomentsCreationFlow.CreationFlowScreen
local t1 = {
	[CreationFlowLocalization.CommunityStandardsText] = "Feature.Moments.Description.CommunityStandards",
	[CreationFlowLocalization.CreationTooltip] = "Feature.Moments.Tooltip.Creation",
	[CreationFlowLocalization.EditingCtaMusic] = "Feature.Moments.Action.AddMusic",
	[CreationFlowLocalization.EditingCtaTextOverlay] = "Feature.Moments.Action.AddText",
	[CreationFlowLocalization.EditingCtaTrimming] = "Feature.Moments.Action.TrimVideo",
	[CreationFlowLocalization.GeneralAllChipLabel] = "Feature.Moments.Label.All",
	[CreationFlowLocalization.GeneralCtaBack] = "Feature.Moments.Action.Back",
	[CreationFlowLocalization.GeneralCtaCancel] = "Feature.Moments.Action.Cancel",
	[CreationFlowLocalization.GeneralCtaDone] = "Feature.Moments.Action.Done",
	[CreationFlowLocalization.GeneralCtaLeave] = "Feature.Moments.Action.Leave",
	[CreationFlowLocalization.GeneralCtaOk] = "Feature.Moments.Action.Ok",
	[CreationFlowLocalization.GeneralCtaShowMore] = "Feature.Moments.Action.ShowMore",
	[CreationFlowLocalization.GeneralEmptyStateText] = "Feature.Moments.Description.NothingHereYet",
	[CreationFlowLocalization.GeneralPhotosChipLabel] = "Feature.Moments.Label.Photos",
	[CreationFlowLocalization.GeneralSearchPlaceholder] = "Feature.Moments.Label.Search",
	[CreationFlowLocalization.GeneralVideosChipLabel] = "Feature.Moments.Label.Videos",
	[CreationFlowLocalization.LeaveMomentCreationBody] = "Feature.Moments.Description.LeaveMomentsCreation",
	[CreationFlowLocalization.LeaveMomentCreationTitle] = "Feature.Moments.Title.LeaveMomentCreation",
	[CreationFlowLocalization.MusicNoResults] = "Feature.Moments.Description.NoMusicResults",
	[CreationFlowLocalization.PostRemovedTitle] = "Feature.Moments.Title.MomentRemoved",
	[CreationFlowLocalization.PublishingCtaContinue] = "Feature.Moments.Action.Continue",
	[CreationFlowLocalization.PublishingCtaPrimary] = "Feature.Moments.Action.Post",
	[CreationFlowLocalization.PublishingCtaReturn] = "Feature.Moments.Action.Return",
	[CreationFlowLocalization.PublishingCtaSecondary] = "Feature.Moments.Action.ReturnToEditing",
	[CreationFlowLocalization.PublishingDescription] = "Feature.Moments.Description.PublishMoment",
	[CreationFlowLocalization.StayFriendlyModeration] = "Feature.Moments.Description.StayFriendly"
}

local function MomentsCreationFlowScreen() -- line: 61
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), t1 (copy), useSelector (copy), Constants (copy), React (copy), MomentsCreationFlowClosed (copy), CreateMoment (copy), Dash (copy), Cryo (copy), CreationFlowContextProvider (copy), CreationFlowScreen (copy)
	local v21 = useAnalytics()
	local v22 = useDispatch()
	local v23 = useLocalization(t1)
	local v24 = useSelector(function(p1) -- line: 67
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].MomentsCreationFlow.IsOpen
	end)
	local v25 = useSelector(function(p2) -- line: 71
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].MomentsCreationFlow.Capture
	end)
	local v26 = useSelector(function(p3) -- line: 75
		-- upvalues: Constants (copy)
		return p3[Constants.RoduxKey].MomentsCreationFlow.SessionId
	end)
	local v27 = React.useCallback(function() -- line: 79
		-- upvalues: v22 (copy), MomentsCreationFlowClosed (copy)
		v22(MomentsCreationFlowClosed())
	end, { v22 })
	local v28 = React.useCallback(function(p4) -- line: 83
		-- upvalues: v23 (copy)
		return v23[p4] or nil
	end, { v23 })
	local v29 = React.useCallback(function(p5, p6, p7) -- line: 88
		-- upvalues: v22 (copy), CreateMoment (copy)
		v22(CreateMoment(p5, p6, p7))
	end, { v22 })

	if not v24 or not v25 then
		return nil
	end

	local t2 = {
		capturesPagesIsFinished = function() -- line: 103
			return true
		end,
		createMoment = v29,
		fetchAdditionalCaptures = Dash.noop,
		fetchInitialCaptures = Dash.noop,
		fireEvent = function(s1: string, p8) -- line: 109
			-- upvalues: v21 (copy), Cryo (copy), v26 (copy)
			v21.fireEvent("XExp" .. s1, Cryo.Dictionary.join(p8 or {}, {
				creationSessionId = v26
			}))
		end,
		getLocalization = v28,
		getUserConfiguration = Dash.noop,
		isTextFiltered = function() -- line: 119
			return false
		end,
		setScreenOrientation = Dash.noop
	}

	return React.createElement(CreationFlowContextProvider, {
		captures = { v25 },
		exitCreationFlow = v27,
		value = t2
	}, {
		Screen = React.createElement(CreationFlowScreen, {
			excludeGallery = true
		})
	})
end

return MomentsCreationFlowScreen
