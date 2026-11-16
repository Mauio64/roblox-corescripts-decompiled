local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/AvatarMomentView")
local decodeInlineMomentScene = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/decodeInlineMomentScene")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")

local cframe = CFrame.new(0, 2000, 0)

local function disposeMomentScene(p2)
	pcall(function()
		p2.root.Parent = nil
	end)
	pcall(p2.dispose)
end

local function saveCamera(data)
	return {
		instance = data,
		cframe = data.CFrame,
		focus = data.Focus,
		fieldOfView = data.FieldOfView,
		fieldOfViewMode = data.FieldOfViewMode,
		cameraType = data.CameraType
	}
end

local function restoreCamera(data)
	if data == nil or data.instance.Parent == nil or Workspace.CurrentCamera ~= data.instance then
		return
	end

	data.instance.CFrame = data.cframe
	data.instance.Focus = data.focus
	data.instance.FieldOfView = data.fieldOfView
	data.instance.FieldOfViewMode = data.fieldOfViewMode
	data.instance.CameraType = data.cameraType
end

local function useAvatarMomentViewModel(p2)
	local v5 = FeedContext.useFeed()
	local getCurrentIndex = v5.getCurrentIndex
	assert(getCurrentIndex ~= nil, "Avatar Moments require the flag-gated feed index")
	local v6 = SignalsReact.useSignalState(getCurrentIndex)
	local ref = React.useRef(0)
	local moment = p2.item.moment
	local v7 = MomentsCommon.Media.useMomentMediaController(moment.momentId)
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			return v7 ~= nil and v7.getState(p3).isPlaying
		end)
	end, { v7 })
	local v9 = SignalsReact.useSignalState(v8)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local v10 = React.useCallback(function(current)
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
	local v11 = v5.isPlaybackActive and v6 == p2.index
	local feedItemId = moment.recommendationMetadata.feedItemId

	React.useEffect(function()
		if not v11 or v7 == nil then
			return
		end

		local setExternalBaseReadiness = v7.setExternalBaseReadiness
		assert(setExternalBaseReadiness ~= nil, "Avatar Moments require external-base readiness")
		setExternalBaseReadiness("Loading")

		ref.current += 1
		local current = ref.current
		local v13 = nil
		local v14 = nil
		local renderSteppedConnection = nil
		local v15 = nil

		task.spawn(function()
			local v16 = "validate-outfit"
			local success, result = pcall(function()
				local source = p2.item.outfit.source

				if source.type ~= "outfit" then
					error("Inline Avatar Moment requires an outfit annotation")
				end

				v16 = "decode-inline-scene"
				local v17 = decodeInlineMomentScene(p2.item.rbxmData, source.id)

				v16 = "create-moment-scene"
				return require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentScenes").createMomentScene(v17)
			end)

			if current == ref.current then
				if success and result ~= nil then
					v13 = result
					ref2.current = result
					ref3.current = false
					local avatarMomentCamera = Workspace.CurrentCamera

					if avatarMomentCamera == nil then
						avatarMomentCamera = Instance.new("Camera")
						avatarMomentCamera.Name = "AvatarMomentCamera"
						avatarMomentCamera.Parent = Workspace
						Workspace.CurrentCamera = avatarMomentCamera
						v15 = avatarMomentCamera
					end

					v14 = {
						instance = avatarMomentCamera,
						cframe = avatarMomentCamera.CFrame,
						focus = avatarMomentCamera.Focus,
						fieldOfView = avatarMomentCamera.FieldOfView,
						fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
						cameraType = avatarMomentCamera.CameraType
					}
					result.root.Parent = Workspace
					result.root:PivotTo(cframe)

					local function updateCamera()
						if Workspace.CurrentCamera ~= avatarMomentCamera then
							return
						end

						avatarMomentCamera.CameraType = Enum.CameraType.Scriptable
						avatarMomentCamera.FieldOfViewMode = result.camera.FieldOfViewMode
						avatarMomentCamera.FieldOfView = result.camera.FieldOfView
						avatarMomentCamera.CFrame = cframe * result.camera.CFrame
						avatarMomentCamera.Focus = cframe * result.camera.Focus
					end

					if Workspace.CurrentCamera == avatarMomentCamera then
						avatarMomentCamera.CameraType = Enum.CameraType.Scriptable
						avatarMomentCamera.FieldOfViewMode = result.camera.FieldOfViewMode
						avatarMomentCamera.FieldOfView = result.camera.FieldOfView
						avatarMomentCamera.CFrame = cframe * result.camera.CFrame
						avatarMomentCamera.Focus = cframe * result.camera.Focus
					end

					renderSteppedConnection = RunService.RenderStepped:Connect(updateCamera)
					setExternalBaseReadiness("Ready")
					v10(v7.getState(false).isPlaying)
				else
					MomentsCommon.Analytics.fireAnalyticsEvent(
						MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
						{
							stage = v16,
							recommendationSource = v5.recommendationSource or "unknown",
							momentId = moment.momentId,
							feedItemId = feedItemId or "unknown"
						}
					)

					setExternalBaseReadiness("Failed", `Avatar scene {v16} failed: {tostring(result)}`)
				end
			elseif success and result ~= nil then
				pcall(function()
					result.root.Parent = nil
				end)
				pcall(result.dispose)
			end
		end)

		return function()
			ref.current += 1

			if renderSteppedConnection ~= nil then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			local v17 = v13
			v13 = nil

			if v17 ~= nil then
				setExternalBaseReadiness("Loading")

				if ref2.current == v17 then
					ref2.current = nil
					ref3.current = false
				end

				local v18 = v14

				if
					v18 ~= nil
					and v18.instance.Parent ~= nil
					and Workspace.CurrentCamera == v18.instance
				then
					v18.instance.CFrame = v18.cframe
					v18.instance.Focus = v18.focus
					v18.instance.FieldOfView = v18.fieldOfView
					v18.instance.FieldOfViewMode = v18.fieldOfViewMode
					v18.instance.CameraType = v18.cameraType
				end

				pcall(function()
					v17.root.Parent = nil
				end)
				pcall(v17.dispose)
			end

			if v15 ~= nil then
				if Workspace.CurrentCamera == v15 then
					Workspace.CurrentCamera = nil
				end

				v15:Destroy()
				v15 = nil
			end
		end
	end, {
		v11,
		v7,
		p2.item.rbxmData,
		p2.item.outfit.source,
		moment.momentId,
		feedItemId,
		v5.recommendationSource,
		v10
	})

	React.useEffect(function()
		v10(v9)
	end, { v9, v10 })

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
				outfit = p2.item.outfit
			}
		end, {
			moment,
			p2.item.outfit,
			recommendationMetadata.feedItemId,
			recommendationMetadata.tracingId
		}),
		moment = moment
	}
end

return useAvatarMomentViewModel
