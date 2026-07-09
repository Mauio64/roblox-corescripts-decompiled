local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore

local function SduiHoverDetector(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), GetInputModeStore (copy), Responsive (copy)
	local guiObject = t1.guiObject

	React.useEffect(function() -- line: 18
		-- upvalues: guiObject (copy), GetInputModeStore (copy), Responsive (copy), t1 (copy)
		local t2 = {}

		if guiObject then
			table.insert(t2, guiObject.MouseEnter:Connect(function() -- line: 23
				-- upvalues: GetInputModeStore (copy), Responsive (copy), t1 (copy)
				if GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer then
					t1.setHovered(true)
				end
			end))
			table.insert(t2, guiObject.MouseLeave:Connect(function() -- line: 33
				-- upvalues: t1 (copy)
				t1.setHovered(false)
			end))
		end

		return function() -- line: 38
			-- upvalues: t2 (copy)
			for _, v10 in t2 do
				if v10 then
					v10:Disconnect()
				end
			end
		end
	end, { guiObject })
end

return React.memo(SduiHoverDetector)
