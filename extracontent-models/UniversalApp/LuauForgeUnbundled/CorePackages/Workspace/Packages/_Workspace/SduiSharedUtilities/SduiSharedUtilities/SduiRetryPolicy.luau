local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/HttpClient")

local defineFastInt = game:DefineFastInt("SduiMaxRetryCount", 2)
local defineFastInt2 = game:DefineFastInt("SduiRetryJitterMinMs", 100)
local defineFastInt3 = game:DefineFastInt("SduiRetryJitterMaxMs", 1000)
local defineFastInt4 = game:DefineFastInt("SduiRetryBudgetSec", 20)

local defineFastInt5 = game:DefineFastInt("SduiFetchTimeoutHeadroomSec", 10)

local function getDefaultRetryOptions()
	local defaultRetryOptions = {
		maxRetryCount = defineFastInt,
		retryJitterMinMs = defineFastInt2,
		retryJitterMaxMs = defineFastInt3,
		retryBudgetSec = defineFastInt4,
		retryOnHttpErrors = 0
	}

	local set = {
		[Enum.HttpError.ConnectFail] = true,
		[Enum.HttpError.DnsResolve] = true,
		[Enum.HttpError.NetFail] = true
	}
	defaultRetryOptions.retryOnHttpErrors = set
	return defaultRetryOptions
end

return {
	resolve = function(p2)
		if p2 == nil then
			return getDefaultRetryOptions()
		end

		if p2.mode == "none" then
			return nil
		end

		local joined = Cryo.Dictionary.join(getDefaultRetryOptions(), p2.overrides)

		local retryBudgetSec = joined.retryBudgetSec
		local v5 = if retryBudgetSec == nil then defineFastInt4 else math.min(retryBudgetSec, defineFastInt4)
		joined.retryBudgetSec = v5

		return joined
	end,
	getRequestDeadlineSec = function()
		return defineFastInt4 + defineFastInt5
	end,
	getFetchTimeoutSec = function()
		return defineFastInt4 + defineFastInt5 + 5
	end
}
