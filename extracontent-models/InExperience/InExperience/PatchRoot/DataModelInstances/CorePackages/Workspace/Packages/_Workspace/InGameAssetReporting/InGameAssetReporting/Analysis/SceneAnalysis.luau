local Players = game:GetService("Players")

local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.Analysis.Types)
local GetFIntIGARRaycastTargetCount = require(InGameAssetReporting.Flags.GetFIntIGARRaycastTargetCount)
local GetFIntIGARSubtreeDivergenceThresholdPerMille = require(InGameAssetReporting.Flags.GetFIntIGARSubtreeDivergenceThresholdPerMille)
local extractAssetIdsFromInstance = require(InGameAssetReporting.Analysis.extractAssetIdsFromInstance)

local v = Random.new()

function getRandomSampleUniformDisk(vector2: Vector2, p: number, vector2_2: Vector2)
	local count = 0

	while true do
		local v2 = v:NextNumber() * 2 * 3.141592653589793
		local v3 = math.sqrt((v:NextNumber())) * p
		local v4 = math.cos(v2) * v3
		local v5 = math.sin(v2) * v3
		local v6 = vector2.X + v4
		local v7 = vector2.Y + v5
		count += 1

		if count > 6 then
			return vector2
		end

		if v6 >= 0 and v6 <= vector2_2.X and v7 >= 0 and v7 <= vector2_2.Y then
			return Vector2.new(v6, v7)
		end
	end
end

function interpretAnnotation(vector2: Vector2, p: number, callback)
	local flag = false

	local v2 = {
		hitCountMap = {},
		stats = {
			targetCount = GetFIntIGARRaycastTargetCount(),
			completedCount = 0,
			hitCount = 0,
			resumptionCount = 0,
			wallTime = 0,
			computeTime = 0
		},
		highlights = {},
		topLevelObjects = {},
		errorReason = nil,
		cancel = function()
			flag = true
		end
	}

	v2.raycastComputation = coroutine.create(function()
		callback(v2)
	end)

	local currentCamera = workspace.CurrentCamera

	if currentCamera == nil then
		v2.errorReason = "No camera"
		return v2
	end

	local viewportSize = currentCamera.ViewportSize

	if vector2.X < 0 or vector2.X > viewportSize.X or vector2.Y < 0 or vector2.Y > viewportSize.Y then
		v2.errorReason = "Coordinates out of bounds"
		return v2
	end

	if p <= 0 or math.max(viewportSize.X, viewportSize.Y) < p then
		v2.errorReason = "Invalid radius"
		return v2
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		v2.errorReason = "No local player"
		return v2
	end

	local instances = { localPlayer.Character }

	v2.raycastComputation = coroutine.create(function()
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = instances
		raycastParams.IgnoreWater = true

		local lastTime = os.clock()
		local lastTime2 = os.clock()

		for _ = 1, v2.stats.targetCount do
			if flag then
				break
			end

			if lastTime2 + 1 / 90 < os.clock() then
				v2.stats.computeTime += os.clock() - lastTime2
				task.wait()
				lastTime2 = os.clock()
				v2.stats.resumptionCount += 1

				if flag then
					break
				end
			end

			local randomSampleUniformDisk = getRandomSampleUniformDisk(vector2, p, viewportSize)

			local viewportPointToRay = currentCamera:ViewportPointToRay(
				randomSampleUniformDisk.X,
				randomSampleUniformDisk.Y
			)
			local raycastResult = nil

			for _ = 1, 5 do
				raycastResult = workspace:Raycast(
					viewportPointToRay.Origin,
					viewportPointToRay.Direction * 5000,
					raycastParams
				)

				if raycastResult == nil then
					break
				end

				local instance = raycastResult.Instance

				if (1 - instance.Transparency) * (1 - instance.LocalTransparencyModifier) > 0.05 then
					break
				end

				table.insert(instances, instance)
				raycastParams.FilterDescendantsInstances = instances
				raycastResult = nil
			end

			if raycastResult then
				local instance = raycastResult.Instance

				if instance ~= nil then
					v2.stats.hitCount += 1
				end

				local v3 = nil

				while
					instance ~= nil
					and (instance:IsA("PVInstance") or instance:IsA("Accessory"))
					and instance ~= workspace
				do
					if not v2.hitCountMap[instance] then
						v2.hitCountMap[instance] = { raycastHits = 0, children = {} }
					end

					v2.hitCountMap[instance].raycastHits += 1

					if v3 then
						v2.hitCountMap[instance].children[v3] = true
					end

					v3 = instance
					instance = instance.Parent
				end

				if v3 then
					v2.topLevelObjects[v3] = (v2.topLevelObjects[v3] or 0) + 1
				end
			end

			v2.stats.completedCount += 1
		end

		v2.stats.wallTime = os.clock() - lastTime
		v2.stats.computeTime += os.clock() - lastTime2

		callback(v2)
	end)

	return v2
end

function createPlayerCharacterReferenceToPlayerMap(list)
	local playerCharacterReferenceToPlayerMap = {}

	for _, item in ipairs(list) do
		local character = item.Character

		if character then
			playerCharacterReferenceToPlayerMap[character] = item
		end
	end

	return playerCharacterReferenceToPlayerMap
end

function descendingOrderBySecondElement(list, list2): boolean
	return list[2] > list2[2]
end

function createTraversalTaskList(p, items)
	local playerCharacterReferenceToPlayerMap = createPlayerCharacterReferenceToPlayerMap(Players:GetPlayers())

	local v2 = {}
	local result = {}
	local result2 = {}

	for k, item in pairs(items) do
		table.insert(v2, { k, item })
	end

	table.sort(v2, descendingOrderBySecondElement)

	local v3 = GetFIntIGARSubtreeDivergenceThresholdPerMille() / 1000

	for _, v4 in ipairs(v2) do
		local instance = v4[1]
		local count3 = v4[2]

		if playerCharacterReferenceToPlayerMap[instance] == nil then
			local instance2 = instance
			local count = 0

			while p[instance2] do
				local v5 = p[instance2]
				local raycastHits = v5.raycastHits
				local children = v5.children
				local count2 = 0

				for k, _ in pairs(children) do
					if p[k] then
						count2 += 1
					end
				end

				if count2 == 0 then
					break
				end

				local maxRaycastHits = 0

				for k, _ in pairs(children) do
					if p[k] then
						maxRaycastHits = math.max(maxRaycastHits, p[k].raycastHits)
					end
				end

				if maxRaycastHits / raycastHits < v3 then
					break
				end

				local v6 = 0
				instance2 = nil

				for k, _ in pairs(children) do
					if not (p[k] and v6 < p[k].raycastHits) then
						continue
					end

					v6 = p[k].raycastHits
					instance2 = k
				end

				count += 1
			end

			table.insert(result, { instance = instance2, count = count3 })

			if instance2 ~= instance then
				table.insert(result, { instance = instance, count = count3 })
			end
		else
			table.insert(result2, {
				player = playerCharacterReferenceToPlayerMap[instance],
				count = count3
			})
		end
	end

	return result, result2
end

function mutateMergeExtractedAssets(p, data, data2)
	for _, v2 in ipairs(data2.Image) do
		if p[v2] then
			continue
		end

		p[v2] = true
		table.insert(data.Image, v2)
	end

	for _, v2 in ipairs(data2.Mesh) do
		if p[v2] then
			continue
		end

		p[v2] = true
		table.insert(data.Mesh, v2)
	end

	for _, v2 in ipairs(data2.Video) do
		if p[v2] then
			continue
		end

		p[v2] = true
		table.insert(data.Video, v2)
	end

	for _, v2 in ipairs(data2.Model) do
		if p[v2] then
			continue
		end

		p[v2] = true
		table.insert(data.Model, v2)
	end

	for _, v2 in ipairs(data2.Package) do
		if p[v2.id] then
			continue
		end

		p[v2.id] = true
		table.insert(data.Package, v2)
	end

	if game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
		for _, v2 in ipairs(data2.Text) do
			if p[v2] then
				continue
			end

			p[v2] = true
			table.insert(data.Text, v2)
		end
	end
end

function interpretInstanceListForGUIObjects(list)
	local v2 = {
		hitCountMap = {},
		stats = {
			targetCount = 0,
			completedCount = 0,
			hitCount = 0,
			resumptionCount = 0,
			wallTime = 0,
			computeTime = 0
		},
		highlights = {},
		topLevelObjects = {},
		errorReason = nil,
		cancel = function() end
	}

	for _, guiObject in ipairs(list) do
		local v3 = nil

		while guiObject ~= nil and guiObject:IsA("GuiObject") do
			if not v2.hitCountMap[guiObject] then
				v2.hitCountMap[guiObject] = { raycastHits = 0, children = {} }
			end

			v2.hitCountMap[guiObject].raycastHits += 1

			if v3 then
				v2.hitCountMap[guiObject].children[v3] = true
			end

			v3 = guiObject
			guiObject = guiObject.Parent
		end

		if v3 then
			v2.topLevelObjects[v3] = (v2.topLevelObjects[v3] or 0) + 1
		end
	end

	return v2
end

function interpretAndExtractItemsFromInstanceForPreciseSelection(instance)
	local v2 = {
		extractedAssets = {
			Package = {},
			Model = {},
			Image = {},
			Mesh = {},
			Text = {},
			Video = {}
		},
		extractedPlayers = {},
		cancel = function() end,
		stats = {
			hitCountMapSize = 0,
			topLevelObjectsSize = 0,
			instancesTraversed = 0,
			traversalTaskListSize = 0,
			traversalTasksCompleted = 0,
			playersCount = 0,
			resumptionCount = 0,
			wallTime = 0,
			computeTime = 0,
			raycastTargetCount = 0,
			raycastCompletedCount = 0,
			raycastResumptionCount = 0,
			raycastComputeTime = 0
		}
	}

	v2.computation = coroutine.create(function() end)

	if not instance then
		return v2
	end

	local playerCharacterReferenceToPlayerMap = createPlayerCharacterReferenceToPlayerMap(Players:GetPlayers())
	local instance2 = instance
	local v3 = {}

	while
		instance2 ~= nil
		and (instance2:IsA("PVInstance") or instance2:IsA("Accessory") or instance2:IsA("GuiObject") or instance2:IsA("FaceInstance"))
		and instance2 ~= workspace
	do
		if playerCharacterReferenceToPlayerMap[instance2] ~= nil then
			table.insert(v2.extractedPlayers, {
				player = playerCharacterReferenceToPlayerMap[instance2],
				count = 1
			})

			return v2
		end

		local v4 = extractAssetIdsFromInstance(instance2)

		if v4 then
			mutateMergeExtractedAssets(v3, v2.extractedAssets, v4)
		end

		v2.stats.instancesTraversed += 1

		instance2 = instance2.Parent
	end

	local children = instance:GetChildren()

	for _, child in ipairs(children) do
		local v4 = extractAssetIdsFromInstance(child)

		if v4 then
			mutateMergeExtractedAssets(v3, v2.extractedAssets, v4)
		end

		v2.stats.instancesTraversed += 1
	end

	return v2
end

function extractItemsFromInterpretations(list, callback)
	local flag = false

	local itemsFromInterpretations = {
		extractedAssets = {
			Package = {},
			Model = {},
			Image = {},
			Mesh = {},
			Text = {},
			Video = {}
		},
		extractedPlayers = {},
		cancel = function()
			flag = true
		end,
		stats = {
			hitCountMapSize = 0,
			topLevelObjectsSize = 0,
			instancesTraversed = 0,
			traversalTaskListSize = 0,
			traversalTasksCompleted = 0,
			playersCount = 0,
			resumptionCount = 0,
			wallTime = 0,
			computeTime = 0,
			raycastTargetCount = 0,
			raycastCompletedCount = 0,
			raycastResumptionCount = 0,
			raycastComputeTime = 0
		}
	}

	itemsFromInterpretations.computation = coroutine.create(function()
		callback(itemsFromInterpretations)
	end)

	for _, item in ipairs(list) do
		item.cancel()
		itemsFromInterpretations.stats.raycastTargetCount += item.stats.targetCount
		itemsFromInterpretations.stats.raycastCompletedCount += item.stats.completedCount
		itemsFromInterpretations.stats.raycastResumptionCount += item.stats.resumptionCount
		itemsFromInterpretations.stats.raycastComputeTime += item.stats.computeTime
	end

	local lastTime = os.clock()

	local v2 = {}
	local v3 = {}

	for _, item in ipairs(list) do
		for k, hitCount in pairs(item.hitCountMap) do
			if not v2[k] then
				v2[k] = { raycastHits = 0, children = {} }

				itemsFromInterpretations.stats.hitCountMapSize += 1
			end

			v2[k].raycastHits += hitCount.raycastHits

			for k2, _ in pairs(hitCount.children) do
				v2[k].children[k2] = true
			end
		end

		for k, topLevelObject in pairs(item.topLevelObjects) do
			local v4 = v3[k]

			if not v4 then
				itemsFromInterpretations.stats.topLevelObjectsSize += 1
			end

			v3[k] = (v4 or 0) + topLevelObject
		end
	end

	local traversalTaskList, extractedPlayers = createTraversalTaskList(v2, v3)

	itemsFromInterpretations.extractedPlayers = extractedPlayers
	itemsFromInterpretations.stats.playersCount = #extractedPlayers

	itemsFromInterpretations.stats.wallTime = os.clock() - lastTime
	itemsFromInterpretations.stats.traversalTaskListSize = #traversalTaskList

	itemsFromInterpretations.computation = coroutine.create(function()
		local lastTime2 = os.clock()
		local lastTime3 = os.clock()

		local set = {}
		local v4 = {}

		local function fn(): boolean -- 2 equivalent calls inferred from this helper
			return lastTime3 + 1 / 90 < os.clock()
		end

		local function fn2() -- 2 equivalent calls inferred from this helper
			itemsFromInterpretations.stats.computeTime += os.clock() - lastTime3
			task.wait()
			lastTime3 = os.clock()
			itemsFromInterpretations.stats.resumptionCount += 1
		end

		for _, traversalTask in ipairs(traversalTaskList) do
			local v5 = {}

			table.insert(v5, traversalTask.instance)
			local v6 = {}

			while #v5 > 0 do
				if fn() then -- inferred equivalent call
					fn2() -- inferred equivalent call

					if flag then
						itemsFromInterpretations.stats.wallTime += os.clock() - lastTime2
						callback(itemsFromInterpretations)
						return
					end
				end

				local v7 = table.remove(v5)

				if set[v7] then
					continue
				end

				table.insert(v6, v7)

				local children = v7:GetChildren()
				local v8 = {}

				for _, child in pairs(children) do
					table.insert(v8, { child, not v2[child] and 0 or v2[child].raycastHits })
				end

				table.sort(v8, descendingOrderBySecondElement)

				for _, v9 in ipairs(v8) do
					table.insert(v5, v9[1])
				end

				set[v7] = true
			end

			while #v6 > 0 do
				if fn() then -- inferred equivalent call
					fn2() -- inferred equivalent call

					if flag then
						itemsFromInterpretations.stats.wallTime += os.clock() - lastTime2
						callback(itemsFromInterpretations)
						return
					end
				end

				local v7 = extractAssetIdsFromInstance((table.remove(v6)))

				if v7 then
					mutateMergeExtractedAssets(v4, itemsFromInterpretations.extractedAssets, v7)
				end

				itemsFromInterpretations.stats.instancesTraversed += 1
			end

			itemsFromInterpretations.stats.traversalTasksCompleted += 1
		end

		itemsFromInterpretations.stats.wallTime += os.clock() - lastTime2
		itemsFromInterpretations.stats.computeTime += os.clock() - lastTime3
		callback(itemsFromInterpretations)
	end)

	return itemsFromInterpretations
end

return {
	interpretAnnotation = interpretAnnotation,
	extractItemsFromInterpretations = extractItemsFromInterpretations,
	interpretInstanceListForGUIObjects = interpretInstanceListForGUIObjects,
	interpretAndExtractItemsFromInstanceForPreciseSelection = interpretAndExtractItemsFromInstanceForPreciseSelection,
	__setRandomGenerator = function(p)
		v = p
	end
}
