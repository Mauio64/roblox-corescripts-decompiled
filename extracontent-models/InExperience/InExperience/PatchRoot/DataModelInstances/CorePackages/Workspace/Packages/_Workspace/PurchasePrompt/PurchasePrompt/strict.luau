local function invalidKey(p, p2)
	local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), (tostring(p)))

	error(formatted, 2)
end

local function strict(p, p2)
	return (setmetatable(p, {
		__index = invalidKey,
		__newindex = invalidKey,
		__tostring = function()
			return p2
		end
	}))
end

return strict
