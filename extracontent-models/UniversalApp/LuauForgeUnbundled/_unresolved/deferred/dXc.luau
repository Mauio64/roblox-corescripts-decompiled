local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")

return function()
	local state, setState = React.useState(GuiService:GetSafeZoneOffsets())

	React.useEffect(function()
		local safeZoneOffsetsChangedConnection = GuiService.SafeZoneOffsetsChanged:Connect(function()
			setState(GuiService:GetSafeZoneOffsets())
		end)

		return function()
			safeZoneOffsetsChangedConnection:Disconnect()
		end
	end, {})

	return state
end
