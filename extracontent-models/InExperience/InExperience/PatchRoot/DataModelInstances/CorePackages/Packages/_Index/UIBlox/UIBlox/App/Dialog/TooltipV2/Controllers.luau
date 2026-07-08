local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local LuauPolyfill = require(ParentParent.LuauPolyfill)

require(scriptParent.Types)

local TooltipController = require(scriptParent.TooltipController)
local HoverController = require(scriptParent.HoverController)

local function createControllerFunction(p1) -- line: 14
	-- upvalues: LuauPolyfill (copy), React (copy)
	return function(p2, p3, p4) -- line: 15
		-- upvalues: LuauPolyfill (copy), React (copy), p1 (copy)
		local v20 = LuauPolyfill.Object.assign({}, p3, {
			tooltipProps = p2,
			renderTriggerPoint = p4
		})

		return React.createElement(p1, v20)
	end
end

return {
	withTooltip = function(p5, p6, p7) -- line: 15
		-- upvalues: LuauPolyfill (copy), React (copy), TooltipController (copy)
		local v12 = LuauPolyfill.Object.assign({}, p6, {
			tooltipProps = p5,
			renderTriggerPoint = p7
		})

		return React.createElement(TooltipController, v12)
	end,
	withHoverTooltip = function(p8, p9, p10) -- line: 15
		-- upvalues: LuauPolyfill (copy), React (copy), HoverController (copy)
		local v16 = LuauPolyfill.Object.assign({}, p9, {
			tooltipProps = p8,
			renderTriggerPoint = p10
		})

		return React.createElement(HoverController, v16)
	end
}
