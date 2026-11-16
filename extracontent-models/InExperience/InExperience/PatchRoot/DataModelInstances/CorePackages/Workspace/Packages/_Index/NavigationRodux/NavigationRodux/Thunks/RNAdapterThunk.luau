local parent = script:FindFirstAncestor("NavigationRodux").Parent

local ArgCheck = require(parent.ArgCheck)
local AppCommonLib = require(parent.AppCommonLib)
local named = AppCommonLib.Symbol.named("RNAdapterThunkTag")
local RNAdapterThunk = {}

function RNAdapterThunk.middleware(p)
	ArgCheck.isType(p, "function", "rnDispatcher")

	return function(callback, p2)
		return function(callback2)
			if typeof(callback2) == "table" and callback2[named] == true then
				return callback2(p2, p)
			end

			return callback(callback2)
		end
	end
end

function RNAdapterThunk.new(p, callback)
	ArgCheck.isNonEmptyString(p, "name")
	ArgCheck.isType(callback, "function", "onInvoke")

	return (setmetatable({ [named] = true, type = p }, {
		__call = function(_, ...)
			callback(...)
		end
	}))
end

function RNAdapterThunk.test(callback, p, p2)
	ArgCheck.assert(type(callback) == "table" and callback[named] == true, "'thunk' must be a valid RNAdapterThunk")

	return callback(p, p2)
end

function RNAdapterThunk.is(p): boolean
	return type(p) == "table" and p[named] == true
end

return RNAdapterThunk
