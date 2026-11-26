local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/isSelectedDataDSAIllegalContent")
return {
	isShowEUDSAIllegalContentReportingLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/isShowEUDSAIllegalContentReportingLink"),
	isSelectedDataDSAIllegalContent = module,
	isInDSAFeaturesOverrideList = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/isInDSAFeaturesOverrideList"),
	DSAReportLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Components/DSAReportLink"),
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/Constants"),
	OSAReportLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Components/OSAReportLink"),
	isShowUKOSAIllegalContentReportingLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/isShowUKOSAIllegalContentReportingLink"),
	GenericReportLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Components/GenericReportLink"),
	isShowGenericIllegalContentReportingLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/isShowGenericIllegalContentReportingLink"),
	TakeItDownReportLink = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Components/TakeItDownReportLink"),
	getTakeItDownReportLinkVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/getTakeItDownReportLinkVisibility")
}
