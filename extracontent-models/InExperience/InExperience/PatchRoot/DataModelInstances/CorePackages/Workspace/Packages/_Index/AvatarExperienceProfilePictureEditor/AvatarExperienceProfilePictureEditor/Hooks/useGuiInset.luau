local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local Display = require(parent.Display)

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

local function computeGuiInset()
	local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
	local guiInset, v = GuiService:GetGuiInset()
	local y = UserInputService.BottomBarSize.Y
	local bottom = GuiService:GetSafeZoneOffsets().bottom

	local guiInset2 = {
		top = shouldUseDeviceSafeInsets and 0 or UserInputService.StatusBarSize.Y,
		left = guiInset.X,
		right = v.X,
		bottom = 0
	}

	if y ~= 0 then
		bottom = y
	end

	guiInset2.bottom = bottom
	return guiInset2
end

return {
	useGuiInset = function()
		local state, setState = React.useState(computeGuiInset)

		React.useEffect(function()
			local function updateGuiInset()
				setState(computeGuiInset())
			end

			local v = {
				GuiService.SafeZoneOffsetsChanged:Connect(updateGuiInset),
				UserInputService:GetPropertyChangedSignal("StatusBarSize"):Connect(updateGuiInset),
				UserInputService:GetPropertyChangedSignal("BottomBarSize"):Connect(updateGuiInset),
				UserInputService:GetPropertyChangedSignal("RightBarSize"):Connect(updateGuiInset)
			}

			return function()
				for _, connection in v do
					connection:Disconnect()
				end
			end
		end, {})

		return state
	end,
	computeGuiInset = computeGuiInset
}
