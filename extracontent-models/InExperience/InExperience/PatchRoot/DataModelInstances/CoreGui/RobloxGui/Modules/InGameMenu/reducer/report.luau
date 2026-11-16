local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Rodux = InGameMenuDependencies.Rodux
local Cryo = InGameMenuDependencies.Cryo

local parent = script.Parent.Parent

local OpenReportDialog = require(parent.Actions.OpenReportDialog)
local CloseReportDialog = require(parent.Actions.CloseReportDialog)
local OpenReportSentDialog = require(parent.Actions.OpenReportSentDialog)
local CloseReportSentDialog = require(parent.Actions.CloseReportSentDialog)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)

return Rodux.createReducer({
	dialogOpen = false,
	reportSentOpen = false,
	userId = nil,
	userName = nil
}, {
	[OpenReportDialog.name] = function(p, p2)
		return {
			dialogOpen = true,
			reportSentOpen = p.reportSentOpen,
			userId = p2.userId,
			userName = p2.userName
		}
	end,
	[SetCurrentPage.name] = function(p, _)
		return Cryo.Dictionary.join(p, { dialogOpen = false })
	end,
	[CloseReportDialog.name] = function(p, _)
		return Cryo.Dictionary.join(p, { dialogOpen = false })
	end,
	[OpenReportSentDialog.name] = function(p, _)
		return Cryo.Dictionary.join(p, { reportSentOpen = true })
	end,
	[CloseReportSentDialog.name] = function(p, _)
		return Cryo.Dictionary.join(p, { reportSentOpen = false })
	end
})
