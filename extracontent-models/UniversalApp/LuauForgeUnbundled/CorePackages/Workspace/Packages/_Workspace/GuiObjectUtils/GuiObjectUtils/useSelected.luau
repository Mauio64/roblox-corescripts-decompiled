local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GuiObjectUtils/React")

local function isGuiObjectSelected(p2): boolean
	if p2.current == nil then
		return false
	end

	return GuiService.SelectedCoreObject == p2.current or GuiService.SelectedObject == p2.current
end

local function useSelected(p2)
	local state, setState = React.useState(function(): boolean
		local v5 = p2

		if v5.current == nil then
			return false
		end

		return GuiService.SelectedCoreObject == v5.current or GuiService.SelectedObject == v5.current
	end)

	React.useEffect(function()
		local v6 = p2
		setState(v6.current ~= nil and (GuiService.SelectedCoreObject == v6.current or GuiService.SelectedObject == v6.current))
	end, { p2 })

	React.useEffect(function()
		local connections = {}
		local current = p2.current

		if current then
			table.insert(connections, current.SelectionGained:Connect(function()
				setState(true)
			end))

			table.insert(connections, current.SelectionLost:Connect(function()
				setState(false)
			end))
		end

		return function()
			for i, connection in ipairs(connections) do
				connection:Disconnect()
			end
		end
	end, { p2 })

	return state
end

return useSelected
