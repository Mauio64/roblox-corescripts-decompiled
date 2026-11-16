local function findBackdrop(layerCollector)
	for _ = 1, 3 do
		if layerCollector == nil or layerCollector:IsA("LayerCollector") then
			return nil
		end

		local backdrop = layerCollector:FindFirstChild("Backdrop")

		if backdrop ~= nil and backdrop:IsA("GuiObject") then
			return backdrop
		end

		layerCollector = layerCollector.Parent
	end

	return nil
end

local function getSheetStructure(instance)
	local scrollingFrame = instance:FindFirstChildOfClass("ScrollingFrame")
	local sheetContainer

	if scrollingFrame ~= nil then
		sheetContainer = scrollingFrame:FindFirstChild("SheetContainer")
	end

	if scrollingFrame == nil or sheetContainer == nil or not sheetContainer:IsA("GuiObject") then
		return {
			kind = instance.Position.X.Scale == 1 and "side" or "center",
			sheet = instance,
			scroller = nil,
			container = nil,
			backdrop = findBackdrop(instance.Parent)
		}
	end

	return {
		kind = "bottom",
		sheet = instance,
		scroller = scrollingFrame,
		container = sheetContainer,
		backdrop = findBackdrop(scrollingFrame)
	}
end

return getSheetStructure
