local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

local InlineAppealLink = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/genericComponents/InlineAppealLink")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local button = Foundation.Button
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local text = Foundation.Text
local view = Foundation.View

local function InterventionDialogFooter(props)
	local createElement = React.createElement

	local v7 = {
		AppealLink = props.isAppealable and React.createElement(InlineAppealLink, {
			onActivated = props.onAppealActivated,
			LayoutOrder = 1
		}),
		Cta = React.createElement(button, {
			variant = buttonVariant.Emphasis,
			size = buttonSize.Medium,
			text = props.ctaText,
			onActivated = props.onCtaActivated,
			width = UDim.new(1, 0),
			testId = "intervention-dialog-footer-cta",
			LayoutOrder = 2
		}),
		DsaMessage = 0
	}

	local v8 = props.dsaMessage

	if v8 then
		if props.dsaMessage == "" then
			v8 = false
		else
			v8 = React.createElement(text, {
				Text = props.dsaMessage,
				tag = "auto-xy text-caption-small text-wrap text-align-x-left content-default",
				testId = "intervention-dialog-footer-dsa-message",
				LayoutOrder = 3
			})
		end
	end

	v7.DsaMessage = v8
	return createElement(
		view,
		{
			tag = "col no-flex gap-medium size-full-0 auto-y",
			testId = "intervention-dialog-footer",
			LayoutOrder = 3
		},
		v7
	)
end

return React.memo(InterventionDialogFooter)
