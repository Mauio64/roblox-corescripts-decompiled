local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local CurveAnimationFrameCalculator = require(parent.util.CurveAnimationFrameCalculator)

local getFFlagUGCValidateRunValidationsOnSecondaryCurveAnimations = require(parent.flags.getFFlagUGCValidateRunValidationsOnSecondaryCurveAnimations)

return {
	getData = function(list, list2)
		if #list == 0 then
			return nil
		end

		local fFlagUGCValidateRunValidationsOnSecondaryCurveAnimations = getFFlagUGCValidateRunValidationsOnSecondaryCurveAnimations()
		local result = {}

		for i = 1, fFlagUGCValidateRunValidationsOnSecondaryCurveAnimations and #list or 1 do
			local item = list[i]
			local success, result2, animLength, positionMagnitudeFrames, tracks = pcall(function()
				return CurveAnimationFrameCalculator.calculateAnimFramesAtOrigin(item)
			end)

			if not success then
				return nil
			end

			local animation

			if fFlagUGCValidateRunValidationsOnSecondaryCurveAnimations and list2 then
				animation = list2[i]
			end

			table.insert(result, {
				animation = animation,
				animFrames = result2,
				animLength = animLength,
				positionMagnitudeFrames = positionMagnitudeFrames,
				tracks = tracks
			})
		end

		return result
	end
}
