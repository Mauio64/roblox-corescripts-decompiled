local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local PeopleService = require(parent.PeopleService)

local View = Foundation.View
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local useSignalState = SignalsReact.useSignalState

local service = PeopleService.getService("Flags")
local getFFlagAddPeoplePageCardLayout = service.GetFFlagAddPeoplePageCardLayout
local getFFlagNewPeoplePageIcons = service.GetFFlagNewPeoplePageIcons

local function useIconName(data, p: string, flag: boolean)
	return React.useMemo(function()
		if data.animatedIcon then
			return p
		end

		if not data.icon then
			return ""
		end

		if data.icon.off and data.buttonState and flag then
			return data.icon.off
		end

		return data.icon.on
	end, { p, flag, data.icon, data.animatedIcon, data.buttonState })
end

local function useTransparency(flag: boolean, p) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		if flag then
			return p.Color.Common.Shadow.Transparency
		end

		return nil
	end, { flag })
end

local function useButtonSize(flag: boolean, p) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		if not flag then
			return UDim2.fromOffset(p.Size.Size_1000, p.Size.Size_1000)
		end

		if getFFlagNewPeoplePageIcons() then
			return UDim2.fromOffset(p.Size.Size_1800 * 2, p.Size.Size_1000)
		end

		return UDim2.new(0, p.Size.Size_1800 * 2, 1, 0)
	end, { flag })
end

local function MemoizedIconElement(data)
	local v = useTokens()

	local v2 = useSignalState(data.animatedIcon or Signals.createSignal(""))
	local v3 = useSignalState(data.buttonState or Signals.createSignal(false))
	local isDisabled = useSignalState(data.isGrayedOut or Signals.createSignal(false))

	local v4 = useIconName(data, v2, v3)
	local transparency = useTransparency(isDisabled, v) -- inferred equivalent call

	if data.isBuilderIcon then
		transparency = nil
	end

	return React.useMemo(function()
		if not v4 or v4 == "" then
			return nil
		end

		if data.isBuilderIcon then
			return (React.createElement(IconButton, {
				icon = v4,
				size = IconSize.Medium,
				LayoutOrder = data.LayoutOrder,
				Selectable = false,
				variant = ButtonVariant.Utility,
				isDisabled = isDisabled,
				onActivated = data.onActivated,
				ref = data.onMount
			}))
		end

		return (React.createElement(Icon, {
			name = v4,
			size = IconSize.Medium,
			LayoutOrder = data.LayoutOrder,
			style = { Transparency = transparency }
		}))
	end, {
		data.isBuilderIcon,
		v4,
		data.LayoutOrder,
		isDisabled,
		data.onActivated,
		data.onMount,
		transparency
	})
end

local function createTextElement(text: string, flag: boolean?, variant, onActivated, layoutOrder: number)
	if not text then
		return nil
	end

	local createElement = React.createElement
	local v = {
		text = text,
		fillBehavior = FillBehavior.Fill,
		Selectable = false,
		variant = 0,
		onActivated = 0,
		LayoutOrder = 0
	}

	if flag then
		variant = ButtonVariant.Text
	end

	v.variant = variant
	v.onActivated = onActivated
	v.LayoutOrder = layoutOrder
	return createElement(Button, v)
end

local function PersonButton(props)
	local v = useTokens()

	local isDisabled = useSignalState(props.isDisabled or Signals.createSignal(false))
	local text = useSignalState(type(props.text) == "function" and props.text or Signals.createSignal(props.text))
	local variant = useSignalState(type(props.buttonVariant) == "function" and props.buttonVariant or Signals.createSignal(props.buttonVariant))

	local size = useButtonSize(props.text ~= nil, v) -- inferred equivalent call

	local selectionImageObject = useCursor({
		radius = UDim.new(0, v.Radius.Medium),
		offset = v.Size.Size_150,
		borderWidth = v.Stroke.Thicker
	})

	local onActivated = props.onActivated
	local text2

	if text then
		local createElement = React.createElement
		local v2 = {
			text = text,
			fillBehavior = FillBehavior.Fill,
			Selectable = false,
			variant = 0,
			onActivated = 0,
			LayoutOrder = 2
		}

		if isDisabled then
			variant = ButtonVariant.Text
		end

		v2.variant = variant
		v2.onActivated = onActivated
		text2 = createElement(Button, v2)
	end

	local createElement = React.createElement
	local tag

	if getFFlagAddPeoplePageCardLayout() then
		tag = {
			["radius-medium row align-y-center align-x-center"] = true,
			["bg-action-standard"] = not (props.text or props.isBackgroundTransparent)
		}
	else
		tag = {
			["radius-medium row align-y-center align-x-center"] = props.text ~= nil,
			["radius-medium row align-y-center align-x-center bg-action-standard"] = props.text == nil
		}
	end

	return createElement(View, {
		tag = tag,
		Size = size,
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		isDisabled = isDisabled,
		selection = { SelectionImageObject = selectionImageObject },
		ref = props.onMount
	}, {
		Icon = React.createElement(MemoizedIconElement, {
			icon = props.icon,
			animatedIcon = props.animatedIcon,
			buttonState = props.buttonState,
			LayoutOrder = props.LayoutOrder,
			isGrayedOut = props.isGrayedOut,
			isBuilderIcon = props.isBuilderIcon,
			onActivated = props.onActivated,
			onMount = props.onMount
		}),
		Text = text2
	})
end

return PersonButton
