local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Rodux = InGameMenuDependencies.Rodux
local Cryo = InGameMenuDependencies.Cryo
local ParentParent = script.Parent.Parent
local OpenReportDialog = require(ParentParent.Actions.OpenReportDialog)
local CloseReportDialog = require(ParentParent.Actions.CloseReportDialog)
local OpenReportSentDialog = require(ParentParent.Actions.OpenReportSentDialog)
local CloseReportSentDialog = require(ParentParent.Actions.CloseReportSentDialog)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)

return Rodux.createReducer({
	dialogOpen = false,
	reportSentOpen = false,
	userId = nil,
	userName = nil
}, {
	[OpenReportDialog.name] = function(p1, p2) -- line: 21
		return {
			dialogOpen = true,
			reportSentOpen = p1.reportSentOpen,
			userId = p2.userId,
			userName = p2.userName
		}
	end,
	[SetCurrentPage.name] = function(p3, _) -- line: 31
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			dialogOpen = false
		})
	end,
	[CloseReportDialog.name] = function(p5, _) -- line: 36
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			dialogOpen = false
		})
	end,
	[OpenReportSentDialog.name] = function(p7, _) -- line: 41
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			reportSentOpen = true
		})
	end,
	[CloseReportSentDialog.name] = function(p9, _) -- line: 46
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			reportSentOpen = false
		})
	end
})
