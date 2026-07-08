local function strict(p1, s1: string?) -- line: 1
	local v4 = s1 or tostring(p1)

	return (setmetatable(p1, {
		__index = function(_, p3) -- line: 5
			-- upvalues: v4 (copy)
			local v7 = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), v4)

			error(v7, 2)
		end,
		__newindex = function(_, p5, _) -- line: 11
			-- upvalues: v4 (copy)
			local v11 = ("%q (%s) is not a valid member of %s"):format(tostring(p5), typeof(p5), v4)

			error(v11, 2)
		end
	}))
end

return strict
