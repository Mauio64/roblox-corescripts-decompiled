local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)

require(script.Parent.AvatarMomentView)
local Constants = require(MomentsCreation.Constants)
local useCreationMusicSync = require(MomentsCreation.Hooks.useCreationMusicSync)
require(MomentsCreation.Types.CreationFlowTypes)

local function disposeMomentScene(p) -- 3 equivalent calls inferred from this helper
	pcall(function()
		p.root.Parent = nil
	end)
	pcall(p.dispose)
end

local function useAvatarMomentViewModel(data)
	local preview = data.preview
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)

	local v = useCreationMusicSync(preview, Constants.ScreenshotMusicDuration, data.ttsAudio)
	local music = v.music
	local elapsed = v.audio.timeline.elapsed

	React.useEffect(function()
		preview.bindEngine(nil)
		preview.setDuration(Constants.ScreenshotMusicDuration)
		preview.setTimeLength(Constants.ScreenshotMusicDuration)
		preview.setPosition(0)
		preview.setReadiness("Loading")

		ref4.current += 1
		local current = ref4.current
		task.spawn(function()
			local success, result = pcall(function()
				local MomentScenes = require(parent.MomentScenes)
				return MomentScenes.createMomentScene(data.avatarMoment.SceneSpec)
			end)

			if current == ref4.current then
				if success and result ~= nil then
					local current2 = ref.current
					local current3 = ref2.current

					if current2 == nil or current3 == nil then
						disposeMomentScene(result) -- inferred equivalent call
					else
						ref3.current = result
						result.root.Parent = current3
						current2.CurrentCamera = result.camera
						result.playhead.play()
						preview.setReadiness("Ready")
					end
				else
					warn(`Failed to build Avatar Moment scene: {result}`)
					preview.setReadiness("Failed")
				end
			elseif success and result ~= nil then
				disposeMomentScene(result) -- inferred equivalent call
			end
		end)

		return function()
			ref4.current += 1
			local current2 = ref3.current
			ref3.current = nil

			if current2 ~= nil then
				disposeMomentScene(current2) -- inferred equivalent call
			end
		end
	end, { preview, data.avatarMoment })

	React.useEffect(function()
		preview.setPosition(music == nil and 0 or math.clamp(elapsed, 0, Constants.ScreenshotMusicDuration))
	end, { preview, music, elapsed })

	return {
		viewportFrameRef = ref,
		worldModelRef = React.useCallback(function(current)
			if current == nil and ref3.current ~= nil then
				pcall(function()
					ref3.current.root.Parent = nil
				end)
			end

			ref2.current = current
		end, {}),
		onAbsoluteSizeChanged = React.useCallback(function(p)
			if data.onAbsoluteSizeChanged ~= nil then
				data.onAbsoluteSizeChanged(p)
			end

			if data.onResolutionChanged ~= nil then
				data.onResolutionChanged(p.AbsoluteSize)
			end
		end, { data.onAbsoluteSizeChanged, data.onResolutionChanged }),
		children = data.children
	}
end

return useAvatarMomentViewModel
