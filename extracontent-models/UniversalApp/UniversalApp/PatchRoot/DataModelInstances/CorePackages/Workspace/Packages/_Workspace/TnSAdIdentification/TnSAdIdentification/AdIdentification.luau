local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local TnSAdIdentification = script:FindFirstAncestor("TnSAdIdentification")
local GetFIntAdIdentificationMinimumAreaPerMyriad = require(TnSAdIdentification.Flags.GetFIntAdIdentificationMinimumAreaPerMyriad)
local GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent = require(TnSAdIdentification.Flags.GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent)
local TnSAdIdentificationParent = TnSAdIdentification.Parent
local LoggingProtocol = require(TnSAdIdentificationParent.LoggingProtocol)
local default = LoggingProtocol.default
local GetFFlagAvatarIdentificationSafeAreaFix = require(TnSAdIdentificationParent.SharedFlags).GetFFlagAvatarIdentificationSafeAreaFix
local IdentificationUtils = require(TnSAdIdentificationParent.AvatarIdentification).IdentificationUtils
local v11 = math.max(GetFIntAdIdentificationMinimumAreaPerMyriad() / 10000, 0)
local t1 = {}

function getLocalCharacterPosition(p1) -- line: 33
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	return HumanoidRootPart.Position
end
function checkVisibility(p2, p3, t2: {[any]: any}, t3: {[any]: any}) -- line: 45
	local CFramePosition = p2.CFrame.Position
	local ViewportSize = p2.ViewportSize
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t3
	raycastParams.IgnoreWater = true

	local n1 = 0
	local n2 = 0
	local v24 = t2[2] - t2[1]
	local v25 = t2[3] - t2[1]

	for i = 1, 4 do
		local v27 = v24 * (i - 0.5) / 4

		for j = 1, 4 do
			local v29 = t2[1] + v27 + v25 * (j - 0.5) / 4
			local v30 = v29 - CFramePosition

			n1 += 1

			local v31, _ = p2:WorldToViewportPoint(v29)

			if not (v31.Z < 0) and not (v31.X < 0) and not (v31.Y < 0) and not (v31.X > ViewportSize.X) and not (v31.Y > ViewportSize.Y) then
				local raycastResult = workspace:Raycast(CFramePosition, v30 * 1.1, raycastParams)

				if raycastResult and p3 == raycastResult.Instance then
					n2 += 1
				end
			end
		end
	end

	return n2 / n1
end
function createSingleVisibleRegionFromWorldSpaceCorners(t4: {[any]: any}, p4, p5) -- line: 93
	-- upvalues: GetFFlagAvatarIdentificationSafeAreaFix (copy), IdentificationUtils (copy)
	local ViewportSize = p4.ViewportSize
	local t5 = table.create(#t4)

	for i, v in ipairs(t4) do
		if GetFFlagAvatarIdentificationSafeAreaFix() then
			local v41, _, _ = IdentificationUtils.worldToFullViewportPointNormalized(v, p4, p5)

			t5[i] = Vector2.new(v41.X, v41.Y)
		else
			local v44, _ = p4:WorldToViewportPoint(v)

			t5[i] = Vector2.new(v44.X, v44.Y) / ViewportSize
		end
	end

	local t6 = {
		t5[1],
		t5[2],
		t5[4],
		t5[3]
	}

	return {
		id = 1,
		convexHull = t6
	}
end
function getAdCenterAndScreenArea(p6, p7) -- line: 117
	local ViewportSize = p7.ViewportSize
	local vector3 = Vector3.new(0, 0, 0)
	local t7 = {}

	for _, v in ipairs(p6) do
		vector3 += v

		local v54, _ = p7:WorldToViewportPoint(v)

		table.insert(t7, Vector2.new(v54.X, v54.Y) / ViewportSize)
	end

	return vector3 / 4, (0 + math.abs(((t7[2] - t7[1]):Cross(t7[3] - t7[1]))) + math.abs(((t7[2] - t7[4]):Cross(t7[3] - t7[4])))) / 2
end
function t1.getAdsForPoint(t8: {[any]: any}, vector2: Vector2) -- line: 185
	local t9 = {}

	for k, v in pairs(t8) do
		local boundingBox = v.boundingBox

		if not (vector2.X < boundingBox.min.X) and not (vector2.Y < boundingBox.min.Y) and not (vector2.X > boundingBox.max.X) and not (vector2.Y > boundingBox.max.Y) then
			for _, v2 in ipairs(v.visibleRegions) do
				local convexHull = v2.convexHull

				if #convexHull < 3 then
					continue
				end

				local v65 = convexHull[#convexHull]
				local v66 = true
				local v67 = true

				for _, v3 in ipairs(convexHull) do
					local v70 = (v3 - v65):Cross(vector2 - v65)

					v67 = v67 and v70 <= 0
					v66 = v66 and v70 >= 0
					v65 = v3
				end

				if v66 or v67 then
					t9[k] = v

					break
				end
			end
		end
	end

	return t9
end
function t1.getVisibleAds() -- line: 221
	-- upvalues: AdService (copy), Players (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), IdentificationUtils (copy), v11 (copy), default (copy), LoggingProtocol (copy), GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent (copy)
	local t10 = {}
	local t11 = {
		totalAds = 0,
		checkedAds = 0,
		duration = 0
	}
	local ReportAdInfo = AdService:GetReportAdInfo()
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return t10, t11
	end

	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return t10, t11
	end

	local Character = LocalPlayer.Character
	local v77 = if not Character then CurrentCamera.CFrame.Position else getLocalCharacterPosition(Character) or CurrentCamera.CFrame.Position
	local v78 = nil

	if GetFFlagAvatarIdentificationSafeAreaFix() then
		v78 = IdentificationUtils.getViewportInfo()
		t11.viewportInfo = v78
	end

	local elapsed = os.clock()

	t11.totalAds = #ReportAdInfo

	local n3 = 1

	for _, v in ipairs(ReportAdInfo) do
		if os.clock() - elapsed > 0.2 then
			t11.duration = os.clock() - elapsed

			return t10, t11
		end

		local basePart = v.basePart
		local adUnitName = v.adUnitName
		local assetId = v.assetId
		local encryptedAdTrackingData = v.encryptedAdTrackingData
		local encryptionMetadata = v.encryptionMetadata

		if encryptedAdTrackingData ~= "" and encryptionMetadata ~= "" and assetId ~= "11307989327" then
			local assetCorners = v.assetCorners

			if not assetCorners or #assetCorners < 4 then
				t11.checkedAds = t11.checkedAds + 1

				continue
			end

			local v89, v90 = getAdCenterAndScreenArea(assetCorners, CurrentCamera)
			local Magnitude = (v89 - v77).Magnitude

			if (v89 - CurrentCamera.CFrame.Position):Dot(CurrentCamera.CFrame.LookVector) < 0 then
				t11.checkedAds = t11.checkedAds + 1

				continue
			end

			local Unit = (assetCorners[1] - assetCorners[2]):Cross(assetCorners[1] - assetCorners[3]).Unit

			if Unit:Dot(v89 - basePart.Position) < 0 then
				Unit = -Unit
			end

			if (CurrentCamera.CFrame.Position - v89):Dot(Unit) < 0 then
				t11.checkedAds = t11.checkedAds + 1

				continue
			end

			local v93, v94 = IdentificationUtils.getViewportCorners(assetCorners, CurrentCamera, v78)

			if v93 == IdentificationUtils.defaultMin then
				t11.checkedAds = t11.checkedAds + 1

				continue
			end

			if v90 < v11 then
				t11.checkedAds = t11.checkedAds + 1

				continue
			end

			local v95 = checkVisibility(CurrentCamera, basePart, assetCorners, {})

			if v95 < 0.3 then
				t11.checkedAds = t11.checkedAds + 1

				continue
			end

			if os.clock() - elapsed > 0.2 then
				t11.duration = os.clock() - elapsed

				return t10, t11
			end

			t10[n3] = {
				distance = Magnitude,
				boundingBox = {
					min = v93,
					max = v94
				},
				hitRate = v95,
				visibleRegions = { createSingleVisibleRegionFromWorldSpaceCorners(assetCorners, CurrentCamera, v78) },
				adUnitName = adUnitName,
				assetId = assetId,
				encryptedAdTrackingData = encryptedAdTrackingData,
				encryptionMetadata = encryptionMetadata
			}
			default:logRobloxTelemetryEvent({
				eventName = "AdIdentifiedInAbuseReport",
				description = "Ad Identified in Report Anything Screenshot",
				backends = { LoggingProtocol.TelemetryBackends.Points },
				throttlingPercentage = GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent(),
				lastUpdated = {
					24,
					6,
					25
				}
			}, nil, {
				assetId = assetId,
				encryptedAdTrackingData = encryptedAdTrackingData,
				encryptionMetadata = encryptionMetadata
			})
			t11.checkedAds = t11.checkedAds + 1
			n3 += 1

			continue
		end

		t11.checkedAds = t11.checkedAds + 1
	end

	t11.duration = os.clock() - elapsed

	return t10, t11
end

return t1
