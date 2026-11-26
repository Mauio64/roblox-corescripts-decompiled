return function(items)
	local v5 = {}

	for k, item in pairs(items) do
		table.insert(v5, {
			buttonType = item.type,
			props = {
				isDisabled = item.isDisabled,
				isLoading = item.isLoading,
				onActivated = item.onActivated or function() end,
				text = item.text
			}
		})
	end

	return { buttonHeight = 48, buttons = v5 }
end
