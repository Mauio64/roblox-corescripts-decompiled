local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local constants = require(script.Parent.constants)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)

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

local t1 = {
	size = require(Foundation.Enums.ProgressSize).Medium
}

local function getRotationFromProgress(n1: number?, p1) -- line: 42
	local v24 = p1 ~= Enum.HorizontalAlignment.Left and 0 or 180
	local v25 = p1 ~= Enum.HorizontalAlignment.Left and 180 or 360

	if n1 == nil then
		return 0
	end

	return (math.clamp(n1 * 360, v24, v25))
end
local function getLabelFromProgress(n2: number?) -- line: 48
	if n2 == nil then
		return "0%"
	end

	return `{ math.floor(n2 * 100) }%`
end
local function ProgressGradient(t2: {[any]: any}) -- line: 52
	-- upvalues: useTokens (copy), usePreferences (copy), React (copy), ReactIs (copy)
	local side = t2.side
	local isIndeterminate = t2.isIndeterminate
	local progress = t2.progress
	local v31 = useTokens()
	local v32 = usePreferences()
	local v33 = React.useMemo(function() -- line: 66
		-- upvalues: v31 (copy), isIndeterminate (copy)
		local EmphasisTransparency = v31.Color.Content.Emphasis.Transparency
		local v53 = if not isIndeterminate then v31.Color.Shift.Shift_200.Transparency else 1

		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, EmphasisTransparency),
			NumberSequenceKeypoint.new(0.4999, EmphasisTransparency),
			NumberSequenceKeypoint.new(0.5, v53),
			NumberSequenceKeypoint.new(1, v53)
		})
	end, {
		v31,
		isIndeterminate
	})
	local v34 = React.useMemo(function() -- line: 78
		-- upvalues: v31 (copy)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, v31.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.4999, v31.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.5, v31.Color.Shift.Shift_200.Color3),
			ColorSequenceKeypoint.new(1, v31.Color.Shift.Shift_200.Color3)
		})
	end, { v31 })

	if isIndeterminate and v32.reducedMotion then
		local v35 = if isIndeterminate then side ~= Enum.HorizontalAlignment.Left and 180 or 0 else t2.rotation

		return React.createElement("UIGradient", {
			Transparency = t2.pulse:map(function(n3: number) -- line: 96
				-- upvalues: v31 (copy)
				return NumberSequence.new((math.lerp(v31.Color.Content.Emphasis.Transparency, v31.Color.Shift.Shift_200.Transparency, n3)))
			end),
			Color = t2.pulse:map(function(n4: number) -- line: 105
				-- upvalues: v31 (copy)
				return ColorSequence.new(v31.Color.Content.Emphasis.Color3:Lerp(v31.Color.Shift.Shift_200.Color3, n4))
			end),
			Rotation = v35
		})
	end

	local createElement = React.createElement
	local t3 = {
		Transparency = v33,
		Color = v34
	}
	local v38

	if ReactIs.isBinding(progress) then
		v38 = progress:map(function(n5: number?) -- line: 117
			-- upvalues: side (copy)
			local v57 = side
			local v58 = v57 ~= Enum.HorizontalAlignment.Left and 0 or 180
			local v59 = v57 ~= Enum.HorizontalAlignment.Left and 180 or 360

			if n5 == nil then
				return 0
			end

			return (math.clamp(n5 * 360, v58, v59))
		end)
	else
		local v39 = side ~= Enum.HorizontalAlignment.Left and 0 or 180
		local v40 = side ~= Enum.HorizontalAlignment.Left and 180 or 360

		v38 = if progress ~= nil then math.clamp(progress * 360, v39, v40) else 0
	end

	t3.Rotation = v38

	return (createElement("UIGradient", t3))
end
local function ProgressCircle(p2) -- line: 125
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePreferences (copy), useProgressVariants (copy), useProgressBinding (copy), React (copy), useRotation (copy), usePulseBinding (copy), constants (copy), View (copy), withCommonProps (copy), Image (copy), ProgressGradient (copy), Text (copy), ReactIs (copy), getLabelFromProgress (copy)
	local v42 = withDefaults(p2, t1)
	local v43 = useTokens()
	local v44 = usePreferences()
	local v45 = useProgressVariants(v43, v42.size)
	local v46, v47 = useProgressBinding(v42.value)
	local v48 = React.useBinding(0.8)
	local v49 = useRotation(1)
	local v50 = usePulseBinding(1 / constants.INDETERMINATE_SHIMMER_SPEED)
	local uDim2 = UDim2.fromOffset(v45.circle.size, v45.circle.size)

	if v47 and not v44.reducedMotion then
		return React.createElement(View, withCommonProps(v42, {
			tag = "auto-xy",
			ref = v42.ref
		}), {
			IndeterminateContainer = React.createElement(View, {
				Size = uDim2,
				Rotation = v49,
				testId = `{ v42.testId }--indeterminate-container`
			}, {
				LeftGradient = React.createElement(View, {
					tag = "position-top-left clip",
					Size = UDim2.fromScale(0.5, 1),
					testId = `{ v42.testId }--left-gradient`
				}, {
					Image = React.createElement(Image, {
						Image = "rbxasset://textures/ui/Controls/RadialFill.png",
						tag = "position-top-left content-emphasis",
						Size = UDim2.fromScale(2, 1)
					}, {
						Gradient = React.createElement(ProgressGradient, {
							side = Enum.HorizontalAlignment.Left,
							isIndeterminate = v47,
							rotation = v49,
							progress = v48,
							pulse = v50
						})
					})
				}),
				RightGradient = React.createElement(View, {
					tag = "position-top-center clip",
					Size = UDim2.fromScale(0.5, 1),
					testId = `{ v42.testId }--right-gradient`
				}, {
					Image = React.createElement(Image, {
						Image = "rbxasset://textures/ui/Controls/RadialFill.png",
						tag = "content-emphasis",
						Size = UDim2.fromScale(2, 1),
						Position = UDim2.fromScale(-1, 0)
					}, {
						Gradient = React.createElement(ProgressGradient, {
							side = Enum.HorizontalAlignment.Right,
							isIndeterminate = v47,
							rotation = v49,
							progress = v48,
							pulse = v50
						})
					})
				})
			})
		})
	end

	return React.createElement(View, withCommonProps(v42, {
		Size = uDim2,
		ref = v42.ref
	}), {
		LeftGradient = React.createElement(View, {
			tag = "position-top-left clip",
			Size = UDim2.fromScale(0.5, 1),
			testId = `{ v42.testId }--left-gradient`
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/Controls/RadialFill.png",
				tag = "position-top-left content-emphasis",
				Size = UDim2.fromScale(2, 1)
			}, {
				Gradient = React.createElement(ProgressGradient, {
					side = Enum.HorizontalAlignment.Left,
					isIndeterminate = v47,
					rotation = v49,
					progress = v46,
					pulse = v50
				})
			})
		}),
		RightGradient = React.createElement(View, {
			tag = "position-top-center clip",
			Size = UDim2.fromScale(0.5, 1),
			testId = `{ v42.testId }--right-gradient`
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/Controls/RadialFill.png",
				tag = "content-emphasis",
				Size = UDim2.fromScale(2, 1),
				Position = UDim2.fromScale(-1, 0)
			}, {
				Gradient = React.createElement(ProgressGradient, {
					side = Enum.HorizontalAlignment.Right,
					isIndeterminate = v47,
					rotation = v49,
					progress = v46,
					pulse = v50
				})
			})
		}),
		ProgressLabel = if not v45.circle.labelFont or v47 then nil else React.createElement(Text, {
			tag = "position-center-center anchor-center-center",
			Text = if not ReactIs.isBinding(v46) then if v46 ~= nil then `{ math.floor(v46 * 100) }%` else "0%" else v46:map(getLabelFromProgress),
			fontStyle = v45.circle.labelFont,
			testId = `{ v42.testId }--label`
		})
	})
end

return ProgressCircle
