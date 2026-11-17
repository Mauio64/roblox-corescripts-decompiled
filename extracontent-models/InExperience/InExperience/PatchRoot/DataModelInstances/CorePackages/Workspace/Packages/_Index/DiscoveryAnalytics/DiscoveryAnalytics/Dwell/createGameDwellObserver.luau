local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local parent = DiscoveryAnalytics.Parent
local UnifiedLogging = require(parent.UnifiedLogging)
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields
local DwellTracker = require(script.Parent.DwellTracker)
local GameDwellItem = require(script.Parent.GameDwellItem)
local buildGameDwellEvent = require(script.Parent.buildGameDwellEvent)
local sendGameDwellEvent = require(DiscoveryAnalytics.Events.sendGameDwellEvent)

local function itemFromAnalytics(data, cell: number, data2)
	if type(data2) ~= "table" then
		return nil
	end

	local universeId = tonumber(data2.universeId)

	if not universeId or universeId <= 0 or data2.tileType == "Blank" then
		return nil
	end

	local v = calculateRowPositionFields(cell, data.itemsPerRow, data.startRowNumber)
	local topicContentsIndex = tonumber(data2.topicContentsIndex)
	local adFlag = data2.adFlag
	local v2

	if adFlag == true or adFlag == 1 then
		v2 = true
	elseif type(adFlag) == "string" then
		v2 = adFlag:lower() == "true" or adFlag:lower() == "t"
	else
		v2 = false
	end

	return {
		universeId = universeId,
		cell = cell,
		rank = (not topicContentsIndex or not (topicContentsIndex > 0) or topicContentsIndex % 1 ~= 0) and -1 or topicContentsIndex,
		row = v.rowInSort,
		rowOnPage = v.rowOnPage,
		positionInRow = v.positionInRow,
		componentType = tostring(data2.itemComponentType or data2.componentType or "unknown"),
		adFlag = v2 and 1 or 0,
		adId = not v2 and "0" or tostring(data2.adId or "0")
	}
end

local function createGameDwellObserver(data)
	local v = nil

	local function detach(value: string?) -- 2 equivalent calls inferred from this helper
		local v2 = v

		if not v2 then
			return
		end

		v = nil

		for _, connection in v2.connections do
			connection:Disconnect()
		end

		v2.tracker.close(value or "collectionReplaced")
	end

	local function createTracker(clone, p: number)
		local v2 = {
			gameSetTypeId = tostring(clone.collectionId),
			sortPos = tonumber(clone.collectionPosition) or -1,
			collectionComponentType = tostring(clone.collectionComponentType or "unknown"),
			measurementVersion = 1,
			scanDebounceMs = math.floor(p * 1000)
		}

		if data.collectionItemSize then
			v2.collectionItemSize = data.collectionItemSize
		end

		local HttpService = game:GetService("HttpService")
		local v3 = {
			now = function()
				return (math.floor(os.clock() * 1000))
			end,
			wallNow = function()
				return DateTime.now().UnixTimestampMillis
			end,
			newUuid = function()
				return HttpService:GenerateGUID(false)
			end,
			getItem = function(cell)
				return itemFromAnalytics(clone, cell, data.getItemData(cell))
			end,
			identity = GameDwellItem.identity,
			sendStarts = function(p2)
				sendGameDwellEvent("gameDwellStart", buildGameDwellEvent.starts(v2, p2), data.pageContext)
			end,
			sendEnds = function(p2)
				sendGameDwellEvent("gameDwellEnd", buildGameDwellEvent.ends(v2, p2), data.pageContext)
			end
		}

		return DwellTracker.new(v3)
	end

	return {
		attach = function(callback, p)
			detach() -- inferred equivalent call
			local collectionData = data.getCollectionData()
			local collectionId

			if type(collectionData) == "table" then
				collectionId = collectionData.collectionId
			end

			if collectionId == nil or collectionId == -1 then
				return function() end
			end

			local v2 = {
				blocked = {},
				connections = {},
				tracker = createTracker(table.clone(collectionData), p)
			}

			v = v2
			local function boundary(p2: string, flag: boolean)
				if v ~= v2 or (v2.blocked[p2] == true) == flag then
					return
				end

				v2.blocked[p2] = flag and true or nil

				if flag then
					v2.tracker.close(p2)
				elseif next(v2.blocked) == nil then
					callback()
				end
			end
			local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
			local ExperienceService = game:GetService("ExperienceService")
			v2.connections = {
				AppLifecycleObserverService.OnHide:Connect(function()
					if v == v2 then
						if (v2.blocked.background == true) == true then
							return
						end

						v2.blocked.background = true

						v2.tracker.close("background")
					end
				end),
				AppLifecycleObserverService.OnUnhide:Connect(function()
					if v == v2 then
						if (v2.blocked.background == true) == false then
							return
						end

						v2.blocked.background = nil

						if next(v2.blocked) == nil then
							callback()
						end
					end
				end),
				ExperienceService:RegisterForExperienceJoin(function()
					if v == v2 then
						if (v2.blocked.experience == true) == true then
							return
						end

						v2.blocked.experience = true

						v2.tracker.close("experience")
					end
				end),
				ExperienceService:RegisterForExperienceLeave(function()
					if v == v2 then
						if (v2.blocked.experience == true) == false then
							return
						end

						v2.blocked.experience = nil

						if next(v2.blocked) == nil then
							callback()
						end
					end
				end)
			}

			return function(value: string?)
				if v == v2 then
					detach(value) -- inferred equivalent call
				end
			end
		end,
		sample = function(p, p2)
			local v2 = v

			if not v2 then
				return
			end

			if not p2 then
				v2.tracker.close("detectorUnavailable")
			elseif next(v2.blocked) == nil then
				v2.tracker.sample(p)
			end
		end,
		focusChanged = function(p)
			local v2 = v

			if v2 and not p then
				v2.tracker.close("navigation")
			end
		end
	}
end

return createGameDwellObserver
