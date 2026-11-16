local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local Signals = require(parent.Signals)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local HomeConstants = require(Home.HomeConstants)
local refreshHomePage = require(Home.refreshHomePage)

local defineFastInt = game:DefineFastInt("SduiHomePageAutoRefreshIntervalSeconds", 10800)

local function defaultSchedule(p: number, fn) -- 2 equivalent calls inferred from this helper
	local flag = true
	local thread = task.defer(function()
		local v = p

		while v > 0 and flag do
			v -= task.wait((math.min(v, 300)))
		end

		if flag then
			flag = false
			fn()
		end
	end)
	return function()
		if flag then
			flag = false
			task.cancel(thread)
		end
	end
end

local function createHomePageAutoRefreshStore()
	local v = nil
	local v2 = nil

	local function clearTimer() -- 2 equivalent calls inferred from this helper
		if v then
			v()
			v = nil
		end
	end

	local function stop() -- 1 equivalent call inferred from this helper
		if v2 then
			v2()
			v2 = nil
		end

		clearTimer() -- inferred equivalent call
	end

	local function scheduleRefresh(defineFastInt2: number)
		local function fn()
			v = nil
			local v3 = refreshHomePage(HomeConstants.RequestIntent.AutoRefresh, nil, false)

			if v3 then
				v3:catch(function(p)
					warn("We failed to auto-refresh SDUI Home!", p)

					if defineFastInt > 0 then
						scheduleRefresh(defineFastInt)
					end
				end)
			end
		end

		v = defaultSchedule(defineFastInt2, fn) -- inferred equivalent call
	end

	return {
		start = function()
			stop() -- inferred equivalent call
			v2 = Signals.createEffect(function(p)
				local dataUpdatedTimestamp = getSduiApiStore().getDataUpdatedTimestamp(HomeConstants.ConfigKey, p)
				clearTimer() -- inferred equivalent call

				if dataUpdatedTimestamp and defineFastInt > 0 then
					local v3 = math.max(0, dataUpdatedTimestamp + defineFastInt - os.clock())

					local function fn()
						v = nil
						local v4 = refreshHomePage(HomeConstants.RequestIntent.AutoRefresh, nil, false)

						if v4 then
							v4:catch(function(p2)
								warn("We failed to auto-refresh SDUI Home!", p2)

								if defineFastInt > 0 then
									scheduleRefresh(defineFastInt)
								end
							end)
						end
					end

					v = defaultSchedule(v3, fn) -- inferred equivalent call
				end
			end)
			return stop
		end
	}
end

return createHomePageAutoRefreshStore
