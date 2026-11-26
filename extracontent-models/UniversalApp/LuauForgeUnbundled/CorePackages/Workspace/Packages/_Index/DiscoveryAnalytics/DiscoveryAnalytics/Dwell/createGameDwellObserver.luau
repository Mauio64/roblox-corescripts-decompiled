local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/UnifiedLogging").calculateRowPositionFields
local DwellTracker = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Dwell/DwellTracker")
local GameDwellItem = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Dwell/GameDwellItem")
local buildGameDwellEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Dwell/buildGameDwellEvent")
local sendGameDwellEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendGameDwellEvent")

local function itemFromAnalytics(data, p2, data2)
	if type(data2) ~= "table" then
		return nil
	end

	local universeId = tonumber(data2.universeId)

	if not universeId or universeId <= 0 or data2.tileType == "Blank" then
		return nil
	end

	local v5 = calculateRowPositionFields(p2, data.itemsPerRow, data.startRowNumber)
	local topicContentsIndex = tonumber(data2.topicContentsIndex)
	local adFlag = data2.adFlag
	local v6

	if adFlag == true or adFlag == 1 then
		v6 = true
	else
		v6 = type(adFlag) == "string" and (adFlag:lower() == "true" or adFlag:lower() == "t")
	end

	return {
		universeId = universeId,
		cell = p2,
		rank = (not topicContentsIndex or not (topicContentsIndex > 0) or topicContentsIndex % 1 ~= 0) and -1 or topicContentsIndex,
		row = v5.rowInSort,
		rowOnPage = v5.rowOnPage,
		positionInRow = v5.positionInRow,
		componentType = tostring(data2.itemComponentType or data2.componentType or "unknown"),
		adFlag = v6 and 1 or 0,
		adId = not v6 and "0" or tostring(data2.adId or "0")
	}
end

local function createGameDwellObserver(data)
	local v5 = nil

	local function detach(value)
		local v6 = v5

		if not v6 then
			return
		end

		v5 = nil

		for k, connection in v6.connections do
			connection:Disconnect()
		end

		v6.tracker.close(value or "collectionReplaced")
	end

	local function createTracker(clone, p2)
		local v6 = {
			gameSetTypeId = tostring(clone.collectionId),
			sortPos = tonumber(clone.collectionPosition) or -1,
			collectionComponentType = tostring(clone.collectionComponentType or "unknown"),
			measurementVersion = 1,
			scanDebounceMs = math.floor(p2 * 1000)
		}

		if data.collectionItemSize then
			v6.collectionItemSize = data.collectionItemSize
		end

		local HttpService = game:GetService("HttpService")
		local v7 = {
			now = function()
				return (math.floor(os.clock() * 1000))
			end,
			wallNow = function()
				return DateTime.now().UnixTimestampMillis
			end,
			newUuid = function()
				return HttpService:GenerateGUID(false)
			end,
			getItem = function(p3)
				return itemFromAnalytics(clone, p3, data.getItemData(p3))
			end,
			identity = GameDwellItem.identity,
			sendStarts = function(p3)
				sendGameDwellEvent("gameDwellStart", buildGameDwellEvent.starts(v6, p3), data.pageContext)
			end,
			sendEnds = function(p3)
				sendGameDwellEvent("gameDwellEnd", buildGameDwellEvent.ends(v6, p3), data.pageContext)
			end
		}

		return DwellTracker.new(v7)
	end

	return {
		attach = function(callback, p2)
			local v6 = v5

			if v6 then
				v5 = nil

				for k, connection in v6.connections do
					connection:Disconnect()
				end

				v6.tracker.close("collectionReplaced")
			end

			local collectionData = data.getCollectionData()
			local collectionId = if type(collectionData) == "table" then collectionData.collectionId else nil

			if collectionId == nil or collectionId == -1 then
				return function() end
			end

			local v7 = {
				blocked = {},
				connections = {},
				tracker = createTracker(table.clone(collectionData), p2)
			}

			v5 = v7
			local function boundary(p3, p4)
				if v5 ~= v7 or (v7.blocked[p3] == true) == p4 then
					return
				end

				v7.blocked[p3] = p4 and true or nil

				if p4 then
					v7.tracker.close(p3)
				elseif next(v7.blocked) == nil then
					callback()
				end
			end
			local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
			local ExperienceService = game:GetService("ExperienceService")
			v7.connections = {
				AppLifecycleObserverService.OnHide:Connect(function()
					if v5 == v7 then
						if (v7.blocked.background == true) == true then
							return
						end

						v7.blocked.background = true

						v7.tracker.close("background")
					end
				end),
				AppLifecycleObserverService.OnUnhide:Connect(function()
					if v5 == v7 then
						if (v7.blocked.background == true) == false then
							return
						end

						v7.blocked.background = nil

						if next(v7.blocked) == nil then
							callback()
						end
					end
				end),
				ExperienceService:RegisterForExperienceJoin(function()
					if v5 == v7 then
						if (v7.blocked.experience == true) == true then
							return
						end

						v7.blocked.experience = true

						v7.tracker.close("experience")
					end
				end),
				ExperienceService:RegisterForExperienceLeave(function()
					if v5 == v7 then
						if (v7.blocked.experience == true) == false then
							return
						end

						v7.blocked.experience = nil

						if next(v7.blocked) == nil then
							callback()
						end
					end
				end)
			}

			return function(value)
				if v5 == v7 then
					local v8 = v5

					if not v8 then
						return
					end

					v5 = nil

					for k, connection in v8.connections do
						connection:Disconnect()
					end

					v8.tracker.close(value or "collectionReplaced")
				end
			end
		end,
		sample = function(p2, p3)
			local v6 = v5

			if not v6 then
				return
			end

			if not p3 then
				v6.tracker.close("detectorUnavailable")
			elseif next(v6.blocked) == nil then
				v6.tracker.sample(p2)
			end
		end,
		focusChanged = function(p2)
			local v6 = v5

			if v6 and not p2 then
				v6.tracker.close("navigation")
			end
		end
	}
end

return createGameDwellObserver
