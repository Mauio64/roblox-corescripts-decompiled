local function isMeshPartAccessory(p1) -- line: 1
	if p1:IsA("Accessory") then
		local Handle = p1:FindFirstChild("Handle")

		if Handle and Handle:IsA("MeshPart") then
			return true
		end
	end

	return false
end

return isMeshPartAccessory
