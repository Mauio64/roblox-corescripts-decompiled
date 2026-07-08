local EnumNetworkStatus = require(script.Parent.EnumNetworkStatus)
local buildActionName = require(script.Parent.buildActionName)
local Promise = require(script.Parent.Promise)

return function(p1) -- line: 5
	-- upvalues: buildActionName (copy), EnumNetworkStatus (copy), Promise (copy)
	local v5 = require(script.Parent.getStatus)(p1)

	local function actionCreator(p2, p3, p4) -- line: 8
		-- upvalues: buildActionName (copy), p1 (copy)
		return {
			ids = p2,
			keymapper = p3,
			status = p4,
			type = buildActionName(p1)
		}
	end
	local function filter(p5, p6, p7) -- line: 17
		-- upvalues: v5 (copy), EnumNetworkStatus (copy)
		local t1 = {}

		for _, v in ipairs(p6) do
			if v5(p5, p7(v)) ~= EnumNetworkStatus.Fetching then
				table.insert(t1, v)
			end
		end

		return t1
	end

	return function(p8, p9, p10, p11) -- line: 28
		-- upvalues: filter (copy), p1 (copy), Promise (copy), EnumNetworkStatus (copy), buildActionName (copy)
		local v21 = filter(p8:getState(), p9, p10)

		if p1.killRequestWithFilteredIds and (#p9 > 0 and #v21 == 0) then
			return Promise.reject("Request with provided IDs already fetching.")
		end

		local Fetching = EnumNetworkStatus.Fetching

		p8:dispatch({
			ids = v21,
			keymapper = p10,
			status = Fetching,
			type = buildActionName(p1)
		})

		return p11(p8, v21):andThen(function(p12) -- line: 38
			-- upvalues: p8 (copy), v21 (copy), p10 (copy), EnumNetworkStatus (copy), buildActionName (copy), p1 (copy)
			local v24 = p8
			local v25 = v21
			local v26 = p10
			local Done = EnumNetworkStatus.Done

			v24:dispatch({
				ids = v25,
				keymapper = v26,
				status = Done,
				type = buildActionName(p1)
			})

			return p12
		end, function(p13) -- line: 41
			-- upvalues: p8 (copy), v21 (copy), p10 (copy), EnumNetworkStatus (copy), buildActionName (copy), p1 (copy), Promise (copy)
			local v29 = p8
			local v30 = v21
			local v31 = p10
			local Failed = EnumNetworkStatus.Failed

			v29:dispatch({
				ids = v30,
				keymapper = v31,
				status = Failed,
				type = buildActionName(p1)
			})

			return Promise.reject(p13)
		end)
	end
end
