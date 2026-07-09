local GuiService = game:GetService("GuiService")

return function() -- line: 6
	-- upvalues: GuiService (copy)
	if GuiService.SelectedCoreObject then
		GuiService.SelectedCoreObject.NextSelectionLeft = nil
		GuiService.SelectedCoreObject.NextSelectionRight = nil
		GuiService.SelectedCoreObject.NextSelectionDown = nil
		GuiService.SelectedCoreObject.NextSelectionUp = nil
	end
end
