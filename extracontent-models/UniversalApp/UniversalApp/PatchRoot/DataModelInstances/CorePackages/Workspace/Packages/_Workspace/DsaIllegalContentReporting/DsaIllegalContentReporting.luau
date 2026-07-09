local isSelectedDataDSAIllegalContent = require(script.Utility.isSelectedDataDSAIllegalContent)
local isShowEUDSAIllegalContentReportingLink = require(script.Utility.isShowEUDSAIllegalContentReportingLink)
local isInDSAFeaturesOverrideList = require(script.Utility.isInDSAFeaturesOverrideList)
local DSAReportLink = require(script.Components.DSAReportLink)
local Constants = require(script.Utility.Constants)
local OSAReportLink = require(script.Components.OSAReportLink)
local isShowUKOSAIllegalContentReportingLink = require(script.Utility.isShowUKOSAIllegalContentReportingLink)
local GenericReportLink = require(script.Components.GenericReportLink)
local isShowGenericIllegalContentReportingLink = require(script.Utility.isShowGenericIllegalContentReportingLink)
local TakeItDownReportLink = require(script.Components.TakeItDownReportLink)
local getTakeItDownReportLinkVisibility = require(script.Utility.getTakeItDownReportLinkVisibility)

return {
	isShowEUDSAIllegalContentReportingLink = isShowEUDSAIllegalContentReportingLink,
	isSelectedDataDSAIllegalContent = isSelectedDataDSAIllegalContent,
	isInDSAFeaturesOverrideList = isInDSAFeaturesOverrideList,
	DSAReportLink = DSAReportLink,
	Constants = Constants,
	OSAReportLink = OSAReportLink,
	isShowUKOSAIllegalContentReportingLink = isShowUKOSAIllegalContentReportingLink,
	GenericReportLink = GenericReportLink,
	isShowGenericIllegalContentReportingLink = isShowGenericIllegalContentReportingLink,
	TakeItDownReportLink = TakeItDownReportLink,
	getTakeItDownReportLinkVisibility = getTakeItDownReportLinkVisibility,
	["jest.config"] = script["jest.config"]
}
