local function isSelectionOnScreen(selectedCoreObject) -- 1 equivalent call inferred from this helper
	if selectedCoreObject == nil then
		return false
	end

	local success, result = pcall(function()
		return selectedCoreObject:IsDescendantOf(game)
	end)

	return success and result
end

local function restoreSelectionIfStranded(p, selectedCoreObject)
	if selectedCoreObject == nil then
		return
	end

	if not isSelectionOnScreen(p.SelectedCoreObject) then -- inferred equivalent call
		p.SelectedCoreObject = selectedCoreObject
	end
end

return restoreSelectionIfStranded
