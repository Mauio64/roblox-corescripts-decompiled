local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local ProgressBar = require(script.Parent.ProgressBar)

local ProgressCircle = require(script.Parent.ProgressCircle)

local ProgressShape = require(Foundation.Enums.ProgressShape)

require(Foundation.Enums.ProgressSize)

local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Providers.Style.Tokens)

local v = { testId = "--foundation-progress" }

local function Progress(p, ref)
	local v2 = withDefaults(p, v)

	if v2.shape == ProgressShape.Circle then
		return React.createElement(ProgressCircle, Dash.join(v2, { ref = ref }))
	end

	return React.createElement(ProgressBar, Dash.join(v2, { ref = ref }))
end

return React.memo(React.forwardRef(Progress))
