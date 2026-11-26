local function invalidKey(p2, p3)
	local formatted = ("%q (%s) is not a valid member of %s"):format(
		tostring(p3),
		typeof(p3),
		(tostring(p2))
	)

	error(formatted, 2)
end

local function strict(p2, p3)
	return (setmetatable(p2, {
		__index = invalidKey,
		__newindex = invalidKey,
		__tostring = function()
			return p3
		end
	}))
end

return strict
