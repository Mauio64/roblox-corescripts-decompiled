local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Motion = require(parent.Motion)
local useMotion = Motion.useMotion
local AnimatePresence = Motion.AnimatePresence

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

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
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext

local v = {
	[ButtonVariant.Link] = {
		format = "<u>%s</u>",
		controlState = { ControlState.Hover, ControlState.Pressed }
	}
}

local function onProgressChange(p: number)
	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(math.max(0, p - 0.0001), 0),
		NumberSequenceKeypoint.new(math.min(1, p + 0.0001), Constants.DISABLED_TRANSPARENCY),
		NumberSequenceKeypoint.new(1, Constants.DISABLED_TRANSPARENCY)
	})
end

local function getTransparency(transparency: number?, transparency2) -- 2 equivalent calls inferred from this helper
	return transparency2:map(function(p)
		if transparency == nil then
			return p
		end

		return transparency + (1 - transparency) * p
	end)
end

local v2 = {
	isDisabled = false,
	isLoading = false,
	variant = ButtonVariant.Standard,
	size = InputSize.Medium,
	width = UDim.new(0, 0),
	inputDelay = 0,
	testId = "--foundation-button"
}

local function Button(p, ref)
	local v3 = withDefaults(p, v2)
	local inputDelay = v3.inputDelay

	local v4, onStateChanged = React.useBinding(ControlState.Initialize)
	local state, setState = React.useState(inputDelay > 0)
	local v5, v6 = ReactOtter.useAnimatedBinding(0, function()
		setState(false)
	end)

	local v7 = v3.icon and endAlignedIcons[v3.icon]

	React.useEffect(function()
		if state == false then
			v6(ReactOtter.instant(0))
		end
	end, { state })

	React.useEffect(function()
		if state then
			setState(false)
		end

		if inputDelay > 0 then
			setState(true)
			v6((ReactOtter.ease(1, { duration = inputDelay, easingStyle = Enum.EasingStyle.Quad })))
		end
	end, { inputDelay })

	local v8 = useTokens()
	local v9 = usePresentationContext()

	local size = v3.size
	local variant = v3.variant
	local v10

	if v9 then
		v10 = v9.colorNamespace
	end

	local v11 = useButtonVariants(v8, size, variant, v10)

	local v12 = useButtonMotionStates(v11.content.style.Transparency, Constants.DISABLED_TRANSPARENCY)
	local v13, v14 = useMotion(v12.Default)
	local v15, v16 = useMotion(v12.Default)

	React.useEffect(function()
		if v3.isLoading then
			v16(v12.Loading)
		else
			v16(v12.Default)
		end
	end, { v3.isLoading })

	React.useEffect(function()
		if v3.isDisabled then
			v14(v12.Disabled)
		else
			v14(v12.Default)
		end
	end, { v3.isDisabled })

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v11.container.radius),
			offset = v8.Size.Size_200,
			borderWidth = v8.Stroke.Thicker
		}
	end, { v8, v11.container.radius })

	local v17 = v3.text and v3.text ~= ""

	local v18 = React.useCallback(function(p2)
		local v18 = v[v3.variant]

		if v17 and v18 and table.find(v18.controlState, p2) then
			return (v18.format:format(v3.text))
		end

		return v3.text
	end, { v3.text, v3.variant, v17 })

	local createElement = React.createElement
	local automaticSize

	if v3.width.Scale == 0 and v3.width.Offset == 0 then
		automaticSize = Enum.AutomaticSize.X
	end

	local v19 = {
		AutomaticSize = automaticSize,
		cornerRadius = UDim.new(0, v11.container.radius),
		backgroundStyle = 0,
		flexItem = 0,
		stroke = 0,
		Size = 0,
		selection = 0,
		cursor = 0,
		onActivated = 0,
		onStateChanged = 0,
		isDisabled = 0,
		stateLayer = 0,
		tag = 0,
		ref = 0
	}
	local backgroundStyle

	if v11.container.style then
		backgroundStyle = getTransparency(v11.container.style.Transparency, v13.transparency):map(function(transparency) -- inferred equivalent call
			return { Color3 = v11.container.style.Color3, Transparency = transparency }
		end)
	end

	v19.backgroundStyle = backgroundStyle
	local flexItem

	if v3.fillBehavior then
		flexItem = { FlexMode = 0 }
		local flexMode

		if v3.fillBehavior == FillBehavior.Fill then
			flexMode = Enum.UIFlexMode.Fill
		else
			flexMode = Enum.UIFlexMode.Shrink
		end

		flexItem.FlexMode = flexMode
	end

	v19.flexItem = flexItem
	local stroke

	if v11.container.stroke then
		stroke = { Color = v11.container.stroke.Color, Transparency = 0 }
		stroke.Transparency = getTransparency(v11.container.stroke.Transparency, v13.transparency) -- inferred equivalent call
	end

	v19.stroke = stroke

	v19.Size = UDim2.new(
		v3.fillBehavior == FillBehavior.Fill and 1 or v3.width.Scale,
		v3.fillBehavior == FillBehavior.Fill and 0 or v3.width.Offset,
		0,
		v11.container.height
	)

	v19.selection = {
		Selectable = not v3.isDisabled and v3.Selectable,
		NextSelectionUp = v3.NextSelectionUp,
		NextSelectionDown = v3.NextSelectionDown,
		NextSelectionLeft = v3.NextSelectionLeft,
		NextSelectionRight = v3.NextSelectionRight
	}

	v19.cursor = cursor
	v19.onActivated = v3.onActivated
	v19.onStateChanged = onStateChanged
	v19.isDisabled = v3.isDisabled or v3.isLoading or state
	v19.stateLayer = v11.container.stateLayer
	v19.tag = v11.container.tag
	v19.ref = ref
	local v20 = withCommonProps(v3, v19)
	local loading

	if v3.isLoading then
		local createElement2 = React.createElement
		local createElement3 = React.createElement
		local createElement4 = React.createElement
		local size2 = v11.icon.size
		local v21

		if Flags.FoundationUsePath2DSpinner then
			v21 = UDim2.fromOffset(v8.Padding.XSmall, v8.Padding.XSmall)
		else
			v21 = UDim2.fromOffset(0, 0)
		end

		loading = createElement2("Folder", {}, {
			PresenceWrapper = createElement3(AnimatePresence, {}, {
				Spinner = createElement4(Spinner, {
					Size = size2 - v21,
					style = v13.transparency:map(function(transparency)
						return { Color3 = v11.content.style.Color3, Transparency = transparency }
					end),
					testId = `{v3.testId}--spinner`
				})
			})
		})
	end

	local iconWrapper

	if v3.icon then
		local createElement2 = React.createElement
		local size2

		if v3.icon then
			size2 = v11.icon.size
		end

		local v21 = {
			Size = size2,
			LayoutOrder = v3.icon and (v7 and 3 or 1) or nil,
			testId = 0
		}
		local testId

		if v3.icon then
			testId = `{v3.testId}--icon-wrapper`
		end

		v21.testId = testId
		iconWrapper = createElement2(View, v21, {
			Icon = React.createElement(ButtonIcon, {
				icon = v3.icon,
				isLoading = v3.isLoading,
				variant = v3.variant,
				size = v3.size,
				disabledTransparencyBinding = v13.transparency,
				textTransparencyBinding = v15.textTransparency,
				testId = v3.testId
			})
		})
	end

	local text

	if v17 then
		text = React.createElement(Text, {
			Text = v4:map(v18),
			RichText = v[v3.variant] ~= nil,
			tag = v11.text.tag,
			textStyle = React.joinBindings({ v13.transparency, v15.textTransparency }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return {
					Color3 = v11.content.style.Color3,
					Transparency = item2 + item
				}
			end),
			LayoutOrder = 2,
			testId = `{v3.testId}--text`
		})
	end

	local gradient

	if state then
		gradient = React.createElement("UIGradient", { Transparency = v5:map(onProgressChange) })
	end

	return createElement(View, v20, {
		Loading = loading,
		IconWrapper = iconWrapper,
		Text = text,
		Gradient = gradient
	})
end

return React.memo(React.forwardRef(Button))
