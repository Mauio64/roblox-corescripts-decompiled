local ParentParent = script.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local Promise = require(ParentParent.Promise)
local asyncMapValue = nil
local iteratorResult = nil
local t2 = {
	mapAsyncIterator = function(t1: {[any]: any}, p1: ((...any) -> ...any), p2) -- line: 25
		-- upvalues: Promise (copy), Boolean (copy), asyncMapValue (ref), iteratorResult (ref)
		local u10 = nil
		local u11 = nil

		if typeof(t1["return"]) == "function" then
			u10 = t1["return"]

			function u11(p3) -- line: 35
				-- upvalues: Promise (copy), u10 (ref), t1 (copy)
				local function rethrow() -- line: 36
					-- upvalues: Promise (copy), p3 (copy)
					return Promise.reject(p3)
				end

				return u10(t1):andThen(rethrow, rethrow)
			end
		end

		local function mapResult(p4) -- line: 47
			-- upvalues: Boolean (copy), asyncMapValue (ref), p1 (copy), iteratorResult (ref), u11 (ref)
			if Boolean.toJSBoolean(p4.done) then
				return p4
			end

			return (asyncMapValue(p4.value, p1):andThen(iteratorResult, u11))
		end

		local u13 = nil

		if p2 then
			function u13(p5) -- line: 62
				-- upvalues: asyncMapValue (ref), p2 (copy), iteratorResult (ref), u11 (ref)
				return asyncMapValue(p5, p2):andThen(iteratorResult, u11)
			end
		end

		return {
			next = function(_) -- line: 70
				-- upvalues: t1 (copy), mapResult (copy), u13 (ref)
				return t1:next():andThen(mapResult, u13)
			end,
			["return"] = function(_) -- line: 76
				-- upvalues: Boolean (copy), u10 (ref), t1 (copy), mapResult (copy), u13 (ref), Promise (copy)
				if Boolean.toJSBoolean(u10) then
					return (u10(t1):andThen(mapResult, u13))
				end

				return (Promise.resolve({
					value = nil,
					done = true
				}))
			end,
			throw = function(_, p9) -- line: 88
				-- upvalues: t1 (copy), mapResult (copy), u13 (ref), Promise (copy), u11 (ref)
				if typeof(t1.throw) == "function" then
					return t1.throw(t1, p9):andThen(mapResult, u13)
				end

				return Promise.reject(p9):catch(u11)
			end
		}
	end
}

function asyncMapValue(p10, p11: ((...any) -> ...any)) -- line: 108
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve) -- line: 110
		-- upvalues: p11 (copy), p10 (copy)
		return resolve(p11(p10))
	end)
end
function iteratorResult(p12) -- line: 116
	return {
		done = false,
		value = p12
	}
end

return t2
