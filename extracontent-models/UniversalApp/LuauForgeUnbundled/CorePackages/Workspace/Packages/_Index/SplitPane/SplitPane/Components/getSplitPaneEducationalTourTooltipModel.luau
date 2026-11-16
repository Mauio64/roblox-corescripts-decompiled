local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Foundation")

require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourSteps")

local getSplitPaneEducationalTourVideoAssetId = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/getSplitPaneEducationalTourVideoAssetId")

local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

return function(data)
	local step = data.step

	if step == nil then
		return nil
	end

	local v5

	if data.isCollapsedStepOne and not data.isDirectionalInput then
		v5 = { side = popoverSide.Bottom, align = popoverAlign.End }
	elseif data.isDirectionalInput and (data.stepIndex == 2 or data.stepIndex == 3) then
		v5 = { side = popoverSide.Top, align = popoverAlign.Center }
	elseif data.stepIndex == 1 then
		v5 = { side = popoverSide.Left, align = popoverAlign.Center }
	elseif data.stepIndex == 2 then
		v5 = { side = popoverSide.Top, align = popoverAlign.Center }
	else
		v5 = { side = popoverSide.Bottom, align = popoverAlign.End }
	end

	local v6

	if data.stepIndex == 1 then
		v6 = data.localized.stepOneTitle
	else
		v6 = if data.stepIndex == 2 then data.localized.stepTwoTitle else data.localized.stepThreeTitle
	end

	local v7

	if data.stepIndex == 1 then
		if data.isCollapsedStepOne then
			v7 = data.localized.stepOneCollapsedDescription
		else
			v7 = data.localized.stepOneExpandedDescription
		end
	elseif data.stepIndex == 2 then
		v7 = data.localized.stepTwoDescription
	else
		v7 = data.localized.stepThreeDescription
	end

	local v8 = {
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
	local v9 = if step.isFinal then data.localized.finishTourButton else data.localized.continueButton
	v8.primaryActionText = v9
	local v10 = if not step.isFinal then data.localized.skipTourButton else nil
	v8.skipActionText = v10
	v8.title = v6
	v8.text = v7
	v8.side = v5.side
	v8.align = v5.align
	v8.videoAssetId = getSplitPaneEducationalTourVideoAssetId(step, data.isDirectionalInput, data.isCollapsedStepOne)
	return v8
end
