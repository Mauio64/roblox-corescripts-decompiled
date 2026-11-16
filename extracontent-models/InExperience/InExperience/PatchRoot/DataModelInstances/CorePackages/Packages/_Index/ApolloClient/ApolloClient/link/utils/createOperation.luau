local CreateOperation = {}
local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

require(script.Parent.Parent.core.types)

function CreateOperation.createOperation(p, p2)
	local v = Object.assign({}, p)

	local function getContext(_)
		return Object.assign({}, v)
	end

	return (setmetatable(p2, {
		__index = {
			setContext = function(_, callback)
				if typeof(callback) == "function" then
					v = Object.assign({}, v, callback(v))
				else
					v = Object.assign({}, v, callback)
				end
			end,
			getContext = getContext
		}
	}))
end

return CreateOperation
