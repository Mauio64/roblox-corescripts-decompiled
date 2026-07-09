local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local RoduxNetworking = require(CorePackages.Packages.RoduxNetworking)
local constructAbuseReportTags = require(Modules.LuaApp.Components.AbuseReporting.constructAbuseReportTags)

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)
require(Modules.LuaApp.Components.AbuseReporting.Constants)

local function submitAbuseReport(t1: {[any]: any}, s1: string, p1, p2) -- line: 9
	-- upvalues: HttpRequest (copy), RoduxNetworking (copy), constructAbuseReportTags (copy)
	local v11 = HttpRequest.config({
		maxWaitTime = 3,
		requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
		maxRetryCount = game:DefineFastInt("SubmitAbuseReportHttpRetryCount", 2)
	})
	local v12 = RoduxNetworking.config({
		keyPath = "AbuseReporting",
		networkImpl = v11
	})
	local t2 = {
		safetyEvent = {
			tags = constructAbuseReportTags(t1, p1, p2)
		}
	}

	return v12.POST("SubmitAbuseReport", function(p3, _: nil) -- line: 31
		-- upvalues: s1 (copy), t2 (copy)
		return p3(s1):body(t2)
	end).API()
end

return submitAbuseReport
