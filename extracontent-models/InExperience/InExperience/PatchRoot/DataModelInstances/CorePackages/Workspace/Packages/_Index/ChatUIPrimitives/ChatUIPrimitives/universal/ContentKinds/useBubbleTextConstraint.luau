local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)

local Sizing = require(script.Parent.Parent.Sizing)

local function useBubbleTextConstraint()
	local contentMaxWidth = Sizing.useSizing().bubble.contentMaxWidth
	return React.useMemo(function()
		return {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(contentMaxWidth, 1e999)
		}
	end, { contentMaxWidth })
end

return useBubbleTextConstraint
