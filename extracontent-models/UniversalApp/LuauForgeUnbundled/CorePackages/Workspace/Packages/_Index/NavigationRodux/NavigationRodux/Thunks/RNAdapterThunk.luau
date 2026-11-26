local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")
local named = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/AppCommonLib").Symbol.named("RNAdapterThunkTag")
return {
	middleware = function(p2)
		ArgCheck.isType(p2, "function", "rnDispatcher")

		return function(callback, p3)
			return function(callback2)
				if typeof(callback2) == "table" and callback2[named] == true then
					return callback2(p3, p2)
				end

				return callback(callback2)
			end
		end
	end,
	new = function(p2, callback)
		ArgCheck.isNonEmptyString(p2, "name")
		ArgCheck.isType(callback, "function", "onInvoke")

		return (setmetatable({ [named] = true, type = p2 }, {
			__call = function(p3, ...)
				callback(...)
			end
		}))
	end,
	test = function(self, p2, p3)
		ArgCheck.assert(
			type(self) == "table" and self[named] == true,
			"'thunk' must be a valid RNAdapterThunk"
		)

		return self(p2, p3)
	end,
	is = function(p2): boolean
		if type(p2) == "table" then
			return p2[named] == true
		end

		return false
	end
}
