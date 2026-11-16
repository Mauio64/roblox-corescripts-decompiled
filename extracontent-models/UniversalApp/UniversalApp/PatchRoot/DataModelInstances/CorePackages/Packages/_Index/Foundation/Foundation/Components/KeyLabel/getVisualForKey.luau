local Foundation = script:FindFirstAncestor("Foundation")

local Wrappers = require(Foundation.Utility.Wrappers)
local UserInputService = Wrappers.Services.UserInputService

local v = {}

return function(p)
	if v[p] then
		return v[p]
	end

	local imageForKeyCode = UserInputService:GetImageForKeyCode(p)

	if imageForKeyCode and imageForKeyCode ~= "" then
		return { keyVisualType = "Image", size = UDim2.fromScale(0.7, 0.7), key = imageForKeyCode }
	end

	local stringForKeyCode = UserInputService:GetStringForKeyCode(p)
	local v2 = {
		keyVisualType = "String",
		size = UDim2.fromScale(0.8, 0.8),
		key = stringForKeyCode or ""
	}

	v[p] = v2
	return v2
end
