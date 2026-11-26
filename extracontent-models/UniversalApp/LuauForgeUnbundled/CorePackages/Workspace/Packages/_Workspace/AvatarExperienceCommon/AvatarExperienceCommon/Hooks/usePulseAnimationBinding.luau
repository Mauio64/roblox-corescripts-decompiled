local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactOtter")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Otter")
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local v5 = { easeIn = 1, easeOut = 10 }

local v6 = { easeOut = 1, easeIn = 0 }

local v7 = { frequency = 10, dampingRatio = 1 }

local function usePulseAnimationBinding(p2)
	local ref = React.useRef(nil)

	local v9, v10 = useAnimatedBinding({ thickness = 0, transparency = 0 }, (React.useCallback(function(p3)
		if ref.current and p2 then
			if p3.thickness == 10 then
				ref.current({
					thickness = Otter.instant(1),
					transparency = Otter.instant(0)
				})
			elseif p3.thickness == 1 then
				ref.current({
					thickness = Otter.ease(10, v7),
					transparency = Otter.ease(1, v7)
				})
			end
		end
	end, { p2 })))

	React.useEffect(function()
		if p2 then
			if not ref.current then
				ref.current = v10
			end

			v10({ thickness = Otter.ease(10, v7), transparency = Otter.ease(1, v7) })
		end

		return function()
			v10({ thickness = Otter.instant(0), transparency = Otter.instant(0) })
		end
	end, { p2 })

	return v9
end

return usePulseAnimationBinding
