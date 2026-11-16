local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local ProgressBar = require(script.Parent.ProgressBar)

local ProgressCircle = require(script.Parent.ProgressCircle)

local ProgressShape = require(Foundation.Enums.ProgressShape)

require(Foundation.Enums.ProgressSize)

local Flags = require(Foundation.Utility.Flags)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Providers.Style.Tokens)

local v = { testId = "--foundation-progress" }

local function Progress(p, ref)
	local joined = withDefaults(p, v)

	if not Flags.FoundationProgressBarBetaUpdate then
		joined.ref = ref
	end

	if joined.shape == ProgressShape.Circle then
		local createElement = React.createElement

		if Flags.FoundationProgressBarBetaUpdate then
			joined = Dash.join(joined, { ref = ref })
		end

		return createElement(ProgressCircle, joined)
	else
		local createElement = React.createElement

		if Flags.FoundationProgressBarBetaUpdate then
			joined = Dash.join(joined, { ref = ref })
		end

		return createElement(ProgressBar, joined)
	end
end

return React.memo(React.forwardRef(Progress))
