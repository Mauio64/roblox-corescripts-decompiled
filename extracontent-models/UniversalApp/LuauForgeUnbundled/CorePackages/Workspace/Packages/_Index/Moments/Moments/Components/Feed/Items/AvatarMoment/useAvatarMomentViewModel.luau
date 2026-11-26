local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/AvatarMomentView")
local decodeInlineMomentScene = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/decodeInlineMomentScene")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local MomentsHostContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")
local observeGuiOnScreen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/observeGuiOnScreen")
local VerticalPager = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")
local getAvatarSceneStage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/getAvatarSceneStage")
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local FFlagMomentsAvatarSceneStage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsAvatarSceneStage")
local FFlagMomentsAvatarUnthrottleFramerate = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsAvatarUnthrottleFramerate")
local useAvatarMomentFramerateHold = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/useAvatarMomentFramerateHold")

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

	local v10 = if FFlagMomentsAvatarUnthrottleFramerate then useAvatarMomentFramerateHold(ref3) else nil

	local v11 = React.useCallback(function(current)
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

		if v10 ~= nil then
			v10.refresh()
		end
	end, { v10 })
	local v12 = v5.isPlaybackActive and v6 == p2.index
	local feedItemId = moment.recommendationMetadata.feedItemId

	local ref4 = if fFlagProfileRenderAvatarMoments or FFlagMomentsAvatarSceneStage then React.useRef(nil) else nil

	local ref5 = if FFlagMomentsAvatarSceneStage then React.useRef(nil) else nil

	local ref6 = if FFlagMomentsAvatarSceneStage then React.useRef(nil) else nil

	local v13 = if fFlagProfileRenderAvatarMoments then MomentsHostContext.useMomentsHost() else nil
	local v14 = v13 == nil or v13.isTopShell ~= false

	if fFlagProfileRenderAvatarMoments then
		v12 = v14 and v6 == p2.index
	end

	React.useEffect(function()
		if FFlagMomentsAvatarSceneStage or (not v12 or v7 == nil) then
			return
		end

		local setExternalBaseReadiness = v7.setExternalBaseReadiness
		assert(setExternalBaseReadiness ~= nil, "Avatar Moments require external-base readiness")
		setExternalBaseReadiness("Loading")

		ref.current += 1
		local current = ref.current
		local v16 = nil
		local v17 = nil
		local v18 = nil
		local renderSteppedConnection = nil
		local v19 = nil

		local function showScene()
			local v20 = v16

			if v20 == nil or renderSteppedConnection ~= nil then
				return
			end

			local avatarMomentCamera = Workspace.CurrentCamera

			if avatarMomentCamera == nil then
				avatarMomentCamera = Instance.new("Camera")
				avatarMomentCamera.Name = "AvatarMomentCamera"
				avatarMomentCamera.Parent = Workspace
				Workspace.CurrentCamera = avatarMomentCamera
				v19 = avatarMomentCamera
			end

			v18 = {
				instance = avatarMomentCamera,
				cframe = avatarMomentCamera.CFrame,
				focus = avatarMomentCamera.Focus,
				fieldOfView = avatarMomentCamera.FieldOfView,
				fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
				cameraType = avatarMomentCamera.CameraType
			}
			v20.root.Parent = Workspace
			v20.root:PivotTo(cframe)

			local function updateCamera()
				if Workspace.CurrentCamera ~= avatarMomentCamera then
					return
				end

				avatarMomentCamera.CameraType = Enum.CameraType.Scriptable
				avatarMomentCamera.FieldOfViewMode = v20.camera.FieldOfViewMode
				avatarMomentCamera.FieldOfView = v20.camera.FieldOfView
				avatarMomentCamera.CFrame = cframe * v20.camera.CFrame
				avatarMomentCamera.Focus = cframe * v20.camera.Focus
			end

			if Workspace.CurrentCamera == avatarMomentCamera then
				avatarMomentCamera.CameraType = Enum.CameraType.Scriptable
				avatarMomentCamera.FieldOfViewMode = v20.camera.FieldOfViewMode
				avatarMomentCamera.FieldOfView = v20.camera.FieldOfView
				avatarMomentCamera.CFrame = cframe * v20.camera.CFrame
				avatarMomentCamera.Focus = cframe * v20.camera.Focus
			end

			renderSteppedConnection = RunService.RenderStepped:Connect(updateCamera)

			if v10 ~= nil then
				v10.setShown(true)
			end
		end

		local function hideScene()
			local v20 = v16

			if v20 == nil or renderSteppedConnection == nil then
				return
			end

			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil

			if v10 ~= nil then
				v10.setShown(false)
			end

			v20.root.Parent = nil
			local v21 = v18

			if v21 ~= nil and v21.instance.Parent ~= nil and Workspace.CurrentCamera == v21.instance then
				v21.instance.CFrame = v21.cframe
				v21.instance.Focus = v21.focus
				v21.instance.FieldOfView = v21.fieldOfView
				v21.instance.FieldOfViewMode = v21.fieldOfViewMode
				v21.instance.CameraType = v21.cameraType
			end

			v18 = nil

			if v19 ~= nil then
				if Workspace.CurrentCamera == v19 then
					Workspace.CurrentCamera = nil
				end

				v19:Destroy()
				v19 = nil
			end
		end

		task.spawn(function()
			local v20 = "validate-outfit"
			local success, result = pcall(function()
				local source = p2.item.outfit.source

				if source.type ~= "outfit" then
					error("Inline Avatar Moment requires an outfit annotation")
				end

				v20 = "decode-inline-scene"
				local v21 = decodeInlineMomentScene(p2.item.rbxmData, source.id)

				v20 = "create-moment-scene"
				return require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentScenes").createMomentScene({
					type = v21.type,
					args = v21.args
				})
			end)

			if current == ref.current then
				if success and result ~= nil then
					local current2 = if ref4 ~= nil then ref4.current else nil

					if fFlagProfileRenderAvatarMoments and current2 == nil then
						MomentsCommon.Analytics.fireAnalyticsEvent(
							MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
							{
								stage = "attach-page",
								recommendationSource = v5.recommendationSource or "unknown",
								momentId = moment.momentId,
								feedItemId = feedItemId or "unknown"
							}
						)

						setExternalBaseReadiness(
							"Failed",
							"Avatar scene attach-page failed: page ref was not attached"
						)
						pcall(function()
							result.root.Parent = nil
						end)
						pcall(result.dispose)
					else
						v16 = result
						ref2.current = result
						ref3.current = false

						if fFlagProfileRenderAvatarMoments then
							v17 = observeGuiOnScreen(current2, function(p3)
								if p3 then
									showScene()
								else
									hideScene()
								end
							end)
						else
							showScene()
						end

						setExternalBaseReadiness("Ready")
						v11(v7.getState(false).isPlaying)
					end
				else
					MomentsCommon.Analytics.fireAnalyticsEvent(
						MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
						{
							stage = v20,
							recommendationSource = v5.recommendationSource or "unknown",
							momentId = moment.momentId,
							feedItemId = feedItemId or "unknown"
						}
					)

					setExternalBaseReadiness("Failed", `Avatar scene {v20} failed: {tostring(result)}`)
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

			if v17 ~= nil then
				v17()
				v17 = nil
			end

			hideScene()
			local v21 = v16
			v16 = nil

			if v21 ~= nil then
				setExternalBaseReadiness("Loading")

				if ref2.current == v21 then
					ref2.current = nil
					ref3.current = false
				end

				pcall(function()
					v21.root.Parent = nil
				end)
				pcall(v21.dispose)
			end
		end
	end, {
		v12,
		v7,
		p2.item.rbxmData,
		p2.item.outfit.source,
		moment.momentId,
		feedItemId,
		v5.recommendationSource,
		v11,
		v10
	})

	if FFlagMomentsAvatarSceneStage then
		React.useEffect(function()
			local current = if ref4 ~= nil then ref4.current else nil

			if current == nil then
				return nil
			end

			return getAvatarSceneStage().trackPage(current)
		end, {})

		local getIsVisible = VerticalPager.usePagerItem().getIsVisible

		local v15 = SignalsReact.useSignalState(getIsVisible)

		local ref7 = React.useRef({ readiness = "Loading", failureReason = nil })

		local ref8 = React.useRef(v7)
		ref8.current = v7

		local ref9 = React.useRef(v9)
		ref9.current = v9

		local v16 = React.useCallback(function(p3, p4)
			ref7.current = { readiness = p3, failureReason = p4 }
			local current = ref8.current

			if current ~= nil then
				local setExternalBaseReadiness = current.setExternalBaseReadiness
				assert(setExternalBaseReadiness ~= nil, "Avatar Moments require external-base readiness")
				setExternalBaseReadiness(p3, p4)
			end
		end, {})

		React.useEffect(function()
			if v7 ~= nil then
				local current = ref7.current
				v16(current.readiness, current.failureReason)
			end
		end, { v7, v16 })

		React.useEffect(function()
			if not v15 then
				return
			end

			v16("Loading")

			ref.current += 1
			local current = ref.current
			local v18 = nil
			local v19 = nil

			task.spawn(function()
				local v20 = "validate-outfit"
				local success, result = pcall(function()
					local source = p2.item.outfit.source

					if source.type ~= "outfit" then
						error("Inline Avatar Moment requires an outfit annotation")
					end

					v20 = "decode-inline-scene"
					local v21 = decodeInlineMomentScene(p2.item.rbxmData, source.id)

					v20 = "create-moment-scene"
					return require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentScenes").createMomentScene({
						type = v21.type,
						args = v21.args
					})
				end)

				if current == ref.current then
					if success and result ~= nil then
						local current2 = if ref4 ~= nil then ref4.current else nil
						local current3 = if ref5 ~= nil then ref5.current else nil
						local current4 = if ref6 ~= nil then ref6.current else nil

						if current2 == nil or current3 == nil or current4 == nil then
							MomentsCommon.Analytics.fireAnalyticsEvent(
								MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
								{
									stage = "attach-page",
									recommendationSource = v5.recommendationSource or "unknown",
									momentId = moment.momentId,
									feedItemId = feedItemId or "unknown"
								}
							)

							v16("Failed", "Avatar scene attach-page failed: page refs were not attached")
							pcall(function()
								result.root.Parent = nil
							end)
							pcall(result.dispose)
						else
							v18 = result
							ref2.current = result
							ref3.current = false
							v19 = getAvatarSceneStage().register({
								scene = result,
								page = current2,
								viewportFrame = current3,
								worldModel = current4
							})

							if v10 ~= nil then
								v10.trackPage(current2)
							end

							v16("Ready")
							v11(ref9.current)
						end
					else
						MomentsCommon.Analytics.fireAnalyticsEvent(
							MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
							{
								stage = v20,
								recommendationSource = v5.recommendationSource or "unknown",
								momentId = moment.momentId,
								feedItemId = feedItemId or "unknown"
							}
						)

						v16("Failed", `Avatar scene {v20} failed: {tostring(result)}`)
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

				if v10 ~= nil then
					v10.untrackPage()
				end

				if v19 ~= nil then
					v19()
					v19 = nil
				end

				local v21 = v18
				v18 = nil

				if v21 ~= nil then
					v16("Loading")

					if ref2.current == v21 then
						ref2.current = nil
						ref3.current = false
					end

					pcall(function()
						v21.root.Parent = nil
					end)
					pcall(v21.dispose)
				end
			end
		end, {
			v15,
			p2.item.rbxmData,
			p2.item.outfit.source,
			moment.momentId,
			feedItemId,
			v5.recommendationSource,
			v16,
			v11,
			v10
		})
	end

	React.useEffect(function()
		v11(v9)
	end, { v9, v11 })

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
		moment = moment,
		pageRef = ref4,
		viewportFrameRef = ref5,
		worldModelRef = ref6
	}
end

return useAvatarMomentViewModel
