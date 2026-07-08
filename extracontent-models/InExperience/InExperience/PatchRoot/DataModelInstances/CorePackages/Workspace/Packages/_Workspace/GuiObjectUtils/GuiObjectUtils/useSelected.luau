local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("GuiObjectUtils").Parent
local React = require(Parent.React)

local function isGuiObjectSelected(t1: {[any]: any}) -- line: 12
	-- upvalues: GuiService (copy)
	if t1.current == nil then
		return false
	end

	return GuiService.SelectedCoreObject == t1.current or GuiService.SelectedObject == t1.current
end
local function useSelected(t2: {[any]: any}) -- line: 19
	-- upvalues: React (copy), GuiService (copy)
	local v8, v9 = React.useState(function() -- line: 20
		-- upvalues: t2 (copy), GuiService (copy)
		local v10 = t2

		if v10.current == nil then
			return false
		end

		return GuiService.SelectedCoreObject == v10.current or GuiService.SelectedObject == v10.current
	end)

	React.useEffect(function() -- line: 25
		-- upvalues: v9 (copy), t2 (copy), GuiService (copy)
		local v11 = v9
		local v12 = t2

		v11(v12.current ~= nil and (GuiService.SelectedCoreObject == v12.current or GuiService.SelectedObject == v12.current))
	end, { t2 })
	React.useEffect(function() -- line: 33
		-- upvalues: t2 (copy), v9 (copy)
		local t3 = {}
		local current = t2.current

		if current then
			table.insert(t3, current.SelectionGained:Connect(function() -- line: 39
				-- upvalues: v9 (copy)
				v9(true)
			end))
			table.insert(t3, current.SelectionLost:Connect(function() -- line: 45
				-- upvalues: v9 (copy)
				v9(false)
			end))
		end

		return function() -- line: 51
			-- upvalues: t3 (copy)
			for _, v in ipairs(t3) do
				v:Disconnect()
			end
		end
	end, { t2 })

	return v8
end

return useSelected
