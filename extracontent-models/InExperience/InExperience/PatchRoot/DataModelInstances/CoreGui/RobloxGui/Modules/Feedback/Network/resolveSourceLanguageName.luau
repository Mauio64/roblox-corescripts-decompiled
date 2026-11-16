return function(items, p: string?)
	if items == nil or p == nil then
		return nil
	end

	for _, item in pairs(items) do
		local locale = item.locale

		if locale and locale.language and locale.language.languageCode == p then
			return locale.language.name
		end
	end

	return nil
end
