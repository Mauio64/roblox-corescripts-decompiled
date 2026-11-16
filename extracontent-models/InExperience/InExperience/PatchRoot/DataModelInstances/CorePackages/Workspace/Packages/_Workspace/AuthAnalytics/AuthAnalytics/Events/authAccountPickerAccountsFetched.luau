local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, list, list2, list3)
	checkAndSendEvent(p, "authAccountPickerAccountsFetched", {
		validSessionUserIds = `[{table.concat(list, ",")}]`,
		shownUserIds = `[{table.concat(list2, ",")}]`,
		appStoragePreviousUserIds = `[{table.concat(list3, ",")}]`
	})
end
