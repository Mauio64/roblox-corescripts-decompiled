local parent = script.Parent.Parent.Parent

require(parent.React)

local function setAndForwardRef(p)
	local getForwardedRef = p.getForwardedRef
	local setLocalRef = p.setLocalRef
	return function(current)
		local forwardedRef = getForwardedRef()
		setLocalRef(current)

		if typeof(forwardedRef) == "function" then
			forwardedRef(current)
		elseif typeof(forwardedRef) == "table" then
			forwardedRef.current = current
		end
	end
end

return setAndForwardRef
