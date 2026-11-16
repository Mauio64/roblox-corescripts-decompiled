local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)
local Lumberyak = require(parent2.Lumberyak)
local ContentSharingNetworking = require(parent2.ContentSharingNetworking)
local ShareLinksNetworking = require(parent2.ShareLinksNetworking)
local ShareLinksRodux = require(parent2.ShareLinksRodux)
local FFlagCreateMomentsToast = require(parent.Flags.FFlagCreateMomentsToast)
local FFlagMomentsCaptureEndIxpEnabled = require(parent.Flags.FFlagMomentsCaptureEndIxpEnabled)

local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking

local Constants = require(parent.Constants)

local logger = Lumberyak.Logger.new(nil, Constants.LoggerKey)

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		logger:debug(`Request: [ requestMethod = {p2}, url = {p} ]`)
		return httpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = game:DefineFastInt("CapturesMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("CapturesMaxHttpRequestWaitTime", 8)
})

local config2 = RoduxNetworking.config({ keyPath = "NetworkStatus", networkImpl = config })
local contentSharingNetworking

if FFlagCreateMomentsToast or FFlagMomentsCaptureEndIxpEnabled then
	contentSharingNetworking = ContentSharingNetworking.config({ roduxNetworking = config2 })
end

return {
	RoduxNetworking = config2,
	ContentSharingNetworking = contentSharingNetworking,
	ShareLinksNetworking = ShareLinksNetworking.config({ roduxNetworking = config2 }),
	ShareLinksRodux = ShareLinksRodux.config({ keyPath = "ShareLinks" })
}
