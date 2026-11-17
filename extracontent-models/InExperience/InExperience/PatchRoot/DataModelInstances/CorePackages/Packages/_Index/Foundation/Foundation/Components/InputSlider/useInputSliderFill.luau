local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local ReactOtter = require(parent.ReactOtter)

require(Foundation.Components.Types)
local getDisabledStyle = require(Foundation.Utility.getDisabledStyle)
local mapBindable = require(Foundation.Utility.mapBindable)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function getFraction(value: number, range: NumberRange) -- 2 equivalent calls inferred from this helper
	local v = range.Max - range.Min

	if v <= 0 then
		return 1
	end

	return (math.clamp(value, range.Min, range.Max) - range.Min) / v
end

local function getGradientOffset(p: number)
	if p <= 0 then
		return Vector2.new(-1, 0)
	end

	if p >= 1 then
		return Vector2.new(1, 0)
	end

	return Vector2.new(p - 0.5, 0)
end

local function useInputSliderFill(p, range: NumberRange, flag: boolean, p2)
	local v = useTokens()
	local v2 = usePreferences()

	local binding = ReactIs.isBinding(p)
	local v3

	if binding then
		v3 = nil
	else
		v3 = p
	end

	local useAnimatedBinding = ReactOtter.useAnimatedBinding
	local v4 = range.Max - range.Min
	local v5, v6 = useAnimatedBinding(v4 <= 0 and 1 or (math.clamp(v3 or 0, range.Min, range.Max) - range.Min) / v4)

	React.useEffect(function()
		if v3 == nil then
			return
		end

		local fraction = getFraction(v3, range) -- inferred equivalent call

		if p2.current and not v2.reducedMotion then
			v6(ReactOtter.ease(fraction, {
				easingStyle = v.Ease.StandardOut,
				duration = v.Time.Time_300
			}))
		else
			v6((ReactOtter.instant(fraction)))
		end

		p2.current = false
	end, { v3, range, v2.reducedMotion, v })

	local offset = React.useMemo(function()
		local v7

		if binding then
			v7 = mapBindable(p, function(value: number)
				return getFraction(value, range) -- inferred equivalent call
			end)
		else
			v7 = v5
		end

		return mapBindable(v7, getGradientOffset)
	end, { binding, p, range, v5 })

	local v7 = React.useMemo(function()
		local disabledStyle = getDisabledStyle(v.Color.Shift.Shift_300, flag)
		local disabledStyle2 = getDisabledStyle(v.Color.Shift.Shift_200, flag)
		return {
			color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, disabledStyle.Color3),
				ColorSequenceKeypoint.new(0.499, disabledStyle.Color3),
				ColorSequenceKeypoint.new(0.5, disabledStyle2.Color3),
				ColorSequenceKeypoint.new(1, disabledStyle2.Color3)
			}),
			transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, disabledStyle.Transparency or 0),
				NumberSequenceKeypoint.new(0.499, disabledStyle.Transparency or 0),
				NumberSequenceKeypoint.new(0.5, disabledStyle2.Transparency or 0),
				NumberSequenceKeypoint.new(1, disabledStyle2.Transparency or 0)
			})
		}
	end, { v, flag })

	return { color = v7.color, transparency = v7.transparency, offset = offset }
end

return useInputSliderFill
