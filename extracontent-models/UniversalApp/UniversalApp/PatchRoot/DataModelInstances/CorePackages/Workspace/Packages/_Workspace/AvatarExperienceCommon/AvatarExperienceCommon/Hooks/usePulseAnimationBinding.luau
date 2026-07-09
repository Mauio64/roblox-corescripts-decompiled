local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Otter = require(Parent.Otter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local _ = {
	easeIn = 1,
	easeOut = 10
}
local _ = {
	easeOut = 1,
	easeIn = 0
}
local t1 = {
	frequency = 10,
	dampingRatio = 1
}

local function usePulseAnimationBinding(b1: boolean?) -- line: 53
	-- upvalues: React (copy), Otter (copy), t1 (copy), useAnimatedBinding (copy)
	local v11 = React.useRef(nil)
	local v12 = React.useCallback(function(t2: {[any]: any}) -- line: 56
		-- upvalues: v11 (copy), b1 (copy), Otter (copy), t1 (copy)
		if v11.current and b1 then
			if t2.thickness == 10 then
				v11.current({
					thickness = Otter.instant(1),
					transparency = Otter.instant(0)
				})

				return
			end

			if t2.thickness == 1 then
				v11.current({
					thickness = Otter.ease(10, t1),
					transparency = Otter.ease(1, t1)
				})
			end
		end
	end, { b1 })
	local v13, v14 = useAnimatedBinding({
		thickness = 0,
		transparency = 0
	}, v12)

	React.useEffect(function() -- line: 76
		-- upvalues: b1 (copy), v11 (copy), v14 (copy), Otter (copy), t1 (copy)
		if b1 then
			if not v11.current then
				v11.current = v14
			end

			v14({
				thickness = Otter.ease(10, t1),
				transparency = Otter.ease(1, t1)
			})
		end

		return function() -- line: 87
			-- upvalues: v14 (copy), Otter (copy)
			v14({
				thickness = Otter.instant(0),
				transparency = Otter.instant(0)
			})
		end
	end, { b1 })

	return v13
end

return usePulseAnimationBinding
