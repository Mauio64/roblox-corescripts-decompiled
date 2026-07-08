local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local OpenReportMenu = require(ParentParent.Actions.OpenReportMenu)
local CloseReportMenu = require(ParentParent.Actions.CloseReportMenu)

require(ParentParent.Actions.OpenReportDialog)
require(ParentParent.Actions.OpenCategoryMenu)

local SelectReportCategory = require(ParentParent.Actions.SelectReportCategory)
local OpenReportSentDialog = require(ParentParent.Actions.OpenReportSentDialog)

require(ParentParent.Actions.CloseReportSentDialog)

local SelectReportListing = require(ParentParent.Actions.SelectReportListing)
local SetVoiceReportingFlow = require(ParentParent.Actions.SetVoiceReportingFlow)
local SetIdentifiedAvatars = require(ParentParent.Actions.SetIdentifiedAvatars)
local SetSelectedAvatars = require(ParentParent.Actions.SetSelectedAvatars)
local BeginReportFlow = require(ParentParent.Actions.BeginReportFlow)
local EndReportFlow = require(ParentParent.Actions.EndReportFlow)
local ScreenshotAnnotated = require(ParentParent.Actions.ScreenshotAnnotated)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local Constants = require(ParentParent.Resources.Constants)
local GetFFlagReportAnythingScreenshot = require(ParentParent.Flags.GetFFlagReportAnythingScreenshot)

return Rodux.createReducer({
	voiceReportingFlowEnabled = true,
	targetPlayer = nil,
	beginningTimestamp = 0,
	currentPage = Constants.Page.None,
	history = {},
	reportType = Constants.ReportType.Any,
	beginningReportType = Constants.ReportType.Any,
	reportCategory = Constants.Category.None,
	sortedUserIds = {},
	screenshotAnnotationPoints = {},
	identifiedAvatars = {},
	selectedAvatars = {}
}, {
	[EndReportFlow.name] = function(p1, _) -- line: 41
		-- upvalues: Cryo (copy), Constants (copy)
		return Cryo.Dictionary.join(p1, {
			history = {},
			currentPage = Constants.Page.None,
			targetPlayer = Cryo.None,
			reportType = Constants.ReportType.Any,
			identifiedAvatars = {},
			selectedAvatars = {},
			screenshotAnnotationPoints = {}
		})
	end,
	[BeginReportFlow.name] = function(p3, p4) -- line: 52
		-- upvalues: Constants (copy), Cryo (copy)
		local t1 = {
			reportCategory = Constants.Category.None,
			beginningTimestamp = workspace:GetServerTimeNow(),
			sortedUserIds = {},
			history = { Constants.Page.None }
		}

		if p4.reportType == Constants.ReportType.Place then
			return Cryo.Dictionary.join(p3, t1, {
				reportType = p4.reportType,
				beginningReportType = p4.reportType,
				currentPage = Constants.Page.ReportForm,
				targetPlayer = Cryo.None
			})
		end

		if p4.reportType == Constants.ReportType.Player then
			return Cryo.Dictionary.join(p3, t1, {
				reportType = p4.reportType,
				beginningReportType = p4.reportType,
				targetPlayer = p4.targetPlayer,
				currentPage = if not p3.voiceReportingFlowEnabled then Constants.Page.ReportForm else Constants.Page.Category
			})
		end

		return Cryo.Dictionary.join(p3, t1, {
			reportType = Constants.ReportType.Any,
			beginningReportType = Constants.ReportType.Any,
			targetPlayer = Cryo.None,
			currentPage = if not p3.voiceReportingFlowEnabled then Constants.Page.Listing else Constants.Page.Category
		})
	end,
	[NavigateBack.name] = function(p5, _) -- line: 86
		-- upvalues: Cryo (copy)
		local v26 = p5.history[#p5.history] or p5.currentPage
		local v27 = Cryo.List.removeIndex(p5.history, #p5.history)

		return Cryo.Dictionary.join(p5, {
			history = v27,
			currentPage = v26
		})
	end,
	[SelectReportCategory.name] = function(p7, p8) -- line: 95
		-- upvalues: Constants (copy), GetFFlagReportAnythingScreenshot (copy), Cryo (copy)
		local v30 = p8.reportCategory == Constants.Category.Experience
		local v31 = p7.beginningReportType == Constants.ReportType.Player
		local Listing = Constants.Page.Listing
		local reportType = p7.reportType

		if GetFFlagReportAnythingScreenshot() then
			if v30 then
				Listing = Constants.Page.ScreenshotDialog
				reportType = Constants.ReportType.Place
			elseif v31 then
				Listing = Constants.Page.ReportForm
			end
		elseif v30 or v31 then
			Listing = Constants.Page.ReportForm

			if v30 then
				reportType = Constants.ReportType.Place
			end
		end

		local v34 = Cryo.List.join(p7.history, { p7.currentPage })

		return Cryo.Dictionary.join(p7, {
			history = v34,
			currentPage = Listing,
			reportType = reportType,
			reportCategory = p8.reportCategory
		})
	end,
	[SelectReportListing.name] = function(p9, p10) -- line: 129
		-- upvalues: Cryo (copy), Constants (copy)
		local v37 = Cryo.List.join(p9.history, { p9.currentPage })

		return Cryo.Dictionary.join(p9, {
			sortedUserIds = Cryo.List.join(p10.sortedUserIds or {}, {}),
			history = v37,
			currentPage = Constants.Page.ReportForm,
			reportType = p10.reportType,
			targetPlayer = p10.targetPlayer or Cryo.None
		})
	end,
	[ScreenshotAnnotated.name] = function(p11, p12) -- line: 140
		-- upvalues: Cryo (copy), Constants (copy)
		local v40 = Cryo.List.join(p11.history, { p11.currentPage })
		local ReportForm = Constants.Page.ReportForm

		return Cryo.Dictionary.join(p11, {
			history = v40,
			currentPage = ReportForm,
			screenshotAnnotationPoints = p12.annotationPoints
		})
	end,
	[OpenReportMenu.name] = function(p13, _) -- line: 151
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p13, {
			isReportMenuOpen = true
		})
	end,
	[CloseReportMenu.name] = function(p15, _) -- line: 156
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p15, {
			isReportMenuOpen = false
		})
	end,
	[OpenReportSentDialog.name] = function(p17, p18) -- line: 161
		-- upvalues: Cryo (copy), Constants (copy)
		return Cryo.Dictionary.join(p17, {
			currentPage = Constants.Page.ReportSent,
			reportType = p18.reportType,
			targetPlayer = p18.targetPlayer or Cryo.None
		})
	end,
	[SetVoiceReportingFlow.name] = function(p19, p20) -- line: 168
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p19, {
			voiceReportingFlowEnabled = p20.enable
		})
	end,
	[SetIdentifiedAvatars.name] = function(p21, p22) -- line: 173
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p21, {
			identifiedAvatars = p22.identifiedAvatars,
			screenshotAnnotationPoints = {}
		})
	end,
	[SetSelectedAvatars.name] = function(p23, p24) -- line: 179
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p23, {
			selectedAvatars = p24.selectedAvatars
		})
	end
})
