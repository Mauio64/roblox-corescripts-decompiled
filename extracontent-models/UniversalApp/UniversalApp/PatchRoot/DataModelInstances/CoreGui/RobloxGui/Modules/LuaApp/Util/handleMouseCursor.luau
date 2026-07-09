local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Signals = require(CorePackages.Packages.Signals)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local v5 = Responsive.GetInputModeStore(false)
local Input = Responsive.Input

function handleMouseCursor() -- line: 10
	-- upvalues: v5 (copy), Signals (copy), Input (copy), UserInputService (copy)
	local getLastInputType = v5.getLastInputType

	return Signals.createEffect(function(p1) -- line: 12
		-- upvalues: getLastInputType (copy), Input (copy), UserInputService (copy)
		local v9 = getLastInputType(p1)

		if v9 == Input.Pointer then
			UserInputService.MouseIconEnabled = true

			return
		end

		if v9 == Input.Touch or v9 == Input.Directional then
			UserInputService.MouseIconEnabled = false
		end
	end)
end

return handleMouseCursor
