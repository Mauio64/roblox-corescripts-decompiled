local parent = script:FindFirstAncestor("SplitPane").Parent

require(parent.React)

local function expandRect(collapsedExpandButtonRect: Rect, collapsedSpotlightPadding: number) -- 1 equivalent call inferred from this helper
	return Rect.new(
		collapsedExpandButtonRect.Min.X - collapsedSpotlightPadding,
		collapsedExpandButtonRect.Min.Y - collapsedSpotlightPadding,
		collapsedExpandButtonRect.Max.X + collapsedSpotlightPadding,
		collapsedExpandButtonRect.Max.Y + collapsedSpotlightPadding
	)
end

return function(data)
	local isCollapsedStepOne

	if data.stepIndex == 1 then
		isCollapsedStepOne = data.isSupportPaneCollapsed
	else
		isCollapsedStepOne = false
	end

	local isDirectionalInput = isCollapsedStepOne and data.isDirectionalInput
	local isAnchorReady = not isCollapsedStepOne

	if not isAnchorReady then
		if data.anchors.gamepadCollapsedStepOne == nil then
			if data.collapsedExpandButtonRect == nil then
				isAnchorReady = false
			else
				isAnchorReady = data.anchors.collapsedExpandButton ~= nil
			end
		else
			isAnchorReady = true
		end
	end

	local anchorRef

	if isDirectionalInput and data.anchors.gamepadCollapsedStepOne ~= nil then
		anchorRef = data.anchors.gamepadCollapsedStepOne
	elseif isCollapsedStepOne and data.anchors.collapsedExpandButton ~= nil then
		anchorRef = data.anchors.collapsedExpandButton
	elseif data.stepIndex == 2 and data.isDirectionalInput and data.anchors.gamepadStepTwo ~= nil then
		anchorRef = data.anchors.gamepadStepTwo
	elseif data.stepIndex == 2 and data.anchors.bottomPane ~= nil then
		anchorRef = data.anchors.bottomPane
	elseif data.stepIndex == 3 and data.isDirectionalInput and data.anchors.gamepadFinal ~= nil then
		anchorRef = data.anchors.gamepadFinal
	elseif data.stepIndex == 3 and data.anchors.topRightControl ~= nil then
		anchorRef = data.anchors.topRightControl
	else
		anchorRef = data.anchors.supportPane
	end

	local spotlightRect

	if isCollapsedStepOne and not isDirectionalInput and data.collapsedExpandButtonRect ~= nil then
		spotlightRect = expandRect(data.collapsedExpandButtonRect, data.collapsedSpotlightPadding) -- inferred equivalent call
	end

	local dimEndX

	if not (isCollapsedStepOne or data.supportPaneRect == nil) then
		dimEndX = data.supportPaneRect.Min.X
	end

	return {
		isCollapsedStepOne = isCollapsedStepOne,
		isGamepadCollapsedStepOne = isDirectionalInput,
		isAnchorReady = isAnchorReady,
		anchorRef = anchorRef,
		spotlightRect = spotlightRect,
		dimEndX = dimEndX
	}
end
