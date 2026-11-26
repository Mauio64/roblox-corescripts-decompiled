require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")

local function expandRect(p2, p3)
	return Rect.new(p2.Min.X - p3, p2.Min.Y - p3, p2.Max.X + p3, p2.Max.Y + p3)
end

return function(data)
	local v5 = data.stepIndex == 1 and data.isSupportPaneCollapsed
	local isDirectionalInput = v5 and data.isDirectionalInput
	local v6 = not v5

	if not v6 then
		if data.anchors.gamepadCollapsedStepOne == nil then
			v6 = not (data.collapsedExpandButtonRect == nil) and data.anchors.collapsedExpandButton ~= nil
		else
			v6 = true
		end
	end

	local v7

	if isDirectionalInput and data.anchors.gamepadCollapsedStepOne ~= nil then
		v7 = data.anchors.gamepadCollapsedStepOne
	elseif v5 and data.anchors.collapsedExpandButton ~= nil then
		v7 = data.anchors.collapsedExpandButton
	elseif data.stepIndex == 2 and data.isDirectionalInput and data.anchors.gamepadStepTwo ~= nil then
		v7 = data.anchors.gamepadStepTwo
	elseif data.stepIndex == 2 and data.anchors.bottomPane ~= nil then
		v7 = data.anchors.bottomPane
	elseif data.stepIndex == 3 and data.isDirectionalInput and data.anchors.gamepadFinal ~= nil then
		v7 = data.anchors.gamepadFinal
	elseif data.stepIndex == 3 and data.anchors.topRightControl ~= nil then
		v7 = data.anchors.topRightControl
	else
		v7 = data.anchors.supportPane
	end

	local rect

	if v5 and not isDirectionalInput and data.collapsedExpandButtonRect ~= nil then
		local collapsedExpandButtonRect = data.collapsedExpandButtonRect
		local collapsedSpotlightPadding = data.collapsedSpotlightPadding
		rect = Rect.new(
			collapsedExpandButtonRect.Min.X - collapsedSpotlightPadding,
			collapsedExpandButtonRect.Min.Y - collapsedSpotlightPadding,
			collapsedExpandButtonRect.Max.X + collapsedSpotlightPadding,
			collapsedExpandButtonRect.Max.Y + collapsedSpotlightPadding
		)
	end

	local v8 = if not v5 and data.supportPaneRect ~= nil then data.supportPaneRect.Min.X else nil

	return {
		isCollapsedStepOne = v5,
		isGamepadCollapsedStepOne = isDirectionalInput,
		isAnchorReady = v6,
		anchorRef = v7,
		spotlightRect = rect,
		dimEndX = v8
	}
end
