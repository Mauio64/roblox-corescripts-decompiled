local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ScriptContext = game:GetService("ScriptContext")

local React = require(CorePackages.Packages.React)

local FFlagCoreScriptErrorReporterIncludeScriptContext = require(script.Parent.Parent.Flags.FFlagCoreScriptErrorReporterIncludeScriptContext)

local function isCoreScript(coreScript)
	return coreScript:IsDescendantOf(CoreGui)
		or coreScript:IsDescendantOf(CorePackages)
		or FFlagCoreScriptErrorReporterIncludeScriptContext
		and coreScript:IsA("CoreScript")
		and coreScript:IsDescendantOf(ScriptContext)
end

local function createCoreScriptErrorHandler(data)
	local piiFilter = data.piiFilter
	local rateLimiter = data.rateLimiter
	local isReportableScript = data.isReportableScript or isCoreScript

	return function(p: string, p2: string, p3, p4: string?)
		if p3 == nil or not isReportableScript(p3) then
			return
		end

		local unstable_parseReactError, v = React.unstable_parseReactError(p)

		local message = unstable_parseReactError.message

		local stack = unstable_parseReactError.stack or p2

		local v2 = p4 or v

		local v3 = piiFilter:cleanPii(message)
		local v4 = piiFilter:cleanPii(stack)
		local v5

		if v2 ~= nil then
			v5 = piiFilter:cleanPii(v2)
		end

		if rateLimiter ~= nil then
			local v6 = v3 .. v4

			if rateLimiter:isRateLimited(v6) then
				return
			end

			rateLimiter:increment(v6)
		end

		for _, reporter in data.reporters do
			reporter:reportErrorDeferred(v3, v4, v5)
		end

		if data.onErrorReported ~= nil then
			data.onErrorReported()
		end
	end
end

return createCoreScriptErrorHandler
