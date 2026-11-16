local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local React = require(parent2.React)
local LuauPolyfill = require(parent2.LuauPolyfill)

require(parent.Types)
local TooltipController = require(parent.TooltipController)
local HoverController = require(parent.HoverController)

local function createControllerFunction(p) -- 2 equivalent calls inferred from this helper
	return function(tooltipProps, p2, renderTriggerPoint)
		local v = LuauPolyfill.Object.assign({}, p2, {
			tooltipProps = tooltipProps,
			renderTriggerPoint = renderTriggerPoint
		})

		return React.createElement(p, v)
	end
end

return {
	withTooltip = createControllerFunction(TooltipController), -- inferred equivalent call
	withHoverTooltip = createControllerFunction(HoverController) -- inferred equivalent call
}
