local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local constants = require(script.Parent.constants)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useProgressBinding = require(script.Parent.useProgressBinding)
local useProgressVariants = require(script.Parent.useProgressVariants)
local usePulseBinding = require(Foundation.Utility.usePulseBinding)
local useRotation = require(Foundation.Utility.useRotation)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Enums.ProgressShape)

local function getBarSequenceFromProgress(n1: number?) -- line: 27
	local v19 = n1 or 0

	if v19 == 0 then
		return NumberSequence.new(1)
	end

	if v19 == 1 then
		return NumberSequence.new(0)
	end

	local t1 = {
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(v19, 0),
		NumberSequenceKeypoint.new(math.min(v19 + 0.001, 1), 1)
	}

	if v19 < 0.999 then
		table.insert(t1, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(t1)
end

local t2 = {
	size = require(Foundation.Enums.ProgressSize).Medium,
	width = UDim.new(1, 0)
}

local function ProgressBar(p1) -- line: 63
	-- upvalues: withDefaults (copy), t2 (copy), useTokens (copy), usePreferences (copy), useProgressVariants (copy), useProgressBinding (copy), useRotation (copy), usePulseBinding (copy), constants (copy), ReactIs (copy), getBarSequenceFromProgress (copy), React (copy), View (copy), withCommonProps (copy)
	local v22 = withDefaults(p1, t2)
	local v23 = useTokens()
	local v24 = usePreferences()
	local v25 = useProgressVariants(v23, v22.size)
	local v26, v27 = useProgressBinding(v22.value)
	local v28 = useRotation(1)
	local v29 = usePulseBinding(1 / constants.INDETERMINATE_SHIMMER_SPEED)
	local v30 = if not ReactIs.isBinding(v26) then getBarSequenceFromProgress(v26) else v26:map(getBarSequenceFromProgress)

	return React.createElement(View, withCommonProps(v22, {
		tag = "radius-small bg-shift-400",
		Size = UDim2.new(v22.width, UDim.new(0, v25.bar.height)),
		ref = v22.ref
	}), {
		Fill = React.createElement(View, {
			tag = "size-full radius-small",
			backgroundStyle = v23.Color.Content.Emphasis,
			ref = v22.ref,
			testId = `{ v22.testId }--fill`
		}, {
			Gradient = React.createElement("UIGradient", {
				Color = ColorSequence.new(v23.Color.Content.Emphasis.Color3),
				Transparency = if not v27 then v30 else v29:map(function(n2: number) -- line: 94
					-- upvalues: v24 (copy), v23 (copy)
					if v24.reducedMotion then
						return NumberSequence.new(n2)
					end

					return NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.2, 1),
						NumberSequenceKeypoint.new(0.5, v23.Color.Content.Emphasis.Transparency),
						NumberSequenceKeypoint.new(0.8, 1),
						NumberSequenceKeypoint.new(1, 1)
					})
				end),
				Offset = if not v27 then nil else v28:map(function(n3: number) -- line: 109
					-- upvalues: v24 (copy), constants (copy)
					if v24.reducedMotion then
						return Vector2.new(0, 0)
					end

					return Vector2.new(n3 * constants.INDETERMINATE_SHIMMER_SPEED % 360 / 360 * 2 - 1, 0)
				end)
			})
		})
	})
end

return ProgressBar
