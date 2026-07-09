require(script.Parent.ActionBarWithContextualTextView)

local function useActionBarWithContextualTextViewModel(t1: {[any]: any}) -- line: 14
	return {
		titleText = t1.titleText,
		actionButtonText = t1.actionButtonText,
		onActionActivated = t1.onActionActivated,
		onMoreActivated = t1.onMoreActivated,
		isActionDisabled = t1.isActionDisabled,
		isActionLoading = t1.isActionLoading,
		LayoutOrder = t1.LayoutOrder
	}
end

return useActionBarWithContextualTextViewModel
