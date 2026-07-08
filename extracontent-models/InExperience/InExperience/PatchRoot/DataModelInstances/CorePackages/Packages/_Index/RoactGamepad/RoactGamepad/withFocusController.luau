local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local FocusContext = require(script.Parent.FocusContext)

local function FocusControllerConsumer(p1) -- line: 9
	-- upvalues: Roact (copy), FocusContext (copy)
	return Roact.createElement(FocusContext.Consumer, {
		render = function(p2) -- line: 11
			-- upvalues: p1 (copy)
			local v9 = if not p2 then nil else p2.focusNode.focusController

			return p1.render(v9)
		end
	})
end
local function withFocusController(p3) -- line: 24
	-- upvalues: Roact (copy), FocusControllerConsumer (copy)
	return Roact.createElement(FocusControllerConsumer, {
		render = p3
	})
end

return withFocusController
