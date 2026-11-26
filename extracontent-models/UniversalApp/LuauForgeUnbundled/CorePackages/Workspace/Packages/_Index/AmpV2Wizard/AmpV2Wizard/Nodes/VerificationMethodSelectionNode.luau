local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local inputLabel = Foundation.InputLabel
local scrollView = Foundation.ScrollView
local optionSelectorGroup = Foundation.OptionSelectorGroup
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local OdpAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpAnalytics")
local FullPageChrome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FullPageChrome")

local v5 = {
	FAE = "square-person",
	IDV = "rectangle-person-with-three-horizontal-lines",
	CCV = "credit-card"
}

local function VerificationMethodSelectionNode(props)
	local props2 = props.props
	local report = props.report
	local methods = props2.methods or {}
	local v6 = OdpAnalytics.useOdpAnalytics(props.ctx)

	local id = if methods[1] ~= nil then methods[1].id else nil
	local state, setState = React.useState(id)

	React.useEffect(function()
		v6.verificationMethodSelectorShown(id)
	end, {})

	local v7 = React.useCallback(function()
		if state ~= nil then
			v6.verificationMethodContinue(state)
			report(state)
		end
	end, { state, report, v6 })

	local v8 = React.useCallback(function()
		v6.verificationMethodBack()
		report("Back")
	end, { report, v6 })

	local v9 = React.useCallback(function(p2)
		if p2 ~= nil then
			v6.verificationMethodSelected(p2)
			setState(p2)
		end
	end, { setState, v6 })

	local children = {}

	for k, method in methods do
		children[method.id] = React.createElement(optionSelectorGroup.Item, {
			value = method.id,
			label = method.label,
			description = method.description,
			icon = v5[method.id],
			LayoutOrder = k
		})
	end

	local element = React.createElement(view, {
		tag = "col gap-xlarge size-full-0 auto-y"
	}, {
		TitleAndBody = React.createElement(
			view,
			{ tag = "col gap-xsmall size-full-0 auto-y", LayoutOrder = 1 },
			{
				Title = React.createElement(text, {
					Text = props2.title,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
					LayoutOrder = 1
				}),
				Description = React.createElement(text, {
					Text = props2.description,
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-default",
					LayoutOrder = 2
				})
			}
		),
		Options = React.createElement(
			view,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xsmall",
				LayoutOrder = 2
			},
			{
				OptionsLabel = React.createElement(inputLabel, {
					Text = props2.optionsLabel,
					LayoutOrder = 1
				}),
				OptionList = React.createElement(
					optionSelectorGroup.Root,
					{ value = state, onValueChanged = v9, LayoutOrder = 2 },
					{
						Items = React.createElement(
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

	local createElement = React.createElement
	local v13 = {
		Body = React.createElement(scrollView, {
			LayoutOrder = 1,
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.fromScale(1, 0),
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 1)
			}
		}, {
			Content = React.createElement(
				view,
				{
					tag = "col gap-none size-full-0 auto-y padding-x-xlarge padding-y-xlarge"
				},
				{ Body = element }
			)
		}),
		Footer = 0
	}

	local v14 = if state ~= nil then React.createElement(
		view,
		{
			tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
			LayoutOrder = 2
		},
		{
			Continue = React.createElement(button, {
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

	local createElement2 = React.createElement
	local v16 = { title = props2.headerTitle, onBack = 0 }

	if not v10 then
		v8 = nil
	end

	v16.onBack = v8
	return createElement2(FullPageChrome, v16, { Content = element2 })
end

return VerificationMethodSelectionNode
