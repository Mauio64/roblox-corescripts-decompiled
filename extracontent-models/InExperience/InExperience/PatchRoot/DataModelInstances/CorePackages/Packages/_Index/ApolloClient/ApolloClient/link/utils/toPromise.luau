local ToPromise = {}
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Promise = require(parent2.Promise)

require(parent2.LuauPolyfill)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

require(script.Parent.Parent.Parent.utilities)

function ToPromise.toPromise(object)
	local flag = false
	return Promise.new(function(callback, callback2)
		object:subscribe({
			next = function(_, p)
				if flag then
					invariant2.warn("Promise Wrapper does not support multiple results from Observable")
					return
				end

				flag = true
				callback(p)
			end,
			error = function(_, p)
				callback2(p)
			end
		})
	end):andThen(function(p)
		return Promise.delay(0):andThenReturn(p)
	end)
end

return ToPromise
