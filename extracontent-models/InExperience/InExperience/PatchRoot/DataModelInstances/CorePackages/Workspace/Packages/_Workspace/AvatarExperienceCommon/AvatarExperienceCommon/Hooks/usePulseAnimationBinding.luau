local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Otter = require(parent.Otter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local _ = { easeIn = 1, easeOut = 10 }

local _ = { easeOut = 1, easeIn = 0 }

local v = { frequency = 10, dampingRatio = 1 }

local function usePulseAnimationBinding(flag: boolean?)
	local ref = React.useRef(nil)

	local v2, current = useAnimatedBinding({ thickness = 0, transparency = 0 }, (React.useCallback(function(p)
		if ref.current and flag then
			if p.thickness == 10 then
				ref.current({ thickness = Otter.instant(1), transparency = Otter.instant(0) })
			elseif p.thickness == 1 then
				ref.current({ thickness = Otter.ease(10, v), transparency = Otter.ease(1, v) })
			end
		end
	end, { flag })))

	React.useEffect(function()
		if flag then
			if not ref.current then
				ref.current = current
			end

			current({ thickness = Otter.ease(10, v), transparency = Otter.ease(1, v) })
		end

		return function()
			current({ thickness = Otter.instant(0), transparency = Otter.instant(0) })
		end
	end, { flag })

	return v2
end

return usePulseAnimationBinding
