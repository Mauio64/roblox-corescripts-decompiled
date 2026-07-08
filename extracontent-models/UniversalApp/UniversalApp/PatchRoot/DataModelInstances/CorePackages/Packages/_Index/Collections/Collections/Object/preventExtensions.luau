local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

local function preventExtensions(p1) -- line: 26
	local str = tostring(p1)

	return (setmetatable(p1, {
		__metatable = false,
		__newindex = function(_, p3, _) -- line: 31
			-- upvalues: str (copy)
			local v8 = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), str)

			error(v8, 2)
		end
	}))
end

return preventExtensions
