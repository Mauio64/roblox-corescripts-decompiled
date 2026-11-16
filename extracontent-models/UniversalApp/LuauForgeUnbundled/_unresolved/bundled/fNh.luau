local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dwM")
local Promise = require(CorePackages.Packages.Promise)

local interface = t.interface({
	previousResult = t.optional(t.any),
	isResolveConditionMet = t.callback,
	retryCallback = t.callback,
	retryCount = t.number,
	retryTimeMultiplier = t.number,
	waitImpl = t.callback
})
local function retry(data)
	local retryCount = data.retryCount
	local previousResult = data.previousResult
	local isResolveConditionMet = data.isResolveConditionMet
	local retryCallback = data.retryCallback
	local retryTimeMultiplier = data.retryTimeMultiplier
	local waitImpl = data.waitImpl

	if isResolveConditionMet(previousResult) then
		return Promise.resolve(previousResult)
	end

	return Promise.new(function(callback, p2)
		coroutine.wrap(function()
			waitImpl(retryTimeMultiplier * math.pow(2, retryCount - 1))
			callback()
		end)()
	end):andThen(function()
		return retryCallback()
	end):andThen(function(p2)
		if retryCount > 1 then
			return retry(Cryo.Dictionary.join(data, {
				retryCount = retryCount - 1,
				previousResult = p2
			}))
		end

		return Promise.reject()
	end)
end

return function(p2)
	module.assert(interface(p2))

	return retry(p2)
end
