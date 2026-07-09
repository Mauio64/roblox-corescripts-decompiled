return function(t1: {[any]: any}) -- line: 13
	local t2 = {}

	for _, v in pairs(t1) do
		table.insert(t2, {
			buttonType = v.type,
			props = {
				isDisabled = v.isDisabled,
				isLoading = v.isLoading,
				onActivated = v.onActivated or function() -- line: 22
				end,
				text = v.text
			}
		})
	end

	return {
		buttonHeight = 48,
		buttons = t2
	}
end
