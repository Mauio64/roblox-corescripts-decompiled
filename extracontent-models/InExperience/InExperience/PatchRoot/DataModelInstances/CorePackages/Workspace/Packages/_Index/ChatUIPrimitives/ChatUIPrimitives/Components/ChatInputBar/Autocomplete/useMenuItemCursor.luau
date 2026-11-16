local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function useMenuItemCursor()
	local v = Foundation.Hooks.useTokens()
	return React.useMemo(function()
		return {
			radius = UDim.new(0, v.Radius.Small),
			offset = v.Size.Size_200,
			borderWidth = v.Stroke.Thicker
		}
	end, { v })
end

return useMenuItemCursor
