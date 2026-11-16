local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local FocusContext = require(script.Parent.FocusContext)

local function FocusControllerConsumer(p)
	return Roact.createElement(FocusContext.Consumer, {
		render = function(p2)
			local v

			if p2 then
				v = p2.focusNode.focusController
			end

			return p.render(v)
		end
	})
end

local function withFocusController(render)
	return Roact.createElement(FocusControllerConsumer, { render = render })
end

return withFocusController
