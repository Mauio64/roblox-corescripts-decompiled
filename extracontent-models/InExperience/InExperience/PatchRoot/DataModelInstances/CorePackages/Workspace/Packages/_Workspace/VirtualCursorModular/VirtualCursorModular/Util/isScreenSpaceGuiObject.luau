local function isScreenSpaceGuiObject(instance)
	local layerCollector = instance:FindFirstAncestorWhichIsA("LayerCollector")
	return layerCollector ~= nil and layerCollector:IsA("ScreenGui")
end

return isScreenSpaceGuiObject
