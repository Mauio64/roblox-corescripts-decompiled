local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/drj")
local validateProps = require("@luauforge/bundled/dqK").validateProps
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus
local roactNetworking = require("@luauforge/bundled/drk").RoactNetworking
local appLogging = require("@luauforge/bundled/drk").AppLogging
local module3 = require("@luauforge/bundled/drs")
local fetchStatusReducer = module3.FetchStatusReducer
local fetchStatusNamespace = module3.FetchStatusNamespace
local module4 = require("@luauforge/bundled/dsB")
local nextDataExpirationTimeReducer = module4.NextDataExpirationTimeReducer
local expirationTimeNamespace = module4.ExpirationTimeNamespace
local useRoactService = require("@luauforge/bundled/dsp").useRoactService
local module5 = require("@luauforge/bundled/dsv")
local useSelector = module5.Hooks.RoactRodux.useSelector
local useDispatch = module5.Hooks.RoactRodux.useDispatch
local omniFeedConstants = require("@luauforge/bundled/dqn").OmniFeedConstants

local module6 = require("@luauforge/bundled/dsC")
local module7 = require("@luauforge/bundled/dro")

local strictInterface = module2.strictInterface({
	isOmni = module2.boolean,
	pageType = module2.string,
	sortToRefresh = module2.string
})

local function OmniFeedAutoRefresher(data): nil
	validateProps(strictInterface, data)

	local v5 = useRoactService(roactNetworking)
	local v6 = useRoactService(appLogging)

	local sortToRefresh = data.sortToRefresh

	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)

	local v7 = useSelector(function(p2)
		local v8, v9

		if data.isOmni then
			v8 = fetchStatusNamespace.OmniRecommendations
			v9 = data.pageType
		else
			v8 = fetchStatusNamespace.GameSortToken
			v9 = sortToRefresh
		end

		local v10 = p2.Personalization[fetchStatusReducer.key][v8]

		if v10 then
			return v10[v9]
		end

		return nil
	end)

	local v8 = useSelector(function(p2)
		if data.isOmni then
			local omniRecommendationsRefreshTime = p2.OmniRecommendationsRefreshTime

			if omniRecommendationsRefreshTime then
				return omniRecommendationsRefreshTime[data.pageType]
			end
		else
			local v9 = p2.Personalization[nextDataExpirationTimeReducer.key][expirationTimeNamespace.GameSortGroup]

			if v9 then
				return v9[data.sortToRefresh]
			end
		end

		return nil
	end)

	local v9 = useDispatch()

	local v10 = module.useCallback(function()
		ref.current = v8

		if data.isOmni then
			v9(module7(
				v5,
				nil,
				data.pageType,
				nil,
				nil,
				omniFeedConstants.OmniRecommendationsRequestIntent.AutoRefresh,
				v6
			))
		else
			v9(module6(v5, sortToRefresh, nil)):catch(function() end)
		end
	end, { v8, data.isOmni, v9, v5, nil, data.pageType, v6, sortToRefresh })

	module.useEffect(function()
		if v7 ~= retrievalStatus.Done or (not v8 or v8 <= 0) or ref.current and v8 <= ref.current then
			return
		end

		local thread = task.defer(function(p2)
			ref2.current = true
			local v11 = p2 - tick()

			while v11 > 0 and ref2.current do
				local v12 = math.min(v11, 300)
				task.wait(v12)
				v11 = p2 - tick()
			end

			if ref2.current then
				v10()
				ref2.current = nil
			end
		end, v8)

		return function()
			if thread and ref2.current then
				task.cancel(thread)
				ref2.current = nil
			end
		end
	end, { v7, v8, v10 })

	return nil
end

return module.memo(OmniFeedAutoRefresher)
