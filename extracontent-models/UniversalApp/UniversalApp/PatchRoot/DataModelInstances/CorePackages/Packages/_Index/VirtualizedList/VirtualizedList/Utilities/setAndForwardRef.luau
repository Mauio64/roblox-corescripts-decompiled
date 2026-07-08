local ParentParent = script.Parent.Parent.Parent

require(ParentParent.React)

local function setAndForwardRef(p1) -- line: 57
	local getForwardedRef = p1.getForwardedRef
	local setLocalRef = p1.setLocalRef

	return function(p2) -- line: 59
		-- upvalues: getForwardedRef (copy), setLocalRef (copy)
		local v7 = getForwardedRef()

		setLocalRef(p2)

		if typeof(v7) == "function" then
			v7(p2)

			return
		end

		if typeof(v7) == "table" then
			v7.current = p2
		end
	end
end

return setAndForwardRef
