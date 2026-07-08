local function getAttachment(p1, t1: {[any]: any}) -- line: 1
	for _, v in pairs(t1) do
		local v2 = p1:FindFirstChild(v)

		if v2 then
			if v2:IsA("Attachment") then
				return v2
			end

			return v2
		end
	end

	return nil
end

return getAttachment
