local Http = script:FindFirstAncestor("Http")
local Actions = require(Http.Actions)
local UpdateFetchingStatus = Actions.UpdateFetchingStatus
local Actions2 = require(Http.Actions)
local BatchUpdateFetchingStatus = Actions2.BatchUpdateFetchingStatus

local function createPerformFetchMiddleware(value)
	local v = {}
	local flag = false
	local v2 = value or 0

	return function(callback, object)
		local function runBatchDispatcher() -- 1 equivalent call inferred from this helper
			if flag then
				return
			end

			flag = true
			task.delay(v2, function()
				local v3 = v
				v = {}
				flag = false

				object:dispatch(BatchUpdateFetchingStatus(v3, true))
			end)
		end

		return function(data)
			if data.type == UpdateFetchingStatus.name then
				table.insert(v, data)
			else
				if data.type ~= BatchUpdateFetchingStatus.name or data.shouldImmediatelyDispatch then
					return callback(data)
				end

				for _, fetchingStatus in pairs(data.fetchingStatuses) do
					table.insert(v, fetchingStatus)
				end
			end

			runBatchDispatcher() -- inferred equivalent call
			return nil
		end
	end
end

return createPerformFetchMiddleware
