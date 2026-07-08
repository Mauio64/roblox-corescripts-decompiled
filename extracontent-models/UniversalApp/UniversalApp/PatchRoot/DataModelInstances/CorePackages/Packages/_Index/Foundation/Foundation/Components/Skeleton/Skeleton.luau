local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useClock = require(FoundationParent.ReactUtils).useClock
local Components = Foundation.Components

require(Components.Types)

local View = require(Components.View)
local Radius = require(Foundation.Enums.Radius)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local usePulseBinding = require(Foundation.Utility.usePulseBinding)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local lerp = require(Foundation.Utility.lerp)
local t1 = {
	testId = "--foundation-skeleton",
	radius = Radius.None,
	Size = UDim2.fromScale(1, 1)
}

local function Skeleton(p1, p2) -- line: 39
	-- upvalues: withDefaults (copy), t1 (copy), useClock (copy), usePulseBinding (copy), useTokens (copy), usePreferences (copy), Radius (copy), React (copy), View (copy), withCommonProps (copy), lerp (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = useClock()
	local v20 = usePulseBinding(2)
	local v21 = useTokens()
	local v22 = usePreferences()
	local v23 = if v18.radius == Radius.None then nil else UDim.new(0, v21.Radius[v18.radius])

	return React.createElement(View, withCommonProps(v18, {
		cornerRadius = v23,
		backgroundStyle = if not v22.reducedMotion then v21.Color.Extended.White.White_100 else v20:map(function(n1: number) -- line: 53
			-- upvalues: v21 (copy), lerp (copy)
			return {
				Color3 = v21.Color.Shift.Shift_300.Color3,
				Transparency = lerp(v21.Color.Extended.White.White_10.Transparency, v21.Color.Extended.White.White_10.Transparency - 0.1, n1)
			}
		end),
		Size = v18.Size,
		ref = p2
	}), {
		Gradient = if v22.reducedMotion then nil else React.createElement("UIGradient", {
			Rotation = 15,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, v21.Color.Shift.Shift_300.Color3),
				ColorSequenceKeypoint.new(0.5, v21.Color.Extended.White.White_30.Color3),
				ColorSequenceKeypoint.new(1, v21.Color.Shift.Shift_300.Color3)
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, v21.Color.Shift.Shift_300.Transparency),
				NumberSequenceKeypoint.new(0.5, v21.Color.Extended.White.White_30.Transparency),
				NumberSequenceKeypoint.new(1, v21.Color.Shift.Shift_300.Transparency)
			}),
			Offset = v19:map(function(n2: number) -- line: 81
				return Vector2.new(n2 * 2 % 3 - 1.5, 0)
			end)
		})
	})
end

return React.memo(React.forwardRef(Skeleton))
