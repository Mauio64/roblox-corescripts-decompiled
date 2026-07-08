local TnSAvatarIdentification = script:FindFirstAncestor("TnSAvatarIdentification")
local GetFIntReportAnythingAvatarIdentificationCloseDiscardDistanceHundredths = require(TnSAvatarIdentification.Flags.GetFIntReportAnythingAvatarIdentificationCloseDiscardDistanceHundredths)
local GetFIntReportAnythingAvatarIdentificationDiscardFractionSkipThresholdPercent = require(TnSAvatarIdentification.Flags.GetFIntReportAnythingAvatarIdentificationDiscardFractionSkipThresholdPercent)
local GetFIntReportAnythingAvatarIdentificationOffScreenDiscardDistancePercent = require(TnSAvatarIdentification.Flags.GetFIntReportAnythingAvatarIdentificationOffScreenDiscardDistancePercent)
local Players = game:GetService("Players")
local TnSAvatarIdentificationParent = TnSAvatarIdentification.Parent
local SharedFlags = require(TnSAvatarIdentificationParent.SharedFlags)
local GetFFlagAvatarIdentificationSafeAreaFix = SharedFlags.GetFFlagAvatarIdentificationSafeAreaFix
local GetFFlagGetHumanoidDescriptionUpdatesV2E = SharedFlags.GetFFlagGetHumanoidDescriptionUpdatesV2E
local GetHumanoidDescription = require(TnSAvatarIdentificationParent.GetHumanoidDescription)
local IdentificationUtils = require(script.Parent.IdentificationUtils)
local v12 = GetFIntReportAnythingAvatarIdentificationCloseDiscardDistanceHundredths() / 100
local v13 = GetFIntReportAnythingAvatarIdentificationOffScreenDiscardDistancePercent() / 100
local v14 = GetFIntReportAnythingAvatarIdentificationDiscardFractionSkipThresholdPercent() / 100
local t1 = {}

function getBBCorners(cFrame: CFrame, vector3: Vector3) -- line: 29
	local t2 = table.create(8)
	local XVector = cFrame.XVector
	local YVector = cFrame.YVector
	local ZVector = cFrame.ZVector
	local n1 = 1

	for i = -0.5, 0.5 do
		local v28 = XVector * i * vector3.X

		for j = -0.5, 0.5 do
			local v30 = YVector * j * vector3.Y

			for k = -0.5, 0.5 do
				local v32 = ZVector * k * vector3.Z

				t2[n1] = cFrame.Position + v28 + v30 + v32
				n1 += 1
			end
		end
	end

	return t2
end

local v16 = v13 + 1
local v17 = -v13
local t3 = {
	total = 0,
	offScreenDiscardCount = 0,
	tooCloseDiscardCount = 0,
	wasSkipped = false
}

function getCoveringPolygon(t4: {[any]: any}, p1, p2) -- line: 74
	-- upvalues: t3 (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), IdentificationUtils (copy), v12 (copy), v16 (copy), v17 (copy), v14 (copy)
	if #t4 == 0 then
		return {}, t3
	end

	local ViewportSize = p1.ViewportSize
	local t5 = {}

	for _, v in ipairs(t4) do
		local target = v.target
		local ExtentsCFrame = target.ExtentsCFrame
		local ExtentsSize = target.ExtentsSize

		for _, v45 in (getBBCorners(ExtentsCFrame, ExtentsSize)) do
			table.insert(t5, v45)
		end
	end

	local t6 = {}
	local n2 = 0
	local n3 = 0

	if GetFFlagAvatarIdentificationSafeAreaFix() then
		assert(p2, "getCoveringPolygon requires viewportInfo when FFlagAvatarIdentificationSafeAreaFix is enabled")

		for _, v in ipairs(t5) do
			local v51, v52, _ = IdentificationUtils.worldToFullViewportPointNormalized(v, p1, p2)

			if v52 < v12 then
				n2 += 1
			elseif v51.Y > v16 or (v51.Y < v17 or (v51.X > v16 or v51.X < v17)) then
				n3 += 1
			else
				t6[#t6 + 1] = v51
			end
		end
	else
		for _, v in ipairs(t5) do
			local v56, _ = p1:WorldToViewportPoint(v)
			local v58 = Vector2.new(v56.X, v56.Y) / ViewportSize

			if v56.Z < v12 then
				n2 += 1
			elseif v58.Y > v16 or (v58.Y < v17 or (v58.X > v16 or v58.X < v17)) then
				n3 += 1
			else
				t6[#t6 + 1] = v58
			end
		end
	end

	local t7 = {
		wasSkipped = false,
		total = #t5,
		offScreenDiscardCount = n3,
		tooCloseDiscardCount = n2
	}

	if (n2 + n3) / #t5 > v14 then
		t7.wasSkipped = true

		return {}, t7
	end

	return getConvexHull(t6), t7
end
function getDistanceAlongCamLookVector(cFrame: CFrame, p3) -- line: 149
	local p3CFrame = p3.CFrame

	return ((cFrame.Position - p3CFrame.Position):Dot(p3CFrame.LookVector))
end
function getVisibleParts(p4, p5, t8: {[any]: any}) -- line: 162
	local CFramePosition = p4.CFrame.Position
	local Character = p5.Character

	if not Character or not Character.Parent then
		return 0, {}
	end

	local children = Character:GetChildren()
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t8
	raycastParams.IgnoreWater = true

	local n4 = 0
	local t9 = {}

	for _, v in ipairs(children) do
		if v:IsA("BasePart") then
			local v74 = v.CFrame.Position - CFramePosition

			n4 += 1

			local raycastResult = workspace:Raycast(CFramePosition, v74, raycastParams)

			if raycastResult and raycastResult.Instance:IsDescendantOf(Character) then
				table.insert(t9, {
					result = raycastResult,
					target = v
				})
			end
		end
	end

	return n4, t9
end

local function counterclockwise(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- line: 203
	return (vector2_2 - vector2):Cross(vector2_3 - vector2_2)
end

function getConvexHull(t10: {[any]: any}) -- line: 207
	if #t10 <= 2 then
		return {}
	end

	local t11 = {}
	local u81 = t10[1]
	local t12 = {}

	for i = 2, #t10 do
		local v84 = t10[i]

		if v84.Y < u81.Y or v84.Y == u81.Y and v84.X < u81.X then
			u81 = v84
		end
	end

	table.insert(t11, u81)

	local function angleFromLowest(vector2: Vector2) -- line: 224
		-- upvalues: u81 (ref)
		local v212 = vector2 - u81

		return (math.atan2(v212.Y, v212.X))
	end

	for _, v in ipairs(t10) do
		if v ~= u81 then
			local vX = v.X
			local vY = v.Y
			local v90 = v - u81

			table.insert(t12, (Vector3.new(vX, vY, (math.atan2(v90.Y, v90.X)))))
		end
	end

	local function compareByAngle(vector3: Vector3, vector3_2: Vector3) -- line: 236
		-- upvalues: u81 (ref)
		if vector3.Z ~= vector3_2.Z then
			return vector3.Z < vector3_2.Z
		end

		return (Vector2.new(vector3.X, vector3.Y) - u81).Magnitude < (Vector2.new(vector3_2.X, vector3_2.Y) - u81).Magnitude
	end

	table.sort(t12, compareByAngle)

	local t13 = {}
	local v93 = t12[1]

	for i = 2, #t12 do
		local v95 = t12[i]

		if v93.Z == v95.Z then
			v93 = v95
		else
			table.insert(t13, Vector2.new(v93.X, v93.Y))
			v93 = v95
		end
	end

	table.insert(t13, Vector2.new(v93.X, v93.Y))

	if #t13 == 1 then
		return {}
	end

	table.insert(t11, t13[1])
	table.insert(t11, t13[2])

	for i = 3, #t13 do
		local v97 = t13[i]

		while #t11 > 1 do
			local v98 = t11[#t11 - 1]
			local v99 = t11[#t11]

			if not ((v99 - v98):Cross(v97 - v99) <= 0) then
				break
			end

			table.remove(t11)
		end

		table.insert(t11, v97)
	end

	return t11
end
function projectVertices(t14: {[any]: any}, vector2: Vector2, vector2_4: Vector2) -- line: 308
	local n5 = 1e999
	local n6 = -1e999

	for _, v in ipairs(t14) do
		local v107 = (v * vector2_4):Dot(vector2)

		if v107 < n5 then
			n5 = v107
		end

		if n6 < v107 then
			n6 = v107
		end
	end

	return n5, n6
end
function projectCircle(vector2: Vector2, n7: number, vector2_5: Vector2) -- line: 328
	local v111 = vector2_5.Unit * n7
	local v112 = vector2 + v111
	local v113 = vector2 - v111
	local v114 = v112:Dot(vector2_5)
	local v115 = v113:Dot(vector2_5)

	if v115 < v114 then
		local v116 = v115

		v115 = v114
		v114 = v116
	end

	return v114, v115
end
function getClosestPoint(vector2: Vector2, t15: {[any]: any}, vector2_6: Vector2) -- line: 347
	local n8 = -1
	local n9 = 1e999

	for i, v in ipairs(t15) do
		local v124 = v * vector2_6
		local v125 = math.sqrt(math.pow(v124.X - vector2.X, 2) + math.pow(v124.Y - vector2.Y, 2))

		if v125 < n9 then
			n9 = v125
			n8 = i
		end
	end

	return n8
end
function intersectCirclePolygon(vector2: Vector2, n10: number, t16: {[any]: any}, vector2_7: Vector2) -- line: 361
	for i, _ in ipairs(t16) do
		local v132 = t16[i] * vector2_7
		local v133 = t16[i % #t16 + 1] * vector2_7 - v132
		local Unit = Vector2.new(v133.Y, -v133.X).Unit
		local v135, v136 = projectVertices(t16, Unit, vector2_7)
		local v137, v138 = projectCircle(vector2, n10, Unit)

		if v138 <= v135 or v136 <= v137 then
			return false
		end
	end

	local v139 = getClosestPoint(vector2, t16, vector2_7)

	if v139 == -1 then
		return false
	end

	local Unit = (t16[v139] - vector2).Unit
	local v141, v142 = projectVertices(t16, Unit, vector2_7)
	local v143, v144 = projectCircle(vector2, n10, Unit)

	if v144 <= v141 or v142 <= v143 then
		return false
	end

	return true
end
function intersectCircleBox(vector2: Vector2, n11: number, vector2_8: Vector2, vector2_9: Vector2, _: Vector2) -- line: 392
	local vector2X = vector2.X
	local vector2Y = vector2.Y
	local v152 = vector2X
	local v153 = vector2Y
	local vector2_8X = vector2_8.X
	local vector2_8Y = vector2_8.Y
	local v156 = vector2_9.X - vector2_8.X
	local v157 = vector2_9.Y - vector2_8.Y

	if vector2X < vector2_8X then
		v152 = vector2_8X
	elseif vector2X > vector2_8X + v156 then
		v152 = vector2_8X + v156
	end

	if vector2Y < vector2_8Y then
		v153 = vector2_8Y
	elseif vector2Y > vector2_8Y + v157 then
		v153 = vector2_8Y + v157
	end

	local v158 = vector2X - v152
	local v159 = vector2Y - v153

	if n11 >= math.sqrt(v158 * v158 + v159 * v159) then
		return true
	end

	return false
end
function t1.getAvatarsForRegion(t17: {[any]: any}, vector2: Vector2, n12: number, n13: number, n14: number) -- line: 431
	local t18 = {}
	local v166 = n14 < n13
	local v167 = if not v166 then n14 / n13 else n13 / n14
	local v168 = if not v166 then Vector2.new(1, v167) else Vector2.new(v167, 1)

	for _, v in pairs(t17) do
		if intersectCircleBox(vector2 * v168, n12 * v167, v.boundingBox.min * v168, v.boundingBox.max * v168, v168) and not (#v.convexHull < 3) and intersectCirclePolygon(vector2 * v168, n12 * v167, v.convexHull, v168) then
			t18[v.player.UserId] = v.player
		end
	end

	return t18
end
function t1.getAvatarsForPoint(t19: {[any]: any}, vector2: Vector2) -- line: 478
	local t20 = {}

	for _, v in pairs(t19) do
		local boundingBox = v.boundingBox

		if not (vector2.X < boundingBox.min.X) and not (vector2.Y < boundingBox.min.Y) and not (vector2.X > boundingBox.max.X) and not (vector2.Y > boundingBox.max.Y) then
			local convexHull = v.convexHull

			if not (#convexHull < 3) then
				local v178 = convexHull[#convexHull]
				local v179 = true
				local v180 = true

				for _, v2 in ipairs(convexHull) do
					local v183 = (v2 - v178):Cross(vector2 - v178)

					v180 = v180 and v183 <= 0
					v179 = v179 and v183 >= 0
					v178 = v2
				end

				if v179 or v180 then
					t20[v.player.UserId] = v.player
				end
			end
		end
	end

	return t20
end
function t1.getVisibleAvatars(b1: boolean?, n15: number?) -- line: 515
	-- upvalues: Players (copy), IdentificationUtils (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), GetFFlagGetHumanoidDescriptionUpdatesV2E (copy), GetHumanoidDescription (copy)
	local players = Players:GetPlayers()
	local t21 = {
		totalPlayers = 0,
		checkedPlayers = 0,
		duration = 0
	}
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return {}, t21
	end

	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return {}, t21
	end

	local Character = LocalPlayer.Character
	local t22 = {}
	local u192

	if Character then
		u192 = IdentificationUtils.getLocalCharacterPosition(Character) or CurrentCamera.CFrame.Position

		if IdentificationUtils.shouldIgnoreLocalCharacter(Character) then
			t22[#t22 + 1] = Character
		end
	else
		u192 = CurrentCamera.CFrame.Position
	end

	local v193 = nil

	if GetFFlagAvatarIdentificationSafeAreaFix() then
		v193 = IdentificationUtils.getViewportInfo()
		t21.viewportInfo = v193
	end

	local t23 = {}
	local elapsed = os.clock()

	t21.totalPlayers = #players - 1

	if u192 then
		table.sort(players, function(p6, p7) -- line: 570
			-- upvalues: u192 (ref)
			return p6:DistanceFromCharacter(u192) < p7:DistanceFromCharacter(u192)
		end)
	end

	for _, v in ipairs(players) do
		if v == LocalPlayer and not b1 or not v.Character then
			continue
		end

		if (n15 or 0.5) < os.clock() - elapsed then
			t21.duration = os.clock() - elapsed

			return t23, t21
		end

		local v198, v199 = v.Character:GetBoundingBox()
		local Magnitude = (v198.Position - u192).Magnitude

		if not (getDistanceAlongCamLookVector(v198, CurrentCamera) < 0) then
			local v201 = getBBCorners(v198, v199)
			local v202, v203 = IdentificationUtils.getViewportCorners(v201, CurrentCamera, v193)

			if v203.X == 0 or v203.Y == 0 then
				t21.checkedPlayers = t21.checkedPlayers + 1

				continue
			end

			local v204, v205 = getVisibleParts(CurrentCamera, v, t22)

			if (n15 or 0.5) < os.clock() - elapsed then
				t21.duration = os.clock() - elapsed

				return t23, t21
			end

			local v206 = #v205 / v204
			local v207, v208 = getCoveringPolygon(v205, CurrentCamera, v193)
			local v209 = nil
			local v210 = nil

			if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
				v209, v210 = GetHumanoidDescription.getHumanoidDescription(v.UserId)
			end

			t23[v.UserId] = {
				player = v,
				distance = Magnitude,
				boundingBox = {
					min = v202,
					max = v203
				},
				hitRate = v206,
				convexHull = v207,
				pointProcessingStats = v208,
				humanoidDescription = v209,
				humanoidDescriptionStatus = v210
			}
			t21.checkedPlayers = t21.checkedPlayers + 1

			continue
		end

		t21.checkedPlayers = t21.checkedPlayers + 1
	end

	t21.duration = os.clock() - elapsed

	return t23, t21
end

return t1
