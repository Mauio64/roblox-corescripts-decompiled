local function strict(p, p2: string?)
	local v = p2 or tostring(p)

	return (setmetatable(p, {
		__index = function(_, p3)
			local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), v)

			error(formatted, 2)
		end,
		__newindex = function(_, p3)
			local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), v)

			error(formatted, 2)
		end
	}))
end

return strict
