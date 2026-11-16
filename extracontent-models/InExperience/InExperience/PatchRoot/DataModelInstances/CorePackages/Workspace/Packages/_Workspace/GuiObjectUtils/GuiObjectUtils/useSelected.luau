local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("GuiObjectUtils").Parent
local React = require(parent.React)

local function isGuiObjectSelected(p): boolean -- 2 equivalent calls inferred from this helper
	if p.current == nil then
		return false
	end

	return GuiService.SelectedCoreObject == p.current or GuiService.SelectedObject == p.current
end

local function useSelected(p)
	local state, setState = React.useState(function()
		return isGuiObjectSelected(p) -- inferred equivalent call
	end)

	React.useEffect(function()
		setState(isGuiObjectSelected(p)) -- inferred equivalent call
	end, { p })

	React.useEffect(function()
		local connections = {}
		local current = p.current

		if current then
			table.insert(connections, current.SelectionGained:Connect(function()
				setState(true)
			end))

			table.insert(connections, current.SelectionLost:Connect(function()
				setState(false)
			end))
		end

		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
		end
	end, { p })

	return state
end

return useSelected
