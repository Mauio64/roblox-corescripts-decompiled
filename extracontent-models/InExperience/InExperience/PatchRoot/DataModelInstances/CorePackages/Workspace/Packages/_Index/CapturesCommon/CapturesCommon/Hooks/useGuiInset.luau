local ParentParent = script.Parent.Parent.Parent
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection

return function() -- line: 22
	-- upvalues: React (copy), GuiService (copy), useEventConnection (copy), UserInputService (copy)
	local useState = React.useState
	local v9, v10 = GuiService:GetGuiInset()
	local v11, v12 = useState({
		bottom = v10.Y,
		left = v9.X,
		right = v10.X,
		top = v9.Y
	})

	local function v13() -- line: 25
		-- upvalues: v12 (copy), GuiService (copy)
		local v14 = v12
		local v15, v16 = GuiService:GetGuiInset()

		v14({
			bottom = v16.Y,
			left = v15.X,
			right = v16.X,
			top = v15.Y
		})
	end

	useEventConnection(GuiService.SafeZoneOffsetsChanged, v13)
	useEventConnection(UserInputService:GetPropertyChangedSignal("BottomBarSize"), v13)
	useEventConnection(UserInputService:GetPropertyChangedSignal("RightBarSize"), v13)

	return v11
end
