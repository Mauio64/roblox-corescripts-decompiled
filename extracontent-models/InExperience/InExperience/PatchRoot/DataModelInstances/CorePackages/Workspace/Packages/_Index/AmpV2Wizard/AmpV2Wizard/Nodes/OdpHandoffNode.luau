local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local ScrollView = Foundation.ScrollView
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

require(AmpV2Wizard.Types)
local FullPageChrome = require(AmpV2Wizard.FullPageChrome)
local ODPTiltedCardsArt = require(AmpV2Wizard.ODPTiltedCardsArt)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)

local function OdpHandoffNode(props)
	local props2 = props.props
	local report = props.report
	local transitions = props.transitions
	local v = OdpAnalytics.useOdpAnalytics(props.ctx)
	local ref = React.useRef(false)
	React.useEffect(function()
		if not ref.current then
			ref.current = true
			v.handoffShown()
		end
	end, { v })

	local onActivated = React.useCallback(function()
		v.handoffContinue()
		report("Continue")
	end, { report, v })

	local onBack = React.useCallback(function()
		v.handoffBack()
		report("Back")
	end, { report, v })
	local v2

	if transitions == nil then
		v2 = false
	else
		v2 = transitions.Back ~= nil
	end

	local onClose = React.useCallback(function()
		report("Cancel")
	end, { report })
	local v3

	if transitions == nil then
		v3 = false
	else
		v3 = transitions.Cancel ~= nil
	end

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 1,
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = UDim2.fromScale(1, 0),
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 1)
		}
	}

	local createElement3 = React.createElement

	local v5 = {
		Hero = React.createElement(ODPTiltedCardsArt, { LayoutOrder = 1 }),
		Copy = 0
	}
	local createElement4 = React.createElement

	local createElement5 = React.createElement

	local v6 = {
		Title = React.createElement(Text, {
			Text = props2.title,
			tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Description = 0
	}
	local description

	if not (props2.description == nil or props2.description == "") then
		description = React.createElement(Text, {
			Text = props2.description,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
			LayoutOrder = 2
		})
	end

	v6.Description = description
	v5.Copy = createElement4(
		View,
		{
			tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge",
			LayoutOrder = 2
		},
		{
			Intro = createElement5(View, {
				tag = "col gap-none size-full-0 auto-y",
				LayoutOrder = 1
			}, v6)
		}
	)
	local element = createElement(View, { tag = "col size-full" }, {
		Body = createElement2(ScrollView, v4, {
			Content = createElement3(View, { tag = "col gap-none size-full-0 auto-y" }, v5)
		}),
		Footer = React.createElement(
			View,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{
				Continue = React.createElement(Button, {
					text = props2.continueLabel or "",
					onActivated = onActivated,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			}
		)
	})

	local createElement6 = React.createElement
	local v7 = { title = props2.headerTitle, onBack = 0, onClose = 0 }

	if not v2 then
		onBack = nil
	end

	v7.onBack = onBack

	if v2 or not v3 then
		onClose = nil
	end

	v7.onClose = onClose
	return createElement6(FullPageChrome, v7, { Content = element })
end

return OdpHandoffNode
