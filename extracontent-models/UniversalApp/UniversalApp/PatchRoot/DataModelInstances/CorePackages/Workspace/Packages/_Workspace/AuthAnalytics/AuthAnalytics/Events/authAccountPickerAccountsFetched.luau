local ParentParent = script.Parent.Parent
local checkAndSendEvent = require(ParentParent.Utils.checkAndSendEvent)

return function(s1: string, t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 4
	-- upvalues: checkAndSendEvent (copy)
	local t4 = {
		validSessionUserIds = `[{ table.concat(t1, ",") }]`,
		shownUserIds = `[{ table.concat(t2, ",") }]`,
		appStoragePreviousUserIds = `[{ table.concat(t3, ",") }]`
	}

	checkAndSendEvent(s1, "authAccountPickerAccountsFetched", t4)
end
