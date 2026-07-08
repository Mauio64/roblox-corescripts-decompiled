local t1 = {}
local v2 = require(script.Parent.Symbol).named("ThunkTag")

function t1.middleware(p1) -- line: 15
	-- upvalues: v2 (copy)
	local u4 = p1 or {}

	return function(p2, p3) -- line: 18
		-- upvalues: v2 (copy), u4 (ref)
		return function(p4) -- line: 23
			-- upvalues: v2 (copy), u4 (ref), p3 (copy), p2 (copy)
			if p4[v2] == true then
				local t2 = {}

				for _, v in pairs(p4.requiredServices) do
					local v21 = u4[v]

					if v21 == nil then
						error(("Service with key %s is a dependency but was not provided"):format(v))
					end

					t2[v] = v21
				end

				return p4(p3, t2)
			end

			return p2(p4)
		end
	end
end
function t1.new(p5, p6, p7) -- line: 51
	-- upvalues: v2 (copy)
	assert(typeof(p5) == "string", "Bad arg #1: name must be a string")
	assert(p6 == nil or typeof(p6) == "table", "Bad arg #2: requiredServices must be a table or nil")
	assert(typeof(p7) == "function", "Bad arg #3: onInvoke must be a function")

	local v8 = p6 or {}

	return (setmetatable({
		[v2] = true,
		type = p5,
		requiredServices = v8
	}, {
		__call = function(_, ...) -- line: 66
			-- upvalues: p7 (copy)
			p7(...)
		end
	}))
end
function t1.test(p9, p10, p11) -- line: 72
	-- upvalues: v2 (copy)
	assert(typeof(p9) == "table" and p9[v2] == true, "Test Error - Bad arg #1: Must provide a valid thunk")

	if #p9.requiredServices > 0 then
		for _, v in ipairs(p9.requiredServices) do
			assert(p11[v] ~= nil, "Test Error - Bad arg #3: Missing required service " .. tostring(v))
		end
	end

	return p9(p10, p11)
end

return t1
