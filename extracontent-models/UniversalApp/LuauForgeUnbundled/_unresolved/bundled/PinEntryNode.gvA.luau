local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local view = module2.View
local text = module2.Text

require("@luauforge/bundled/gvc")
local module3 = require("@luauforge/bundled/gvr")
local module4 = require("@luauforge/bundled/gvB")
local module5 = require("@luauforge/bundled/gvl")

local function PinEntryNode(props)
	local props2 = props.props
	local report = props.report
	local transitions = props.transitions
	local v5 = module5.useOdpAnalytics(props.ctx)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState(false)

	local ref = module.useRef(false)
	local ref2 = module.useRef(nil)

	local ref3 = module.useRef(false)
	module.useEffect(function()
		if not ref3.current then
			ref3.current = true
			v5.pinEntryShown()
		end
	end, { v5 })

	local ref4 = module.useRef(0)

	module.useEffect(function()
		setState("")
		setState2(false)
		ref.current = false
		ref4.current = 0
	end, { props2 })

	local ref5 = module.useRef(nil)
	module.useEffect(function()
		if ref5.current == props2 then
			return
		end

		ref5.current = props2

		if props2.error ~= nil and props2.error ~= "" then
			v5.pinEntryIncorrect()
		end
	end, { props2, v5 })

	local v6 = module.useCallback(function(list)
		if #list ~= ref4.current then
			ref4.current = #list
			v5.pinEntryDigitsChanged(#list)
		end

		setState(list)
	end, { v5 })

	local v7 = module.useCallback(function(p2)
		report("Success", { pin = p2 })
	end, { report })

	local v8 = module.useCallback(function()
		local current = ref2.current

		if current ~= nil then
			current.releaseFocus()
		end

		v5.pinEntryForgotPin()
		report("ForgotPin")
	end, { report, v5 })

	local v9 = module.useCallback(function()
		local current = ref2.current

		if current ~= nil then
			current.releaseFocus()
		end

		report("Back")
	end, { report })

	local v10 = module.useCallback(function()
		local current = ref2.current

		if current ~= nil then
			current.releaseFocus()
		end

		report("Cancel")
	end, { report })

	local v11 = module.useCallback(function()
		local v12 = not ref.current
		ref.current = v12
		v5.pinEntryRevealToggled(v12)
		setState2(v12)
	end, { v5 })

	local createElement = module.createElement

	local v14 = {
		Copy = module.createElement(
			view,
			{
				tag = "col gap-none size-full-0 auto-y padding-x-xlarge",
				LayoutOrder = 1
			},
			{
				Title = module.createElement(text, {
					Text = props2.title,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
					LayoutOrder = 1
				}),
				Description = module.createElement(text, {
					Text = props2.description,
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
					LayoutOrder = 2
				}),
				ForgotPin = module.createElement(text, {
					Text = `<u>{props2.forgotPinLabel}</u>`,
					RichText = true,
					onActivated = v8,
					tag = "auto-xy text-body-large text-align-x-left content-default",
					LayoutOrder = 3
				})
			}
		),
		Field = 0
	}

	local createElement2 = module.createElement

	local createElement3 = module.createElement

	local v19 = {
		InputLabel = module.createElement(text, {
			Text = props2.inputLabel,
			tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		RevealToggle = 0
	}

	local createElement4 = module.createElement
	local v22 = if state2 then props2.hidePinLabel else props2.showPinLabel
	v19.RevealToggle = createElement4(text, {
		Text = v22,
		onActivated = v11,
		tag = "auto-xy text-title-medium content-default",
		LayoutOrder = 2
	})
	local children = {
		Label = createElement3(
			view,
			{
				tag = "row flex-between align-y-center gap-xsmall size-full-0 auto-y padding-bottom-small",
				LayoutOrder = 1
			},
			v19
		),
		Input = module.createElement(module4, {
			value = state,
			onChanged = v6,
			length = 6,
			onComplete = v7,
			isMasked = not state2,
			controlRef = ref2,
			LayoutOrder = 2
		}),
		Error = 0
	}

	local v23 = if props2.error ~= nil and props2.error ~= "" then module.createElement(text, {
		Text = props2.error,
		tag = "size-full-0 auto-y padding-top-small text-body-small text-wrap text-align-x-left content-system-alert",
		LayoutOrder = 3
	}) else nil
	children.Error = v23
	v14.Field = createElement2(
		view,
		{ tag = "col gap-none size-full-0 auto-y padding-x-xlarge", LayoutOrder = 2 },
		children
	)
	local element = createElement(view, {
		tag = "col gap-xlarge size-full-0 auto-y padding-y-xlarge"
	}, v14)

	local createElement5 = module.createElement
	local v25 = { title = props2.headerTitle, onBack = 0, onClose = 0 }

	if transitions == nil or transitions.Back == nil then
		v9 = nil
	end

	v25.onBack = v9

	if transitions == nil or transitions.Back ~= nil or transitions.Cancel == nil then
		v10 = nil
	end

	v25.onClose = v10
	return createElement5(module3, v25, { Content = element })
end

return PinEntryNode
