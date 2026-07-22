local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local Dialog = Foundation.Dialog
local RadioGroup = Foundation.RadioGroup
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local t1 = {
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

local function ReportMomentDialog(t2: {[any]: any}) -- line: 39
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), Dialog (copy), Foundation (copy), View (copy), FoundationText (copy), RadioGroup (copy)
	local v13 = useLocalization(t1)
	local v14, v15 = React.useState(false)
	local v16, v17 = React.useState(false)
	local v18, v19 = React.useState("Safety")
	local v20, v21 = React.useState("------")

	React.useEffect(function() -- line: 46
		-- upvalues: t2 (copy), v19 (copy), v15 (copy), v17 (copy), v21 (copy)
		if t2.isOpen then
			v19("Safety")
			v15(false)
			v17(false)
			v21("------")
		end
	end, { t2.isOpen })

	local v22 = React.useCallback(function() -- line: 55
		-- upvalues: v16 (copy), v18 (copy), v17 (copy), t2 (copy), v21 (copy), v15 (copy)
		if v16 then
			return
		end

		local v25 = v18
		local v26 = v25 == "IntellectualProperty"

		v17(true)

		if not v26 then
			v17(false)
			t2.onClose()
		end

		task.spawn(function() -- line: 69
			-- upvalues: t2 (copy), v25 (copy), v26 (copy), v21 (copy), v15 (copy), v17 (copy)
			local v27 = t2.onSubmitReport(v25, v26)

			if v26 then
				v21((not v27 or v27 == "") and "------" or v27)
				v15(true)
				v17(false)
			end
		end)
	end, {
		v16,
		v18,
		t2.onClose,
		t2.onSubmitReport
	})
	local v23 = React.useCallback(function() -- line: 83
		-- upvalues: v16 (copy), t2 (copy)
		if v16 then
			return
		end

		t2.onClose()
	end, {
		v16,
		t2.onClose
	})
	local v24 = React.useCallback(function() -- line: 91
		-- upvalues: v15 (copy), t2 (copy)
		v15(false)
		t2.onClose()
	end, { t2.onClose })

	if v14 then
		return React.createElement(Dialog.Root, {
			disablePortal = false,
			hasBackdrop = true,
			onClose = v24,
			size = Foundation.Enums.DialogSize.Medium
		}, {
			DialogTitle = React.createElement(Dialog.Title, {
				LayoutOrder = 1,
				text = v13.ipReportSubmittedTitle
			}),
			DialogContent = React.createElement(Dialog.Content, {
				LayoutOrder = 2
			}, {
				ReportCodeContent = React.createElement(View, {
					tag = "col align-x-center gap-small size-full-0 auto-y"
				}, {
					ReportCodeLabel = React.createElement(FoundationText, {
						tag = "auto-xy text-title-medium text-align-x-center content-default",
						LayoutOrder = 1,
						Text = v13.ipReportCodeLabel
					}),
					ReportCode = React.createElement(FoundationText, {
						tag = "auto-xy text-heading-medium text-align-x-center content-emphasis",
						LayoutOrder = 2,
						Text = v20
					}),
					ReportSubmittedBody = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
						RichText = true,
						LayoutOrder = 3,
						Text = v13.ipReportSubmittedBody
					})
				})
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {{
					text = v13.ipReportSubmittedClose,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = v24
				}}
			})
		})
	end

	if not t2.isOpen then
		return nil
	end

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		onClose = v23,
		size = Foundation.Enums.DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v13.reportDialogTitle
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			ReportReasons = React.createElement(RadioGroup.Root, {
				value = v18,
				onValueChanged = v19
			}, {
				BreaksRules = React.createElement(RadioGroup.Item, {
					value = "Safety",
					label = v13.reportReasonBreaksRules
				}),
				IntellectualProperty = React.createElement(RadioGroup.Item, {
					value = "IntellectualProperty",
					label = v13.reportReasonIntellectualProperty
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = if v18 ~= "IntellectualProperty" then v13.report else v13.continue,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = v22,
					isDisabled = v16
				},
				{
					text = v13.cancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = v23,
					isDisabled = v16
				}
			}
		})
	})
end

return ReportMomentDialog
