local UserInputService = game:GetService("UserInputService")

local function doesGamepadSupportKeyCodes(items, p2): boolean
	for k, item in items do
		if not UserInputService:GamepadSupports(p2, item) then
			return false
		end
	end

	return true
end

return doesGamepadSupportKeyCodes
