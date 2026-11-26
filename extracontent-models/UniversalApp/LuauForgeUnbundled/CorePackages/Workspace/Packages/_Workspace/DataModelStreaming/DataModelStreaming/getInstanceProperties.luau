local v5 = {
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

local function getProperty(instance, p2)
	local success, result = pcall(function()
		return instance[p2]
	end)

	if not success or result == nil then
		return nil
	end

	local function handleInf(p3)
		if p3 == 1e999 then
			return "inf"
		elseif p3 == -1e999 then
			return "-inf"
		end

		return p3
	end

	if typeof(result) == "Vector2" then
		local x = result.X
		local v6 = x == 1e999 and "inf" or x == -1e999 and "-inf" or x

		local y = result.Y
		return { v6, y == 1e999 and "inf" or y == -1e999 and "-inf" or y }
	elseif typeof(result) == "Vector3" then
		local x = result.X
		local v6 = x == 1e999 and "inf" or x == -1e999 and "-inf" or x

		local y = result.Y
		local v7 = y == 1e999 and "inf" or y == -1e999 and "-inf" or y

		local z = result.Z
		return { v6, v7, z == 1e999 and "inf" or z == -1e999 and "-inf" or z }
	else
		if typeof(result) == "Color3" then
			return { result.R, result.G, result.B }
		end

		if typeof(result) == "UDim2" then
			local scale = result.X.Scale
			local v6 = scale == 1e999 and "inf" or scale == -1e999 and "-inf" or scale

			local offset = result.X.Offset
			local v7 = offset == 1e999 and "inf" or offset == -1e999 and "-inf" or offset

			local scale2 = result.Y.Scale
			local v8 = scale2 == 1e999 and "inf" or scale2 == -1e999 and "-inf" or scale2

			local offset2 = result.Y.Offset
			return {
				v6,
				v7,
				v8,
				offset2 == 1e999 and "inf" or offset2 == -1e999 and "-inf" or offset2
			}
		elseif typeof(result) == "Rect" then
			local x = result.Min.X
			local v6 = x == 1e999 and "inf" or x == -1e999 and "-inf" or x

			local y = result.Min.Y
			local v7 = y == 1e999 and "inf" or y == -1e999 and "-inf" or y

			local x2 = result.Max.X
			local v8 = x2 == 1e999 and "inf" or x2 == -1e999 and "-inf" or x2

			local y2 = result.Max.Y
			return {
				v6,
				v7,
				v8,
				y2 == 1e999 and "inf" or y2 == -1e999 and "-inf" or y2
			}
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

	for className, v6 in v5 do
		if not instance:IsA(className) then
			continue
		end

		for k, v7 in v6 do
			if not (list == nil or table.find(list, v7)) then
				continue
			end

			local property = getProperty(instance, v7)

			if property ~= nil then
				properties[v7] = property
			end
		end
	end

	local tags = instance:GetTags()

	for k, tag in tags do
		if string.sub(tag, 1, 12) == "data-testid=" then
			properties.TestId = string.sub(tag, 13)
		end
	end

	return properties
end

return getInstanceProperties
