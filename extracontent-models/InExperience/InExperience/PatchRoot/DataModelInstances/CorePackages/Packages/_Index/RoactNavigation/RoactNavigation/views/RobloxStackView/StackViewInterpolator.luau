local ParentParent = script.Parent.Parent.Parent
local getSceneIndicesForInterpolationInputRange = require(ParentParent.utils.getSceneIndicesForInterpolationInputRange)
local lerp = require(ParentParent.utils.lerp)

local function forInitial(p1) -- line: 33
	local v6 = p1.initialPositionValue ~= p1.scene.index
	local v7 = not v6 and 0 or 1000000

	return {
		positionStep = nil,
		forceHidden = v6,
		initialPosition = UDim2.new(0, v7, 0, v7)
	}
end

return {
	forHorizontal = function(p2) -- line: 48
		-- upvalues: forInitial (copy), getSceneIndicesForInterpolationInputRange (copy), lerp (copy)
		local initialPositionValue = p2.initialPositionValue
		local layout = p2.layout
		local scene = p2.scene

		if not layout.isMeasured then
			return (forInitial(p2))
		end

		local v12 = getSceneIndicesForInterpolationInputRange(p2)

		if not v12 then
			return {
				forceHidden = true,
				positionStep = nil,
				initialPosition = UDim2.new(0, 100000, 0, 100000)
			}
		end

		local first = v12.first
		local last = v12.last
		local index = scene.index
		local initWidth = layout.initWidth

		local function calculate(p3) -- line: 75
			-- upvalues: first (copy), initWidth (copy), index (copy), lerp (copy), last (copy)
			if p3 < first then
				return initWidth
			end

			if p3 < index then
				return lerp(initWidth, 0, (p3 - first) / (index - first))
			end

			if p3 == index then
				return 0
			end

			if p3 < last then
				return lerp(0, -initWidth, (p3 - index) / (last - index))
			end

			return -initWidth
		end
		local function stepper(p4, p5) -- line: 90
			-- upvalues: first (copy), initWidth (copy), index (copy), lerp (copy), last (copy)
			local current = p4.current

			if not current then
				return
			end

			local currentPosition = current.Position

			current.Position = UDim2.new(currentPosition.X.Scale, if not (p5 < first) then if not (p5 < index) then if p5 ~= index then if not (p5 < last) then -initWidth else lerp(0, -initWidth, (p5 - index) / (last - index)) else 0 else lerp(initWidth, 0, (p5 - first) / (index - first)) else initWidth, currentPosition.Y.Scale, currentPosition.Y.Offset)
		end

		return {
			initialPosition = UDim2.new(0, if not (initialPositionValue < first) then if not (initialPositionValue < index) then if initialPositionValue ~= index then if not (initialPositionValue < last) then -initWidth else lerp(0, -initWidth, (initialPositionValue - index) / (last - index)) else 0 else lerp(initWidth, 0, (initialPositionValue - first) / (index - first)) else initWidth, 0, 0),
			positionStep = stepper
		}
	end,
	forVertical = function(p6) -- line: 110
		-- upvalues: forInitial (copy), getSceneIndicesForInterpolationInputRange (copy), lerp (copy)
		local initialPositionValue = p6.initialPositionValue
		local layout = p6.layout
		local scene = p6.scene

		if not layout.isMeasured then
			return (forInitial(p6))
		end

		local v23 = getSceneIndicesForInterpolationInputRange(p6)

		if not v23 then
			return {
				forceHidden = true,
				positionStep = nil,
				initialPosition = UDim2.new(0, 100000, 0, 100000)
			}
		end

		local first = v23.first
		local index = scene.index
		local initHeight = layout.initHeight

		local function calculate(p7) -- line: 133
			-- upvalues: first (copy), initHeight (copy), index (copy), lerp (copy)
			if p7 < first then
				return initHeight
			end

			if p7 < index then
				return lerp(initHeight, 0, (p7 - first) / (index - first))
			end

			return 0
		end
		local function stepper(p8, p9) -- line: 144
			-- upvalues: calculate (copy)
			local current = p8.current

			if not current then
				return
			end

			local currentPosition = current.Position

			current.Position = UDim2.new(currentPosition.X.Scale, currentPosition.X.Offset, currentPosition.Y.Scale, calculate(p9))
		end

		return {
			initialPosition = UDim2.new(0, 0, 0, calculate(initialPositionValue)),
			positionStep = stepper
		}
	end,
	forFade = function(p10) -- line: 165
		-- upvalues: forInitial (copy), getSceneIndicesForInterpolationInputRange (copy)
		local initialPositionValue = p10.initialPositionValue
		local layout = p10.layout
		local scene = p10.scene

		if not layout.isMeasured then
			return (forInitial(p10))
		end

		if not getSceneIndicesForInterpolationInputRange(p10) then
			return {
				forceHidden = true,
				positionStep = nil,
				initialPosition = UDim2.new(0, 100000, 0, 100000)
			}
		end

		local index = scene.index

		local function calculate(p11) -- line: 186
			-- upvalues: index (copy)
			return p11 >= index - 0.5
		end
		local function stepper(p12, p13) -- line: 190
			-- upvalues: index (copy)
			local current = p12.current

			if not current then
				return
			end

			current.Visible = p13 >= index - 0.5
		end

		return {
			forceHidden = not (initialPositionValue >= index - 0.5),
			initialPosition = UDim2.new(0, 0, 0, 0),
			positionStep = stepper
		}
	end
}
