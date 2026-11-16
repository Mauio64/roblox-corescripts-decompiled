local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local OpenReportMenu = require(parent.Actions.OpenReportMenu)
local CloseReportMenu = require(parent.Actions.CloseReportMenu)
require(parent.Actions.OpenReportDialog)
require(parent.Actions.OpenCategoryMenu)
local SelectReportCategory = require(parent.Actions.SelectReportCategory)
local OpenReportSentDialog = require(parent.Actions.OpenReportSentDialog)
require(parent.Actions.CloseReportSentDialog)
local SelectReportListing = require(parent.Actions.SelectReportListing)
local SetVoiceReportingFlow = require(parent.Actions.SetVoiceReportingFlow)
local BeginReportFlow = require(parent.Actions.BeginReportFlow)
local EndReportFlow = require(parent.Actions.EndReportFlow)
local NavigateBack = require(parent.Actions.NavigateBack)
local Constants = require(parent.Resources.Constants)

return Rodux.createReducer({
	currentPage = Constants.Page.None,
	history = {},
	voiceReportingFlowEnabled = true,
	reportType = Constants.ReportType.Any,
	beginningReportType = Constants.ReportType.Any,
	reportCategory = Constants.Category.None,
	targetPlayer = nil,
	beginningTimestamp = 0,
	sortedUserIds = {}
}, {
	[EndReportFlow.name] = function(p, _)
		return Cryo.Dictionary.join(p, {
			history = {},
			currentPage = Constants.Page.None,
			targetPlayer = Cryo.None,
			reportType = Constants.ReportType.Any
		})
	end,
	[BeginReportFlow.name] = function(p, p2)
		local v = {
			reportCategory = Constants.Category.None,
			beginningTimestamp = workspace:GetServerTimeNow(),
			sortedUserIds = {},
			history = { Constants.Page.None }
		}

		if p2.reportType == Constants.ReportType.Place then
			return Cryo.Dictionary.join(p, v, {
				reportType = p2.reportType,
				beginningReportType = p2.reportType,
				currentPage = Constants.Page.ReportForm,
				targetPlayer = Cryo.None
			})
		end

		if p2.reportType == Constants.ReportType.Player then
			local join = Cryo.Dictionary.join
			local v2 = {
				reportType = p2.reportType,
				beginningReportType = p2.reportType,
				targetPlayer = p2.targetPlayer,
				currentPage = 0
			}
			local currentPage

			if p.voiceReportingFlowEnabled then
				currentPage = Constants.Page.Category
			else
				currentPage = Constants.Page.ReportForm
			end

			v2.currentPage = currentPage
			return join(p, v, v2)
		else
			local join = Cryo.Dictionary.join
			local v2 = {
				reportType = Constants.ReportType.Any,
				beginningReportType = Constants.ReportType.Any,
				targetPlayer = Cryo.None,
				currentPage = 0
			}
			local currentPage

			if p.voiceReportingFlowEnabled then
				currentPage = Constants.Page.Category
			else
				currentPage = Constants.Page.Listing
			end

			v2.currentPage = currentPage
			return join(p, v, v2)
		end
	end,
	[NavigateBack.name] = function(p, _)
		local currentPage = p.history[#p.history] or p.currentPage
		local history = Cryo.List.removeIndex(p.history, #p.history)

		return Cryo.Dictionary.join(p, { history = history, currentPage = currentPage })
	end,
	[SelectReportCategory.name] = function(data, p)
		local v = p.reportCategory == Constants.Category.Experience
		local v2 = data.beginningReportType == Constants.ReportType.Player

		local currentPage = Constants.Page.Listing
		local reportType = data.reportType

		if v or v2 then
			currentPage = Constants.Page.ReportForm

			if v then
				reportType = Constants.ReportType.Place
			end
		end

		local joined = Cryo.List.join(data.history, { data.currentPage })

		return Cryo.Dictionary.join(data, {
			history = joined,
			currentPage = currentPage,
			reportType = reportType,
			reportCategory = p.reportCategory
		})
	end,
	[SelectReportListing.name] = function(p, data)
		local joined = Cryo.List.join(p.history, { p.currentPage })

		return Cryo.Dictionary.join(p, {
			sortedUserIds = Cryo.List.join(data.sortedUserIds or {}, {}),
			history = joined,
			currentPage = Constants.Page.ReportForm,
			reportType = data.reportType,
			targetPlayer = data.targetPlayer or Cryo.None
		})
	end,
	[OpenReportMenu.name] = function(p, _)
		return Cryo.Dictionary.join(p, { isReportMenuOpen = true })
	end,
	[CloseReportMenu.name] = function(p, _)
		return Cryo.Dictionary.join(p, { isReportMenuOpen = false })
	end,
	[OpenReportSentDialog.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			currentPage = Constants.Page.ReportSent,
			reportType = p2.reportType,
			targetPlayer = p2.targetPlayer or Cryo.None
		})
	end,
	[SetVoiceReportingFlow.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { voiceReportingFlowEnabled = p2.enable })
	end
})
