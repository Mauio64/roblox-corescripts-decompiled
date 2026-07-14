local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function useMenuItemCursor() -- line: 10
	-- upvalues: Foundation (copy), React (copy)
	local v5 = Foundation.Hooks.useTokens()

	return React.useMemo(function() -- line: 12
		-- upvalues: v5 (copy)
		return {
			radius = UDim.new(0, v5.Radius.Small),
			offset = v5.Size.Size_200,
			borderWidth = v5.Stroke.Thicker
		}
	end, { v5 })
end

return useMenuItemCursor
