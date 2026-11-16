local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local LuauPolyfill = require(parent3.LuauPolyfill)

require(parent.Types)
local Constants = require(parent.Constants)
local TooltipController = require(parent.TooltipController)
local ControlState = require(parent2.Core.Control.Enum.ControlState)

local UIBloxConfig = require(parent2.UIBloxConfig)

local function HoverController(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(tick())

	React.useEffect(function()
		return function()
			ref.current = tick()
		end
	end, UIBloxConfig.enableTooltipV2HoverControllerReRenderFix and {} or nil)

	local delayTime = props.delayTime or Constants.DEFAULT_DELAY_TIME

	local v = React.useCallback(function(p, p2)
		if props.disabled then
			setState(false)
		elseif p2 == ControlState.Hover or p2 == ControlState.Selected then
			local current = ref.current
			delay(delayTime, function()
				if ref.current == current then
					setState(true)
				end
			end)
		elseif p == ControlState.Hover or p == ControlState.Selected then
			ref.current = tick()
			setState(false)
		end
	end, { delayTime })

	local v2 = LuauPolyfill.Object.assign({}, props, {
		delayTime = LuauPolyfill.Object.None,
		active = state,
		renderTriggerPoint = function(p)
			return props.renderTriggerPoint(p, v)
		end
	})

	return React.createElement(TooltipController, v2)
end

return HoverController
