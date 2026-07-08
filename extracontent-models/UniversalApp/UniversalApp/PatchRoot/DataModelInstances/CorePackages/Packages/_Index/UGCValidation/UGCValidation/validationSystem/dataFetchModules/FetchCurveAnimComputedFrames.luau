local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local CurveAnimationFrameCalculator = require(ParentParent.util.CurveAnimationFrameCalculator)

return {
	getData = function(p1) -- line: 14
		-- upvalues: CurveAnimationFrameCalculator (copy)
		if #p1 == 0 then
			return nil
		end

		local v4 = p1[1]
		local ok, result, v7, v8, v9 = pcall(function() -- line: 22
			-- upvalues: CurveAnimationFrameCalculator (copy), v4 (copy)
			return CurveAnimationFrameCalculator.calculateAnimFramesAtOrigin(v4)
		end)

		if not ok then
			return nil
		end

		return {
			animFrames = result,
			animLength = v7,
			positionMagnitudeFrames = v8,
			tracks = v9
		}
	end
}
