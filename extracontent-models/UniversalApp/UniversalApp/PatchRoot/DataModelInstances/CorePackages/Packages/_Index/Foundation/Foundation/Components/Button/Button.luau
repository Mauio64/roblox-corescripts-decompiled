local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Motion = require(FoundationParent.Motion)
local useMotion = Motion.useMotion
local AnimatePresence = Motion.AnimatePresence
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local InputSize = require(Foundation.Enums.InputSize)
local Spinner = require(script.Parent.Spinner)
local endAlignedIcons = require(script.Parent.endAlignedIcons)
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local ControlState = require(Foundation.Enums.ControlState)
local ButtonIcon = require(script.Parent.ButtonIcon)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local withDefaults = require(Foundation.Utility.withDefaults)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local useButtonMotionStates = require(script.Parent.useButtonMotionStates)
local useButtonVariants = require(script.Parent.useButtonVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
local t1 = {
	[ButtonVariant.Link] = {
		format = "<u>%s</u>",
		controlState = {
			ControlState.Hover,
			ControlState.Pressed
		}
	}
}

local function onProgressChange(n1: number) -- line: 52
	-- upvalues: Constants (copy)
	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(math.max(0, n1 - 0.0001), 0),
		NumberSequenceKeypoint.new(math.min(1, n1 + 0.0001), Constants.DISABLED_TRANSPARENCY),
		NumberSequenceKeypoint.new(1, Constants.DISABLED_TRANSPARENCY)
	})
end
local function getTransparency(n2: number?, p1) -- line: 61
	return p1:map(function(p2) -- line: 65
		-- upvalues: n2 (copy)
		if n2 ~= nil then
			return n2 + (1 - n2) * p2
		end

		return p2
	end)
end

local t2 = {
	isDisabled = false,
	isLoading = false,
	inputDelay = 0,
	testId = "--foundation-button",
	variant = ButtonVariant.Standard,
	size = InputSize.Medium,
	width = UDim.new(0, 0)
}

local function Button(p3, p4) -- line: 100
	-- upvalues: withDefaults (copy), t2 (copy), React (copy), ControlState (copy), ReactOtter (copy), endAlignedIcons (copy), useTokens (copy), usePresentationContext (copy), useButtonVariants (copy), useButtonMotionStates (copy), Constants (copy), useMotion (copy), t1 (copy), View (copy), withCommonProps (copy), Flags (copy), FillBehavior (copy), AnimatePresence (copy), Spinner (copy), ButtonIcon (copy), Text (copy), onProgressChange (copy)
	local v35 = withDefaults(p3, t2)
	local inputDelay = v35.inputDelay
	local v37, v38 = React.useBinding(ControlState.Initialize)
	local v39, v40 = React.useState(inputDelay > 0)
	local v41, v42 = ReactOtter.useAnimatedBinding(0, function() -- line: 106
		-- upvalues: v40 (copy)
		v40(false)
	end)
	local v43 = v35.icon and endAlignedIcons[v35.icon]

	React.useEffect(function() -- line: 112
		-- upvalues: v39 (copy), v42 (copy), ReactOtter (copy)
		if v39 == false then
			v42(ReactOtter.instant(0))
		end
	end, { v39 })
	React.useEffect(function() -- line: 118
		-- upvalues: v39 (copy), v40 (copy), inputDelay (copy), v42 (copy), ReactOtter (copy)
		if v39 then
			v40(false)
		end

		if inputDelay > 0 then
			v40(true)
			v42((ReactOtter.ease(1, {
				duration = inputDelay,
				easingStyle = Enum.EasingStyle.Quad
			})))
		end
	end, { inputDelay })

	local v44 = useTokens()
	local v45 = usePresentationContext()
	local v46 = useButtonVariants(v44, v35.size, v35.variant, if not v45 then nil else v45.colorNamespace)
	local v47 = useButtonMotionStates(v46.content.style.Transparency, Constants.DISABLED_TRANSPARENCY)
	local v48, v49 = useMotion(v47.Default)
	local v50, v51 = useMotion(v47.Default)

	React.useEffect(function() -- line: 147
		-- upvalues: v35 (copy), v51 (copy), v47 (copy)
		if v35.isLoading then
			v51(v47.Loading)

			return
		end

		v51(v47.Default)
	end, { v35.isLoading })
	React.useEffect(function() -- line: 155
		-- upvalues: v35 (copy), v49 (copy), v47 (copy)
		if v35.isDisabled then
			v49(v47.Disabled)

			return
		end

		v49(v47.Default)
	end, { v35.isDisabled })

	local v52 = React.useMemo(function() -- line: 163
		-- upvalues: v46 (copy), v44 (copy)
		return {
			radius = UDim.new(0, v46.container.radius),
			offset = v44.Size.Size_200,
			borderWidth = v44.Stroke.Thicker
		}
	end, {
		v44,
		v46.container.radius
	})
	local v53 = v35.text and v35.text ~= ""
	local v54 = React.useCallback(function(p5) -- line: 173
		-- upvalues: t1 (copy), v35 (copy), v53 (copy)
		local v65 = t1[v35.variant]

		if v53 and (v65 and table.find(v65.controlState, p5)) then
			return (v65.format:format(v35.text))
		end

		return v35.text
	end, {
		v35.text,
		v35.variant,
		v53
	})
	local createElement = React.createElement
	local v56 = View
	local v57 = withCommonProps
	local t3 = {
		AutomaticSize = if Flags.FoundationButtonFillBehaviorEqualSize and v35.fillBehavior == FillBehavior.Fill or (v35.width.Scale ~= 0 or v35.width.Offset ~= 0) then nil else Enum.AutomaticSize.X,
		cornerRadius = UDim.new(0, v46.container.radius)
	}
	local v60

	if v46.container.style then
		local styleTransparency = v46.container.style.Transparency

		v60 = v48.transparency:map(function(p6) -- line: 65
			-- upvalues: styleTransparency (copy)
			if styleTransparency ~= nil then
				return styleTransparency + (1 - styleTransparency) * p6
			end

			return p6
		end):map(function(p7) -- line: 194
			-- upvalues: v46 (copy)
			return {
				Color3 = v46.container.style.Color3,
				Transparency = p7
			}
		end)
	else
		v60 = nil
	end

	t3.backgroundStyle = v60
	t3.flexItem = if not v35.fillBehavior then nil else {
		FlexMode = if v35.fillBehavior ~= FillBehavior.Fill then Enum.UIFlexMode.Shrink else Enum.UIFlexMode.Fill
	}

	local t4

	if v46.container.stroke then
		t4 = {
			Color = v46.container.stroke.Color
		}

		local strokeTransparency = v46.container.stroke.Transparency

		t4.Transparency = v48.transparency:map(function(p8) -- line: 65
			-- upvalues: strokeTransparency (copy)
			if strokeTransparency ~= nil then
				return strokeTransparency + (1 - strokeTransparency) * p8
			end

			return p8
		end)
	else
		t4 = nil
	end

	t3.stroke = t4
	t3.Size = UDim2.new(if v35.fillBehavior ~= FillBehavior.Fill then v35.width.Scale else 1, if v35.fillBehavior ~= FillBehavior.Fill then v35.width.Offset else 0, 0, v46.container.height)
	t3.selection = {
		Selectable = not v35.isDisabled and v35.Selectable,
		NextSelectionUp = v35.NextSelectionUp,
		NextSelectionDown = v35.NextSelectionDown,
		NextSelectionLeft = v35.NextSelectionLeft,
		NextSelectionRight = v35.NextSelectionRight
	}
	t3.cursor = v52
	t3.onActivated = v35.onActivated
	t3.onStateChanged = v38
	t3.isDisabled = v35.isDisabled or (v35.isLoading or v39)
	t3.stateLayer = v46.container.stateLayer
	t3.tag = v46.container.tag
	t3.ref = p4

	return createElement(v56, v57(v35, t3), {
		Loading = if not v35.isLoading then nil else React.createElement("Folder", {}, {
			PresenceWrapper = React.createElement(AnimatePresence, {}, {
				Spinner = React.createElement(Spinner, {
					Size = v46.icon.size - if not Flags.FoundationUsePath2DSpinner then UDim2.fromOffset(0, 0) else UDim2.fromOffset(v44.Padding.XSmall, v44.Padding.XSmall),
					style = v48.transparency:map(function(p9) -- line: 248
						-- upvalues: v46 (copy)
						return {
							Color3 = v46.content.style.Color3,
							Transparency = p9
						}
					end),
					testId = `{ v35.testId }--spinner`
				})
			})
		}),
		IconWrapper = if not v35.icon then nil else React.createElement(View, {
			Size = if not v35.icon then nil else v46.icon.size,
			LayoutOrder = if not v35.icon then nil else not v43 and 1 or 3,
			testId = if not v35.icon then nil else `{ v35.testId }--icon-wrapper`
		}, {
			Icon = React.createElement(ButtonIcon, {
				icon = v35.icon,
				isLoading = v35.isLoading,
				variant = v35.variant,
				size = v35.size,
				disabledTransparencyBinding = v48.transparency,
				textTransparencyBinding = v50.textTransparency,
				testId = v35.testId
			})
		}),
		Text = if not v53 then nil else React.createElement(Text, {
			LayoutOrder = 2,
			Text = v37:map(v54),
			RichText = t1[v35.variant] ~= nil,
			tag = v46.text.tag,
			textStyle = React.joinBindings({
				v48.transparency,
				v50.textTransparency
			}):map(function(p10) -- line: 286
				-- upvalues: v46 (copy)
				local v71 = p10[1]
				local v72 = p10[2]

				return {
					Color3 = v46.content.style.Color3,
					Transparency = v72 + v71
				}
			end),
			testId = `{ v35.testId }--text`
		}),
		Gradient = if not v39 then nil else React.createElement("UIGradient", {
			Transparency = v41:map(onProgressChange)
		})
	})
end

return React.memo(React.forwardRef(Button))
