local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.useShareSheetViewModel)
local GetUniversalShareSheetStore = require(ShareSheet.Stores.GetUniversalShareSheetStore)

local function useUniversalShareSheetViewModel()
	local universalShareSheetStore = GetUniversalShareSheetStore()
	local v = SignalsReact.useSignalState(universalShareSheetStore.getRequest)

	if v == nil then
		return nil
	end

	return {
		context = v.context,
		formatSuccessSnackbarText = v.formatSuccessSnackbarText,
		isOpen = true,
		messagePlaceholder = v.messagePlaceholder,
		onCloseWithReason = universalShareSheetStore.hide,
		recipientSource = v.recipientSource,
		telemetryId = v.telemetryId,
		url = v.url
	}
end

return useUniversalShareSheetViewModel
