local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local Text = Foundation.Text
local View = Foundation.View

local useLocalization = Localization.Hooks.useLocalization

local v = {
	ipReportCodeLabel = "Feature.ReportAbuse.Label.YourReportCode",
	ipReportSubmittedBody = "Feature.ReportAbuse.Description.IpInfringementReportModal",
	ipReportSubmittedClose = "Feature.ReportAbuse.Action.Close",
	ipReportSubmittedTitle = "Feature.ReportAbuse.Title.SelectInSceneIpReport"
}

local function IpReportConfirmationDialog(p)
	local v2 = useLocalization(v)

	return React.createElement(
		Dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			onClose = p.onClose,
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
							Text = p.reportCode,
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
						onActivated = p.onClose
					}
				}
			})
		}
	)
end

return IpReportConfirmationDialog
