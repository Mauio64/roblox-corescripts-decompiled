local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local MomentsCommon = require(parent.MomentsCommon)

require(script.Parent.AvatarMomentView)
local decodeInlineMomentScene = require(script.Parent.decodeInlineMomentScene)
local FeedContext = require(Moments.Components.Feed.FeedContext)
require(Moments.Components.Feed.FeedTypes)
require(Moments.Components.Feed.Items.Moment.MomentContext)
local MomentsHostContext = require(Moments.MomentsHostContext)
local observeGuiOnScreen = require(script.Parent.observeGuiOnScreen)
local VerticalPager = require(Moments.Components.VerticalPager)
local getAvatarSceneStage = require(script.Parent.getAvatarSceneStage)
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local FFlagMomentsAvatarSceneStage = require(Moments.Flags.FFlagMomentsAvatarSceneStage)
local FFlagMomentsAvatarUnthrottleFramerate = require(Moments.Flags.FFlagMomentsAvatarUnthrottleFramerate)
local useAvatarMomentFramerateHold = require(script.Parent.useAvatarMomentFramerateHold)

local cframe = CFrame.new(0, 2000, 0)

local function disposeMomentScene(p) -- 6 equivalent calls inferred from this helper
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
	local current5 = MomentsCommon.Media.useMomentMediaController(moment.momentId)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return current5 ~= nil and current5.getState(p2).isPlaying
		end)
	end, { current5 })
	local current6 = SignalsReact.useSignalState(v3)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local v4

	if FFlagMomentsAvatarUnthrottleFramerate then
		v4 = useAvatarMomentFramerateHold(ref3)
	else
		v4 = nil
	end

	local v5 = React.useCallback(function(current: boolean)
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

		if v4 ~= nil then
			v4.refresh()
		end
	end, { v4 })
	local v6 = v.isPlaybackActive and v2 == p.index
	local feedItemId = moment.recommendationMetadata.feedItemId
	local ref4

	if FFlagProfileRenderAvatarMoments or FFlagMomentsAvatarSceneStage then
		ref4 = React.useRef(nil)
	else
		ref4 = nil
	end

	local ref5

	if FFlagMomentsAvatarSceneStage then
		ref5 = React.useRef(nil)
	else
		ref5 = nil
	end

	local ref6

	if FFlagMomentsAvatarSceneStage then
		ref6 = React.useRef(nil)
	else
		ref6 = nil
	end

	local v7

	if FFlagProfileRenderAvatarMoments then
		v7 = MomentsHostContext.useMomentsHost()
	end

	local v8 = v7 == nil or v7.isTopShell ~= false

	if FFlagProfileRenderAvatarMoments then
		v6 = v8 and v2 == p.index
	end

	React.useEffect(function()
		if FFlagMomentsAvatarSceneStage or (not v6 or current5 == nil) then
			return
		end

		local setExternalBaseReadiness = current5.setExternalBaseReadiness
		assert(setExternalBaseReadiness ~= nil, "Avatar Moments require external-base readiness")
		setExternalBaseReadiness("Loading")

		ref.current += 1
		local current = ref.current
		local v9 = nil
		local v10 = nil
		local v11 = nil
		local renderSteppedConnection = nil
		local v12 = nil

		local function showScene()
			local v13 = v9

			if v13 == nil or renderSteppedConnection ~= nil then
				return
			end

			local avatarMomentCamera = Workspace.CurrentCamera

			if avatarMomentCamera == nil then
				avatarMomentCamera = Instance.new("Camera")
				avatarMomentCamera.Name = "AvatarMomentCamera"
				avatarMomentCamera.Parent = Workspace
				Workspace.CurrentCamera = avatarMomentCamera
				v12 = avatarMomentCamera
			end

			v11 = saveCamera(avatarMomentCamera) -- inferred equivalent call
			v13.root.Parent = Workspace
			v13.root:PivotTo(cframe)

			local function updateCamera() -- 1 equivalent call inferred from this helper
				if Workspace.CurrentCamera ~= avatarMomentCamera then
					return
				end

				avatarMomentCamera.CameraType = Enum.CameraType.Scriptable
				avatarMomentCamera.FieldOfViewMode = v13.camera.FieldOfViewMode
				avatarMomentCamera.FieldOfView = v13.camera.FieldOfView
				avatarMomentCamera.CFrame = cframe * v13.camera.CFrame
				avatarMomentCamera.Focus = cframe * v13.camera.Focus
			end

			updateCamera() -- inferred equivalent call
			renderSteppedConnection = RunService.RenderStepped:Connect(updateCamera)

			if v4 ~= nil then
				v4.setShown(true)
			end
		end

		local function hideScene()
			local v13 = v9

			if v13 == nil or renderSteppedConnection == nil then
				return
			end

			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil

			if v4 ~= nil then
				v4.setShown(false)
			end

			v13.root.Parent = nil
			restoreCamera(v11) -- inferred equivalent call
			v11 = nil

			if v12 ~= nil then
				if Workspace.CurrentCamera == v12 then
					Workspace.CurrentCamera = nil
				end

				v12:Destroy()
				v12 = nil
			end
		end

		task.spawn(function()
			local stage = "validate-outfit"
			local success, result = pcall(function()
				local source = p.item.outfit.source

				if source.type ~= "outfit" then
					error("Inline Avatar Moment requires an outfit annotation")
				end

				stage = "decode-inline-scene"
				local v13 = decodeInlineMomentScene(p.item.rbxmData, source.id)

				stage = "create-moment-scene"
				local MomentScenes = require(parent.MomentScenes)
				return MomentScenes.createMomentScene({ type = v13.type, args = v13.args })
			end)

			if current == ref.current then
				if success and result ~= nil then
					local current2

					if ref4 ~= nil then
						current2 = ref4.current
					end

					if FFlagProfileRenderAvatarMoments and current2 == nil then
						MomentsCommon.Analytics.fireAnalyticsEvent(
							MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
							{
								stage = "attach-page",
								recommendationSource = v.recommendationSource or "unknown",
								momentId = moment.momentId,
								feedItemId = feedItemId or "unknown"
							}
						)

						setExternalBaseReadiness("Failed", "Avatar scene attach-page failed: page ref was not attached")
						disposeMomentScene(result) -- inferred equivalent call
					else
						v9 = result
						ref2.current = result
						ref3.current = false

						if FFlagProfileRenderAvatarMoments then
							v10 = observeGuiOnScreen(current2, function(flag: boolean)
								if flag then
									showScene()
								else
									hideScene()
								end
							end)
						else
							showScene()
						end

						setExternalBaseReadiness("Ready")
						v5(current5.getState(false).isPlaying)
					end
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

			if v10 ~= nil then
				v10()
				v10 = nil
			end

			hideScene()
			local v13 = v9
			v9 = nil

			if v13 ~= nil then
				setExternalBaseReadiness("Loading")

				if ref2.current == v13 then
					ref2.current = nil
					ref3.current = false
				end

				disposeMomentScene(v13) -- inferred equivalent call
			end
		end
	end, {
		v6,
		current5,
		p.item.rbxmData,
		p.item.outfit.source,
		moment.momentId,
		feedItemId,
		v.recommendationSource,
		v5,
		v4
	})

	if FFlagMomentsAvatarSceneStage then
		React.useEffect(function()
			local current

			if ref4 ~= nil then
				current = ref4.current
			end

			if current == nil then
				return nil
			end

			return getAvatarSceneStage().trackPage(current)
		end, {})

		local getIsVisible = VerticalPager.usePagerItem().getIsVisible

		local v9 = SignalsReact.useSignalState(getIsVisible)

		local ref7 = React.useRef({ readiness = "Loading", failureReason = nil })

		local ref8 = React.useRef(current5)
		ref8.current = current5

		local ref9 = React.useRef(current6)
		ref9.current = current6

		local v10 = React.useCallback(function(readiness: string, failureReason: string?)
			ref7.current = { readiness = readiness, failureReason = failureReason }
			local current = ref8.current

			if current ~= nil then
				local setExternalBaseReadiness = current.setExternalBaseReadiness
				assert(setExternalBaseReadiness ~= nil, "Avatar Moments require external-base readiness")
				setExternalBaseReadiness(readiness, failureReason)
			end
		end, {})

		React.useEffect(function()
			if current5 ~= nil then
				local current = ref7.current
				v10(current.readiness, current.failureReason)
			end
		end, { current5, v10 })

		React.useEffect(function()
			if not v9 then
				return
			end

			v10("Loading")

			ref.current += 1
			local current = ref.current
			local v11 = nil
			local v12 = nil

			task.spawn(function()
				local stage = "validate-outfit"
				local success, result = pcall(function()
					local source = p.item.outfit.source

					if source.type ~= "outfit" then
						error("Inline Avatar Moment requires an outfit annotation")
					end

					stage = "decode-inline-scene"
					local v13 = decodeInlineMomentScene(p.item.rbxmData, source.id)

					stage = "create-moment-scene"
					local MomentScenes = require(parent.MomentScenes)
					return MomentScenes.createMomentScene({ type = v13.type, args = v13.args })
				end)

				if current == ref.current then
					if success and result ~= nil then
						local current2

						if ref4 ~= nil then
							current2 = ref4.current
						end

						local current3

						if ref5 ~= nil then
							current3 = ref5.current
						end

						local current4

						if ref6 ~= nil then
							current4 = ref6.current
						end

						if current2 == nil or current3 == nil or current4 == nil then
							MomentsCommon.Analytics.fireAnalyticsEvent(
								MomentsCommon.Analytics.EventNames.AvatarMomentLoadFailed,
								{
									stage = "attach-page",
									recommendationSource = v.recommendationSource or "unknown",
									momentId = moment.momentId,
									feedItemId = feedItemId or "unknown"
								}
							)

							v10("Failed", "Avatar scene attach-page failed: page refs were not attached")
							disposeMomentScene(result) -- inferred equivalent call
						else
							v11 = result
							ref2.current = result
							ref3.current = false
							v12 = getAvatarSceneStage().register({
								scene = result,
								page = current2,
								viewportFrame = current3,
								worldModel = current4
							})

							if v4 ~= nil then
								v4.trackPage(current2)
							end

							v10("Ready")
							v5(ref9.current)
						end
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

						v10("Failed", `Avatar scene {stage} failed: {tostring(result)}`)
					end
				elseif success and result ~= nil then
					disposeMomentScene(result) -- inferred equivalent call
				end
			end)

			return function()
				ref.current += 1

				if v4 ~= nil then
					v4.untrackPage()
				end

				if v12 ~= nil then
					v12()
					v12 = nil
				end

				local v13 = v11
				v11 = nil

				if v13 ~= nil then
					v10("Loading")

					if ref2.current == v13 then
						ref2.current = nil
						ref3.current = false
					end

					disposeMomentScene(v13) -- inferred equivalent call
				end
			end
		end, {
			v9,
			p.item.rbxmData,
			p.item.outfit.source,
			moment.momentId,
			feedItemId,
			v.recommendationSource,
			v10,
			v5,
			v4
		})
	end

	React.useEffect(function()
		v5(current6)
	end, { current6, v5 })

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
		moment = moment,
		pageRef = ref4,
		viewportFrameRef = ref5,
		worldModelRef = ref6
	}
end

return useAvatarMomentViewModel
