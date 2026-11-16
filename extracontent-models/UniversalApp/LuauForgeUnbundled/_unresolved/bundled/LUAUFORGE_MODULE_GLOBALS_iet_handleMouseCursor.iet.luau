local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Signals = require(CorePackages.Packages.Signals)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local inputModeStore = Responsive.GetInputModeStore(false)
local input = Responsive.Input

function LUAUFORGE_MODULE_GLOBALS_iet_handleMouseCursor()
	local getLastInputType = inputModeStore.getLastInputType
	return Signals.createEffect(function(p2)
		local lastInputType = getLastInputType(p2)

		if lastInputType == input.Pointer then
			UserInputService.MouseIconEnabled = true
		elseif lastInputType == input.Touch or lastInputType == input.Directional then
			UserInputService.MouseIconEnabled = false
		end
	end)
end

return LUAUFORGE_MODULE_GLOBALS_iet_handleMouseCursor
