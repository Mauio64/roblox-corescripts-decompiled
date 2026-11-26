local defineFastFlag = game:DefineFastFlag("EnablePLTPrefetchCallbacks", false)

local module = require("@game/CorePackages/Workspace/Packages/_Index/PageGate/PageGate/resolveEnumItem")
local signalWith = require("@game/CorePackages/Workspace/Packages/_Index/PageGate/PageGate/signalWith")

local v6 = {
	isEnabled = function()
		return game:GetEngineFeature("PageMilestoneSignalEnabled")
	end,
	getService = function()
		return game:GetService("AppLifecycleObserverService")
	end,
	resolveEnumItem = module,
	defer = function(callback)
		task.defer(callback)
	end,
	warn = warn
}
return {
	["FFlagEnablePLTPrefetchCallbacks"] = defineFastFlag,
	Page = {
		AvatarEditor = "AvatarEditor",
		Party = "Party",
		ExperienceDetail = "ExperienceDetail",
		AvatarMarketplace = "AvatarMarketplace"
	},
	Milestone = {
		Interactive = "Interactive",
		SurfaceMounted = "SurfaceMounted",
		FunctionallyReady = "FunctionallyReady",
		SurfaceReady = "SurfaceReady"
	},
	signal = function(p2, p3)
		signalWith(v6, p2, p3)
	end
}
