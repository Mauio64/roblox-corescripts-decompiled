local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local scrollView = Foundation.ScrollView
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FullPageChrome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FullPageChrome")
local ODPTiltedCardsArt = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ODPTiltedCardsArt")
local OdpAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpAnalytics")

local function OdpHandoffNode(props)
	local props2 = props.props
	local report = props.report
	local transitions = props.transitions
	local v5 = OdpAnalytics.useOdpAnalytics(props.ctx)
	local ref = React.useRef(false)
	React.useEffect(function()
		if not ref.current then
			ref.current = true
			v5.handoffShown()
		end
	end, { v5 })

	local v6 = React.useCallback(function()
		v5.handoffContinue()
		report("Continue")
	end, { report, v5 })

	local v7 = React.useCallback(function()
		v5.handoffBack()
		report("Back")
	end, { report, v5 })

	local v8 = not (transitions == nil) and transitions.Back ~= nil

	local v9 = React.useCallback(function()
		report("Cancel")
	end, { report })

	local v10 = not (transitions == nil) and transitions.Cancel ~= nil

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v14 = {
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

	local v18 = {
		Hero = React.createElement(ODPTiltedCardsArt, { LayoutOrder = 1 }),
		Copy = 0
	}
	local createElement4 = React.createElement

	local createElement5 = React.createElement

	local v24 = {
		Title = React.createElement(text, {
			Text = props2.title,
			tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Description = 0
	}

	local v25 = if props2.description ~= nil and props2.description ~= "" then React.createElement(text, {
		Text = props2.description,
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
		LayoutOrder = 2
	}) else nil
	v24.Description = v25
	v18.Copy = createElement4(
		view,
		{
			tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge",
			LayoutOrder = 2
		},
		{
			Intro = createElement5(view, {
				tag = "col gap-none size-full-0 auto-y",
				LayoutOrder = 1
			}, v24)
		}
	)
	local element = createElement(view, { tag = "col size-full" }, {
		Body = createElement2(scrollView, v14, {
			Content = createElement3(view, { tag = "col gap-none size-full-0 auto-y" }, v18)
		}),
		Footer = React.createElement(
			view,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{
				Continue = React.createElement(button, {
					text = props2.continueLabel or "",
					onActivated = v6,
					variant = buttonVariant.Emphasis,
					size = inputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			}
		)
	})

	local createElement6 = React.createElement
	local v27 = { title = props2.headerTitle, onBack = 0, onClose = 0 }

	if not v8 then
		v7 = nil
	end

	v27.onBack = v7

	if v8 or not v10 then
		v9 = nil
	end

	v27.onClose = v9
	return createElement6(FullPageChrome, v27, { Content = element })
end

return OdpHandoffNode
