local CoreGui = game:GetService("CoreGui")
local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local function useGlobalDefaultSelectionCursor()
	local v = useDesignTokens(function(p)
		return {
			width = p.Size.Size_50,
			radius = UDim.new(0, p.Radius.Medium),
			offset = p.Size.Size_50
		}
	end)

	local v2 = useCursor(v.radius, v.offset, v.width)
	local current

	if v2 then
		current = v2.current
	else
		current = nil
	end

	React.useEffect(function()
		if CoreGui.SelectionImageObject ~= nil or current == nil then
			return nil
		end

		CoreGui.SelectionImageObject = current

		return function()
			CoreGui.SelectionImageObject = nil
		end
	end, { current })
end

return useGlobalDefaultSelectionCursor
