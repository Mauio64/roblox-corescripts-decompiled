local parent = script:FindFirstAncestor("DataHydration").Parent

local Promise = require(parent.Promise)
local HttpClient = require(parent.HttpClient)

local function toRejection(p) -- 2 equivalent calls inferred from this helper
	if typeof(p) == "table" and typeof(p.errorMessage) == "string" then
		return p
	end

	return { errorMessage = tostring(p) }
end

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function pollAnalyticsOperation(data)
	local delay = data.delay or Promise.delay

	return Promise.new(function(callback, callback2, callback3)
		local flag = false
		local v = nil
		local v2 = nil

		callback3(function()
			flag = true

			if v ~= nil then
				v:cancel()
			end

			if v2 ~= nil then
				v2:cancel()
			end
		end)
		local function postQuery(p: number)
			if flag then
				return
			end

			local v3 = asPromise(fetch({
				network = data.network,
				method = "POST",
				url = data.url,
				body = data.body,
				analyticsKey = data.analyticsKey,
				decode = function(p2)
					return p2 and p2.operation or {}
				end
			}))

			v = v3
			v3:andThen(function(p2)
				if flag then
					return
				end

				if p2.done == true then
					if p2.error ~= nil then
						callback2({
							responseCode = p2.error.code,
							errorMessage = p2.error.message or "analytics operation returned an error"
						})

						return
					end

					local success, result = pcall(data.mapResult, p2)

					if success then
						callback(result)
					else
						callback2(toRejection(result)) -- inferred equivalent call
					end
				else
					if p >= 6 then
						callback2({ errorMessage = data.timeoutMessage })
						return
					end

					local v4 = delay(2)
					v2 = v4
					v4:andThen(function()
						postQuery(p + 1)
					end)
				end
			end, function(p2)
				callback2(toRejection(p2)) -- inferred equivalent call
			end)
		end

		postQuery(1)
	end)
end

return pollAnalyticsOperation
