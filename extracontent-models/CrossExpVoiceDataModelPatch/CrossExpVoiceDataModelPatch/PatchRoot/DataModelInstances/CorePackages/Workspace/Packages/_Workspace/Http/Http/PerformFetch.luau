local Http = script:FindFirstAncestor("Http")
local parent = Http.Parent

local Result = require(parent.Result)
local Promise = require(parent.Promise)

local AppCommonLib = require(parent.AppCommonLib)
local PromiseUtilities = AppCommonLib.Utils.PromiseUtilities
local Enum2 = require(Http.Enum)
local RetrievalStatus = Enum2.RetrievalStatus
local Actions = require(Http.Actions)
local BatchUpdateFetchingStatus = Actions.BatchUpdateFetchingStatus

local PerformFetch = {}

local v = {}

function PerformFetch.ClearOutstandingPromiseStatus()
	v = {}
end

local function singleFetchKeymapper(p)
	return p
end

function PerformFetch.GetStatus(p, value)
	assert(typeof(p) == "table")
	assert(typeof(value) == "string")
	assert(#value > 0)
	return p.FetchingStatus[value] or RetrievalStatus.NotStarted
end

function PerformFetch.Single(value, callback)
	assert(typeof(value) == "string")
	assert(typeof(callback) == "function")
	assert(#value > 0)

	return function(p)
		return PerformFetch.Batch({ value }, singleFetchKeymapper, function(p2, list)
			assert(#list == 1)

			local v2 = callback(p2)
			assert(Promise.is(v2))

			return v2:andThen(function(...)
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
		end)(p):andThen(function(p2)
			local unwrapped, v2 = p2[value]:unwrap()

			if unwrapped then
				return Promise.resolve(v2)
			end

			return Promise.reject(v2)
		end)
	end
end

function PerformFetch.Batch(list, callback, callback2)
	assert(typeof(list) == "table")
	assert(typeof(callback) == "function")
	assert(typeof(callback2) == "function")

	return function(object)
		local v2 = {}
		local v3 = {}
		local v4 = {}

		for _, item in ipairs(list) do
			local v5 = callback(item)
			local v6 = v[v5]

			if v6 then
				v2[v5] = v6
			else
				table.insert(v3, item)
				v4[item] = v5
			end
		end

		local v5 = nil
		local v6 = Promise.new(function(p)
			v5 = p
		end)
		local v7

		if #v3 > 0 then
			local v8 = {}

			for _, v9 in pairs(v4) do
				table.insert(v8, { key = v9, status = RetrievalStatus.Fetching })
				v[v9] = v6
			end

			if #v8 > 0 then
				object:dispatch(BatchUpdateFetchingStatus(v8))
			end

			v7 = callback2(object, v3)
			assert(Promise.is(v7))
		else
			v7 = Promise.resolve({})
		end

		v7:andThen(function(options)
			local v8 = options or {}

			return PromiseUtilities.Batch(v2):andThen(function(items)
				local result = {}

				for k, item in pairs(items) do
					local _, v9 = item:unwrap()
					result[k] = v9[k]
				end

				return v8, result
			end)
		end, function()
			assert(false, "PerformFetch fetchFunctor should never reject")
		end):andThen(function(p, p2)
			local v8 = {}

			for _, v9 in pairs(v4) do
				local v10 = p[v9]

				if Result.is(v10) then
					p2[v9] = v10
				else
					p2[v9] = Result.error()
				end

				table.insert(v8, {
					key = v9,
					status = p2[v9]:unwrap() and RetrievalStatus.Done or RetrievalStatus.Failed
				})

				v[v9] = nil
			end

			if #v8 > 0 then
				object:dispatch(BatchUpdateFetchingStatus(v8))
			end

			return p2
		end):andThen(function(p)
			v5(p)
		end)

		return v6
	end
end

return PerformFetch
