local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/hSL")
local module2 = require("@luauforge/bundled/hSR")

local function useHideMouseCursorEffect()
	local v5 = module2.useLastInput() == module2.Input.Pointer
	module.useEffect(function()
		UserInputService.MouseIconEnabled = v5
	end, { v5 })
end

return useHideMouseCursorEffect
