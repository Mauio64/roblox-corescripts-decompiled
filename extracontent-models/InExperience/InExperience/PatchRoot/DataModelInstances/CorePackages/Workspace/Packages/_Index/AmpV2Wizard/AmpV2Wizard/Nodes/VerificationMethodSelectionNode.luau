local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local InputLabel = Foundation.InputLabel
local ScrollView = Foundation.ScrollView
local OptionSelectorGroup = Foundation.OptionSelectorGroup
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

require(AmpV2Wizard.Types)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)
local FullPageChrome = require(AmpV2Wizard.FullPageChrome)

local v = {
	FAE = "square-person",
	IDV = "rectangle-person-with-three-horizontal-lines",
	CCV = "credit-card"
}

local function VerificationMethodSelectionNode(props)
	local props2 = props.props
	local report = props.report
	local methods = props2.methods or {}
	local v2 = OdpAnalytics.useOdpAnalytics(props.ctx)
	local id

	if methods[1] == nil then
		id = nil
	else
		id = methods[1].id
	end

	local state, setState = React.useState(id)

	React.useEffect(function()
		v2.verificationMethodSelectorShown(id)
	end, {})

	local onActivated = React.useCallback(function()
		if state ~= nil then
			v2.verificationMethodContinue(state)
			report(state)
		end
	end, { state, report, v2 })

	local onBack = React.useCallback(function()
		v2.verificationMethodBack()
		report("Back")
	end, { report, v2 })

	local onValueChanged = React.useCallback(function(p: string?)
		if p ~= nil then
			v2.verificationMethodSelected(p)
			setState(p)
		end
	end, { setState, v2 })

	local children = {}

	for k, method in methods do
		children[method.id] = React.createElement(OptionSelectorGroup.Item, {
			value = method.id,
			label = method.label,
			description = method.description,
			icon = v[method.id],
			LayoutOrder = k
		})
	end

	local element = React.createElement(View, { tag = "col gap-xlarge size-full-0 auto-y" }, {
		TitleAndBody = React.createElement(View, {
			tag = "col gap-xsmall size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Text, {
				Text = props2.title,
				tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
				LayoutOrder = 1
			}),
			Description = React.createElement(Text, {
				Text = props2.description,
				tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-default",
				LayoutOrder = 2
			})
		}),
		Options = React.createElement(
			View,
			{ tag = "col gap-small size-full-0 auto-y padding-x-xsmall", LayoutOrder = 2 },
			{
				OptionsLabel = React.createElement(InputLabel, {
					Text = props2.optionsLabel,
					LayoutOrder = 1
				}),
				OptionList = React.createElement(
					OptionSelectorGroup.Root,
					{ value = state, onValueChanged = onValueChanged, LayoutOrder = 2 },
					{
						Items = React.createElement(View, {
							tag = "col gap-medium size-full-0 auto-y"
						}, children)
					}
				)
			}
		)
	})
	local v3

	if props.transitions == nil then
		v3 = false
	else
		v3 = props.transitions.Back ~= nil
	end

	local createElement = React.createElement
	local v4 = {
		Body = React.createElement(ScrollView, {
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
				View,
				{ tag = "col gap-none size-full-0 auto-y padding-x-xlarge padding-y-xlarge" },
				{ Body = element }
			)
		}),
		Footer = 0
	}
	local footer

	if state ~= nil then
		footer = React.createElement(
			View,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{
				Continue = React.createElement(Button, {
					text = props2.continueLabel,
					onActivated = onActivated,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			}
		)
	end

	v4.Footer = footer
	local element2 = createElement(View, { tag = "col size-full" }, v4)

	local createElement2 = React.createElement
	local v5 = { title = props2.headerTitle, onBack = 0 }

	if not v3 then
		onBack = nil
	end

	v5.onBack = onBack
	return createElement2(FullPageChrome, v5, { Content = element2 })
end

return VerificationMethodSelectionNode
