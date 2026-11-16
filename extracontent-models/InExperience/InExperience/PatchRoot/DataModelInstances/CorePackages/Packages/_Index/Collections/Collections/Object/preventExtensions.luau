local parent = script.Parent.Parent.Parent

require(parent.ES7Types)

local function preventExtensions(p)
	local v = tostring(p)

	return (setmetatable(p, {
		__newindex = function(_, p2, _)
			local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), v)

			error(formatted, 2)
		end,
		__metatable = false
	}))
end

return preventExtensions
