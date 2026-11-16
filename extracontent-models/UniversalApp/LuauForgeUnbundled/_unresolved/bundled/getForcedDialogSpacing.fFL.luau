local function getForcedDialogSpacing(p2)
	return {
		titleTopOffset = p2.Size.Size_200,
		formTopPadding = UDim.new(0, p2.Size.Size_200 - p2.Stroke.Standard)
	}
end

return getForcedDialogSpacing
