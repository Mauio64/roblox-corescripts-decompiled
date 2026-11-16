local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent2.LuauPolyfill)

require(script.Parent.helpers_types)
local Helpers = {}
Helpers.hasOwnProperty = require(parent.luaUtils.hasOwnProperty)

function Helpers:toArray()
	if self._array then
		return table.clone(self._array)
	end

	local v = {}
	self:forEach(function(p)
		table.insert(v, p)
	end)
	return v
end

function Helpers:maybeUnsubscribe()
	local unsubscribe = self.unsubscribe

	if type(unsubscribe) == "function" then
		self.unsubscribe = nil
		unsubscribe()
	end
end

return Helpers
