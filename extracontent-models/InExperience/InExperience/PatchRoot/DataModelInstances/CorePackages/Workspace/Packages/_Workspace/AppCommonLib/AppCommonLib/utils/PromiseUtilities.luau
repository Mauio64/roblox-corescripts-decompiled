local parent = script:FindFirstAncestor("AppCommonLib").Parent

local Result = require(parent.Result)
local Promise = require(parent.Promise)
local PromiseUtilities = {}

function PromiseUtilities.Batch(items, callback)
	assert(type(items) == "table", "PromiseUtilities expects a list of Promises!")
	local count = 0

	for _, item in pairs(items) do
		assert(Promise.is(item), "PromiseUtilities expects a list of Promises!")
		count += 1
	end

	return Promise.new(function(callback2, _)
		local count2 = 0
		local v = {}

		local function promiseCompleted(k, p, p2) -- 2 equivalent calls inferred from this helper
			v[k] = Result.new(p, p2)
			count2 += 1

			if count2 == count then
				callback2(v)
			end
		end

		if next(items) == nil then
			callback2(v)
		end

		for k, item in pairs(items) do
			item:andThen(function(p, ...)
				if select("#", ...) > 0 then
					warn("Promises in PromiseUtilities.Batch should not return tuple")
				end

				promiseCompleted(k, true, p) -- inferred equivalent call
			end, function(p)
				promiseCompleted(k, false, p) -- inferred equivalent call

				if callback then
					callback(p)
				end
			end)
		end
	end)
end

function PromiseUtilities.CountResults(items)
	local count = 0
	local count2 = 0

	for _, item in pairs(items) do
		local unwrapped, _ = item:unwrap()

		if not unwrapped then
			count2 += 1
		end

		count += 1
	end

	return {
		successCount = count - count2,
		failureCount = count2,
		totalCount = count
	}
end

return PromiseUtilities
