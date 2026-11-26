local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local dialog = Foundation.Dialog
local radioGroup = Foundation.RadioGroup
local text = Foundation.Text
local view = Foundation.View

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
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
	local v6 = useLocalization(v5)
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

	local v7 = React.useCallback(function()
		if state2 then
			return
		end

		local v8 = state3
		local v9 = v8 == "IntellectualProperty"
		setState2(true)

		if not v9 then
			setState2(false)
			props.onClose()
		end

		task.spawn(function()
			local v10 = props.onSubmitReport(v8, v9)

			if v9 then
				setState4((not v10 or v10 == "") and "------" or v10)

				setState(true)
				setState2(false)
			end
		end)
	end, { state2, state3, props.onClose, props.onSubmitReport })

	local v8 = React.useCallback(function()
		if state2 then
			return
		end

		props.onClose()
	end, { state2, props.onClose })

	local v9 = React.useCallback(function()
		setState(false)
		props.onClose()
	end, { props.onClose })

	if state then
		return React.createElement(
			dialog.Root,
			{
				disablePortal = false,
				hasBackdrop = true,
				onClose = v9,
				size = Foundation.Enums.DialogSize.Medium
			},
			{
				DialogTitle = React.createElement(dialog.Title, {
					text = v6.ipReportSubmittedTitle,
					LayoutOrder = 1
				}),
				DialogContent = React.createElement(dialog.Content, {
					LayoutOrder = 2
				}, {
					ReportCodeContent = React.createElement(
						view,
						{ tag = "col align-x-center gap-small size-full-0 auto-y" },
						{
							ReportCodeLabel = React.createElement(text, {
								Text = v6.ipReportCodeLabel,
								tag = "auto-xy text-title-medium text-align-x-center content-default",
								LayoutOrder = 1
							}),
							ReportCode = React.createElement(text, {
								Text = state4,
								tag = "auto-xy text-heading-medium text-align-x-center content-emphasis",
								LayoutOrder = 2
							}),
							ReportSubmittedBody = React.createElement(text, {
								Text = v6.ipReportSubmittedBody,
								tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
								RichText = true,
								LayoutOrder = 3
							})
						}
					)
				}),
				DialogActions = React.createElement(dialog.Actions, {
					LayoutOrder = 3,
					actions = {
						{
							text = v6.ipReportSubmittedClose,
							variant = Foundation.Enums.ButtonVariant.Emphasis,
							onActivated = v9
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
	local root = dialog.Root
	local v10 = {
		disablePortal = false,
		hasBackdrop = true,
		onClose = v8,
		size = Foundation.Enums.DialogSize.Medium
	}
	local v11 = {
		DialogTitle = React.createElement(dialog.Title, {
			text = v6.reportDialogTitle,
			LayoutOrder = 1
		}),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			ReportReasons = React.createElement(
				radioGroup.Root,
				{ value = state3, onValueChanged = setState3 },
				{
					BreaksRules = React.createElement(radioGroup.Item, {
						value = "Safety",
						label = v6.reportReasonBreaksRules
					}),
					IntellectualProperty = React.createElement(radioGroup.Item, {
						value = "IntellectualProperty",
						label = v6.reportReasonIntellectualProperty
					})
				}
			)
		}),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = dialog.Actions

	local v15 = if state3 == "IntellectualProperty" then v6.continue else v6.report
	v11.DialogActions = createElement2(actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = v15,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = v7,
				isDisabled = state2
			},
			{
				text = v6.cancel,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = v8,
				isDisabled = state2
			}
		}
	})
	return createElement(root, v10, v11)
end

return ReportMomentDialog
