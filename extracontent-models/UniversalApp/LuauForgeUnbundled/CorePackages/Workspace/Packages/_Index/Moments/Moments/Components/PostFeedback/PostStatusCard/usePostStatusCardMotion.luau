local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local usePreferences = Foundation.Hooks.usePreferences

local v5 = { dampingRatio = 1, frequency = 3 }

local function usePostStatusCardMotion(p2)
	local reducedMotion = usePreferences().reducedMotion
	local ref = React.useRef(nil)

	local function finishHiding()
		local current = ref.current
		ref.current = nil

		if current ~= nil then
			current()
		end
	end

	local v6 = React.useCallback(function(p3)
		if p3 <= 0 then
			local current = ref.current
			ref.current = nil

			if current ~= nil then
				current()
			end
		end
	end, {})

	local v7, v8 = ReactOtter.useAnimatedBinding(0, v6)

	React.useEffect(function()
		local current = ref.current
		ref.current = nil

		if current ~= nil then
			current()
		end

		if p2 == nil then
			v8(ReactOtter.instant(0))
		elseif reducedMotion then
			v8(ReactOtter.instant(1))
		else
			v8(ReactOtter.spring(1, v5))
		end
	end, { p2, reducedMotion })

	React.useEffect(function()
		return finishHiding
	end, {})

	return {
		shown = v7,
		hide = React.useCallback(function(current)
			if reducedMotion then
				current()
				return
			end

			ref.current = current
			v8(ReactOtter.spring(0, v5))
		end, { reducedMotion, v8 })
	}
end

return usePostStatusCardMotion
