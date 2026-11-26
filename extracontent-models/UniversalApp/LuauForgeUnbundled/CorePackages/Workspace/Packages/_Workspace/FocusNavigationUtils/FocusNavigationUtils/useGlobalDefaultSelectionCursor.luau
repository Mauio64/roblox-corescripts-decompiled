local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local useCursor = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/UIBlox").App.SelectionCursor.useCursor
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Style").useDesignTokens

local function useGlobalDefaultSelectionCursor()
	local v5 = useDesignTokens(function(p2)
		return {
			width = p2.Size.Size_50,
			radius = UDim.new(0, p2.Radius.Medium),
			offset = p2.Size.Size_50
		}
	end)

	local v6 = useCursor(v5.radius, v5.offset, v5.width)
	local current = if v6 then v6.current else nil

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
