require("@luauforge/deferred/gRc")

local function useActionBarWithContextualTextViewModel(data)
	return {
		titleText = data.titleText,
		actionButtonText = data.actionButtonText,
		onActionActivated = data.onActionActivated,
		onMoreActivated = data.onMoreActivated,
		isActionDisabled = data.isActionDisabled,
		isActionLoading = data.isActionLoading,
		LayoutOrder = data.LayoutOrder
	}
end

return useActionBarWithContextualTextViewModel
