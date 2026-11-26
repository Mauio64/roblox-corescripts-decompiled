local GuiService = game:GetService("GuiService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local function getHardwareSafeAreaInsets()
	local insetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
	local insetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.None)

	return {
		left = insetArea.Min.X - insetArea2.Min.X,
		top = insetArea.Min.Y - insetArea2.Min.Y,
		right = insetArea2.Max.X - insetArea.Max.X,
		bottom = insetArea2.Max.Y - insetArea.Max.Y
	}
end

local function useHardwareInsets(instance)
	local state, setState = React.useState(getHardwareSafeAreaInsets)

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if instance then
			absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState(function(data)
					local hardwareSafeAreaInsets = getHardwareSafeAreaInsets()

					if
						hardwareSafeAreaInsets.bottom == data.bottom
						and hardwareSafeAreaInsets.top == data.top
						and hardwareSafeAreaInsets.left == data.left
						and hardwareSafeAreaInsets.right == data.right
					then
						return data
					end

					return hardwareSafeAreaInsets
				end)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { instance })

	return state
end

return useHardwareInsets
