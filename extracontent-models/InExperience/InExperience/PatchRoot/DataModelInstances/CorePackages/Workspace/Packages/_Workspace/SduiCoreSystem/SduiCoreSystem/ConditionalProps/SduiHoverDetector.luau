local parent = script:FindFirstAncestor("SduiCoreSystem").Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore

local function SduiHoverDetector(p)
	local guiObject = p.guiObject

	React.useEffect(function()
		local connections = {}

		if guiObject then
			table.insert(connections, guiObject.MouseEnter:Connect(function()
				if GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer then
					p.setHovered(true)
				end
			end))

			table.insert(connections, guiObject.MouseLeave:Connect(function()
				p.setHovered(false)
			end))
		end

		return function()
			for _, connection in connections do
				if connection then
					connection:Disconnect()
				end
			end
		end
	end, { guiObject })
end

return React.memo(SduiHoverDetector)
