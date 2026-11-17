local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local usePreferences = Foundation.Hooks.usePreferences

local v = { dampingRatio = 1, frequency = 3 }

local function usePostStatusCardMotion(p: string?)
	local reducedMotion = usePreferences().reducedMotion
	local ref = React.useRef(nil)

	local function finishHiding() -- 2 equivalent calls inferred from this helper
		local current = ref.current
		ref.current = nil

		if current ~= nil then
			current()
		end
	end

	local v2 = React.useCallback(function(p2: number)
		if p2 <= 0 then
			finishHiding() -- inferred equivalent call
		end
	end, {})

	local shown, v3 = ReactOtter.useAnimatedBinding(0, v2)

	React.useEffect(function()
		finishHiding() -- inferred equivalent call

		if p == nil then
			v3(ReactOtter.instant(0))
		elseif reducedMotion then
			v3(ReactOtter.instant(1))
		else
			v3(ReactOtter.spring(1, v))
		end
	end, { p, reducedMotion })

	React.useEffect(function()
		return finishHiding
	end, {})

	return {
		shown = shown,
		hide = React.useCallback(function(current)
			if reducedMotion then
				current()
				return
			end

			ref.current = current
			v3(ReactOtter.spring(0, v))
		end, { reducedMotion, v3 })
	}
end

return usePostStatusCardMotion
