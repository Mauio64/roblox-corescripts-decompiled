local ParentParent = script.Parent.Parent.Parent
local GuiService = game:GetService("GuiService")
local React = require(ParentParent.React)

return function() -- line: 8
	-- upvalues: React (copy), GuiService (copy)
	local v4, v5 = React.useState(GuiService.TopbarInset.Height)

	React.useEffect(function() -- line: 11
		-- upvalues: GuiService (copy), v5 (copy)
		local connection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 13
			-- upvalues: v5 (copy), GuiService (copy)
			v5(GuiService.TopbarInset.Height)
		end)

		return function() -- line: 17
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v4
end
