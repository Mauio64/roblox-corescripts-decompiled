local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local React = require(Parent.React)

local function SduiSelectionDetector(t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy)
	local guiObject = t1.guiObject
	local setSelected = t1.setSelected

	React.useEffect(function() -- line: 14
		-- upvalues: guiObject (copy), setSelected (copy)
		local t2 = {}

		if guiObject then
			table.insert(t2, guiObject.SelectionGained:Connect(function() -- line: 19
				-- upvalues: setSelected (copy)
				setSelected(true)
			end))
			table.insert(t2, guiObject.SelectionLost:Connect(function() -- line: 25
				-- upvalues: setSelected (copy)
				setSelected(false)
			end))
		end

		return function() -- line: 30
			-- upvalues: t2 (copy)
			for _, v9 in t2 do
				if v9 then
					v9:Disconnect()
				end
			end
		end
	end, {
		guiObject,
		setSelected
	})
end

return React.memo(SduiSelectionDetector)
