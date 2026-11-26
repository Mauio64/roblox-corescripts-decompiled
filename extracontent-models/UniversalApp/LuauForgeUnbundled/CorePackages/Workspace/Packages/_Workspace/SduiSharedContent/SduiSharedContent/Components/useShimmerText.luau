local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ReactUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local usePreferences = Foundation.Hooks.usePreferences
local usePulseBinding = Foundation.Hooks.usePulseBinding
local useTokens = Foundation.Hooks.useTokens
local useClock = ReactUtils.useClock

local color = Color3.new(1, 1, 1)

local function generateShimmerGradient(color3)
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
	local v5 = usePreferences()
	local v6 = useTokens()
	local v7 = useClock()
	local v8 = usePulseBinding(0.75)

	local v9 = props.animationSpeed == nil and 0.75 or math.max(props.animationSpeed, 0)

	local v10 = (props.gradientOffset == nil or not (props.gradientOffset > 0)) and 1.05
		or props.gradientOffset

	local default = v6.Color.Content.Default
	local textStyle = props.textStyle or default
	local color3 = textStyle.Color3 or default.Color3
	local transparency = textStyle.Transparency or default.Transparency

	local v11 = React.useMemo(function()
		return generateShimmerGradient(color3)
	end, { color3 })

	if props.isShimmerEnabled == false then
		return { children = props.children, textStyle = props.textStyle }
	end

	if v5.reducedMotion then
		return {
			children = props.children,
			textStyle = v8:map(function(p2)
				return {
					Color3 = color3,
					Transparency = math.min(transparency + p2 * 0.1, 1)
				}
			end)
		}
	end

	return {
		children = {
			Content = React.createElement(React.Fragment, nil, props.children),
			ShimmerGradient = React.createElement("UIGradient", {
				Color = v11,
				Offset = v7:map(function(p2)
					return Vector2.new(p2 * v9 % v10 - v10 / 2, 0)
				end),
				Rotation = 15
			})
		},
		textStyle = { Color3 = color, Transparency = transparency }
	}
end

return useShimmerText
