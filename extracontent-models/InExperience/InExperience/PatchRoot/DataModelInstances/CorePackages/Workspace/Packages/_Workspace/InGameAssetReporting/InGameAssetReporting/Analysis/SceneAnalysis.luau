local Players = game:GetService("Players")
local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.Analysis.Types)

local GetFIntIGARRaycastTargetCount = require(InGameAssetReporting.Flags.GetFIntIGARRaycastTargetCount)
local GetFIntIGARSubtreeDivergenceThresholdPerMille = require(InGameAssetReporting.Flags.GetFIntIGARSubtreeDivergenceThresholdPerMille)
local extractAssetIdsFromInstance = require(InGameAssetReporting.Analysis.extractAssetIdsFromInstance)
local random = Random.new()

function getRandomSampleUniformDisk(vector2: Vector2, n1: number, vector2_2: Vector2) -- line: 70
	-- upvalues: random (ref)
	local n2 = 0
	local v15, v16

	repeat
		local v11 = random:NextNumber() * 2 * 3.141592653589793
		local v12 = math.sqrt((random:NextNumber())) * n1
		local v13 = math.cos(v11) * v12
		local v14 = math.sin(v11) * v12

		v15 = vector2.X + v13
		v16 = vector2.Y + v14
		n2 += 1

		if n2 > 6 then
			return vector2
		end
	until v15 >= 0 and v15 <= vector2_2.X and v16 >= 0 and v16 <= vector2_2.Y

	return Vector2.new(v15, v16)
end
function interpretAnnotation(vector2: Vector2, n3: number, p1: ((...any) -> ...any)) -- line: 89
	-- upvalues: GetFIntIGARRaycastTargetCount (copy), Players (copy)
	local u20 = false
	local t1 = {
		errorReason = nil,
		hitCountMap = {},
		stats = {
			completedCount = 0,
			hitCount = 0,
			resumptionCount = 0,
			wallTime = 0,
			computeTime = 0,
			targetCount = GetFIntIGARRaycastTargetCount()
		},
		highlights = {},
		topLevelObjects = {},
		cancel = function() -- line: 110
			-- upvalues: u20 (ref)
			u20 = true
		end
	}

	t1.raycastComputation = coroutine.create(function() -- line: 116
		-- upvalues: p1 (copy), t1 (copy)
		p1(t1)
	end)

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera == nil then
		t1.errorReason = "No camera"

		return t1
	end

	local ViewportSize = CurrentCamera.ViewportSize

	if vector2.X < 0 or vector2.X > ViewportSize.X or vector2.Y < 0 or vector2.Y > ViewportSize.Y then
		t1.errorReason = "Coordinates out of bounds"

		return t1
	end

	if n3 <= 0 or n3 > math.max(ViewportSize.X, ViewportSize.Y) then
		t1.errorReason = "Invalid radius"

		return t1
	end

	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		t1.errorReason = "No local player"

		return t1
	end

	local t2 = { LocalPlayer.Character }

	t1.raycastComputation = coroutine.create(function() -- line: 147
		-- upvalues: t2 (copy), t1 (copy), u20 (ref), vector2 (copy), n3 (copy), ViewportSize (copy), CurrentCamera (copy), p1 (copy)
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = t2
		raycastParams.IgnoreWater = true

		local elapsed = os.clock()
		local elapsed2 = os.clock()

		for _ = 1, t1.stats.targetCount do
			if u20 then
				break
			end

			if elapsed2 + 0.011111111111111112 < os.clock() then
				local stats = t1.stats

				stats.computeTime = stats.computeTime + (os.clock() - elapsed2)
				task.wait()
				elapsed2 = os.clock()

				local stats2 = t1.stats

				stats2.resumptionCount = stats2.resumptionCount + 1

				if u20 then
					break
				end
			end

			local v128 = getRandomSampleUniformDisk(vector2, n3, ViewportSize)
			local v129 = CurrentCamera:ViewportPointToRay(v128.X, v128.Y)
			local raycastResult = nil

			for _ = 1, 5 do
				raycastResult = workspace:Raycast(v129.Origin, v129.Direction * 5000, raycastParams)

				if raycastResult == nil then
					break
				end

				local Instance = raycastResult.Instance

				if (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) > 0.05 then
					break
				end

				table.insert(t2, Instance)
				raycastParams.FilterDescendantsInstances = t2
				raycastResult = nil
			end

			if raycastResult then
				local Instance = raycastResult.Instance

				if Instance ~= nil then
					local stats = t1.stats

					stats.hitCount = stats.hitCount + 1
				end

				local v135 = nil

				while Instance ~= nil and ((Instance:IsA("PVInstance") or Instance:IsA("Accessory")) and Instance ~= workspace) do
					if not t1.hitCountMap[Instance] then
						t1.hitCountMap[Instance] = {
							raycastHits = 0,
							children = {}
						}
					end

					local v136 = t1.hitCountMap[Instance]

					v136.raycastHits = v136.raycastHits + 1

					if v135 then
						t1.hitCountMap[Instance].children[v135] = true
					end

					v135 = Instance
					Instance = Instance.Parent
				end

				if v135 then
					t1.topLevelObjects[v135] = (t1.topLevelObjects[v135] or 0) + 1
				end
			end

			local stats = t1.stats

			stats.completedCount = stats.completedCount + 1
		end

		t1.stats.wallTime = os.clock() - elapsed

		local stats = t1.stats

		stats.computeTime = stats.computeTime + (os.clock() - elapsed2)
		p1(t1)
	end)

	return t1
end
function createPlayerCharacterReferenceToPlayerMap(t3: {[any]: any}) -- line: 238
	local t4 = {}

	for _, v in ipairs(t3) do
		local Character = v.Character

		if Character then
			t4[Character] = v
		end
	end

	return t4
end
function descendingOrderBySecondElement(t5: {[any]: any}, t6: {[any]: any}) -- line: 249
	return t5[2] > t6[2]
end
function createTraversalTaskList(t7: {[any]: any}, t8: {[any]: any}) -- line: 256
	-- upvalues: Players (copy), GetFIntIGARSubtreeDivergenceThresholdPerMille (copy)
	local t9 = {}
	local t10 = {}
	local v37 = createPlayerCharacterReferenceToPlayerMap(Players:GetPlayers())
	local t11 = {}

	for k, v in pairs(t8) do
		table.insert(t11, {
			k,
			v
		})
	end

	table.sort(t11, descendingOrderBySecondElement)

	local v41 = GetFIntIGARSubtreeDivergenceThresholdPerMille() / 1000

	for _, v in ipairs(t11) do
		local v44 = v[1]
		local v45 = v[2]

		if v37[v44] == nil then
			local n4 = 0
			local v47 = v44

			while t7[v47] do
				local v48 = t7[v47]
				local raycastHits = v48.raycastHits
				local children = v48.children
				local n5 = 0

				for k, _ in pairs(children) do
					if t7[k] then
						n5 += 1
					end
				end

				if n5 == 0 then
					break
				end

				local n6 = 0

				for k, _ in pairs(children) do
					if t7[k] then
						n6 = math.max(n6, t7[k].raycastHits)
					end
				end

				if v41 > n6 / raycastHits then
					break
				end

				v47 = nil

				local n7 = 0

				for k, _ in pairs(children) do
					if t7[k] and n7 < t7[k].raycastHits then
						v47 = k
						n7 = t7[k].raycastHits
					end
				end

				n4 += 1
			end

			table.insert(t9, {
				instance = v47,
				count = v45
			})

			if v47 ~= v44 then
				table.insert(t9, {
					instance = v44,
					count = v45
				})
			end

			continue
		end

		table.insert(t10, {
			player = v37[v44],
			count = v45
		})
	end

	return t9, t10
end
function mutateMergeExtractedAssets(t12: {[any]: any}, p2, p3) -- line: 344
	for _, v in ipairs(p3.Image) do
		if not t12[v] then
			t12[v] = true
			table.insert(p2.Image, v)
		end
	end

	for _, v in ipairs(p3.Mesh) do
		if not t12[v] then
			t12[v] = true
			table.insert(p2.Mesh, v)
		end
	end

	for _, v in ipairs(p3.Video) do
		if not t12[v] then
			t12[v] = true
			table.insert(p2.Video, v)
		end
	end

	for _, v in ipairs(p3.Model) do
		if not t12[v] then
			t12[v] = true
			table.insert(p2.Model, v)
		end
	end

	for _, v in ipairs(p3.Package) do
		if not t12[v.id] then
			t12[v.id] = true
			table.insert(p2.Package, v)
		end
	end

	if game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
		for _, v in ipairs(p3.Text) do
			if not t12[v] then
				t12[v] = true
				table.insert(p2.Text, v)
			end
		end
	end
end
function interpretInstanceListForGUIObjects(t13: {[any]: any}) -- line: 396
	local t14 = {
		errorReason = nil,
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
		cancel = function() -- line: 410
		end
	}

	for _, v in ipairs(t13) do
		local v79 = v
		local v80 = nil

		while v79 ~= nil and v79:IsA("GuiObject") do
			if not t14.hitCountMap[v79] then
				t14.hitCountMap[v79] = {
					raycastHits = 0,
					children = {}
				}
			end

			local v81 = t14.hitCountMap[v79]

			v81.raycastHits = v81.raycastHits + 1

			if v80 then
				t14.hitCountMap[v79].children[v80] = true
			end

			v80 = v79
			v79 = v79.Parent
		end

		if v80 then
			t14.topLevelObjects[v80] = (t14.topLevelObjects[v80] or 0) + 1
		end
	end

	return t14
end
function interpretAndExtractItemsFromInstanceForPreciseSelection(p4) -- line: 439
	-- upvalues: extractAssetIdsFromInstance (copy), Players (copy)
	local t15 = {
		extractedAssets = {
			Package = {},
			Model = {},
			Image = {},
			Mesh = {},
			Text = {},
			Video = {}
		},
		extractedPlayers = {},
		cancel = function() -- line: 450
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
		},
		computation = coroutine.create(function() -- line: 469
		end)
	}

	if not p4 then
		return t15
	end

	local t16 = {}
	local v85 = createPlayerCharacterReferenceToPlayerMap(Players:GetPlayers())
	local v86 = p4

	while v86 ~= nil and ((v86:IsA("PVInstance") or v86:IsA("Accessory") or v86:IsA("GuiObject") or v86:IsA("FaceInstance")) and v86 ~= workspace) do
		if v85[v86] ~= nil then
			table.insert(t15.extractedPlayers, {
				count = 1,
				player = v85[v86]
			})

			return t15
		end

		local v87 = extractAssetIdsFromInstance(v86)

		if v87 then
			mutateMergeExtractedAssets(t16, t15.extractedAssets, v87)
		end

		local stats = t15.stats

		stats.instancesTraversed = stats.instancesTraversed + 1
		v86 = v86.Parent
	end

	local children = p4:GetChildren()

	for _, v in ipairs(children) do
		local v92 = extractAssetIdsFromInstance(v)

		if v92 then
			mutateMergeExtractedAssets(t16, t15.extractedAssets, v92)
		end

		local stats = t15.stats

		stats.instancesTraversed = stats.instancesTraversed + 1
	end

	return t15
end
function extractItemsFromInterpretations(t17: {[any]: any}, p5: ((...any) -> ...any)) -- line: 516
	-- upvalues: extractAssetIdsFromInstance (copy)
	local u96 = false
	local t18 = {
		extractedAssets = {
			Package = {},
			Model = {},
			Image = {},
			Mesh = {},
			Text = {},
			Video = {}
		},
		extractedPlayers = {},
		cancel = function() -- line: 532
			-- upvalues: u96 (ref)
			u96 = true
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

	t18.computation = coroutine.create(function() -- line: 551
		-- upvalues: p5 (copy), t18 (copy)
		p5(t18)
	end)

	for _, v in ipairs(t17) do
		v.cancel()

		local stats = t18.stats

		stats.raycastTargetCount = stats.raycastTargetCount + v.stats.targetCount

		local stats3 = t18.stats

		stats3.raycastCompletedCount = stats3.raycastCompletedCount + v.stats.completedCount

		local stats4 = t18.stats

		stats4.raycastResumptionCount = stats4.raycastResumptionCount + v.stats.resumptionCount

		local stats5 = t18.stats

		stats5.raycastComputeTime = stats5.raycastComputeTime + v.stats.computeTime
	end

	local elapsed = os.clock()
	local t19 = {}
	local t20 = {}

	for _, v in ipairs(t17) do
		for k, v2 in pairs(v.hitCountMap) do
			if not t19[k] then
				t19[k] = {
					raycastHits = 0,
					children = {}
				}

				local stats = t18.stats

				stats.hitCountMapSize = stats.hitCountMapSize + 1
			end

			local v112 = t19[k]

			v112.raycastHits = v112.raycastHits + v2.raycastHits

			for k2, _ in pairs(v2.children) do
				t19[k].children[k2] = true
			end
		end

		for k, v3 in pairs(v.topLevelObjects) do
			local v117 = t20[k]

			if not v117 then
				local stats = t18.stats

				stats.topLevelObjectsSize = stats.topLevelObjectsSize + 1
			end

			t20[k] = (v117 or 0) + v3
		end
	end

	local v119, v120 = createTraversalTaskList(t19, t20)

	t18.extractedPlayers = v120
	t18.stats.playersCount = #v120
	t18.stats.wallTime = os.clock() - elapsed
	t18.stats.traversalTaskListSize = #v119
	t18.computation = coroutine.create(function() -- line: 599
		-- upvalues: t18 (copy), v119 (copy), u96 (ref), p5 (copy), t19 (copy), extractAssetIdsFromInstance (copy)
		local elapsed3 = os.clock()
		local elapsed4 = os.clock()
		local t21 = {}

		for _, v in ipairs(v119) do
			local t22 = {}
			local t23 = {}

			table.insert(t22, v.instance)

			while #t22 > 0 do
				if elapsed4 + 0.011111111111111112 < os.clock() then
					local stats = t18.stats

					stats.computeTime = stats.computeTime + (os.clock() - elapsed4)
					task.wait()
					elapsed4 = os.clock()

					local stats6 = t18.stats

					stats6.resumptionCount = stats6.resumptionCount + 1

					if u96 then
						local stats7 = t18.stats

						stats7.wallTime = stats7.wallTime + (os.clock() - elapsed3)
						p5(t18)

						return
					end
				end

				local v152 = table.remove(t22)

				if not t21[v152] then
					table.insert(t23, v152)

					local children = v152:GetChildren()
					local t24 = {}

					for _, v4 in pairs(children) do
						table.insert(t24, {
							v4,
							not t19[v4] and 0 or t19[v4].raycastHits
						})
					end

					table.sort(t24, descendingOrderBySecondElement)

					for _, v5 in ipairs(t24) do
						table.insert(t22, v5[1])
					end

					t21[v152] = true
				end
			end

			while #t23 > 0 do
				if elapsed4 + 0.011111111111111112 < os.clock() then
					local stats = t18.stats

					stats.computeTime = stats.computeTime + (os.clock() - elapsed4)
					task.wait()
					elapsed4 = os.clock()

					local stats8 = t18.stats

					stats8.resumptionCount = stats8.resumptionCount + 1

					if u96 then
						local stats9 = t18.stats

						stats9.wallTime = stats9.wallTime + (os.clock() - elapsed3)
						p5(t18)

						return
					end
				end

				local v162 = table.remove(t23)
				local v163 = extractAssetIdsFromInstance(v162)

				if v163 then
					mutateMergeExtractedAssets({}, t18.extractedAssets, v163)
				end

				local stats = t18.stats

				stats.instancesTraversed = stats.instancesTraversed + 1
			end

			local stats = t18.stats

			stats.traversalTasksCompleted = stats.traversalTasksCompleted + 1
		end

		local stats = t18.stats

		stats.wallTime = stats.wallTime + (os.clock() - elapsed3)

		local stats10 = t18.stats

		stats10.computeTime = stats10.computeTime + (os.clock() - elapsed4)
		p5(t18)
	end)

	return t18
end

return {
	interpretAnnotation = interpretAnnotation,
	extractItemsFromInterpretations = extractItemsFromInterpretations,
	interpretInstanceListForGUIObjects = interpretInstanceListForGUIObjects,
	interpretAndExtractItemsFromInstanceForPreciseSelection = interpretAndExtractItemsFromInstanceForPreciseSelection,
	__setRandomGenerator = function(p6) -- line: 698
		-- upvalues: random (ref)
		random = p6
	end
}
