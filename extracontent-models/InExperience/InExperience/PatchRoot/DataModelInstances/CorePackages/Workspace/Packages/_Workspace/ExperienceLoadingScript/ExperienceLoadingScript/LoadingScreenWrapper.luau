local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local parent = ExperienceLoadingScript.Parent

local ExperienceService = game:GetService("ExperienceService")

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Responsive = require(parent.Responsive)
local LoggingProtocol = require(parent.LoggingProtocol)
local MockableProxyServices = require(parent.MockableProxyServices)
local Game = MockableProxyServices.game

local GetGameProductInfo = require(ExperienceLoadingScript.Thunks.GetGameProductInfo)
local GetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Thunks.GetIsSubjectToChinaPolicies)
local GetUniverseId = require(ExperienceLoadingScript.Thunks.GetUniverseId)

local GetFFlagReportFirstExperienceCancelled = require(ExperienceLoadingScript.Flags.GetFFlagReportFirstExperienceCancelled)
local SharedFlags = require(parent.SharedFlags)
local FFlagLoadingScreenControlMilestones = SharedFlags.FFlagLoadingScreenControlMilestones
local LoadingScreenMilestones = require(parent.ProgressLoading.LoadingScreenMilestones)

local SocialExperiments = require(parent.SocialExperiments)
local QueueExperimentation = SocialExperiments.QueueExperimentation

local ProgressLoading = require(parent.ProgressLoading)
local LoadingScreenView = ProgressLoading.LoadingScreenView
local PlaceLauncherState = ProgressLoading.PlaceLauncherState

local createNetworking = ProgressLoading.createNetworking

local function LoadingScreenWrapper(p)
	local placeId = useSelector(function(p2)
		return p2.gameIds and p2.gameIds.placeId or p.placeId
	end)

	local universeId = useSelector(function(p2)
		return p2.gameIds and p2.gameIds.universeId or 0
	end)

	local productInfo = useSelector(function(p2)
		return p2.productInfo
	end)

	local isSubjectToChinaPolicies = useSelector(function(p2)
		return p2.isSubjectToChinaPolicies
	end)

	local v = useDispatch()

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)
	ref.current = Responsive.usePreferredInput()

	React.useEffect(function()
		v(GetUniverseId(createNetworking, placeId))
		v(GetGameProductInfo(placeId))
		v(GetIsSubjectToChinaPolicies())
	end, { placeId, v })

	React.useEffect(function()
		local loadedConnection = game.Loaded:Connect(function()
			setState(true)
		end)
		return function()
			loadedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if not (QueueExperimentation.isInExperiment() and ExperienceService:GetFollowUserId() > 0 and placeId > 0) then
			return
		end

		if ExperienceService:GetPlaceJoinState() == PlaceLauncherState.Queued then
			QueueExperimentation.logExposure()
		else
			local placeJoinStateChangedConnection = ExperienceService.PlaceJoinStateChanged:Connect(function(p2)
				if p2 == PlaceLauncherState.Queued then
					QueueExperimentation.logExposure()
				end
			end)
			return function()
				placeJoinStateChangedConnection:Disconnect()
			end
		end
	end, { placeId })

	local createElement = React.createElement
	local v2 = {
		placeId = placeId,
		universeId = universeId,
		productInfo = productInfo,
		isSubjectToChinaPolicies = isSubjectToChinaPolicies,
		preferredInputRef = ref,
		shouldStartFadeOut = state,
		manageRobloxGuiFocus = true,
		milestones = 0,
		onCloseButtonActivated = 0,
		onGamepadCancel = 0
	}
	local milestones

	if FFlagLoadingScreenControlMilestones then
		milestones = p.milestones
	end

	v2.milestones = milestones
	function v2.onCloseButtonActivated()
		if FFlagLoadingScreenControlMilestones and p.milestones then
			p.milestones.abort(LoadingScreenMilestones.AbortReason.Cancelled)
		end

		if GetFFlagReportFirstExperienceCancelled then
			LoggingProtocol.default:logEventOnce("first_experience_cancelled")
		end

		Game:Shutdown()
	end
	function v2.onGamepadCancel()
		if not Game:IsLoaded() then
			if FFlagLoadingScreenControlMilestones and p.milestones then
				p.milestones.abort(LoadingScreenMilestones.AbortReason.Cancelled)
			end

			Game:Shutdown()
		end
	end

	return createElement(LoadingScreenView, v2)
end

return LoadingScreenWrapper
