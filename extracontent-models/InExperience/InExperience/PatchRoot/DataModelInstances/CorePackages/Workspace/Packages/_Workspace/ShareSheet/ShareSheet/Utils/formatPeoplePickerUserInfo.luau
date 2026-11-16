local FormatPeoplePickerUserInfo = {}

function FormatPeoplePickerUserInfo.formatDescription(items)
	local v = {}

	for _, item in items do
		if item.username ~= nil and item.username ~= "" then
			table.insert(v, `@{item.username}`)
		end
	end

	return table.concat(v, ", ")
end

function FormatPeoplePickerUserInfo.formatTitle(list)
	local displayNames = table.create(#list)

	for k, item in list do
		displayNames[k] = item.displayName
	end

	return table.concat(displayNames, ", ")
end

return FormatPeoplePickerUserInfo
