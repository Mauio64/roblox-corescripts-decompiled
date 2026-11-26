local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Result")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Promise")

local promiseUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/AppCommonLib").Utils.PromiseUtilities
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Enum").RetrievalStatus
local batchUpdateFetchingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Actions").BatchUpdateFetchingStatus

local v5 = {}

local v6 = {}

function v5.ClearOutstandingPromiseStatus()
	v6 = {}
end

local function singleFetchKeymapper(p2)
	return p2
end

function v5.GetStatus(p2, value)
	assert(typeof(p2) == "table")
	assert(typeof(value) == "string")
	assert(#value > 0)
	return p2.FetchingStatus[value] or retrievalStatus.NotStarted
end

function v5.Single(value, callback)
	assert(typeof(value) == "string")
	assert(typeof(callback) == "function")
	assert(#value > 0)

	return function(p2)
		return v5.Batch({ value }, singleFetchKeymapper, function(p3, list)
			assert(#list == 1)

			local v7 = callback(p3)
			assert(Promise.is(v7))

			return v7:andThen(function(...)
				assert(#{ ... } <= 1)
				return Promise.resolve({
					[value] = Result.new(true, (...))
				})
			end, function(...)
				assert(#{ ... } <= 1)
				return Promise.resolve({
					[value] = Result.new(false, (...))
				})
			end)
		end)(p2):andThen(function(p3)
			local unwrapped, v7 = p3[value]:unwrap()

			if unwrapped then
				return Promise.resolve(v7)
			end

			return Promise.reject(v7)
		end)
	end
end

function v5.Batch(list, callback, callback2)
	assert(typeof(list) == "table")
	assert(typeof(callback) == "function")
	assert(typeof(callback2) == "function")

	return function(object)
		local v7 = {}
		local v8 = {}
		local v9 = {}

		for i, item in ipairs(list) do
			local v10 = callback(item)
			local v11 = v6[v10]

			if v11 then
				v7[v10] = v11
			else
				table.insert(v8, item)
				v9[item] = v10
			end
		end

		local v10 = nil
		local v11 = Promise.new(function(p2)
			v10 = p2
		end)
		local v12

		if #v8 > 0 then
			local v13 = {}

			for k, v14 in pairs(v9) do
				table.insert(v13, { key = v14, status = retrievalStatus.Fetching })
				v6[v14] = v11
			end

			if #v13 > 0 then
				object:dispatch(batchUpdateFetchingStatus(v13))
			end

			v12 = callback2(object, v8)
			assert(Promise.is(v12))
		else
			v12 = Promise.resolve({})
		end

		v12:andThen(function(options)
			local v13 = options or {}

			return promiseUtilities.Batch(v7):andThen(function(items)
				local result = {}

				for k, item in pairs(items) do
					local unwrapped, v14 = item:unwrap()
					result[k] = v14[k]
				end

				return v13, result
			end)
		end, function()
			assert(false, "PerformFetch fetchFunctor should never reject")
		end):andThen(function(p2, p3)
			local v13 = {}

			for k, v14 in pairs(v9) do
				local v15 = p2[v14]

				if Result.is(v15) then
					p3[v14] = v15
				else
					p3[v14] = Result.error()
				end

				table.insert(v13, {
					key = v14,
					status = p3[v14]:unwrap() and retrievalStatus.Done or retrievalStatus.Failed
				})

				v6[v14] = nil
			end

			if #v13 > 0 then
				object:dispatch(batchUpdateFetchingStatus(v13))
			end

			return p3
		end):andThen(function(p2)
			v10(p2)
		end)

		return v11
	end
end

return v5
