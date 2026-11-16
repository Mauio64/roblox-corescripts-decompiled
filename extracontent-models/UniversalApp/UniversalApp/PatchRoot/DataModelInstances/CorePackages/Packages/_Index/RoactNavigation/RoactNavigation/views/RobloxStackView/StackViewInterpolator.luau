local parent = script.Parent.Parent.Parent

local getSceneIndicesForInterpolationInputRange = require(parent.utils.getSceneIndicesForInterpolationInputRange)
local lerp = require(parent.utils.lerp)

local function forInitial(data)
	local forceHidden = data.initialPositionValue ~= data.scene.index
	local v = forceHidden and 1000000 or 0
	return {
		forceHidden = forceHidden,
		initialPosition = UDim2.new(0, v, 0, v),
		positionStep = nil
	}
end

local StackViewInterpolator = {}

function StackViewInterpolator.forHorizontal(data)
	local initialPositionValue = data.initialPositionValue
	local layout = data.layout
	local scene = data.scene

	if not layout.isMeasured then
		return forInitial(data)
	end

	local sceneIndicesForInterpolationInputRange = getSceneIndicesForInterpolationInputRange(data)

	if not sceneIndicesForInterpolationInputRange then
		return {
			forceHidden = true,
			initialPosition = UDim2.new(0, 100000, 0, 100000),
			positionStep = nil
		}
	end

	local first = sceneIndicesForInterpolationInputRange.first
	local last = sceneIndicesForInterpolationInputRange.last
	local index = scene.index

	local initWidth = layout.initWidth

	local function calculate(p) -- 2 equivalent calls inferred from this helper
		if p < first then
			return initWidth
		end

		if p < index then
			return lerp(initWidth, 0, (p - first) / (index - first))
		end

		if p == index then
			return 0
		end

		if p < last then
			return lerp(0, -initWidth, (p - index) / (last - index))
		end

		return -initWidth
	end

	local function stepper(p, p2)
		local current = p.current

		if not current then
			return
		end

		local position = current.Position
		current.Position = UDim2.new(position.X.Scale, calculate(p2), position.Y.Scale, position.Y.Offset) -- inferred equivalent call
	end

	local v = calculate(initialPositionValue) -- inferred equivalent call
	return { initialPosition = UDim2.new(0, v, 0, 0), positionStep = stepper }
end

function StackViewInterpolator.forVertical(data)
	local initialPositionValue = data.initialPositionValue
	local layout = data.layout
	local scene = data.scene

	if not layout.isMeasured then
		return forInitial(data)
	end

	local sceneIndicesForInterpolationInputRange = getSceneIndicesForInterpolationInputRange(data)

	if not sceneIndicesForInterpolationInputRange then
		return {
			forceHidden = true,
			initialPosition = UDim2.new(0, 100000, 0, 100000),
			positionStep = nil
		}
	end

	local first = sceneIndicesForInterpolationInputRange.first
	local index = scene.index
	local initHeight = layout.initHeight

	local function calculate(p)
		if p < first then
			return initHeight
		end

		if p < index then
			return lerp(initHeight, 0, (p - first) / (index - first))
		end

		return 0
	end

	local function stepper(p, p2)
		local current = p.current

		if not current then
			return
		end

		local position = current.Position
		current.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, calculate(p2))
	end

	return {
		initialPosition = UDim2.new(0, 0, 0, calculate(initialPositionValue)),
		positionStep = stepper
	}
end

function StackViewInterpolator.forFade(data)
	local initialPositionValue = data.initialPositionValue
	local layout = data.layout
	local scene = data.scene

	if not layout.isMeasured then
		return forInitial(data)
	end

	if not getSceneIndicesForInterpolationInputRange(data) then
		return {
			forceHidden = true,
			initialPosition = UDim2.new(0, 100000, 0, 100000),
			positionStep = nil
		}
	end

	local index = scene.index

	local function calculate(p): boolean -- 2 equivalent calls inferred from this helper
		return index - 0.5 <= p
	end

	local function stepper(p, p2)
		local current = p.current

		if not current then
			return
		end

		current.Visible = calculate(p2) -- inferred equivalent call
	end

	return {
		forceHidden = not calculate(initialPositionValue), -- inferred equivalent call
		initialPosition = UDim2.new(0, 0, 0, 0),
		positionStep = stepper
	}
end

return StackViewInterpolator
