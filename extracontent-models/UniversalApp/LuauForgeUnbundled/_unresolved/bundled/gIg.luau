local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	None = "None",
	Pending = "Pending",
	Failed = "Failed",
	Success = "Success",
	Polling = "Polling",
	RobuxPollingFailedAfterNativePurchase = "RobuxPollingFailedAfterNativePurchase"
}

local v6 = enumerate("NativePurchaseStatus", v5)

module(v6, v5)

return v6
