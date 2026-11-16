local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local CurveAnimationFrameCalculator = require(parent.util.CurveAnimationFrameCalculator)

return {
	getData = function(list)
		if #list == 0 then
			return nil
		end

		local item = list[1]
		local success, result, animLength, positionMagnitudeFrames, tracks = pcall(function()
			return CurveAnimationFrameCalculator.calculateAnimFramesAtOrigin(item)
		end)

		if success then
			return {
				animFrames = result,
				animLength = animLength,
				positionMagnitudeFrames = positionMagnitudeFrames,
				tracks = tracks
			}
		end

		return nil
	end
}
