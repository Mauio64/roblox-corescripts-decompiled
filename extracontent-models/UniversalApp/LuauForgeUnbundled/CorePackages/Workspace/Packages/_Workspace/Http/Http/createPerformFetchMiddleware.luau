local updateFetchingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Actions").UpdateFetchingStatus
local batchUpdateFetchingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Actions").BatchUpdateFetchingStatus

local function createPerformFetchMiddleware(value)
	local v5 = {}
	local flag = false
	local v6 = value or 0

	return function(callback, object)
		local function runBatchDispatcher()
			if flag then
				return
			end

			flag = true
			task.delay(v6, function()
				local v7 = v5
				v5 = {}
				flag = false

				object:dispatch(batchUpdateFetchingStatus(v7, true))
			end)
		end

		return function(data)
			if data.type == updateFetchingStatus.name then
				table.insert(v5, data)
			else
				if data.type ~= batchUpdateFetchingStatus.name or data.shouldImmediatelyDispatch then
					return callback(data)
				end

				for k, fetchingStatus in pairs(data.fetchingStatuses) do
					table.insert(v5, fetchingStatus)
				end
			end

			if not flag then
				flag = true
				task.delay(v6, function()
					local v7 = v5
					v5 = {}
					flag = false

					object:dispatch(batchUpdateFetchingStatus(v7, true))
				end)
			end

			return nil
		end
	end
end

return createPerformFetchMiddleware
