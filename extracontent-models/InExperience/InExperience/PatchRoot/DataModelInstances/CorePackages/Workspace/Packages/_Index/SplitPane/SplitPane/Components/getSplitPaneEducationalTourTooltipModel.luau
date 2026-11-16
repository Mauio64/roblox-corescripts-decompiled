local parent = script:FindFirstAncestor("SplitPane").Parent

local Foundation = require(parent.Foundation)

require(script.Parent.SplitPaneEducationalTourSteps)

local getSplitPaneEducationalTourVideoAssetId = require(script.Parent.getSplitPaneEducationalTourVideoAssetId)

local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

return function(data)
	local step = data.step

	if step == nil then
		return nil
	end

	local v

	if data.isCollapsedStepOne and not data.isDirectionalInput then
		v = { side = PopoverSide.Bottom, align = PopoverAlign.End }
	elseif data.isDirectionalInput and (data.stepIndex == 2 or data.stepIndex == 3) then
		v = { side = PopoverSide.Top, align = PopoverAlign.Center }
	elseif data.stepIndex == 1 then
		v = { side = PopoverSide.Left, align = PopoverAlign.Center }
	elseif data.stepIndex == 2 then
		v = { side = PopoverSide.Top, align = PopoverAlign.Center }
	else
		v = { side = PopoverSide.Bottom, align = PopoverAlign.End }
	end

	local title

	if data.stepIndex == 1 then
		title = data.localized.stepOneTitle
	elseif data.stepIndex == 2 then
		title = data.localized.stepTwoTitle
	else
		title = data.localized.stepThreeTitle
	end

	local text

	if data.stepIndex == 1 then
		if data.isCollapsedStepOne then
			text = data.localized.stepOneCollapsedDescription
		else
			text = data.localized.stepOneExpandedDescription
		end
	elseif data.stepIndex == 2 then
		text = data.localized.stepTwoDescription
	else
		text = data.localized.stepThreeDescription
	end

	local v2 = {
		stepIndex = data.stepIndex,
		totalSteps = data.totalSteps,
		isFinal = step.isFinal == true,
		primaryActionText = 0,
		skipActionText = 0,
		title = 0,
		text = 0,
		side = 0,
		align = 0,
		videoAssetId = 0
	}
	local primaryActionText

	if step.isFinal then
		primaryActionText = data.localized.finishTourButton
	else
		primaryActionText = data.localized.continueButton
	end

	v2.primaryActionText = primaryActionText
	local skipActionText

	if not step.isFinal then
		skipActionText = data.localized.skipTourButton
	end

	v2.skipActionText = skipActionText
	v2.title = title
	v2.text = text
	v2.side = v.side
	v2.align = v.align
	v2.videoAssetId = getSplitPaneEducationalTourVideoAssetId(step, data.isDirectionalInput, data.isCollapsedStepOne)
	return v2
end
