local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Display")

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")

local function computeGuiInset()
	local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
	local guiInset, v5 = GuiService:GetGuiInset()
	local y = UserInputService.BottomBarSize.Y
	local v6 = GuiService:GetSafeZoneOffsets().bottom

	local guiInset2 = {
		top = shouldUseDeviceSafeInsets and 0 or UserInputService.StatusBarSize.Y,
		left = guiInset.X,
		right = v5.X,
		bottom = 0
	}

	if y ~= 0 then
		v6 = y
	end

	guiInset2.bottom = v6
	return guiInset2
end

return {
	useGuiInset = function()
		local state, setState = React.useState(computeGuiInset)

		React.useEffect(function()
			local function updateGuiInset()
				setState(computeGuiInset())
			end

			local v5 = {
				GuiService.SafeZoneOffsetsChanged:Connect(updateGuiInset),
				UserInputService:GetPropertyChangedSignal("StatusBarSize"):Connect(updateGuiInset),
				UserInputService:GetPropertyChangedSignal("BottomBarSize"):Connect(updateGuiInset),
				UserInputService:GetPropertyChangedSignal("RightBarSize"):Connect(updateGuiInset)
			}

			return function()
				for k, connection in v5 do
					connection:Disconnect()
				end
			end
		end, {})

		return state
	end,
	computeGuiInset = computeGuiInset
}
