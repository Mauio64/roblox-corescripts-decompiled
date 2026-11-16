local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local InputMode = require(Foundation.Utility.Input.InputMode)
local getInputMode = require(Foundation.Utility.Input.getInputMode)

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

local calculateSliderFraction = require(Foundation.Components.Slider.calculateSliderFraction)
local getGuiInputPosition = require(Foundation.Components.Slider.getGuiInputPosition)

require(script.Parent.useSliderThumbs)

local function getNearestThumbIndex(p: number, list)
	local v = math.abs(list[1] - p)
	local nearestThumbIndex = 1

	for i = 2, #list do
		local v2 = math.abs(list[i] - p)

		if not (v2 < v - 1e-9) then
			continue
		end

		nearestThumbIndex = i
		v = v2
	end

	return nearestThumbIndex
end

local function useSliderPointerDrag(data)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)

	local onThumbDragStarted = React.useCallback(function(p: number)
		setState(p)
		data.setActiveIndex(p)

		if data.onDragStarted then
			data.onDragStarted()
		end
	end, { data.setActiveIndex, data.onDragStarted })

	local onThumbDragEnded = React.useCallback(function()
		setState(nil)

		if data.onDragEnded then
			data.onDragEnded()
		end
	end, { data.onDragEnded })

	local v = React.useCallback(function(vector2: Vector2)
		local current = data.rootRef.current

		if current then
			return calculateSliderFraction(getGuiInputPosition(vector2, current), current, data.isVertical)
		end

		return nil
	end, { data.isVertical, data.rootRef })

	return {
		draggedIndex = state,
		onThumbDragStarted = onThumbDragStarted,
		onThumbDragEnded = onThumbDragEnded,
		onTrackDragStarted = React.useCallback(function(_, vector2: Vector2)
			local v2 = v(vector2)

			if getInputMode(UserInputService:GetLastInputType()) == InputMode.Directional or v2 == nil then
				return
			end

			local v3 = {}

			for k in data.thumbs do
				v3[k] = data.getThumbTrackFraction(k)
			end

			local nearestThumbIndex = getNearestThumbIndex(v2, v3)
			ref.current = nearestThumbIndex
			onThumbDragStarted(nearestThumbIndex)
			data.seekThumbToTrackFraction(nearestThumbIndex, v2)
		end, {
			v,
			data.thumbs,
			data.getThumbTrackFraction,
			onThumbDragStarted,
			data.seekThumbToTrackFraction
		}),
		onTrackDrag = React.useCallback(function(_, vector2: Vector2)
			local current = ref.current
			local v2 = v(vector2)

			if current == nil or v2 == nil then
				return
			end

			data.seekThumbToTrackFraction(current, v2)
		end, { v, data.seekThumbToTrackFraction }),
		onTrackDragEnded = React.useCallback(function()
			if ref.current == nil then
				return
			end

			ref.current = nil
			onThumbDragEnded()
		end, { onThumbDragEnded })
	}
end

return useSliderPointerDrag
