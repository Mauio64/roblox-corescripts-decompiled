local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)

local function useMenuItemHover(data)
	React.useEffect(function()
		if not (data.itemRef.current ~= nil and typeof(data.itemRef.current) == "Instance") then
			return
		end

		local guiStateChangedConnection = data.itemRef.current:GetPropertyChangedSignal("GuiState"):Connect(function()
			if data.isSubmenu then
				if data.isDisabled then
					return
				end

				if data.itemRef.current.GuiState == Enum.GuiState.Hover then
					if data.hoverOpenAtDepth then
						data.hoverOpenAtDepth(data.depth, data.id)
					end
				elseif data.hoverCloseAtDepth then
					data.hoverCloseAtDepth(data.depth)
				end
			elseif data.itemRef.current.GuiState == Enum.GuiState.Hover and data.hoverCloseAtDepth then
				data.hoverCloseAtDepth(data.depth)
			end
		end)

		return function()
			guiStateChangedConnection:Disconnect()
		end
	end, {
		data.isSubmenu,
		data.isDisabled,
		data.id,
		data.depth,
		data.hoverCloseAtDepth,
		data.hoverOpenAtDepth,
		data.itemRef
	})
end

return useMenuItemHover
