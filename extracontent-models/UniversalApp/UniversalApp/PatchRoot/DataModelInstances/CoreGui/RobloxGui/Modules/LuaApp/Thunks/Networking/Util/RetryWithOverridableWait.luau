local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(CorePackages.Packages.Promise)
local v6 = t.interface({
	previousResult = t.optional(t.any),
	isResolveConditionMet = t.callback,
	retryCallback = t.callback,
	retryCount = t.number,
	retryTimeMultiplier = t.number,
	waitImpl = t.callback
})

local function retry(p1) -- line: 96
	-- upvalues: Promise (copy), retry (copy), Cryo (copy)
	local retryCount = p1.retryCount
	local previousResult = p1.previousResult
	local isResolveConditionMet = p1.isResolveConditionMet
	local retryCallback = p1.retryCallback
	local retryTimeMultiplier = p1.retryTimeMultiplier
	local waitImpl = p1.waitImpl

	if isResolveConditionMet(previousResult) then
		return Promise.resolve(previousResult)
	end

	return Promise.new(function(resolve, _) -- line: 108
		-- upvalues: waitImpl (copy), retryTimeMultiplier (copy), retryCount (copy)
		coroutine.wrap(function() -- line: 109
			-- upvalues: waitImpl (copy), retryTimeMultiplier (copy), retryCount (copy), resolve (copy)
			waitImpl(retryTimeMultiplier * math.pow(2, retryCount - 1))
			resolve()
		end)()
	end):andThen(function() -- line: 116
		-- upvalues: retryCallback (copy)
		return retryCallback()
	end):andThen(function(p3) -- line: 119
		-- upvalues: retryCount (copy), retry (copy), Cryo (copy), p1 (copy), Promise (copy)
		if retryCount > 1 then
			return retry(Cryo.Dictionary.join(p1, {
				retryCount = retryCount - 1,
				previousResult = p3
			}))
		end

		return Promise.reject()
	end)
end

return function(p4) -- line: 131
	-- upvalues: ArgCheck (copy), v6 (copy), retry (copy)
	ArgCheck.assert(v6(p4))

	return retry(p4)
end
