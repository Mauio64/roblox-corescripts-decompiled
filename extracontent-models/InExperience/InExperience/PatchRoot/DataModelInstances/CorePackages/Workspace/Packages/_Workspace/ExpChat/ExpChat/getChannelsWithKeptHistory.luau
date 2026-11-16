return function(items, p: number)
	local result = {}

	if p <= 0 then
		return result
	end

	for _, item in items do
		local textChannel = item.TextChannel

		if textChannel then
			result[textChannel.Name] = item
		end
	end

	return result
end
