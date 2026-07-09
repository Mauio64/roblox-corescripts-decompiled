local function invalidKey(p1, p2) -- line: 7
	local v5 = ("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), (tostring(p1)))

	error(v5, 2)
end
local function strict(p3, p4) -- line: 13
	-- upvalues: invalidKey (copy)
	return (setmetatable(p3, {
		__index = invalidKey,
		__newindex = invalidKey,
		__tostring = function() -- line: 17
			-- upvalues: p4 (copy)
			return p4
		end
	}))
end

return strict
