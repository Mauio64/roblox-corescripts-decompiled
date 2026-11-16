return require("@game/CorePackages/Workspace/Packages/_Workspace/ToastRodux/Rodux").makeActionCreator("SetCurrentToastMessage", function(p2)
	assert(type(p2) == "table", "SetCurrentToastMessage action expects toastMessage to be a table")

	return { toastMessage = p2 }
end)
