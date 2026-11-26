local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local button = Foundation.Button
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant

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

	local v5 = React.useCallback(function(p2)
		if props.onErrorCallback then
			props.onErrorCallback(p2)
		else
			warn(p2)
		end
	end, { props.onErrorCallback })

	React.useEffect(function()
		local v6, v7 = validateSteps(props.steps)

		if not v7 then
			v5(v6)
		end
	end, { props.steps, props.onErrorCallback, v5 })

	local v6 = React.useMemo(function()
		return props.steps and props.steps[state]
	end, { state, props.steps })

	local v7 = React.useCallback(function(p2): boolean
		if not props.steps[p2] then
			return false
		end

		setState(p2)

		local index = table.find(state2, p2)

		if index then
			setState2(function(list)
				if #list == 0 then
					return list
				end

				return Cryo.List.removeRange(list, index + 1, #list)
			end)
		else
			setState2(function(p3)
				local clone = table.clone(p3)
				table.insert(clone, p2)
				return clone
			end)
		end

		return true
	end, { props.steps, state2 })

	local v8 = React.useCallback(function()
		if
			v6
			and (not v6.validateState or v6.validateState())
			and v7(v6.predefinedNextStepId)
			and v6.onStepContinue
		then
			v6.onStepContinue()
		end
	end, { v6, v7 })

	local v9 = React.useCallback(function()
		local v10 = state2[#state2 - 1]

		if v10 and v7(v10) and v6 and v6.onStepCancel then
			v6.onStepCancel()
		end
	end, { state2, v6, v7 })

	if v6 == nil then
		return nil
	end

	local createElement = React.createElement

	local v12 = {
		ContentContainer = React.createElement(
			view,
			{ tag = "size-full-0 auto-y", LayoutOrder = 0 },
			v6.content
		),
		ButtonRow = 0,
		FooterContainer = 0
	}
	local createElement2 = React.createElement
	local v14 = {
		tag = `size-full-0 auto-y padding-y-small gap-small row {v6.stepStyle and v6.stepStyle.buttonXAlignment}`,
		LayoutOrder = 1
	}
	local v16

	if v6.labels and v6.labels.backButton then
		local createElement3 = React.createElement
		local v18 = {
			onActivated = v9,
			text = v6.labels.backButton,
			variant = v6.stepStyle and v6.stepStyle.backButton and v6.stepStyle.backButton.variant or buttonVariant.Text,
			fillBehavior = 0,
			LayoutOrder = 0
		}
		local v19 = if v6.stepStyle and v6.stepStyle.backButton then v6.stepStyle.backButton.fillBehavior or nil else nil
		v18.fillBehavior = v19
		v16 = createElement3(button, v18)
	end

	local v17

	if v6.labels and v6.labels.continueButton then
		local createElement3 = React.createElement
		local v19 = {
			onActivated = v8,
			text = v6.labels.continueButton,
			variant = v6.stepStyle and v6.stepStyle.continueButton and v6.stepStyle.continueButton.variant or buttonVariant.Standard,
			fillBehavior = 0,
			LayoutOrder = 1
		}
		local v20 = if v6.stepStyle and v6.stepStyle.continueButton then v6.stepStyle.continueButton.fillBehavior or nil else nil
		v19.fillBehavior = v20
		v17 = createElement3(button, v19)
	end

	v12.ButtonRow = createElement2(view, v14, { BackButton = v16, ContinueButton = v17 })

	local v18 = if v6.footer then React.createElement(
		view,
		{ tag = "size-full-0 auto-y col", LayoutOrder = 2 },
		{
			Divider = React.createElement(view, {
				tag = "size-full-50 bg-shift-100 padding-bottom-medium",
				LayoutOrder = 0
			}),
			Footer = React.createElement(view, { tag = "auto-xy padding-top-medium" }, v6.footer)
		}
	) else nil
	v12.FooterContainer = v18
	return (createElement(view, { tag = "auto-xy col flex-between" }, v12))
end

return React.memo(Stepper)
