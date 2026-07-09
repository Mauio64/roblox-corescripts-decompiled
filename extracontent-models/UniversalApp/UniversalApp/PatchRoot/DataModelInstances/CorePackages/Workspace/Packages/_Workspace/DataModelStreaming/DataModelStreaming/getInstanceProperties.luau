local t1 = {
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
	Frame = {
		"BackgroundTransparency",
		"Style"
	},
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
	LayerCollector = {
		"Enabled",
		"ResetOnSpawn",
		"ZIndexBehavior"
	}
}

local function getProperty(p1, s1: string) -- line: 217
	local ok, result = pcall(function() -- line: 218
		-- upvalues: p1 (copy), s1 (copy)
		return p1[s1]
	end)

	if not ok or result == nil then
		return nil
	end

	local function handleInf(n1: number) -- line: 226
		if n1 == 1e999 then
			return "inf"
		end

		if n1 == -1e999 then
			return "-inf"
		end

		return n1
	end

	if typeof(result) == "Vector2" then
		local t2 = {}
		local resultX = result.X
		local v11 = if resultX ~= 1e999 then if resultX ~= -1e999 then resultX else "-inf" else "inf"
		local resultY = result.Y
		local v13 = if resultY ~= 1e999 then if resultY ~= -1e999 then resultY else "-inf" else "inf"

		t2[1] = v11
		t2[2] = v13

		return t2
	end

	if typeof(result) == "Vector3" then
		local t3 = {}
		local resultX = result.X
		local v16 = if resultX ~= 1e999 then if resultX ~= -1e999 then resultX else "-inf" else "inf"
		local resultY = result.Y
		local v18 = if resultY ~= 1e999 then if resultY ~= -1e999 then resultY else "-inf" else "inf"
		local resultZ = result.Z
		local v20 = if resultZ ~= 1e999 then if resultZ ~= -1e999 then resultZ else "-inf" else "inf"

		t3[1] = v16
		t3[2] = v18
		t3[3] = v20

		return t3
	end

	if typeof(result) == "Color3" then
		return {
			result.R,
			result.G,
			result.B
		}
	end

	if typeof(result) == "UDim2" then
		local t4 = {}
		local XScale = result.X.Scale
		local v23 = if XScale ~= 1e999 then if XScale ~= -1e999 then XScale else "-inf" else "inf"
		local XOffset = result.X.Offset
		local v25 = if XOffset ~= 1e999 then if XOffset ~= -1e999 then XOffset else "-inf" else "inf"
		local YScale = result.Y.Scale
		local v27 = if YScale ~= 1e999 then if YScale ~= -1e999 then YScale else "-inf" else "inf"
		local YOffset = result.Y.Offset
		local v29 = if YOffset ~= 1e999 then if YOffset ~= -1e999 then YOffset else "-inf" else "inf"

		t4[1] = v23
		t4[2] = v25
		t4[3] = v27
		t4[4] = v29

		return t4
	end

	if typeof(result) == "Rect" then
		local t5 = {}
		local MinX = result.Min.X
		local v32 = if MinX ~= 1e999 then if MinX ~= -1e999 then MinX else "-inf" else "inf"
		local MinY = result.Min.Y
		local v34 = if MinY ~= 1e999 then if MinY ~= -1e999 then MinY else "-inf" else "inf"
		local MaxX = result.Max.X
		local v36 = if MaxX ~= 1e999 then if MaxX ~= -1e999 then MaxX else "-inf" else "inf"
		local MaxY = result.Max.Y
		local v38 = if MaxY ~= 1e999 then if MaxY ~= -1e999 then MaxY else "-inf" else "inf"

		t5[1] = v32
		t5[2] = v34
		t5[3] = v36
		t5[4] = v38

		return t5
	end

	if typeof(result) == "number" or typeof(result) == "boolean" then
		return result
	end

	return (tostring(result))
end
local function getInstanceProperties(p2, t6: {[any]: any}?) -- line: 273
	-- upvalues: t1 (copy), getProperty (copy)
	if not p2 then
		return {}
	end

	local t7 = {
		ClassName = p2.ClassName,
		Name = p2.Name
	}

	for v42, v43 in t1 do
		if p2:IsA(v42) then
			for _, v45 in v43 do
				if t6 == nil or table.find(t6, v45) then
					local v46 = getProperty(p2, v45)

					if v46 ~= nil then
						t7[v45] = v46
					end
				end
			end
		end
	end

	for _, tag in (p2:GetTags()) do
		if string.sub(tag, 1, 12) == "data-testid=" then
			t7.TestId = string.sub(tag, 13)
		end
	end

	return t7
end

return getInstanceProperties
