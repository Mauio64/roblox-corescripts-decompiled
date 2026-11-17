local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text

require(AmpV2Wizard.Types)
local FullPageChrome = require(AmpV2Wizard.FullPageChrome)
local CodeInput = require(AmpV2Wizard.CodeInput)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)

local function PinEntryNode(props)
	local props2 = props.props
	local report = props.report
	local transitions = props.transitions
	local v = OdpAnalytics.useOdpAnalytics(props.ctx)

	local state, setState = React.useState("")
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(false)
	React.useEffect(function()
		if not ref3.current then
			ref3.current = true
			v.pinEntryShown()
		end
	end, { v })

	local ref4 = React.useRef(0)

	React.useEffect(function()
		setState("")
		setState2(false)
		ref.current = false
		ref4.current = 0
	end, { props2 })

	local ref5 = React.useRef(nil)
	React.useEffect(function()
		if ref5.current == props2 then
			return
		end

		ref5.current = props2

		if props2.error ~= nil and props2.error ~= "" then
			v.pinEntryIncorrect()
		end
	end, { props2, v })

	local onChanged = React.useCallback(function(list: string)
		if #list ~= ref4.current then
			ref4.current = #list
			v.pinEntryDigitsChanged(#list)
		end

		setState(list)
	end, { v })

	local onComplete = React.useCallback(function(pin: string)
		report("Success", { pin = pin })
	end, { report })

	local onActivated = React.useCallback(function()
		local current = ref2.current

		if current ~= nil then
			current.releaseFocus()
		end

		v.pinEntryForgotPin()
		report("ForgotPin")
	end, { report, v })

	local onBack = React.useCallback(function()
		local current = ref2.current

		if current ~= nil then
			current.releaseFocus()
		end

		report("Back")
	end, { report })

	local onClose = React.useCallback(function()
		local current = ref2.current

		if current ~= nil then
			current.releaseFocus()
		end

		report("Cancel")
	end, { report })

	local onActivated2 = React.useCallback(function()
		local current = not ref.current
		ref.current = current
		v.pinEntryRevealToggled(current)
		setState2(current)
	end, { v })

	local createElement = React.createElement

	local v2 = {
		Copy = React.createElement(
			View,
			{ tag = "col gap-none size-full-0 auto-y padding-x-xlarge", LayoutOrder = 1 },
			{
				Title = React.createElement(Text, {
					Text = props2.title,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
					LayoutOrder = 1
				}),
				Description = React.createElement(Text, {
					Text = props2.description,
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
					LayoutOrder = 2
				}),
				ForgotPin = React.createElement(Text, {
					Text = `<u>{props2.forgotPinLabel}</u>`,
					RichText = true,
					onActivated = onActivated,
					tag = "auto-xy text-body-large text-align-x-left content-default",
					LayoutOrder = 3
				})
			}
		),
		Field = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v3 = {
		InputLabel = React.createElement(Text, {
			Text = props2.inputLabel,
			tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		RevealToggle = 0
	}

	local createElement4 = React.createElement
	local text

	if state2 then
		text = props2.hidePinLabel
	else
		text = props2.showPinLabel
	end

	v3.RevealToggle = createElement4(Text, {
		Text = text,
		onActivated = onActivated2,
		tag = "auto-xy text-title-medium content-default",
		LayoutOrder = 2
	})
	local children = {
		Label = createElement3(
			View,
			{
				tag = "row flex-between align-y-center gap-xsmall size-full-0 auto-y padding-bottom-small",
				LayoutOrder = 1
			},
			v3
		),
		Input = React.createElement(CodeInput, {
			value = state,
			onChanged = onChanged,
			length = 6,
			onComplete = onComplete,
			isMasked = not state2,
			controlRef = ref2,
			LayoutOrder = 2
		}),
		Error = 0
	}
	local err

	if not (props2.error == nil or props2.error == "") then
		err = React.createElement(Text, {
			Text = props2.error,
			tag = "size-full-0 auto-y padding-top-small text-body-small text-wrap text-align-x-left content-system-alert",
			LayoutOrder = 3
		})
	end

	children.Error = err
	v2.Field = createElement2(
		View,
		{ tag = "col gap-none size-full-0 auto-y padding-x-xlarge", LayoutOrder = 2 },
		children
	)
	local element = createElement(View, {
		tag = "col gap-xlarge size-full-0 auto-y padding-y-xlarge"
	}, v2)

	local createElement5 = React.createElement
	local v4 = { title = props2.headerTitle, onBack = 0, onClose = 0 }

	if transitions == nil or transitions.Back == nil then
		onBack = nil
	end

	v4.onBack = onBack

	if transitions == nil or transitions.Back ~= nil or transitions.Cancel == nil then
		onClose = nil
	end

	v4.onClose = onClose
	return createElement5(FullPageChrome, v4, { Content = element })
end

return PinEntryNode
