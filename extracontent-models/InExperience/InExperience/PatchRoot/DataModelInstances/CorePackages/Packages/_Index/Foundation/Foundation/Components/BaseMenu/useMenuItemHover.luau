local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local function useMenuItemHover(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 30
		-- upvalues: t1 (copy)
		if t1.itemRef.current == nil then
			return
		end

		if typeof(t1.itemRef.current) ~= "Instance" then
			return
		end

		local connection = t1.itemRef.current:GetPropertyChangedSignal("GuiState"):Connect(function() -- line: 38
			-- upvalues: t1 (copy)
			if t1.isSubmenu then
				if t1.isDisabled then
					return
				end

				if t1.itemRef.current.GuiState == Enum.GuiState.Hover then
					if t1.hoverOpenAtDepth then
						t1.hoverOpenAtDepth(t1.depth, t1.id)

						return
					end
				elseif t1.hoverCloseAtDepth then
					t1.hoverCloseAtDepth(t1.depth)

					return
				end
			elseif t1.itemRef.current.GuiState == Enum.GuiState.Hover and t1.hoverCloseAtDepth then
				t1.hoverCloseAtDepth(t1.depth)
			end
		end)

		return function() -- line: 64
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t1.isSubmenu,
		t1.isDisabled,
		t1.id,
		t1.depth,
		t1.hoverCloseAtDepth,
		t1.hoverOpenAtDepth,
		t1.itemRef
	})
end

return useMenuItemHover
