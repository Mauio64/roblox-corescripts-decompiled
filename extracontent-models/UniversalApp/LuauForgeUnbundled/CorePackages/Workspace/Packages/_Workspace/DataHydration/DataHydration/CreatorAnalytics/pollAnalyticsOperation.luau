local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local function toRejection(p2)
	if typeof(p2) == "table" and typeof(p2.errorMessage) == "string" then
		return p2
	end

	return { errorMessage = tostring(p2) }
end

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function pollAnalyticsOperation(data)
	local delay2 = data.delay or Promise.delay

	return Promise.new(function(callback, callback2, callback3)
		local flag = false
		local v5 = nil
		local v6 = nil

		callback3(function()
			flag = true

			if v5 ~= nil then
				v5:cancel()
			end

			if v6 ~= nil then
				v6:cancel()
			end
		end)
		local function postQuery(p2)
			if flag then
				return
			end

			local v7 = asPromise(fetch({
				network = data.network,
				method = "POST",
				url = data.url,
				body = data.body,
				analyticsKey = data.analyticsKey,
				decode = function(p3)
					return p3 and p3.operation or {}
				end
			}))

			v5 = v7
			v7:andThen(function(p3)
				if flag then
					return
				end

				if p3.done == true then
					if p3.error ~= nil then
						callback2({
							responseCode = p3.error.code,
							errorMessage = p3.error.message or "analytics operation returned an error"
						})

						return
					end

					local success, result = pcall(data.mapResult, p3)

					if success then
						callback(result)
					else
						callback2((typeof(result) ~= "table" or typeof(result.errorMessage) ~= "string") and {
							errorMessage = tostring(result)
						} or result)
					end
				else
					if p2 >= 6 then
						callback2({ errorMessage = data.timeoutMessage })
						return
					end

					local v8 = delay2(2)
					v6 = v8
					v8:andThen(function()
						postQuery(p2 + 1)
					end)
				end
			end, function(p3)
				callback2((typeof(p3) ~= "table" or typeof(p3.errorMessage) ~= "string") and {
					errorMessage = tostring(p3)
				} or p3)
			end)
		end

		postQuery(1)
	end)
end

return pollAnalyticsOperation
