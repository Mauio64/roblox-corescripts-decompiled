local module = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseEntrypoint")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Thunks/OpenDynamicAbuseReport")

return {
	Components = {
		ReportCompleteDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Dialogs/ReportCompleteDialog"),
		ReportFailedDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Dialogs/ReportFailedDialog")
	},
	Enums = {
		AbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseCategory"),
		AbuseEntrypoint = module,
		AbuseVector = module2
	},
	Thunks = { OpenDynamicAbuseReport = module3 },
	UXFlows = {
		DefaultTwoStepReportFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/ReportWithReasonAndComment/AREntrypoint"),
		DefaultReportDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/ReportWithReasonAndComment/ReportWithReasonAndComment"),
		DefaultDualDropdownDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DualDropdownReport/DualDropdownReport"),
		DefaultDualDropdownDialogV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DualDropdownReport/DualDropdownReportV2"),
		DynamicReportContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReport/DynamicReportContainer"),
		DynamicReportInExpContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/DynamicReportV2InExpContainer")
	}
}
