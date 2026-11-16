local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local calculateSliderStepValue = require(Foundation.Components.Slider.calculateSliderStepValue)
local calculateSliderValueFraction = require(Foundation.Components.Slider.calculateSliderValueFraction)
local getThumbOffset = require(script.Parent.ThumbLayout.getThumbOffset)
local toThumbFraction = require(script.Parent.ThumbLayout.toThumbFraction)
local toThumbTrackFraction = require(script.Parent.ThumbLayout.toThumbTrackFraction)

local function getKnobFraction(vector2: Vector2, isVertical: boolean) -- 5 equivalent calls inferred from this helper
	return if isVertical then vector2.Y else vector2.X
end

local function useSliderThumbs(data)
	local toFraction = React.useCallback(function(p: number)
		return calculateSliderValueFraction(p, data.range)
	end, { data.range })

	local valueFromFraction = React.useCallback(function(p: number)
		local v = data.range.Min + p * (data.range.Max - data.range.Min)

		if data.step then
			return (calculateSliderStepValue(v, data.step, data.range))
		end

		return v
	end, { data.range, data.step })

	local v = React.useCallback(function(p: number, p2: number)
		if not data.step or data.step <= 0 then
			return p
		end

		local v = (p - data.range.Min) / data.step
		local v2 = math.max(1, (math.abs(v))) * 1e-6
		local v3

		if p2 > 0 then
			v3 = math.ceil(v - v2)
		else
			v3 = math.floor(v + v2)
		end

		return data.range.Min + v3 * data.step
	end, { data.range.Min, data.step })

	local clampToNeighbors = React.useCallback(function(p: number, p2: number)
		local v2

		if data.step and data.step > 0 then
			v2 = data.step
		else
			v2 = 0.01 * (data.range.Max - data.range.Min)
		end

		local value = data.thumbs[p].value:getValue()

		if p > 1 then
			local value2 = data.thumbs[p - 1].value:getValue()
			p2 = math.max(p2, value2, (math.min(v(value2 + v2, 1), value)))
		end

		if p < #data.thumbs then
			local value2 = data.thumbs[p + 1].value:getValue()
			p2 = math.min(p2, value2, (math.max(v(value2 - v2, -1), value)))
		end

		return p2
	end, { data.thumbs, data.range.Min, data.range.Max, data.step, v })

	local updateThumbValue = React.useCallback(function(p: number, p2: number)
		if p2 ~= data.thumbs[p].value:getValue() then
			data.onValueChanged(p, p2)
		end
	end, { data.thumbs, data.onValueChanged })

	local seekThumb = React.useCallback(function(p: number, value: number)
		updateThumbValue(p, clampToNeighbors(p, valueFromFraction((math.clamp(value, 0, 1)))))
	end, { updateThumbValue, clampToNeighbors, valueFromFraction })

	local fractions = {}

	for i = 1, #data.thumbs do
		fractions[i] = data.thumbs[i].value:map(toFraction)
	end

	local count = #data.thumbs
	local getThumbTrackFraction = React.useCallback(function(p: number)
		return toThumbTrackFraction(
			toFraction(data.thumbs[p].value:getValue()),
			p,
			count,
			getKnobFraction(data.getKnobScale(), data.isVertical) -- inferred equivalent call
		)
	end, { data.thumbs, toFraction, count, data.getKnobScale, data.isVertical })

	local seekThumbToTrackFraction = React.useCallback(function(p: number, p2: number)
		seekThumb(p, toThumbFraction(p2, p, count, getKnobFraction(data.getKnobScale(), data.isVertical))) -- inferred equivalent call
	end, { seekThumb, count, data.getKnobScale, data.isVertical })

	local trackFractions = {}

	for i = 1, count do
		trackFractions[i] = React.joinBindings({
			fraction = fractions[i],
			knobScale = data.knobScale
		}):map(function(p)
			local fraction = p.fraction
			return toThumbTrackFraction(fraction, i, count, getKnobFraction(p.knobScale, data.isVertical)) -- inferred equivalent call
		end)
	end

	local positions = {}

	for i = 1, count do
		positions[i] = React.joinBindings({ fraction = fractions[i], knobScale = data.knobScale }):map(function(p)
			local fraction = p.fraction

			local fraction2 = p.fraction
			local v2 = fraction + getThumbOffset(
				fraction2,
				i,
				count,
				getKnobFraction(p.knobScale, data.isVertical), -- inferred equivalent call
				data.isContained
			)

			if data.isVertical then
				return (UDim2.fromScale(0.5, 1 - v2))
			end

			return (UDim2.fromScale(v2, 0.5))
		end)
	end

	return {
		fractions = fractions,
		trackFractions = trackFractions,
		positions = positions,
		span = React.joinBindings({
			first = fractions[1],
			last = fractions[count],
			knobScale = data.knobScale
		}):map(function(data2)
			local knobFraction = getKnobFraction(data2.knobScale, data.isVertical) -- inferred equivalent call
			local v2 = data2.first + getThumbOffset(data2.first, 1, count, knobFraction, data.isContained)
			local v3 = data2.last + getThumbOffset(data2.last, count, count, knobFraction, data.isContained)
			local v4 = v3 - v2

			if data.isVertical then
				return {
					Position = UDim2.fromScale(0, 1 - v3),
					Size = UDim2.fromScale(1, v4)
				}
			end

			return { Position = UDim2.fromScale(v2, 0), Size = UDim2.fromScale(v4, 1) }
		end),
		getThumbTrackFraction = getThumbTrackFraction,
		seekThumbToTrackFraction = seekThumbToTrackFraction,
		toFraction = toFraction,
		valueFromFraction = valueFromFraction,
		clampToNeighbors = clampToNeighbors,
		updateThumbValue = updateThumbValue,
		seekThumb = seekThumb
	}
end

return useSliderThumbs
