local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant

local function validateSteps(steps)
	if not steps or type(steps) ~= "table" then
		return "Steps must not be nil and be a table", false
	end

	for k, item in pairs(steps) do
		if k ~= item.stepId then
			return `Step id mismatch: key {k} does not match step.stepId {item.stepId}`, false
		end
	end

	return "", true
end

local function Stepper(props)
	local state, setState = React.useState(props.currentStep)
	local state2, setState2 = React.useState({ props.currentStep })

	local v = React.useCallback(function(p)
		if props.onErrorCallback then
			props.onErrorCallback(p)
		else
			warn(p)
		end
	end, { props.onErrorCallback })

	React.useEffect(function()
		local v2, v3 = validateSteps(props.steps)

		if not v3 then
			v(v2)
		end
	end, { props.steps, props.onErrorCallback, v })

	local v2 = React.useMemo(function()
		return props.steps and props.steps[state]
	end, { state, props.steps })

	local v3 = React.useCallback(function(p): boolean
		if not props.steps[p] then
			return false
		end

		setState(p)

		local index = table.find(state2, p)

		if index then
			setState2(function(list)
				if #list == 0 then
					return list
				end

				return Cryo.List.removeRange(list, index + 1, #list)
			end)
		else
			setState2(function(p2)
				local clone = table.clone(p2)
				table.insert(clone, p)
				return clone
			end)
		end

		return true
	end, { props.steps, state2 })

	local onActivated = React.useCallback(function()
		if
			v2
			and (not v2.validateState or v2.validateState())
			and v3(v2.predefinedNextStepId)
			and v2.onStepContinue
		then
			v2.onStepContinue()
		end
	end, { v2, v3 })

	local onActivated2 = React.useCallback(function()
		local v4 = state2[#state2 - 1]

		if v4 and v3(v4) and v2 and v2.onStepCancel then
			v2.onStepCancel()
		end
	end, { state2, v2, v3 })

	if v2 == nil then
		return nil
	end

	local createElement = React.createElement

	local v4 = {
		ContentContainer = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 0 }, v2.content),
		ButtonRow = 0,
		FooterContainer = 0
	}
	local createElement2 = React.createElement
	local v5 = {
		tag = `size-full-0 auto-y padding-y-small gap-small row {v2.stepStyle and v2.stepStyle.buttonXAlignment}`,
		LayoutOrder = 1
	}
	local backButton

	if v2.labels and v2.labels.backButton then
		local createElement3 = React.createElement
		local v6 = {
			onActivated = onActivated2,
			text = v2.labels.backButton,
			variant = v2.stepStyle and v2.stepStyle.backButton and v2.stepStyle.backButton.variant or ButtonVariant.Text,
			fillBehavior = 0,
			LayoutOrder = 0
		}
		local fillBehavior

		if v2.stepStyle and v2.stepStyle.backButton then
			fillBehavior = v2.stepStyle.backButton.fillBehavior or nil
		end

		v6.fillBehavior = fillBehavior
		backButton = createElement3(Button, v6)
	end

	local continueButton

	if v2.labels and v2.labels.continueButton then
		local createElement3 = React.createElement
		local v6 = {
			onActivated = onActivated,
			text = v2.labels.continueButton,
			variant = v2.stepStyle and v2.stepStyle.continueButton and v2.stepStyle.continueButton.variant or ButtonVariant.Standard,
			fillBehavior = 0,
			LayoutOrder = 1
		}
		local fillBehavior

		if v2.stepStyle and v2.stepStyle.continueButton then
			fillBehavior = v2.stepStyle.continueButton.fillBehavior or nil
		end

		v6.fillBehavior = fillBehavior
		continueButton = createElement3(Button, v6)
	end

	v4.ButtonRow = createElement2(View, v5, {
		BackButton = backButton,
		ContinueButton = continueButton
	})
	local footerContainer

	if v2.footer then
		footerContainer = React.createElement(View, {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 2
		}, {
			Divider = React.createElement(View, {
				tag = "size-full-50 bg-shift-100 padding-bottom-medium",
				LayoutOrder = 0
			}),
			Footer = React.createElement(View, { tag = "auto-xy padding-top-medium" }, v2.footer)
		})
	end

	v4.FooterContainer = footerContainer
	return (createElement(View, { tag = "auto-xy col flex-between" }, v4))
end

return React.memo(Stepper)
