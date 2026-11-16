local EnumNetworkStatus = require(script.Parent.EnumNetworkStatus)
local buildActionName = require(script.Parent.buildActionName)
local Promise = require(script.Parent.Promise)

return function(p)
	local getStatus = require(script.Parent.getStatus)
	local status = getStatus(p)

	local function actionCreator(ids, keymapper, status2) -- 3 equivalent calls inferred from this helper
		return { ids = ids, keymapper = keymapper, status = status2, type = buildActionName(p) }
	end

	local function filter(p2, list, callback)
		local result = {}

		for _, item in ipairs(list) do
			if status(p2, callback(item)) ~= EnumNetworkStatus.Fetching then
				table.insert(result, item)
			end
		end

		return result
	end

	return function(object, list, keymapper, callback)
		local ids = filter(object:getState(), list, keymapper)

		if p.killRequestWithFilteredIds and #list > 0 and #ids == 0 then
			return Promise.reject("Request with provided IDs already fetching.")
		end

		object:dispatch(actionCreator(ids, keymapper, EnumNetworkStatus.Fetching)) -- inferred equivalent call

		return callback(object, ids):andThen(function(p2)
			object:dispatch(actionCreator(ids, keymapper, EnumNetworkStatus.Done)) -- inferred equivalent call
			return p2
		end, function(p2)
			object:dispatch(actionCreator(ids, keymapper, EnumNetworkStatus.Failed)) -- inferred equivalent call
			return Promise.reject(p2)
		end)
	end
end
