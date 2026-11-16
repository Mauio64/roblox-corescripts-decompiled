local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local view = module2.View
local text = module2.Text
local button = module2.Button
local inputLabel = module2.InputLabel
local scrollView = module2.ScrollView
local optionSelectorGroup = module2.OptionSelectorGroup
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize

require("@luauforge/bundled/gvc")
local module3 = require("@luauforge/bundled/gvl")
local module4 = require("@luauforge/bundled/gvr")

local v5 = {
	FAE = "square-person",
	IDV = "rectangle-person-with-three-horizontal-lines",
	CCV = "credit-card"
}

local function VerificationMethodSelectionNode(props)
	local props2 = props.props
	local report = props.report
	local methods = props2.methods or {}
	local v6 = module3.useOdpAnalytics(props.ctx)

	local id = if methods[1] ~= nil then methods[1].id else nil
	local state, setState = module.useState(id)

	module.useEffect(function()
		v6.verificationMethodSelectorShown(id)
	end, {})

	local v7 = module.useCallback(function()
		if state ~= nil then
			v6.verificationMethodContinue(state)
			report(state)
		end
	end, { state, report, v6 })

	local v8 = module.useCallback(function()
		v6.verificationMethodBack()
		report("Back")
	end, { report, v6 })

	local v9 = module.useCallback(function(p2)
		if p2 ~= nil then
			v6.verificationMethodSelected(p2)
			setState(p2)
		end
	end, { setState, v6 })

	local children = {}

	for k, method in methods do
		children[method.id] = module.createElement(optionSelectorGroup.Item, {
			value = method.id,
			label = method.label,
			description = method.description,
			icon = v5[method.id],
			LayoutOrder = k
		})
	end

	local element = module.createElement(view, {
		tag = "col gap-xlarge size-full-0 auto-y"
	}, {
		TitleAndBody = module.createElement(
			view,
			{ tag = "col gap-xsmall size-full-0 auto-y", LayoutOrder = 1 },
			{
				Title = module.createElement(text, {
					Text = props2.title,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
					LayoutOrder = 1
				}),
				Description = module.createElement(text, {
					Text = props2.description,
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-default",
					LayoutOrder = 2
				})
			}
		),
		Options = module.createElement(
			view,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xsmall",
				LayoutOrder = 2
			},
			{
				OptionsLabel = module.createElement(inputLabel, {
					Text = props2.optionsLabel,
					LayoutOrder = 1
				}),
				OptionList = module.createElement(
					optionSelectorGroup.Root,
					{ value = state, onValueChanged = v9, LayoutOrder = 2 },
					{
						Items = module.createElement(
							view,
							{ tag = "col gap-medium size-full-0 auto-y" },
							children
						)
					}
				)
			}
		)
	})

	local v10 = not (props.transitions == nil) and props.transitions.Back ~= nil

	local createElement = module.createElement
	local v13 = {
		Body = module.createElement(scrollView, {
			LayoutOrder = 1,
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.fromScale(1, 0),
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 1)
			}
		}, {
			Content = module.createElement(
				view,
				{
					tag = "col gap-none size-full-0 auto-y padding-x-xlarge padding-y-xlarge"
				},
				{ Body = element }
			)
		}),
		Footer = 0
	}

	local v14 = if state ~= nil then module.createElement(
		view,
		{
			tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
			LayoutOrder = 2
		},
		{
			Continue = module.createElement(button, {
				text = props2.continueLabel,
				onActivated = v7,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				width = UDim.new(1, 0),
				LayoutOrder = 1
			})
		}
	) else nil
	v13.Footer = v14
	local element2 = createElement(view, { tag = "col size-full" }, v13)

	local createElement2 = module.createElement
	local v16 = { title = props2.headerTitle, onBack = 0 }

	if not v10 then
		v8 = nil
	end

	v16.onBack = v8
	return createElement2(module4, v16, { Content = element2 })
end

return VerificationMethodSelectionNode
