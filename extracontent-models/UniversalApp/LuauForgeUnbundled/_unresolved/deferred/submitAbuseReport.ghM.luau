local CorePackages = game:GetService("CorePackages")

local HttpRequest = require(CorePackages.Packages.HttpRequest)
local RoduxNetworking = require(CorePackages.Packages.RoduxNetworking)
local module = require("@luauforge/deferred/ghN")
require("@luauforge/deferred/ghD")
require("@luauforge/deferred/ghE")

local function submitAbuseReport(p2, p3, p4, p5)
	local config = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
		maxWaitTime = 3,
		maxRetryCount = game:DefineFastInt("SubmitAbuseReportHttpRetryCount", 2)
	})

	local config2 = RoduxNetworking.config({
		keyPath = "AbuseReporting",
		networkImpl = config
	})

	local v5 = {
		safetyEvent = { tags = module(p2, p4, p5) }
	}

	return config2.POST("SubmitAbuseReport", function(callback, p6)
		return callback(p3):body(v5)
	end).API()
end

return submitAbuseReport
