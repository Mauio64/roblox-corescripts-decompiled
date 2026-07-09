local scriptParent = script.Parent
local t1 = {}
local v3 = require(scriptParent.Symbols.Symbol).named("ThunkTag")

function t1.middleware(p1) -- line: 16
	-- upvalues: v3 (copy)
	local u5 = p1 or {}

	return function(p2, p3) -- line: 19
		-- upvalues: v3 (copy), u5 (ref)
		return function(p4) -- line: 24
			-- upvalues: v3 (copy), u5 (ref), p3 (copy), p2 (copy)
			if p4[v3] == true then
				local t2 = {}

				for _, v in pairs(p4.requiredServices) do
					local v22 = u5[v]

					if v22 == nil then
						error(("Service with key %s is a dependency but was not provided"):format((tostring(v))))
					end

					t2[v] = v22
				end

				return p4(p3, t2)
			end

			return p2(p4)
		end
	end
end
function t1.new(p5, p6, p7) -- line: 52
	-- upvalues: v3 (copy)
	assert(typeof(p5) == "string", "Bad arg #1: name must be a string")
	assert(p6 == nil or typeof(p6) == "table", "Bad arg #2: requiredServices must be a table or nil")
	assert(typeof(p7) == "function", "Bad arg #3: onInvoke must be a function")

	local v9 = p6 or {}

	return (setmetatable({
		[v3] = true,
		type = p5,
		requiredServices = v9
	}, {
		__call = function(_, ...) -- line: 67
			-- upvalues: p7 (copy)
			return p7(...)
		end
	}))
end
function t1.test(p9, p10, p11) -- line: 73
	-- upvalues: v3 (copy)
	assert(typeof(p9) == "table" and p9[v3] == true, "Test Error - Bad arg #1: Must provide a valid thunk")

	if #p9.requiredServices > 0 then
		for _, v in ipairs(p9.requiredServices) do
			assert(p11[v] ~= nil, "Test Error - Bad arg #3: Missing required service " .. tostring(v))
		end
	end

	return p9(p10, p11)
end

return t1
