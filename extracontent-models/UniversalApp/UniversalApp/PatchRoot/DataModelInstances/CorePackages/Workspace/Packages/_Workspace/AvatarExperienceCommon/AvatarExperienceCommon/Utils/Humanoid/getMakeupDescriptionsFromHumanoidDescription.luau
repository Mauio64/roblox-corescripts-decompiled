local function getMakeupDescriptionsFromHumanoidDescription(p1) -- line: 5
	local t1 = {}

	for _, child in p1:GetChildren() do
		if child:IsA("MakeupDescription") then
			table.insert(t1, child)
		end
	end

	return t1
end

return getMakeupDescriptionsFromHumanoidDescription
