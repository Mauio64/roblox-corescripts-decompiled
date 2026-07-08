local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)

local function useTableWrappedCallbackRef(p1) -- line: 11
	-- upvalues: React (copy)
	local v5 = React.useRef(nil)

	React.useImperativeHandle(p1, function() -- line: 19
		-- upvalues: v5 (copy)
		return v5.current
	end)

	return v5
end

return useTableWrappedCallbackRef
