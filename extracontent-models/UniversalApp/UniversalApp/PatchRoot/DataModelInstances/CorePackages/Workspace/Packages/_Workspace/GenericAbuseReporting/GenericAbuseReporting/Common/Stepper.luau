local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant

local function validateSteps(t1: {[any]: any}) -- line: 58
	if not t1 or type(t1) ~= "table" then
		return "Steps must not be nil and be a table", false
	end

	for k, v in pairs(t1) do
		if k ~= v.stepId then
			return `Step id mismatch: key { k } does not match step.stepId { v.stepId }`, false
		end
	end

	return "", true
end
local function Stepper(t2: {[any]: any}) -- line: 70
	-- upvalues: React (copy), validateSteps (copy), Cryo (copy), View (copy), Button (copy), ButtonVariant (copy)
	local v14, v15 = React.useState(t2.currentStep)
	local v16, v17 = React.useState({ t2.currentStep })
	local v18 = React.useCallback(function(p1) -- line: 74
		-- upvalues: t2 (copy)
		if t2.onErrorCallback then
			t2.onErrorCallback(p1)

			return
		end

		warn(p1)
	end, { t2.onErrorCallback })

	React.useEffect(function() -- line: 82
		-- upvalues: validateSteps (copy), t2 (copy), v18 (copy)
		local v24, v25 = validateSteps(t2.steps)

		if not v25 then
			v18(v24)
		end
	end, {
		t2.steps,
		t2.onErrorCallback,
		v18
	})

	local v19 = React.useMemo(function() -- line: 89
		-- upvalues: t2 (copy), v14 (copy)
		return t2.steps and t2.steps[v14]
	end, {
		v14,
		t2.steps
	})
	local v20 = React.useCallback(function(p2) -- line: 95
		-- upvalues: t2 (copy), v15 (copy), v16 (copy), v17 (copy), Cryo (copy)
		if not t2.steps[p2] then
			return false
		end

		v15(p2)

		local v27 = table.find(v16, p2)

		if v27 then
			v17(function(p3) -- line: 105
				-- upvalues: Cryo (copy), v27 (copy)
				if #p3 == 0 then
					return p3
				end

				return Cryo.List.removeRange(p3, v27 + 1, #p3)
			end)
		else
			v17(function(p4) -- line: 112
				-- upvalues: p2 (copy)
				local v31 = table.clone(p4)

				table.insert(v31, p2)

				return v31
			end)
		end

		return true
	end, {
		t2.steps,
		v16
	})
	local v21 = React.useCallback(function() -- line: 122
		-- upvalues: v19 (copy), v20 (copy)
		if not v19 or v19.validateState and not v19.validateState() then
			return
		end

		if v20(v19.predefinedNextStepId) and v19.onStepContinue then
			v19.onStepContinue()
		end
	end, {
		v19,
		v20
	})
	local v22 = React.useCallback(function() -- line: 136
		-- upvalues: v16 (copy), v20 (copy), v19 (copy)
		local v28 = v16[#v16 - 1]

		if v28 and (v20(v28) and v19 and v19.onStepCancel) then
			v19.onStepCancel()
		end
	end, {
		v16,
		v19,
		v20
	})

	if v19 == nil then
		return nil
	end

	return (React.createElement(View, {
		tag = "auto-xy col flex-between"
	}, {
		ContentContainer = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 0
		}, v19.content),
		ButtonRow = React.createElement(View, {
			LayoutOrder = 1,
			tag = `size-full-0 auto-y padding-y-small gap-small row { v19.stepStyle and v19.stepStyle.buttonXAlignment }`
		}, {
			BackButton = if not v19.labels or not v19.labels.backButton then nil else React.createElement(Button, {
				LayoutOrder = 0,
				onActivated = v22,
				text = v19.labels.backButton,
				variant = v19.stepStyle and (not not v19.stepStyle.backButton and v19.stepStyle.backButton.variant) or ButtonVariant.Text,
				fillBehavior = v19.stepStyle and (not not v19.stepStyle.backButton and v19.stepStyle.backButton.fillBehavior) or nil
			}),
			ContinueButton = if not v19.labels or not v19.labels.continueButton then nil else React.createElement(Button, {
				LayoutOrder = 1,
				onActivated = v21,
				text = v19.labels.continueButton,
				variant = v19.stepStyle and (not not v19.stepStyle.continueButton and v19.stepStyle.continueButton.variant) or ButtonVariant.Standard,
				fillBehavior = v19.stepStyle and (not not v19.stepStyle.continueButton and v19.stepStyle.continueButton.fillBehavior) or nil
			})
		}),
		FooterContainer = if not v19.footer then nil else React.createElement(View, {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 2
		}, {
			Divider = React.createElement(View, {
				tag = "size-full-50 bg-shift-100 padding-bottom-medium",
				LayoutOrder = 0
			}),
			Footer = React.createElement(View, {
				tag = "auto-xy padding-top-medium"
			}, v19.footer)
		})
	}))
end

return React.memo(Stepper)
