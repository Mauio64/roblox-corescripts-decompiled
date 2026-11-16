local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local Cryo = require(parent.Cryo)
require(parent.HttpClient)

local defineFastInt = game:DefineFastInt("SduiMaxRetryCount", 2)
local defineFastInt2 = game:DefineFastInt("SduiRetryJitterMinMs", 100)
local defineFastInt3 = game:DefineFastInt("SduiRetryJitterMaxMs", 1000)
local defineFastInt4 = game:DefineFastInt("SduiRetryBudgetSec", 20)

local defineFastInt5 = game:DefineFastInt("SduiFetchTimeoutHeadroomSec", 10)

local function getRequestDeadlineSec() -- 1 equivalent call inferred from this helper
	return defineFastInt4 + defineFastInt5
end

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

local SduiRetryPolicy = {}

function SduiRetryPolicy.resolve(p)
	if p == nil then
		return getDefaultRetryOptions()
	end

	if p.mode == "none" then
		return nil
	end

	local joined = Cryo.Dictionary.join(getDefaultRetryOptions(), p.overrides)

	local retryBudgetSec = joined.retryBudgetSec
	local retryBudgetSec2

	if retryBudgetSec == nil then
		retryBudgetSec2 = defineFastInt4
	else
		retryBudgetSec2 = math.min(retryBudgetSec, defineFastInt4)
	end

	joined.retryBudgetSec = retryBudgetSec2

	return joined
end

SduiRetryPolicy.getRequestDeadlineSec = getRequestDeadlineSec

function SduiRetryPolicy.getFetchTimeoutSec()
	return getRequestDeadlineSec() + 5 -- inferred equivalent call
end

return SduiRetryPolicy
