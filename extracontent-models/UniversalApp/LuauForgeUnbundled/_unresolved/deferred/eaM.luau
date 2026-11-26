local HttpService = game:GetService("HttpService")

return function(json)
	if not json then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if not (success and result) then
		return nil
	end

	local result2 = {}
	local set = {}

	local function addItems(items)
		for k, item in pairs(items) do
			if set[item] then
				continue
			end

			table.insert(result2, item)
			set[item] = true
		end
	end

	if result.avatarItems then
		local avatarItems = result.avatarItems

		for k, avatarItem in pairs(avatarItems) do
			if set[avatarItem] then
				continue
			end

			table.insert(result2, avatarItem)
			set[avatarItem] = true
		end
	end

	if result.userMetadata then
		for k, v5 in pairs(result.userMetadata) do
			if not v5.avatarItems then
				continue
			end

			local avatarItems = v5.avatarItems

			for k2, avatarItem in pairs(avatarItems) do
				if set[avatarItem] then
					continue
				end

				table.insert(result2, avatarItem)
				set[avatarItem] = true
			end
		end
	end

	if next(result2) == nil then
		return nil
	end

	return result2
end
