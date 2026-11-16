local parent = script:FindFirstAncestor("ToastRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(toastMessage)
	assert(type(toastMessage) == "table", "SetCurrentToastMessage action expects toastMessage to be a table")

	return { toastMessage = toastMessage }
end)
