local function destroyMakeupDescriptions(p1) -- line: 5
	for _, child in p1:GetChildren() do
		if child:IsA("MakeupDescription") then
			child:Destroy()
		end
	end
end

return destroyMakeupDescriptions
