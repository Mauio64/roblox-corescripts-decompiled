return function(instance, className)
	local count = 0

	for _, child in pairs(instance:GetChildren()) do
		if not className or child:IsA(className) then
			count += 1
		end
	end

	return count
end
