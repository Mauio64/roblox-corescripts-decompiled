local v = {
	GuiBase2d = {
		"AbsolutePosition",
		"AbsoluteRotation",
		"AbsoluteSize",
		"AutoLocalize",
		"ClippedRect",
		"IsNotOccluded",
		"RawRect2D",
		"ReplicatedInsertionOrder",
		"RootLocalizationTable",
		"SelectionBehaviorDown",
		"SelectionBehaviorLeft",
		"SelectionBehaviorRight",
		"SelectionBehaviorUp",
		"SelectionGroup",
		"TotalGroupScale"
	},
	GuiObject = {
		"Active",
		"AnchorPoint",
		"AutomaticSize",
		"BackgroundColor",
		"BackgroundColor3",
		"BackgroundTransparency",
		"BorderColor",
		"BorderColor3",
		"BorderMode",
		"BorderSizePixel",
		"ClipsDescendants",
		"Draggable",
		"GuiState",
		"Interactable",
		"LayoutOrder",
		"NextSelectionDown",
		"NextSelectionLeft",
		"NextSelectionRight",
		"NextSelectionUp",
		"Position",
		"Rotation",
		"Selectable",
		"SelectionImageObject",
		"SelectionOrder",
		"SelectionRect2D",
		"Size",
		"SizeConstraint",
		"Transparency",
		"Visible",
		"ZIndex"
	},
	TextLabel = {
		"Confidential",
		"ContentText",
		"Font",
		"FontFace",
		"LineHeight",
		"LocalizationMatchIdentifier",
		"LocalizationMatchedSourceText",
		"LocalizedText",
		"MaxVisibleGraphemes",
		"OpenTypeFeatures",
		"OpenTypeFeaturesError",
		"RichText",
		"Text",
		"TextBounds",
		"TextColor3",
		"TextDirection",
		"TextFits",
		"TextScaled",
		"TextSize",
		"TextStrokeColor3",
		"TextStrokeTransparency",
		"TextTransparency",
		"TextTruncate",
		"TextWrapped",
		"TextXAlignment",
		"TextYAlignment"
	},
	TextButton = {
		"Confidential",
		"ContentText",
		"Font",
		"FontFace",
		"LineHeight",
		"LocalizationMatchIdentifier",
		"LocalizationMatchedSourceText",
		"LocalizedText",
		"MaxVisibleGraphemes",
		"OpenTypeFeatures",
		"OpenTypeFeaturesError",
		"RichText",
		"Text",
		"TextBounds",
		"TextColor3",
		"TextDirection",
		"TextFits",
		"TextScaled",
		"TextSize",
		"TextStrokeColor3",
		"TextStrokeTransparency",
		"TextTransparency",
		"TextTruncate",
		"TextWrapped",
		"TextXAlignment",
		"TextYAlignment"
	},
	TextBox = {
		"ClearTextOnFocus",
		"Confidential",
		"ContentText",
		"CursorPosition",
		"Font",
		"FontFace",
		"LineHeight",
		"LocalizationMatchIdentifier",
		"LocalizationMatchedSourceText",
		"LocalizedText",
		"ManualFocusRelease",
		"MaxVisibleGraphemes",
		"MultiLine",
		"OpenTypeFeatures",
		"OpenTypeFeaturesError",
		"OverlayNativeInput",
		"PlaceholderColor3",
		"PlaceholderText",
		"ReturnKeyType",
		"RichText",
		"SelectionStart",
		"ShouldEmitReturnEvents",
		"ShouldEmitUpAndDownArrowEvents",
		"ShowNativeInput",
		"Text",
		"TextBounds",
		"TextColor3",
		"TextDirection",
		"TextEditable",
		"TextFits",
		"TextInputType",
		"TextScaled",
		"TextSize",
		"TextStrokeColor3",
		"TextStrokeTransparency",
		"TextTransparency",
		"TextTruncate",
		"TextWrapped",
		"TextXAlignment",
		"TextYAlignment"
	},
	ImageLabel = {
		"BackgroundTransparency",
		"ContentImageSize",
		"Image",
		"ImageColor3",
		"ImageRectOffset",
		"ImageRectSize",
		"ImageTransparency",
		"IsLoaded",
		"ResampleMode",
		"ScaleType",
		"SliceCenter",
		"SliceScale",
		"TileSize"
	},
	ImageButton = {
		"BackgroundTransparency",
		"ContentImageSize",
		"HoverImage",
		"Image",
		"ImageColor3",
		"ImageRectOffset",
		"ImageRectSize",
		"ImageTransparency",
		"IsLoaded",
		"PressedImage",
		"ResampleMode",
		"ScaleType",
		"SliceCenter",
		"SliceScale",
		"TileSize"
	},
	Frame = { "BackgroundTransparency", "Style" },
	ScrollingFrame = {
		"AbsoluteCanvasSize",
		"AbsoluteWindowSize",
		"AutomaticCanvasSize",
		"BottomImage",
		"CanvasPosition",
		"CanvasSize",
		"DraggingScrollBar",
		"ElasticBehavior",
		"HorizontalScrollBarInset",
		"HorizontalScrollBarPosition",
		"MidImage",
		"ScrollBarImageColor3",
		"ScrollBarImageTransparency",
		"ScrollBarThickness",
		"ScrollRate",
		"ScrollVelocity",
		"ScrollingDirection",
		"ScrollingEnabled",
		"SmoothScroll",
		"TopImage",
		"VerticalScrollBarInset",
		"VerticalScrollBarPosition"
	},
	LayerCollector = { "Enabled", "ResetOnSpawn", "ZIndexBehavior" }
}

local function getProperty(instance, p: string)
	local success, result = pcall(function()
		return instance[p]
	end)

	if not success or result == nil then
		return nil
	end

	local function handleInf(p2: number) -- 13 equivalent calls inferred from this helper
		if p2 == 1e999 then
			return "inf"
		elseif p2 == -1e999 then
			return "-inf"
		end

		return p2
	end

	if typeof(result) == "Vector2" then
		local v2 = handleInf(result.X) -- inferred equivalent call
		return { v2, handleInf(result.Y) } -- inferred equivalent call
	elseif typeof(result) == "Vector3" then
		local v2 = handleInf(result.X) -- inferred equivalent call
		local v3 = handleInf(result.Y) -- inferred equivalent call
		return { v2, v3, handleInf(result.Z) } -- inferred equivalent call
	else
		if typeof(result) == "Color3" then
			return { result.R, result.G, result.B }
		end

		if typeof(result) == "UDim2" then
			local v2 = handleInf(result.X.Scale) -- inferred equivalent call
			local v3 = handleInf(result.X.Offset) -- inferred equivalent call
			local v4 = handleInf(result.Y.Scale) -- inferred equivalent call
			return { v2, v3, v4, handleInf(result.Y.Offset) } -- inferred equivalent call
		elseif typeof(result) == "Rect" then
			local v2 = handleInf(result.Min.X) -- inferred equivalent call
			local v3 = handleInf(result.Min.Y) -- inferred equivalent call
			local v4 = handleInf(result.Max.X) -- inferred equivalent call
			return { v2, v3, v4, handleInf(result.Max.Y) } -- inferred equivalent call
		elseif typeof(result) == "number" or typeof(result) == "boolean" then
			return result
		else
			return (tostring(result))
		end
	end
end

local function getInstanceProperties(instance, list)
	if not instance then
		return {}
	end

	local properties = { ClassName = instance.ClassName, Name = instance.Name }

	for className, v2 in v do
		if not instance:IsA(className) then
			continue
		end

		for _, v3 in v2 do
			if not (list == nil or table.find(list, v3)) then
				continue
			end

			local property = getProperty(instance, v3)

			if property ~= nil then
				properties[v3] = property
			end
		end
	end

	local tags = instance:GetTags()

	for _, tag in tags do
		if string.sub(tag, 1, 12) == "data-testid=" then
			properties.TestId = string.sub(tag, 13)
		end
	end

	return properties
end

return getInstanceProperties
