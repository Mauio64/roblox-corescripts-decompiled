local UserInputService = game:GetService("UserInputService")

local function doesGamepadSupportKeyCodes(items, p): boolean
	for _, item in items do
		if not UserInputService:GamepadSupports(p, item) then
			return false
		end
	end

	return true
end

return doesGamepadSupportKeyCodes
