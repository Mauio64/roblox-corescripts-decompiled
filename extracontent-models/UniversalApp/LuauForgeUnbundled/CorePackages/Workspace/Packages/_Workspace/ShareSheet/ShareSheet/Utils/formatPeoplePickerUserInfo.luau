return {
	formatDescription = function(items)
		local v5 = {}

		for k, item in items do
			if item.username ~= nil and item.username ~= "" then
				table.insert(v5, `@{item.username}`)
			end
		end

		return table.concat(v5, ", ")
	end,
	formatTitle = function(list)
		local displayNames = table.create(#list)

		for k, item in list do
			displayNames[k] = item.displayName
		end

		return table.concat(displayNames, ", ")
	end
}
