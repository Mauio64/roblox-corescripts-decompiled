local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object

require(script.Parent.Parent.core.types)

function t1.createOperation(p1, p2) -- line: 19
	-- upvalues: Object (copy)
	local u6 = Object.assign({}, p1)

	return (setmetatable(p2, {
		__index = {
			setContext = function(_, p4) -- line: 22
				-- upvalues: u6 (ref), Object (copy)
				if typeof(p4) == "function" then
					u6 = Object.assign({}, u6, p4(u6))

					return
				end

				u6 = Object.assign({}, u6, p4)
			end,
			getContext = function(_) -- line: 30
				-- upvalues: Object (copy), u6 (ref)
				return Object.assign({}, u6)
			end
		}
	}))
end

return t1
