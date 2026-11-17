local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local function springOptions(data, openStartOffset: number?) -- 2 equivalent calls inferred from this helper
	return {
		dampingRatio = data.dampingRatio,
		frequency = data.frequency,
		startingValue = openStartOffset
	}
end

return {
	useSlideOpenCloseAnimation = function(current: boolean, data, p)
		local state, setState = React.useState(current)
		local ref = React.useRef(current)
		ref.current = current
		local ref2 = React.useRef(true)

		if current and not state then
			setState(true)
		end

		local v = React.useCallback(function()
			if not ref.current then
				setState(false)
			end
		end, {})

		local offset, v2 = ReactOtter.useAnimatedBinding(current and 0 or data.hiddenOffset, v)

		local position = React.useMemo(function()
			return offset:map(function(p2: number)
				return UDim2.new(p2, 0, 0, 0)
			end)
		end, { offset })

		React.useEffect(function()
			local current2 = ref2.current
			ref2.current = false

			if current then
				setState(true)

				if current2 and not data.animateInitialOpen then
					return
				end

				v2(ReactOtter.spring(0, springOptions(data, data.openStartOffset))) -- inferred equivalent call
			else
				if current2 then
					return
				end

				v2(ReactOtter.spring(data.hiddenOffset, springOptions(data))) -- inferred equivalent call
			end
		end, { current, p, data })

		return { offset = offset, position = position, shouldMount = state }
	end,
	PANEL_SLIDE_CONFIG = {
		hiddenOffset = 1.1,
		openStartOffset = 0.2,
		dampingRatio = 1,
		frequency = 7,
		animateInitialOpen = false
	},
	PANEL_ZOOM_CONFIG = {
		hiddenOffset = 1,
		openStartOffset = 1,
		dampingRatio = 1,
		frequency = 4,
		animateInitialOpen = false
	},
	MENU_SLIDE_CONFIG = {
		hiddenOffset = 1,
		openStartOffset = 1,
		dampingRatio = 1,
		frequency = 4,
		animateInitialOpen = true
	},
	MOBILE_ZOOM_SPRING = { dampingRatio = 1, frequency = 4 },
	MENU_ZOOM_CLOSED_SCALE = 1.25,
	PANEL_RECESS_SCALE = 0.95,
	PANEL_RECESS_TRANSPARENCY = 0.6
}
