local parent = script:FindFirstAncestor("SduiCoreSystem").Parent

local React = require(parent.React)

local function SduiSelectionDetector(p)
	local guiObject = p.guiObject
	local setSelected = p.setSelected

	React.useEffect(function()
		local connections = {}

		if guiObject then
			table.insert(connections, guiObject.SelectionGained:Connect(function()
				setSelected(true)
			end))

			table.insert(connections, guiObject.SelectionLost:Connect(function()
				setSelected(false)
			end))
		end

		return function()
			for _, connection in connections do
				if connection then
					connection:Disconnect()
				end
			end
		end
	end, { guiObject, setSelected })
end

return React.memo(SduiSelectionDetector)
