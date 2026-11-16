local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants")
local tryMilestoneOperation = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/tryMilestoneOperation")

return {
	reportHoldGateHit = function(p2, holdGateHit)
		return tryMilestoneOperation(function()
			local clone = table.clone(p2)
			clone.dismissSource = Constants.DismissSource.NormalReady
			clone.holdGateHit = holdGateHit
			TelemetryService:LogCounter({
				eventName = Constants.EVENT_NAME .. "_HoldGateHit",
				backends = { "RobloxTelemetryCounter" },
				lastUpdated = { 2026, 10, 12 },
				description = "Completed normal-first HoldOn screens without reduced motion, with readiness and gate-release observations, split by whether readiness preceded gate release.",
				links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
			}, { customFields = clone }, 1)
		end)
	end,
	reportContentVisibility = function(p2, titleVisible, creatorVisible, thumbnailVisible)
		return tryMilestoneOperation(function()
			local clone = table.clone(p2)
			clone.titleVisible = titleVisible
			clone.creatorVisible = creatorVisible
			clone.thumbnailVisible = thumbnailVisible
			clone.allContentVisible = titleVisible and creatorVisible and thumbnailVisible

			TelemetryService:LogCounter({
				eventName = Constants.EVENT_NAME .. "_ContentVisibility",
				backends = { "RobloxTelemetryCounter" },
				lastUpdated = { 2026, 10, 11 },
				description = "Completed loading screens with mount and dismissal-start observations, split by title, creator, thumbnail, and all-content visibility before dismissal.",
				links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
			}, { customFields = clone }, 1)
		end)
	end,
	reportAddedWait = function(p2, p3, dismissSource)
		return tryMilestoneOperation(function()
			local clone = table.clone(p2)
			clone.dismissSource = dismissSource
			TelemetryService:LogStat({
				eventName = "TiltLoadingScreenAddedWait",
				backends = { "RobloxTelemetryStat" },
				lastUpdated = { 2026, 10, 1 },
				description = "Milliseconds from the first dismissal request to dismissal start in completed loading screens.",
				links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
			}, { customFields = clone }, p3)
		end)
	end,
	getMilestoneSessionMetadata = function(p2, p3)
		return {
			category = Constants.CATEGORY,
			page = p3,
			subcategory = p2,
			AppVersion = RunService:GetRobloxVersion(),
			CoreScriptVersion = RunService:GetCoreScriptVersion(),
			Platform = tostring(UserInputService:GetPlatform())
		}
	end,
	countMilestonesStarted = function(p2)
		return tryMilestoneOperation(function()
			TelemetryService:LogCounter({
				eventName = Constants.EVENT_NAME .. "_MilestonesStarted",
				backends = { "RobloxTelemetryCounter" },
				lastUpdated = { 2026, 11, 2 },
				description = "Instrumented loading screens, before tracker initialization.",
				links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
			}, { customFields = p2 }, 1)
		end)
	end,
	countMilestonesOutcome = function(p2, outcome)
		return tryMilestoneOperation(function()
			local clone = table.clone(p2)
			clone.outcome = outcome
			TelemetryService:LogCounter({
				eventName = Constants.EVENT_NAME .. "_MilestonesOutcome",
				backends = { "RobloxTelemetryCounter" },
				lastUpdated = { 2026, 11, 2 },
				description = "Terminal outcomes of instrumented loading screens, independent of TTI sampling.",
				links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
			}, { customFields = clone }, 1)
		end)
	end
}
