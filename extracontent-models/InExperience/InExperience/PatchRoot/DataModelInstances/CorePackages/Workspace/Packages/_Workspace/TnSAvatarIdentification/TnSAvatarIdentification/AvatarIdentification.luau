local TnSAvatarIdentification = script:FindFirstAncestor("TnSAvatarIdentification")

local GetFIntReportAnythingAvatarIdentificationCloseDiscardDistanceHundredths = require(TnSAvatarIdentification.Flags.GetFIntReportAnythingAvatarIdentificationCloseDiscardDistanceHundredths)

local GetFIntReportAnythingAvatarIdentificationDiscardFractionSkipThresholdPercent = require(TnSAvatarIdentification.Flags.GetFIntReportAnythingAvatarIdentificationDiscardFractionSkipThresholdPercent)

local GetFIntReportAnythingAvatarIdentificationOffScreenDiscardDistancePercent = require(TnSAvatarIdentification.Flags.GetFIntReportAnythingAvatarIdentificationOffScreenDiscardDistancePercent)
local Players = game:GetService("Players")

local parent = TnSAvatarIdentification.Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagGetHumanoidDescriptionUpdatesV2E = SharedFlags.GetFFlagGetHumanoidDescriptionUpdatesV2E

local GetHumanoidDescription = require(parent.GetHumanoidDescription)

local IdentificationUtils = require(script.Parent.IdentificationUtils)

local v = GetFIntReportAnythingAvatarIdentificationCloseDiscardDistanceHundredths() / 100
local v2 = GetFIntReportAnythingAvatarIdentificationOffScreenDiscardDistancePercent() / 100
local v3 = GetFIntReportAnythingAvatarIdentificationDiscardFractionSkipThresholdPercent() / 100

local AvatarIdentification = {}

function getBBCorners(cframe: CFrame, vector3: Vector3)
	local bbCorners = table.create(8)

	local xVector = cframe.XVector
	local yVector = cframe.YVector
	local zVector = cframe.ZVector
	local v4 = 1

	for i = -0.5, 0.5 do
		local v5 = xVector * i * vector3.X

		for j = -0.5, 0.5 do
			local v6 = yVector * j * vector3.Y

			for k = -0.5, 0.5 do
				local v7 = zVector * k * vector3.Z

				bbCorners[v4] = cframe.Position + v5 + v6 + v7
				v4 += 1
			end
		end
	end

	return bbCorners
end

local v4 = v2 + 1
local v5 = -v2

local v6 = { total = 0, offScreenDiscardCount = 0, tooCloseDiscardCount = 0, wasSkipped = false }

local function fn(worldToFullViewportPointNormalized: Vector2): boolean -- 1 equivalent call inferred from this helper
	return v4 < worldToFullViewportPointNormalized.Y
		or worldToFullViewportPointNormalized.Y < v5
		or v4 < worldToFullViewportPointNormalized.X
		or worldToFullViewportPointNormalized.X < v5
end

function getCoveringPolygon(list, p, p2)
	if #list == 0 then
		return {}, v6
	end

	local bbCorners = {}

	for _, item in ipairs(list) do
		local target = item.target

		local extentsCFrame = target.ExtentsCFrame
		local extentsSize = target.ExtentsSize
		local bbCorners2 = getBBCorners(extentsCFrame, extentsSize)

		for _, bbCorner in bbCorners2 do
			table.insert(bbCorners, bbCorner)
		end
	end

	assert(p2, "getCoveringPolygon requires viewportInfo")
	local count = 0
	local count2 = 0
	local worldToFullViewportPointNormalizeds = {}

	for _, v7 in ipairs(bbCorners) do
		local worldToFullViewportPointNormalized, v8, _ = IdentificationUtils.worldToFullViewportPointNormalized(
			v7,
			p,
			p2
		)

		if v8 < v then
			count += 1
		elseif fn(worldToFullViewportPointNormalized) then -- inferred equivalent call
			count2 += 1
		else
			worldToFullViewportPointNormalizeds[#worldToFullViewportPointNormalizeds + 1] = worldToFullViewportPointNormalized
		end
	end

	local v7 = {
		total = #bbCorners,
		offScreenDiscardCount = count2,
		tooCloseDiscardCount = count,
		wasSkipped = false
	}

	if v3 < (count + count2) / #bbCorners then
		v7.wasSkipped = true
		return {}, v7
	end

	return getConvexHull(worldToFullViewportPointNormalizeds), v7
end

function getDistanceAlongCamLookVector(cframe: CFrame, p)
	local cframe2 = p.CFrame

	return ((cframe.Position - cframe2.Position):Dot(cframe2.LookVector))
end

function getVisibleParts(p, player, filterDescendantsInstances)
	local position = p.CFrame.Position

	local character = player.Character

	if not (character and character.Parent) then
		return 0, {}
	end

	local children = character:GetChildren()
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	raycastParams.IgnoreWater = true
	local count = 0
	local result = {}

	for _, part in ipairs(children) do
		if not part:IsA("BasePart") then
			continue
		end

		local v7 = part.CFrame.Position - position

		count += 1
		local raycastResult = workspace:Raycast(position, v7, raycastParams)

		if raycastResult and raycastResult.Instance:IsDescendantOf(character) then
			table.insert(result, { result = raycastResult, target = part })
		end
	end

	return count, result
end

local function counterclockwise(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- 1 equivalent call inferred from this helper
	return (vector2_2 - vector2):Cross(vector2_3 - vector2_2)
end

function getConvexHull(list)
	if #list <= 2 then
		return {}
	end

	local v7 = list[1]
	local result = {}

	local vector3s = {}

	for i = 2, #list do
		local item = list[i]

		if item.Y < v7.Y or item.Y == v7.Y and item.X < v7.X then
			v7 = item
		end
	end

	table.insert(result, v7)
	local function angleFromLowest(item: Vector2) -- 1 equivalent call inferred from this helper
		local v8 = item - v7
		return (math.atan2(v8.Y, v8.X))
	end

	for _, item in ipairs(list) do
		if item == v7 then
			continue
		end

		local x = item.X
		local y = item.Y
		table.insert(vector3s, (Vector3.new(x, y, angleFromLowest(item)))) -- inferred equivalent call
	end

	local function compareByAngle(vector3: Vector3, vector3_2: Vector3): boolean
		if vector3.Z == vector3_2.Z then
			return (Vector2.new(vector3.X, vector3.Y) - v7).Magnitude < (Vector2.new(vector3_2.X, vector3_2.Y) - v7).Magnitude
		end

		return vector3.Z < vector3_2.Z
	end

	table.sort(vector3s, compareByAngle)

	local v8 = vector3s[1]
	local vector2s = {}

	for i = 2, #vector3s do
		local v9 = vector3s[i]

		if v8.Z ~= v9.Z then
			table.insert(vector2s, Vector2.new(v8.X, v8.Y))
		end

		v8 = v9
	end

	table.insert(vector2s, Vector2.new(v8.X, v8.Y))

	if #vector2s == 1 then
		return {}
	end

	table.insert(result, vector2s[1])
	table.insert(result, vector2s[2])

	for i = 3, #vector2s do
		local v9 = vector2s[i]

		while #result > 1 do
			if counterclockwise(result[#result - 1], result[#result], v9) <= 0 then -- inferred equivalent call
				table.remove(result)
			else
				break
			end
		end

		table.insert(result, v9)
	end

	return result
end

function projectVertices(list, vector2: Vector2, vector2_2: Vector2)
	local v7 = 1e999
	local v8 = -1e999

	for _, item in ipairs(list) do
		local dot = (item * vector2_2):Dot(vector2)

		if dot < v7 then
			v7 = dot
		end

		if v8 < dot then
			v8 = dot
		end
	end

	return v7, v8
end

function projectCircle(vector2: Vector2, p: number, vector2_2: Vector2)
	local v7 = vector2_2.Unit * p

	local vector = vector2 + v7
	local vector3 = vector2 - v7

	local v8 = vector:Dot(vector2_2)
	local v9 = vector3:Dot(vector2_2)

	if v9 < v8 then
		v9, v8 = v8, v9
	end

	return v8, v9
end

function getClosestPoint(vector2: Vector2, list, vector2_2: Vector2)
	local v7 = 1e999
	local closestPoint = -1

	for i, item in ipairs(list) do
		local v8 = item * vector2_2
		local v9 = math.sqrt(math.pow(v8.X - vector2.X, 2) + math.pow(v8.Y - vector2.Y, 2))

		if not (v9 < v7) then
			continue
		end

		closestPoint = i
		v7 = v9
	end

	return closestPoint
end

function intersectCirclePolygon(vector2: Vector2, p: number, list, vector2_2: Vector2): boolean
	for i, _ in ipairs(list) do
		local v7 = list[i] * vector2_2
		local v8 = list[i % #list + 1] * vector2_2 - v7

		local unit = Vector2.new(v8.Y, -v8.X).Unit
		local v9, v10 = projectVertices(list, unit, vector2_2)
		local v11, v12 = projectCircle(vector2, p, unit)

		if v12 <= v9 or v10 <= v11 then
			return false
		end
	end

	local closestPoint = getClosestPoint(vector2, list, vector2_2)

	if closestPoint == -1 then
		return false
	end

	local unit = (list[closestPoint] - vector2).Unit
	local v7, v8 = projectVertices(list, unit, vector2_2)
	local v9, v10 = projectCircle(vector2, p, unit)

	return not (v10 <= v7 or v8 <= v9)
end

function intersectCircleBox(vector2: Vector2, p: number, vector2_2: Vector2, vector2_3: Vector2, _: Vector2): boolean
	local x = vector2.X
	local y = vector2.Y

	local v7 = vector2_2.X
	local v8 = vector2_2.Y

	local v9 = vector2_3.X - vector2_2.X
	local v10 = vector2_3.Y - vector2_2.Y

	if not (x < v7) then
		if v7 + v9 < x then
			v7 += v9
		else
			v7 = x
		end
	end

	if not (y < v8) then
		if v8 + v10 < y then
			v8 += v10
		else
			v8 = y
		end
	end

	local v11 = x - v7
	local v12 = y - v8

	return math.sqrt(v11 * v11 + v12 * v12) <= p
end

function AvatarIdentification.getAvatarsForRegion(items, vector2: Vector2, p: number, p2: number, p3: number)
	local playersByUserId = {}

	local v7 = p3 < p2
	local v8

	if v7 then
		v8 = p2 / p3
	else
		v8 = p3 / p2
	end

	local vector2_2

	if v7 then
		vector2_2 = Vector2.new(v8, 1)
	else
		vector2_2 = Vector2.new(1, v8)
	end

	for _, item in pairs(items) do
		if
			not intersectCircleBox(
				vector2 * vector2_2,
				p * v8,
				item.boundingBox.min * vector2_2,
				item.boundingBox.max * vector2_2,
				vector2_2
			)
			or #item.convexHull < 3
		then
			continue
		end

		if not intersectCirclePolygon(vector2 * vector2_2, p * v8, item.convexHull, vector2_2) then
			continue
		end

		playersByUserId[item.player.UserId] = item.player
	end

	return playersByUserId
end

function AvatarIdentification.getAvatarsForPoint(items, vector2: Vector2)
	local playersByUserId = {}

	for _, item in pairs(items) do
		local boundingBox = item.boundingBox

		if
			vector2.X < boundingBox.min.X
			or vector2.Y < boundingBox.min.Y
			or vector2.X > boundingBox.max.X
			or vector2.Y > boundingBox.max.Y
		then
			continue
		end

		local convexHull = item.convexHull

		if #convexHull < 3 then
			continue
		end

		local v7 = convexHull[#convexHull]
		local v8 = true
		local v9 = true

		for _, v10 in ipairs(convexHull) do
			local cross = (v10 - v7):Cross(vector2 - v7)

			v8 = v8 and cross <= 0
			v9 = v9 and cross >= 0
			v7 = v10
		end

		if v9 or v8 then
			playersByUserId[item.player.UserId] = item.player
		end
	end

	return playersByUserId
end

function AvatarIdentification.getVisibleAvatars(flag: boolean?, value: number?)
	local players = Players:GetPlayers()
	local result = { totalPlayers = 0, checkedPlayers = 0, duration = 0 }

	local currentCamera = workspace.CurrentCamera

	if not currentCamera then
		return {}, result
	end

	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return {}, result
	end

	local character = localPlayer.Character

	local characters = {}
	local v7

	if character then
		v7 = IdentificationUtils.getLocalCharacterPosition(character) or currentCamera.CFrame.Position

		if IdentificationUtils.shouldIgnoreLocalCharacter(character) then
			characters[#characters + 1] = character
		end
	else
		v7 = currentCamera.CFrame.Position
	end

	local viewportInfo = IdentificationUtils.getViewportInfo()
	result.viewportInfo = viewportInfo

	local result2 = {}
	local lastTime = os.clock()
	result.totalPlayers = #players - 1

	if v7 then
		table.sort(players, function(a, b): boolean
			return a:DistanceFromCharacter(v7) < b:DistanceFromCharacter(v7)
		end)
	end

	local function fn2() -- 3 equivalent calls inferred from this helper
		result.duration = os.clock() - lastTime
		return result
	end

	for _, player in ipairs(players) do
		if not ((player ~= localPlayer or flag) and player.Character) then
			continue
		end

		if (value or 0.5) < os.clock() - lastTime then
			return result2, fn2() -- inferred equivalent call
		end

		local boundingBox, v8 = player.Character:GetBoundingBox()

		local magnitude = (boundingBox.Position - v7).Magnitude

		if getDistanceAlongCamLookVector(boundingBox, currentCamera) < 0 then
			result.checkedPlayers += 1
		else
			local bbCorners = getBBCorners(boundingBox, v8)

			local viewportCorners, max = IdentificationUtils.getViewportCorners(bbCorners, currentCamera, viewportInfo)

			if max.X == 0 or max.Y == 0 then
				result.checkedPlayers += 1
			else
				local visibleParts, v9 = getVisibleParts(currentCamera, player, characters)

				if (value or 0.5) < os.clock() - lastTime then
					return result2, fn2() -- inferred equivalent call
				end

				local hitRate = #v9 / visibleParts
				local coveringPolygon, pointProcessingStats = getCoveringPolygon(v9, currentCamera, viewportInfo)
				local humanoidDescription, humanoidDescriptionStatus

				if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
					humanoidDescription, humanoidDescriptionStatus = GetHumanoidDescription.getHumanoidDescription(player.UserId)
				end

				result2[player.UserId] = {
					player = player,
					distance = magnitude,
					boundingBox = { min = viewportCorners, max = max },
					hitRate = hitRate,
					convexHull = coveringPolygon,
					pointProcessingStats = pointProcessingStats,
					humanoidDescription = humanoidDescription,
					humanoidDescriptionStatus = humanoidDescriptionStatus
				}

				result.checkedPlayers += 1
			end
		end
	end

	return result2, fn2() -- inferred equivalent call
end

return AvatarIdentification
