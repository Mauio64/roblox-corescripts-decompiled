local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, list, list2, list3)
	checkAndSendEvent(p2, "authAccountPickerAccountsFetched", {
		validSessionUserIds = `[{table.concat(list, ",")}]`,
		shownUserIds = `[{table.concat(list2, ",")}]`,
		appStoragePreviousUserIds = `[{table.concat(list3, ",")}]`
	})
end
