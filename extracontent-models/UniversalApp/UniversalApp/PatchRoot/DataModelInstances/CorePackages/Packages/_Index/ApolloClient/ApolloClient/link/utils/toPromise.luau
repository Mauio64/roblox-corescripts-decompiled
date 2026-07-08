local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Promise = require(ParentParentParent.Promise)

require(ParentParentParent.LuauPolyfill)

local invariant = require(ParentParent.jsutils.invariant).invariant

require(script.Parent.Parent.Parent.utilities)

function t1.toPromise(p1) -- line: 23
	-- upvalues: Promise (copy), invariant (copy)
	local u7 = false

	return Promise.new(function(resolve, reject) -- line: 25
		-- upvalues: p1 (copy), u7 (ref), invariant (copy)
		p1:subscribe({
			next = function(_, p3) -- line: 27
				-- upvalues: u7 (ref), invariant (copy), resolve (copy)
				if u7 then
					invariant.warn("Promise Wrapper does not support multiple results from Observable")

					return
				end

				u7 = true
				resolve(p3)
			end,
			error = function(_, p5) -- line: 35
				-- upvalues: reject (copy)
				reject(p5)
			end
		})
	end):andThen(function(p6) -- line: 41
		-- upvalues: Promise (copy)
		return Promise.delay(0):andThenReturn(p6)
	end)
end

return t1
