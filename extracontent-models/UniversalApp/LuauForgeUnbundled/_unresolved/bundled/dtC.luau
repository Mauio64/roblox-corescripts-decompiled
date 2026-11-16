local topicInfosReducer = require("@luauforge/bundled/dqr").TopicInfosReducer
local gameSortGroups = require("@luauforge/bundled/dqn").GameSortGroups
local module = require("@luauforge/bundled/dqe")
local promiseUtilities = require("@luauforge/bundled/dqY").Utils.PromiseUtilities

local module2 = require("@luauforge/bundled/dtD")

return function(p2, p3, p4, p5, p6)
	local v5 = p3 or gameSortGroups.Games

	assert(v5, "not nil")

	return function(object)
		local v6 = {}
		local state = object:getState()

		if p4 then
			if state.Personalization[topicInfosReducer.key][p4] then
				table.insert(
					v6,
					(object:dispatch(module2(p2, state.Personalization[topicInfosReducer.key][p4], nil, p5)))
				)
			else
				module.reject()
			end
		else
			local count = #state.GameSortGroups[v5].sorts

			if p6 ~= nil then
				count = math.min(p6, count)
			end

			for i = 1, count do
				local sort = state.GameSortGroups[v5].sorts[i]
				local v7 = state.Personalization[topicInfosReducer.key][sort]

				table.insert(v6, (object:dispatch(module2(p2, v7, nil, p5))))
			end
		end

		return promiseUtilities.Batch(v6)
	end
end
