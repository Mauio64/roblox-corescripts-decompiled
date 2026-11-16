local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.Types)
local Constants = require(script.Parent.Constants)
local tryMilestoneOperation = require(script.Parent.tryMilestoneOperation)
local LoadingMilestoneTelemetry = {}

function LoadingMilestoneTelemetry.reportHoldGateHit(p, holdGateHit: boolean)
	return tryMilestoneOperation(function()
		local clone = table.clone(p)
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
end

function LoadingMilestoneTelemetry.reportContentVisibility(p, titleVisible: boolean, creatorVisible: boolean, thumbnailVisible: boolean)
	return tryMilestoneOperation(function()
		local clone = table.clone(p)
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
end

function LoadingMilestoneTelemetry.reportAddedWait(p, p2: number, dismissSource)
	return tryMilestoneOperation(function()
		local clone = table.clone(p)
		clone.dismissSource = dismissSource
		TelemetryService:LogStat({
			eventName = "TiltLoadingScreenAddedWait",
			backends = { "RobloxTelemetryStat" },
			lastUpdated = { 2026, 10, 1 },
			description = "Milliseconds from the first dismissal request to dismissal start in completed loading screens.",
			links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
		}, { customFields = clone }, p2)
	end)
end

function LoadingMilestoneTelemetry.getMilestoneSessionMetadata(subcategory: string, page)
	return {
		category = Constants.CATEGORY,
		page = page,
		subcategory = subcategory,
		AppVersion = RunService:GetRobloxVersion(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = tostring(UserInputService:GetPlatform())
	}
end

function LoadingMilestoneTelemetry.countMilestonesStarted(customFields)
	return tryMilestoneOperation(function()
		TelemetryService:LogCounter({
			eventName = Constants.EVENT_NAME .. "_MilestonesStarted",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 2026, 11, 2 },
			description = "Instrumented loading screens, before tracker initialization.",
			links = "https://roblox.atlassian.net/wiki/x/AAPROQE"
		}, { customFields = customFields }, 1)
	end)
end

function LoadingMilestoneTelemetry.countMilestonesOutcome(p, outcome)
	return tryMilestoneOperation(function()
		local clone = table.clone(p)
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

return LoadingMilestoneTelemetry
