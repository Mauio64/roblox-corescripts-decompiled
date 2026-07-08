local ParentParent = script.Parent.Parent

require(ParentParent.types)

local function preventExtensions(p1) -- line: 10
	local str = tostring(p1)

	return (setmetatable(p1, {
		__metatable = false,
		__newindex = function(_, p3, _) -- line: 15
			-- upvalues: str (copy)
			local v8 = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), str)

			error(v8, 2)
		end
	}))
end

return preventExtensions
