local function isMeshPartAccessory(accessory): boolean
	if accessory:IsA("Accessory") then
		local handle = accessory:FindFirstChild("Handle")

		if handle and handle:IsA("MeshPart") then
			return true
		end
	end

	return false
end

return isMeshPartAccessory
