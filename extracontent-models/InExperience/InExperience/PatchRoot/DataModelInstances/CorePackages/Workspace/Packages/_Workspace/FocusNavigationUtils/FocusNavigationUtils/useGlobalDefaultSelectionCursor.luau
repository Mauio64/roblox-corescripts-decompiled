local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)
local useCursor = require(Parent.UIBlox).App.SelectionCursor.useCursor
local useDesignTokens = require(Parent.Style).useDesignTokens

local function useGlobalDefaultSelectionCursor() -- line: 10
	-- upvalues: useDesignTokens (copy), useCursor (copy), React (copy), CoreGui (copy)
	local v7 = useDesignTokens(function(p1) -- line: 11
		return {
			width = p1.Size.Size_50,
			radius = UDim.new(0, p1.Radius.Medium),
			offset = p1.Size.Size_50
		}
	end)
	local v8 = useCursor(v7.radius, v7.offset, v7.width)
	local v9 = if not v8 then nil else v8.current

	React.useEffect(function() -- line: 22
		-- upvalues: CoreGui (copy), v9 (copy)
		if CoreGui.SelectionImageObject == nil and v9 ~= nil then
			CoreGui.SelectionImageObject = v9

			return function() -- line: 26
				-- upvalues: CoreGui (copy)
				CoreGui.SelectionImageObject = nil
			end
		end

		return nil
	end, { v9 })
end

return useGlobalDefaultSelectionCursor
