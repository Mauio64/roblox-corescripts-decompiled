local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/Result")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/Promise")

return {
	Batch = function(items, callback)
		assert(type(items) == "table", "PromiseUtilities expects a list of Promises!")
		local count = 0

		for k, item in pairs(items) do
			assert(Promise.is(item), "PromiseUtilities expects a list of Promises!")
			count += 1
		end

		return Promise.new(function(callback2, p2)
			local count2 = 0
			local v5 = {}

			local function promiseCompleted(p3, p4, p5)
				v5[p3] = Result.new(p4, p5)
				count2 += 1

				if count2 == count then
					callback2(v5)
				end
			end

			if next(items) == nil then
				callback2(v5)
			end

			for k, item in pairs(items) do
				item:andThen(function(p3, ...)
					if select("#", ...) > 0 then
						warn("Promises in PromiseUtilities.Batch should not return tuple")
					end

					v5[k] = Result.new(true, p3)
					count2 += 1

					if count2 == count then
						callback2(v5)
					end
				end, function(p3)
					v5[k] = Result.new(false, p3)
					count2 += 1

					if count2 == count then
						callback2(v5)
					end

					if callback then
						callback(p3)
					end
				end)
			end
		end)
	end,
	CountResults = function(items)
		local count = 0
		local count2 = 0

		for k, item in pairs(items) do
			local unwrapped, v5 = item:unwrap()

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
}
