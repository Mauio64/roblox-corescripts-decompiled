local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local MomentsCommon = require(parent.MomentsCommon)

require(script.Parent.AvatarMomentView)
local decodeInlineMomentScene = require(script.Parent.decodeInlineMomentScene)
local FeedContext = require(Moments.Components.Feed.FeedContext)
require(Moments.Components.Feed.FeedTypes)
require(Moments.Components.Feed.Items.Moment.MomentContext)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)

local cframe = CFrame.new(0, 2000, 0)

local function disposeMomentScene(p) -- 2 equivalent calls inferred from this helper
	pcall(function()
		p.root.Parent = nil
	end)
	pcall(p.dispose)
end

local function saveCamera(avatarMomentCamera) -- 1 equivalent call inferred from this helper
	return {
		instance = avatarMomentCamera,
		cframe = avatarMomentCamera.CFrame,
		focus = avatarMomentCamera.Focus,
		fieldOfView = avatarMomentCamera.FieldOfView,
		fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
		cameraType = avatarMomentCamera.CameraType
	}
end

local function restoreCamera(data) -- 1 equivalent call inferred from this helper
	if data == nil or data.instance.Parent == nil or Workspace.CurrentCamera ~= data.instance then
		return
	end

	data.instance.CFrame = data.cframe
	data.instance.Focus = data.focus
	data.instance.FieldOfView = data.fieldOfView
	data.instance.FieldOfViewMode = data.fieldOfViewMode
	data.instance.CameraType = data.cameraType
end

local function useAvatarMomentViewModel(p)
	local v = FeedContext.useFeed()
	local getCurrentIndex = v.getCurrentIndex
	assert(getCurrentIndex ~= nil, "Avatar Moments require the flag-gated feed index")
	local v2 = SignalsReact.useSignalState(getCurrentIndex)
	local ref = React.useRef(0)
	local moment = p.item.moment
	local v3 = MomentsCommon.Media.useMomentMediaController(moment.momentId)
	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return v3 ~= nil and v3.getState(p2).isPlaying
		end)
	end, { v3 })
	local v5 = SignalsReact.useSignalState(v4)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local v6 = React.useCallback(function(current: boolean)
		local current2 = ref2.current

		if current2 == nil or ref3.current == current then
			return
		end

		ref3.current = current

		if current then
			current2.playhead.play()
		else
			current2.playhead.pause()
		end
	end, {})
	local v7 = v.isPlaybackActive and v2 == p.index
	local feedItemId = moment.recommendationMetadata.feedItemId

	React.useEffect(function()
		if not v7 or v3 == nil then
			return
		end

		local setExternalBaseReadiness = v3.setExternalBaseReadiness
		assert(setExternalBaseReadiness ~= nil, "Avatar Moments require external-base readiness")
		setExternalBaseReadiness("Loading")

		ref.current += 1
		local current = ref.current
		local v8 = nil
		local v9 = nil
		local renderSteppedConnection = nil
		local v10 = nil

		task.spawn(function()
			local stage = "validate-outfit"
			local success, result = pcall(function()
				local source = p.item.outfit.source

				if source.type ~= "outfit" then
					error("Inline Avatar Moment requires an outfit annotation")
				end

				stage = "decode-inline-scene"
				local v11 = decodeInlineMomentScene(p.item.rbxmData, source.id)

				stage = "create-moment-scene"
				local MomentScenes = require(parent.MomentScenes)
				return MomentScenes.createMomentScene(v11)
			end)

			if current == ref.current then
				if success and result ~= nil then
					v8 = result
					ref2.current = result
					ref3.current = false
					local avatarMomentCamera = Workspace.CurrentCamera

					if avatarMomentCamera == nil then
						avatarMomentCamera = Instance.new("Camera")
						avatarMomentCamera.Name = "AvatarMomentCamera"
						avatarMomentCamera.Parent = Workspace
						Workspace.CurrentCamera = avatarMomentCamera
						v10 = avatarMomentCamera
					end

					v9 = saveCamera(avatarMomentCamera) -- inferred equivalent call
					result.root.Parent = Workspace
					result.root:PivotTo(cframe)

					local function updateCamera() -- 1 equivalent call inferred from this helper
						if Workspace.CurrentCamera ~= avatarMomentCamera then
							return
						end

						avatarMomentCamera.CameraType = Enum.CameraType.Scriptable
						avatarMomentCamera.FieldOfViewMode = result.camera.FieldOfViewMode
						avatarMomentCamera.FieldOfView = result.camera.FieldOfView
						avatarMomentCamera.CFrame = cframe * result.camera.CFrame
						avatarMomentCamera.Focus = cframe * result.camera.Focus
					end

					updateCamera() -- inferred equivalent call
					renderSteppedConnection = RunService.RenderStepped:Connect(updateCamera)
					setExternalBaseReadiness("Ready")
					v6(v3.getState(false).isPlaying)
				else
					MomentsCommon.Analytics.fireAnalyticsEvent(
						MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
						{
							stage = stage,
							recommendationSource = v.recommendationSource or "unknown",
							momentId = moment.momentId,
							feedItemId = feedItemId or "unknown"
						}
					)

					setExternalBaseReadiness("Failed", `Avatar scene {stage} failed: {tostring(result)}`)
				end
			elseif success and result ~= nil then
				disposeMomentScene(result) -- inferred equivalent call
			end
		end)

		return function()
			ref.current += 1

			if renderSteppedConnection ~= nil then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			local v11 = v8
			v8 = nil

			if v11 ~= nil then
				setExternalBaseReadiness("Loading")

				if ref2.current == v11 then
					ref2.current = nil
					ref3.current = false
				end

				restoreCamera(v9) -- inferred equivalent call
				disposeMomentScene(v11) -- inferred equivalent call
			end

			if v10 ~= nil then
				if Workspace.CurrentCamera == v10 then
					Workspace.CurrentCamera = nil
				end

				v10:Destroy()
				v10 = nil
			end
		end
	end, {
		v7,
		v3,
		p.item.rbxmData,
		p.item.outfit.source,
		moment.momentId,
		feedItemId,
		v.recommendationSource,
		v6
	})

	React.useEffect(function()
		v6(v5)
	end, { v5, v6 })

	local recommendationMetadata = moment.recommendationMetadata
	return {
		data = React.useMemo(function()
			return {
				kind = "avatar",
				momentId = moment.momentId,
				creatorId = moment.creatorId,
				creatorIsVerified = nil,
				description = moment.metadata.description,
				isModerated = moment.isModerated == true,
				commentCount = nil,
				feedItemId = recommendationMetadata.feedItemId,
				feedSessionId = recommendationMetadata.tracingId,
				contentType = FFlagMomentsRecommendationContentType and "Avatar" or nil,
				outfit = p.item.outfit
			}
		end, {
			moment,
			p.item.outfit,
			recommendationMetadata.feedItemId,
			recommendationMetadata.tracingId
		}),
		moment = moment
	}
end

return useAvatarMomentViewModel
