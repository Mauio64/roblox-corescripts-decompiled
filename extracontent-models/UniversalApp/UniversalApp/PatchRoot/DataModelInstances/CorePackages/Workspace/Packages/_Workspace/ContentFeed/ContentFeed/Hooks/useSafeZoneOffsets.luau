local ParentParent = script.Parent.Parent.Parent
local GuiService = game:GetService("GuiService")
local React = require(ParentParent.React)

return function() -- line: 8
	-- upvalues: React (copy), GuiService (copy)
	local v4, v5 = React.useState(GuiService:GetSafeZoneOffsets())

	React.useEffect(function() -- line: 11
		-- upvalues: GuiService (copy), v5 (copy)
		local connection = GuiService.SafeZoneOffsetsChanged:Connect(function() -- line: 12
			-- upvalues: v5 (copy), GuiService (copy)
			v5(GuiService:GetSafeZoneOffsets())
		end)

		return function() -- line: 16
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v4
end
