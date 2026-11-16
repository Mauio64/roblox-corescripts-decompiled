local function destroyMakeupDescriptions(instance)
	for i, makeupDescription in instance:GetChildren() do
		if makeupDescription:IsA("MakeupDescription") then
			makeupDescription:Destroy()
		end
	end
end

return destroyMakeupDescriptions
