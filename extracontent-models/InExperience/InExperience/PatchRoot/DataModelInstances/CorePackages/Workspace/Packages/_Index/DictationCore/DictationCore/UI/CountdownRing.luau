local parent = script:FindFirstAncestor("DictationCore").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function toPercent(value: number)
	return math.clamp(value, 0, 1) * 100
end

local function CountdownRing(p)
	local v = React.useMemo(function()
		return p.countdownProgress:map(toPercent)
	end, { p.countdownProgress })

	return React.createElement(Foundation.Progress, {
		tag = "position-center-center anchor-center-center",
		shape = Foundation.Enums.ProgressShape.Circle,
		size = Foundation.Enums.ProgressSize.Medium,
		value = v,
		ZIndex = 2
	})
end

return React.memo(CountdownRing)
