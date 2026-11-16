local function getAttachment(instance, items)
	for _, childName in pairs(items) do
		local attachment = instance:FindFirstChild(childName)

		if attachment then
			if attachment:IsA("Attachment") then
			end

			return attachment
		end
	end

	return nil
end

return getAttachment
