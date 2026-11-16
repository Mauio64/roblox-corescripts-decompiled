local Players = game:GetService("Players")

local module = require("@luauforge/bundled/fqO")
local mutedError = require("@luauforge/bundled/fqD").mutedError

local module2 = require("@luauforge/bundled/fqQ")
local module3 = require("@luauforge/bundled/fqE")
local module4 = require("@luauforge/bundled/fqS")

local function capQueries(list)
	if #list <= module4 then
		return list
	end

	return table.move(list, 1, module4, 1, {})
end

local function createTrendingSearchQueriesStore()
	local signal, v5 = module.createSignal({})

	local lastTime = nil
	local v6 = nil
	local v7 = false

	local function isCacheFresh(): boolean
		return lastTime ~= nil and os.clock() - lastTime < 3600
	end

	local function fetchQueriesIfNeeded(p2)
		local v8 = module3(Players)

		if lastTime ~= nil and v8 ~= v6 then
			lastTime = nil
			v6 = nil
			v5({})
		end

		if not v7 then
			local v9 = not (lastTime == nil) and os.clock() - lastTime < 3600

			if not v9 then
				v7 = true

				local flag = false
				local v10 = false
				local v11, v12 = module2(p2)

				v11:andThen(function(p3)
					if flag then
						return
					end

					v10 = true
					v7 = false
					lastTime = os.clock()
					v6 = v8
					v5(capQueries(p3))
				end, function(p3)
					if flag then
						return
					end

					v10 = true
					v7 = false
					mutedError(`Failed to fetch trending search queries: {tostring(p3)}`)
				end)

				return function()
					if flag or v10 then
						return
					end

					flag = true
					v7 = false
					v12()
				end
			end
		end

		return function() end
	end

	return { getQueries = signal, fetchQueriesIfNeeded = fetchQueriesIfNeeded }
end

return createTrendingSearchQueriesStore
