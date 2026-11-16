local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Signals")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities").getSduiApiStore
local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")
local refreshHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/refreshHomePage")

local defineFastInt = game:DefineFastInt("SduiHomePageAutoRefreshIntervalSeconds", 10800)

local function defaultSchedule(p2, callback)
	local flag = true
	local thread = task.defer(function()
		local v5 = p2

		while v5 > 0 and flag do
			v5 -= task.wait((math.min(v5, 300)))
		end

		if flag then
			flag = false
			callback()
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
	local fn = nil
	local v5 = nil

	local function clearTimer()
		if fn then
			fn()
			fn = nil
		end
	end

	local function stop()
		if v5 then
			v5()
			v5 = nil
		end

		if fn then
			fn()
			fn = nil
		end
	end

	local function scheduleRefresh(defineFastInt2)
		local function fn2()
			fn = nil
			local v6 = refreshHomePage(HomeConstants.RequestIntent.AutoRefresh, nil, false)

			if v6 then
				v6:catch(function(p2)
					warn("We failed to auto-refresh SDUI Home!", p2)

					if defineFastInt > 0 then
						scheduleRefresh(defineFastInt)
					end
				end)
			end
		end

		local flag = true
		local thread = task.defer(function()
			local v6 = defineFastInt2

			while v6 > 0 and flag do
				v6 -= task.wait((math.min(v6, 300)))
			end

			if flag then
				flag = false
				fn2()
			end
		end)
		fn = function()
			if flag then
				flag = false
				task.cancel(thread)
			end
		end
	end

	return {
		start = function()
			if v5 then
				v5()
				v5 = nil
			end

			if fn then
				fn()
				fn = nil
			end

			v5 = Signals.createEffect(function(p2)
				local dataUpdatedTimestamp = getSduiApiStore().getDataUpdatedTimestamp(
					HomeConstants.ConfigKey,
					p2
				)

				if fn then
					fn()
					fn = nil
				end

				if dataUpdatedTimestamp and defineFastInt > 0 then
					local v6 = math.max(0, dataUpdatedTimestamp + defineFastInt - os.clock())

					local function fn2()
						fn = nil
						local v7 = refreshHomePage(HomeConstants.RequestIntent.AutoRefresh, nil, false)

						if v7 then
							v7:catch(function(p3)
								warn("We failed to auto-refresh SDUI Home!", p3)

								if defineFastInt > 0 then
									scheduleRefresh(defineFastInt)
								end
							end)
						end
					end

					local flag = true
					local thread = task.defer(function()
						local v7 = v6

						while v7 > 0 and flag do
							v7 -= task.wait((math.min(v7, 300)))
						end

						if flag then
							flag = false
							fn2()
						end
					end)
					fn = function()
						if flag then
							flag = false
							task.cancel(thread)
						end
					end
				end
			end)
			return stop
		end
	}
end

return createHomePageAutoRefreshStore
