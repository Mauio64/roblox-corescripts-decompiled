local ShareSheet = script:FindFirstAncestor("ShareSheet")
local ShareSheetParent = ShareSheet.Parent
local SignalsReact = require(ShareSheetParent.SignalsReact)

require(script.Parent.Parent.useShareSheetViewModel)

local GetUniversalShareSheetStore = require(ShareSheet.Stores.GetUniversalShareSheetStore)

local function useUniversalShareSheetViewModel() -- line: 13
	-- upvalues: GetUniversalShareSheetStore (copy), SignalsReact (copy)
	local v6 = GetUniversalShareSheetStore()
	local v7 = SignalsReact.useSignalState(v6.getRequest)

	if v7 == nil then
		return nil
	end

	return {
		isOpen = true,
		context = v7.context,
		formatSuccessSnackbarText = v7.formatSuccessSnackbarText,
		messagePlaceholder = v7.messagePlaceholder,
		onClose = v6.hide,
		telemetryId = v7.telemetryId,
		url = v7.url
	}
end

return useUniversalShareSheetViewModel
