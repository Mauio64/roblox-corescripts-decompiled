local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local ReactUtils = require(Parent.ReactUtils)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local usePreferences = Foundation.Hooks.usePreferences
local usePulseBinding = Foundation.Hooks.usePulseBinding
local useTokens = Foundation.Hooks.useTokens
local useClock = ReactUtils.useClock
local color3 = Color3.new(1, 1, 1)

local function generateShimmerGradient(color3_2: Color3) -- line: 37
	local v13 = color3_2:Lerp(Color3.new(0, 0, 0), 0.2)
	local v14 = color3_2:Lerp(Color3.new(1, 1, 1), 0.8)

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, color3_2),
		ColorSequenceKeypoint.new(0.25, v13),
		ColorSequenceKeypoint.new(0.5, v14),
		ColorSequenceKeypoint.new(0.75, v13),
		ColorSequenceKeypoint.new(1, color3_2)
	})
end
local function useShimmerText(t1: {[any]: any}) -- line: 50
	-- upvalues: usePreferences (copy), useTokens (copy), useClock (copy), usePulseBinding (copy), React (copy), generateShimmerGradient (copy), color3 (copy)
	local v16 = usePreferences()
	local v17 = useTokens()
	local v18 = useClock()
	local v19 = usePulseBinding(0.75)
	local v20 = t1.animationSpeed == nil and 0.75 or math.max(t1.animationSpeed, 0)
	local v21 = (t1.gradientOffset == nil or not (t1.gradientOffset > 0)) and 1.05 or t1.gradientOffset
	local Default = v17.Color.Content.Default
	local v23 = t1.textStyle or Default
	local v24 = v23.Color3 or Default.Color3
	local v25 = v23.Transparency or Default.Transparency
	local v26 = React.useMemo(function() -- line: 67
		-- upvalues: generateShimmerGradient (copy), v24 (copy)
		return generateShimmerGradient(v24)
	end, { v24 })

	if t1.isShimmerEnabled == false then
		return {
			children = t1.children,
			textStyle = t1.textStyle
		}
	end

	if v16.reducedMotion then
		return {
			children = t1.children,
			textStyle = v19:map(function(n1: number) -- line: 81
				-- upvalues: v24 (copy), v25 (copy)
				return {
					Color3 = v24,
					Transparency = math.min(v25 + n1 * 0.1, 1)
				}
			end)
		}
	end

	return {
		children = {
			Content = React.createElement(React.Fragment, nil, t1.children),
			ShimmerGradient = React.createElement("UIGradient", {
				Rotation = 15,
				Color = v26,
				Offset = v18:map(function(n2: number) -- line: 95
					-- upvalues: v20 (copy), v21 (copy)
					return Vector2.new(n2 * v20 % v21 - v21 / 2, 0)
				end)
			})
		},
		textStyle = {
			Color3 = color3,
			Transparency = v25
		}
	}
end

return useShimmerText
