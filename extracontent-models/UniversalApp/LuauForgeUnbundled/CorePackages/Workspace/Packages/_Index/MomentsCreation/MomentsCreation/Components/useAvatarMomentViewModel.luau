local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/AvatarMomentView")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local useCreationMusicSync = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationMusicSync")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function disposeMomentScene(p2)
	pcall(function()
		p2.root.Parent = nil
	end)
	pcall(p2.dispose)
end

local function useAvatarMomentViewModel(data)
	local preview = data.preview
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)

	local v5 = useCreationMusicSync(preview, Constants.ScreenshotMusicDuration, data.ttsAudio)
	local music = v5.music
	local elapsed = v5.audio.timeline.elapsed

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
				return require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentScenes").createMomentScene(data.avatarMoment.SceneSpec)
			end)

			if current == ref4.current then
				if success and result ~= nil then
					local current2 = ref.current
					local current3 = ref2.current

					if current2 == nil or current3 == nil then
						pcall(function()
							result.root.Parent = nil
						end)
						pcall(result.dispose)
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
				pcall(function()
					result.root.Parent = nil
				end)
				pcall(result.dispose)
			end
		end)

		return function()
			ref4.current += 1
			local current2 = ref3.current
			ref3.current = nil

			if current2 ~= nil then
				pcall(function()
					current2.root.Parent = nil
				end)
				pcall(current2.dispose)
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
		onAbsoluteSizeChanged = React.useCallback(function(p2)
			if data.onAbsoluteSizeChanged ~= nil then
				data.onAbsoluteSizeChanged(p2)
			end

			if data.onResolutionChanged ~= nil then
				data.onResolutionChanged(p2.AbsoluteSize)
			end
		end, { data.onAbsoluteSizeChanged, data.onResolutionChanged }),
		children = data.children
	}
end

return useAvatarMomentViewModel
