local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local RadioGroup = Foundation.RadioGroup
local Text = Foundation.Text
local View = Foundation.View

local useLocalization = Localization.Hooks.useLocalization

local v = {
	report = "Feature.Moments.Action.Report",
	cancel = "Feature.Moments.Action.Cancel",
	continue = "Feature.Moments.Action.Continue",
	reportDialogTitle = "Feature.Moments.Title.ReportPost",
	reportReasonBreaksRules = "Feature.Moments.Label.ReportReason.BreaksRules",
	reportReasonIntellectualProperty = "Feature.Moments.Label.ReportReason.IntellectualProperty",
	ipReportCodeLabel = "Feature.ReportAbuse.Label.YourReportCode",
	ipReportSubmittedBody = "Feature.ReportAbuse.Description.IpInfringementReportModal",
	ipReportSubmittedClose = "Feature.ReportAbuse.Action.Close",
	ipReportSubmittedTitle = "Feature.ReportAbuse.Title.SelectInSceneIpReport"
}

local function ReportMomentDialog(props)
	local v2 = useLocalization(v)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState("Safety")
	local state4, setState4 = React.useState("------")

	React.useEffect(function()
		if props.isOpen then
			setState3("Safety")
			setState(false)
			setState2(false)
			setState4("------")
		end
	end, { props.isOpen })

	local onActivated = React.useCallback(function()
		if state2 then
			return
		end

		local v3 = state3
		local v4 = v3 == "IntellectualProperty"
		setState2(true)

		if not v4 then
			setState2(false)
			props.onClose()
		end

		task.spawn(function()
			local v5 = props.onSubmitReport(v3, v4)

			if v4 then
				setState4((not v5 or v5 == "") and "------" or v5)

				setState(true)
				setState2(false)
			end
		end)
	end, { state2, state3, props.onClose, props.onSubmitReport })

	local v3 = React.useCallback(function()
		if state2 then
			return
		end

		props.onClose()
	end, { state2, props.onClose })

	local v4 = React.useCallback(function()
		setState(false)
		props.onClose()
	end, { props.onClose })

	if state then
		return React.createElement(
			Dialog.Root,
			{
				disablePortal = false,
				hasBackdrop = true,
				onClose = v4,
				size = Foundation.Enums.DialogSize.Medium
			},
			{
				DialogTitle = React.createElement(Dialog.Title, {
					text = v2.ipReportSubmittedTitle,
					LayoutOrder = 1
				}),
				DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
					ReportCodeContent = React.createElement(
						View,
						{ tag = "col align-x-center gap-small size-full-0 auto-y" },
						{
							ReportCodeLabel = React.createElement(Text, {
								Text = v2.ipReportCodeLabel,
								tag = "auto-xy text-title-medium text-align-x-center content-default",
								LayoutOrder = 1
							}),
							ReportCode = React.createElement(Text, {
								Text = state4,
								tag = "auto-xy text-heading-medium text-align-x-center content-emphasis",
								LayoutOrder = 2
							}),
							ReportSubmittedBody = React.createElement(Text, {
								Text = v2.ipReportSubmittedBody,
								tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
								RichText = true,
								LayoutOrder = 3
							})
						}
					)
				}),
				DialogActions = React.createElement(Dialog.Actions, {
					LayoutOrder = 3,
					actions = {
						{
							text = v2.ipReportSubmittedClose,
							variant = Foundation.Enums.ButtonVariant.Emphasis,
							onActivated = v4
						}
					}
				})
			}
		)
	end

	if not props.isOpen then
		return nil
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v5 = {
		disablePortal = false,
		hasBackdrop = true,
		onClose = v3,
		size = Foundation.Enums.DialogSize.Medium
	}
	local v6 = {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v2.reportDialogTitle,
			LayoutOrder = 1
		}),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			ReportReasons = React.createElement(RadioGroup.Root, {
				value = state3,
				onValueChanged = setState3
			}, {
				BreaksRules = React.createElement(RadioGroup.Item, {
					value = "Safety",
					label = v2.reportReasonBreaksRules
				}),
				IntellectualProperty = React.createElement(RadioGroup.Item, {
					value = "IntellectualProperty",
					label = v2.reportReasonIntellectualProperty
				})
			})
		}),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = Dialog.Actions
	local text

	if state3 == "IntellectualProperty" then
		text = v2.continue
	else
		text = v2.report
	end

	v6.DialogActions = createElement2(actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = text,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = onActivated,
				isDisabled = state2
			},
			{
				text = v2.cancel,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = v3,
				isDisabled = state2
			}
		}
	})
	return createElement(root, v5, v6)
end

return ReportMomentDialog
