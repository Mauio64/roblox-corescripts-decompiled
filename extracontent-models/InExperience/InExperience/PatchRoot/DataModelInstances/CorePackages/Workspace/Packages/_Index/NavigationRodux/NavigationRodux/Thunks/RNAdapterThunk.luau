local Parent = script:FindFirstAncestor("NavigationRodux").Parent
local ArgCheck = require(Parent.ArgCheck)
local t1 = {}
local v4 = require(Parent.AppCommonLib).Symbol.named("RNAdapterThunkTag")

function t1.middleware(p1) -- line: 19
	-- upvalues: ArgCheck (copy), v4 (copy)
	ArgCheck.isType(p1, "function", "rnDispatcher")

	return function(p2, p3) -- line: 22
		-- upvalues: v4 (copy), p1 (copy)
		return function(p4) -- line: 23
			-- upvalues: v4 (copy), p3 (copy), p1 (copy), p2 (copy)
			if typeof(p4) == "table" and p4[v4] == true then
				return p4(p3, p1)
			end

			return p2(p4)
		end
	end
end
function t1.new(p5, p6) -- line: 33
	-- upvalues: ArgCheck (copy), v4 (copy)
	ArgCheck.isNonEmptyString(p5, "name")
	ArgCheck.isType(p6, "function", "onInvoke")

	return (setmetatable({
		[v4] = true,
		type = p5
	}, {
		__call = function(_, ...) -- line: 41
			-- upvalues: p6 (copy)
			p6(...)
		end
	}))
end
function t1.test(p8, p9, p10) -- line: 47
	-- upvalues: ArgCheck (copy), v4 (copy)
	ArgCheck.assert(type(p8) == "table" and p8[v4] == true, "'thunk' must be a valid RNAdapterThunk")

	return p8(p9, p10)
end
function t1.is(p11) -- line: 56
	-- upvalues: v4 (copy)
	if type(p11) == "table" then
		return p11[v4] == true
	end

	return false
end

return t1
