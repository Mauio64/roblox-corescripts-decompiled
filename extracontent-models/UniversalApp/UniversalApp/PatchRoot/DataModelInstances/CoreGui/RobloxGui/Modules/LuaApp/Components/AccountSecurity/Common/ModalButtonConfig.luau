return function(p1) -- line: 3
	local t1 = {}

	for _, v in pairs(p1) do
		table.insert(t1, {
			buttonType = v.type,
			props = {
				isDisabled = v.isDisabled,
				isLoading = v.isLoading,
				onActivated = v.onActivated or function() -- line: 12
				end,
				text = v.text
			}
		})
	end

	return {
		buttonHeight = 48,
		buttons = t1
	}
end
