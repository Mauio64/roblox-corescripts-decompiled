local Foundation = script:FindFirstAncestor("Foundation")
local UserInputService = require(Foundation.Utility.Wrappers).Services.UserInputService
local t1 = {}

return function(p1) -- line: 13
	-- upvalues: t1 (copy), UserInputService (copy)
	if t1[p1] then
		return t1[p1]
	end

	local ImageForKeyCode = UserInputService:GetImageForKeyCode(p1)

	if ImageForKeyCode and ImageForKeyCode ~= "" then
		return {
			keyVisualType = "Image",
			size = UDim2.fromScale(0.7, 0.7),
			key = ImageForKeyCode
		}
	end

	local StringForKeyCode = UserInputService:GetStringForKeyCode(p1)
	local t2 = {
		keyVisualType = "String",
		size = UDim2.fromScale(0.8, 0.8),
		key = StringForKeyCode or ""
	}

	t1[p1] = t2

	return t2
end
