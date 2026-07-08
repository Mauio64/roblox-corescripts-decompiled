local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ProgressBar = require(script.Parent.ProgressBar)
local ProgressCircle = require(script.Parent.ProgressCircle)
local ProgressShape = require(Foundation.Enums.ProgressShape)

require(Foundation.Enums.ProgressSize)

local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Providers.Style.Tokens)

local t1 = {
	testId = "--foundation-progress"
}

local function Progress(p1, p2) -- line: 29
	-- upvalues: withDefaults (copy), t1 (copy), ProgressShape (copy), React (copy), ProgressCircle (copy), ProgressBar (copy)
	local v12 = withDefaults(p1, t1)

	v12.ref = p2

	if v12.shape == ProgressShape.Circle then
		return React.createElement(ProgressCircle, v12)
	end

	return React.createElement(ProgressBar, v12)
end

return React.memo(React.forwardRef(Progress))
