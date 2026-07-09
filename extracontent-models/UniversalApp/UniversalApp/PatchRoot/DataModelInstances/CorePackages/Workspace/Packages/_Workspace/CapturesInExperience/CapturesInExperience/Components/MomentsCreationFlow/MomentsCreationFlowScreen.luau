local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
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

local function MomentsCreationFlowScreen() -- line: 60
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), t1 (copy), useSelector (copy), Constants (copy), React (copy), MomentsCreationFlowClosed (copy), CreateMoment (copy), Dash (copy), CreationFlowContextProvider (copy), CreationFlowScreen (copy)
	local v20 = useAnalytics()
	local v21 = useDispatch()
	local v22 = useLocalization(t1)
	local v23 = useSelector(function(p1) -- line: 66
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].MomentsCreationFlow.IsOpen
	end)
	local v24 = useSelector(function(p2) -- line: 70
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].MomentsCreationFlow.Capture
	end)
	local v25 = React.useCallback(function() -- line: 74
		-- upvalues: v21 (copy), MomentsCreationFlowClosed (copy)
		v21(MomentsCreationFlowClosed())
	end, { v21 })
	local v26 = React.useCallback(function(p3) -- line: 78
		-- upvalues: v22 (copy)
		return v22[p3] or nil
	end, { v22 })
	local v27 = React.useCallback(function(p4, p5, p6) -- line: 83
		-- upvalues: v21 (copy), CreateMoment (copy)
		v21(CreateMoment(p4, p5, p6))
	end, { v21 })

	if not v23 or not v24 then
		return nil
	end

	local t2 = {
		capturesPagesIsFinished = function() -- line: 98
			return true
		end,
		createMoment = v27,
		fetchAdditionalCaptures = Dash.noop,
		fetchInitialCaptures = Dash.noop,
		fireEvent = function(s1: string, p7) -- line: 104
			-- upvalues: v20 (copy)
			v20.fireEvent("XExp" .. s1, p7)
		end,
		getLocalization = v26,
		getUserConfiguration = Dash.noop,
		isTextFiltered = function() -- line: 109
			return false
		end,
		setScreenOrientation = Dash.noop
	}

	return React.createElement(CreationFlowContextProvider, {
		captures = { v24 },
		exitCreationFlow = v25,
		value = t2
	}, {
		Screen = React.createElement(CreationFlowScreen, {
			excludeGallery = true
		})
	})
end

return MomentsCreationFlowScreen
