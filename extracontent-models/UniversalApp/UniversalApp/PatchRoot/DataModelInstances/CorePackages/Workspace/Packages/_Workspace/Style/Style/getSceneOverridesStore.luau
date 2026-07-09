local u1 = nil
local t1 = {}
local t2 = {
	getSceneOverrides = function() -- line: 24
		-- upvalues: u1 (ref)
		return u1
	end,
	setSceneOverrides = function(p1) -- line: 27
		-- upvalues: u1 (ref), t1 (copy)
		u1 = p1

		for _, v7 in t1 do
			v7(p1)
		end
	end,
	subscribe = function(p2) -- line: 33
		-- upvalues: t1 (copy)
		table.insert(t1, p2)

		return function() -- line: 35
			-- upvalues: t1 (copy), p2 (copy)
			local v9 = table.find(t1, p2)

			if v9 then
				table.remove(t1, v9)
			end
		end
	end
}

local function getSceneOverridesStore() -- line: 44
	-- upvalues: t2 (copy)
	return t2
end

return getSceneOverridesStore
