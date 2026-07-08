local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)

require(scriptParent.Types)

local Constants = require(scriptParent.Constants)
local TooltipController = require(scriptParent.TooltipController)
local ControlState = require(ParentParent.Core.Control.Enum.ControlState)
local UIBloxConfig = require(ParentParent.UIBloxConfig)

local function HoverController(p1) -- line: 17
	-- upvalues: React (copy), UIBloxConfig (copy), Constants (copy), ControlState (copy), LuauPolyfill (copy), TooltipController (copy)
	local v12, v13 = React.useState(false)
	local v14 = React.useRef(tick())

	React.useEffect(function() -- line: 21
		-- upvalues: v14 (copy)
		return function() -- line: 22
			-- upvalues: v14 (copy)
			v14.current = tick()
		end
	end, if not UIBloxConfig.enableTooltipV2HoverControllerReRenderFix then nil else {})

	local v15 = p1.delayTime or Constants.DEFAULT_DELAY_TIME
	local v16 = React.useCallback(function(p2, p3) -- line: 30
		-- upvalues: p1 (copy), v13 (copy), ControlState (copy), v14 (copy), v15 (copy)
		if p1.disabled then
			v13(false)

			return
		end

		if p3 == ControlState.Hover or p3 == ControlState.Selected then
			local current = v14.current

			delay(v15, function() -- line: 37
				-- upvalues: v14 (copy), current (copy), v13 (copy)
				if v14.current == current then
					v13(true)
				end
			end)

			return
		end

		if p2 == ControlState.Hover or p2 == ControlState.Selected then
			v14.current = tick()
			v13(false)
		end
	end, { v15 })
	local v17 = LuauPolyfill.Object.assign({}, p1, {
		delayTime = LuauPolyfill.Object.None,
		active = v12,
		renderTriggerPoint = function(p4) -- line: 52
			-- upvalues: p1 (copy), v16 (copy)
			return p1.renderTriggerPoint(p4, v16)
		end
	})

	return React.createElement(TooltipController, v17)
end

return HoverController
