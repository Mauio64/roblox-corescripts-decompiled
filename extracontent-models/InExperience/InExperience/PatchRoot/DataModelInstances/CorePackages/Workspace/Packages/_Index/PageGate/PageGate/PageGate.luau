local defineFastFlag = game:DefineFastFlag("EnablePLTPrefetchCallbacks", false)

local resolveEnumItem = require(script.Parent.resolveEnumItem)
local signalWith = require(script.Parent.signalWith)

local v = {
	isEnabled = function()
		return game:GetEngineFeature("PageMilestoneSignalEnabled")
	end,
	getService = function()
		return game:GetService("AppLifecycleObserverService")
	end,
	resolveEnumItem = resolveEnumItem,
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
	signal = function(p: string, p2: string)
		signalWith(v, p, p2)
	end
}
