local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local SignalsReact = require(parent.SignalsReact)

local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
require(script.Parent.Parent.useShareSheetViewModel)
local GetUniversalShareSheetStore = require(ShareSheet.Stores.GetUniversalShareSheetStore)

local function useUniversalShareSheetViewModel()
	local universalShareSheetStore = GetUniversalShareSheetStore()
	local v = SignalsReact.useSignalState(universalShareSheetStore.getRequest)

	if v == nil then
		return nil
	end

	local v2 = {
		context = v.context,
		formatSuccessSnackbarText = v.formatSuccessSnackbarText,
		isOpen = true,
		messagePlaceholder = v.messagePlaceholder,
		onCloseWithReason = universalShareSheetStore.hide,
		recipientSource = 0,
		telemetryId = 0,
		url = 0
	}
	local recipientSource

	if FFlagShareSheetFriendsSort then
		recipientSource = v.recipientSource
	end

	v2.recipientSource = recipientSource
	v2.telemetryId = v.telemetryId
	v2.url = v.url
	return v2
end

return useUniversalShareSheetViewModel
