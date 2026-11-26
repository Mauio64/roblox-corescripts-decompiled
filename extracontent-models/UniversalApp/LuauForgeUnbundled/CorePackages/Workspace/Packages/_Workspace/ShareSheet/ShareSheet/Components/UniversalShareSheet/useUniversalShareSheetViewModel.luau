local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetViewModel")
local GetUniversalShareSheetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/GetUniversalShareSheetStore")

local function useUniversalShareSheetViewModel()
	local v5 = GetUniversalShareSheetStore()
	local v6 = SignalsReact.useSignalState(v5.getRequest)

	if v6 == nil then
		return nil
	end

	return {
		context = v6.context,
		formatSuccessSnackbarText = v6.formatSuccessSnackbarText,
		isOpen = true,
		messagePlaceholder = v6.messagePlaceholder,
		onCloseWithReason = v5.hide,
		recipientSource = v6.recipientSource,
		telemetryId = v6.telemetryId,
		url = v6.url
	}
end

return useUniversalShareSheetViewModel
