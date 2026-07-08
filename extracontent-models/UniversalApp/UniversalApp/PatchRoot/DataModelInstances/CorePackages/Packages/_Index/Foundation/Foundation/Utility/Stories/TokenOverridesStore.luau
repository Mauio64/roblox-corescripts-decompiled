local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)

local u2 = nil
local t1 = {}
local t2 = {
	getTokenOverrides = function() -- line: 35
		-- upvalues: u2 (ref)
		return u2
	end,
	setTokenOverrides = function(p1) -- line: 38
		-- upvalues: u2 (ref), t1 (copy)
		u2 = p1

		for _, v8 in t1 do
			v8(p1)
		end
	end,
	subscribe = function(p2) -- line: 44
		-- upvalues: t1 (copy)
		table.insert(t1, p2)

		return function() -- line: 46
			-- upvalues: t1 (copy), p2 (copy)
			local v10 = table.find(t1, p2)

			if v10 then
				table.remove(t1, v10)
			end
		end
	end
}

local function getTokenOverridesStore() -- line: 55
	-- upvalues: t2 (copy)
	return t2
end

return getTokenOverridesStore
