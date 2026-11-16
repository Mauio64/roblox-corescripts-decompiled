local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetViewModel")
local GetUniversalShareSheetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/GetUniversalShareSheetStore")

local function useUniversalShareSheetViewModel()
	local v5 = GetUniversalShareSheetStore()
	local v6 = SignalsReact.useSignalState(v5.getRequest)

	if v6 == nil then
		return nil
	end

	local v7 = {
		context = v6.context,
		formatSuccessSnackbarText = v6.formatSuccessSnackbarText,
		isOpen = true,
		messagePlaceholder = v6.messagePlaceholder,
		onCloseWithReason = v5.hide,
		recipientSource = 0,
		telemetryId = 0,
		url = 0
	}
	local v8 = if fFlagShareSheetFriendsSort then v6.recipientSource else nil
	v7.recipientSource = v8
	v7.telemetryId = v6.telemetryId
	v7.url = v6.url
	return v7
end

return useUniversalShareSheetViewModel
