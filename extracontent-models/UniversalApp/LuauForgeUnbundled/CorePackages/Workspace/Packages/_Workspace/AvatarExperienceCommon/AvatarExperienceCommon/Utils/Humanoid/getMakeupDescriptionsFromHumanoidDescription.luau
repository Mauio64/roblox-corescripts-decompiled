local function getMakeupDescriptionsFromHumanoidDescription(instance)
	local makeupDescriptions = {}

	for i, makeupDescription in instance:GetChildren() do
		if makeupDescription:IsA("MakeupDescription") then
			table.insert(makeupDescriptions, makeupDescription)
		end
	end

	return makeupDescriptions
end

return getMakeupDescriptionsFromHumanoidDescription
