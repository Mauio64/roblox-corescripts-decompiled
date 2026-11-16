local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local usePreferences = Foundation.Hooks.usePreferences
local usePulseBinding = Foundation.Hooks.usePulseBinding
local useTokens = Foundation.Hooks.useTokens
local useClock = ReactUtils.useClock

local color = Color3.new(1, 1, 1)

local function generateShimmerGradient(color3: Color3)
	local lerped = color3:Lerp(Color3.new(0, 0, 0), 0.2)
	local lerped2 = color3:Lerp(Color3.new(1, 1, 1), 0.8)

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, color3),
		ColorSequenceKeypoint.new(0.25, lerped),
		ColorSequenceKeypoint.new(0.5, lerped2),
		ColorSequenceKeypoint.new(0.75, lerped),
		ColorSequenceKeypoint.new(1, color3)
	})
end

local function useShimmerText(props)
	local v = usePreferences()
	local v2 = useTokens()
	local v3 = useClock()
	local v4 = usePulseBinding(0.75)

	local v5 = props.animationSpeed == nil and 0.75 or math.max(props.animationSpeed, 0)

	local v6 = (props.gradientOffset == nil or not (props.gradientOffset > 0)) and 1.05 or props.gradientOffset

	local default = v2.Color.Content.Default
	local textStyle = props.textStyle or default
	local color3 = textStyle.Color3 or default.Color3
	local transparency = textStyle.Transparency or default.Transparency

	local color2 = React.useMemo(function()
		return generateShimmerGradient(color3)
	end, { color3 })

	if props.isShimmerEnabled == false then
		return { children = props.children, textStyle = props.textStyle }
	end

	if v.reducedMotion then
		return {
			children = props.children,
			textStyle = v4:map(function(p: number)
				return {
					Color3 = color3,
					Transparency = math.min(transparency + p * 0.1, 1)
				}
			end)
		}
	end

	return {
		children = {
			Content = React.createElement(React.Fragment, nil, props.children),
			ShimmerGradient = React.createElement("UIGradient", {
				Color = color2,
				Offset = v3:map(function(p: number)
					return Vector2.new(p * v5 % v6 - v6 / 2, 0)
				end),
				Rotation = 15
			})
		},
		textStyle = { Color3 = color, Transparency = transparency }
	}
end

return useShimmerText
