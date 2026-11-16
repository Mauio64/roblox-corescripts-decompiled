local AdService = game:GetService("AdService")
local Players = game:GetService("Players")

local TnSAdIdentification = script:FindFirstAncestor("TnSAdIdentification")

local GetFIntAdIdentificationMinimumAreaPerMyriad = require(TnSAdIdentification.Flags.GetFIntAdIdentificationMinimumAreaPerMyriad)

local GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent = require(TnSAdIdentification.Flags.GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent)

local parent = TnSAdIdentification.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local AvatarIdentification = require(parent.AvatarIdentification)
local IdentificationUtils = AvatarIdentification.IdentificationUtils

local v = math.max(GetFIntAdIdentificationMinimumAreaPerMyriad() / 10000, 0)

local AdIdentification = {}

function getLocalCharacterPosition(instance)
	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	return if humanoidRootPart then humanoidRootPart.Position else nil
end

function checkVisibility(object, p, list, filterDescendantsInstances)
	local position = object.CFrame.Position
	local viewportSize = object.ViewportSize

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	raycastParams.IgnoreWater = true

	local v2 = list[2] - list[1]
	local v3 = list[3] - list[1]
	local count = 0
	local count2 = 0

	for i = 1, 4 do
		local v4 = v2 * (i - 0.5) / 4

		for j = 1, 4 do
			local v5 = list[1] + v4 + v3 * (j - 0.5) / 4
			local v6 = v5 - position

			count += 1

			local worldToViewportPoint, _ = object:WorldToViewportPoint(v5)

			if
				worldToViewportPoint.Z < 0
				or worldToViewportPoint.X < 0
				or worldToViewportPoint.Y < 0
				or worldToViewportPoint.X > viewportSize.X
				or worldToViewportPoint.Y > viewportSize.Y
			then
				continue
			end

			local raycastResult = workspace:Raycast(position, v6 * 1.1, raycastParams)

			if raycastResult and raycastResult.Instance == p then
				count2 += 1
			end
		end
	end

	return count2 / count
end

function createSingleVisibleRegionFromWorldSpaceCorners(list, p, p2)
	local vector2s = table.create(#list)

	for i, item in ipairs(list) do
		local worldToFullViewportPointNormalized, _, _ = IdentificationUtils.worldToFullViewportPointNormalized(
			item,
			p,
			p2
		)
		vector2s[i] = Vector2.new(worldToFullViewportPointNormalized.X, worldToFullViewportPointNormalized.Y)
	end

	return {
		convexHull = { vector2s[1], vector2s[2], vector2s[4], vector2s[3] },
		id = 1
	}
end

function getAdCenterAndScreenArea(list, object)
	local viewportSize = object.ViewportSize
	local total = Vector3.new(0, 0, 0)
	local v2 = {}

	for _, item in ipairs(list) do
		total += item
		local worldToViewportPoint, _ = object:WorldToViewportPoint(item)
		table.insert(v2, Vector2.new(worldToViewportPoint.X, worldToViewportPoint.Y) / viewportSize)
	end

	return
		total / 4,
		(0 + math.abs(((v2[2] - v2[1]):Cross(v2[3] - v2[1]))) + math.abs(((v2[2] - v2[4]):Cross(v2[3] - v2[4])))) / 2
end

function AdIdentification.getAdsForPoint(items, vector2: Vector2)
	local result = {}

	for k, item in pairs(items) do
		local boundingBox = item.boundingBox

		if
			vector2.X < boundingBox.min.X
			or vector2.Y < boundingBox.min.Y
			or vector2.X > boundingBox.max.X
			or vector2.Y > boundingBox.max.Y
		then
			continue
		end

		for _, visibleRegion in ipairs(item.visibleRegions) do
			local convexHull = visibleRegion.convexHull

			if #convexHull < 3 then
				continue
			end

			local v2 = convexHull[#convexHull]
			local v3 = true
			local v4 = true

			for _, v5 in ipairs(convexHull) do
				local cross = (v5 - v2):Cross(vector2 - v2)

				v3 = v3 and cross <= 0
				v4 = v4 and cross >= 0
				v2 = v5
			end

			if v4 or v3 then
				result[k] = item
				break
			end
		end
	end

	return result
end

function AdIdentification.getVisibleAds()
	local result = {}
	local result2 = { totalAds = 0, checkedAds = 0, duration = 0 }

	local reportAdInfo = AdService:GetReportAdInfo()

	local currentCamera = workspace.CurrentCamera

	if not currentCamera then
		return result, result2
	end

	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return result, result2
	end

	local character = localPlayer.Character

	local v2 = {}
	local v3

	if character then
		v3 = getLocalCharacterPosition(character) or currentCamera.CFrame.Position
	else
		v3 = currentCamera.CFrame.Position
	end

	local viewportInfo = IdentificationUtils.getViewportInfo()
	result2.viewportInfo = viewportInfo

	local lastTime = os.clock()
	result2.totalAds = #reportAdInfo
	local v4 = 1

	local function fn() -- 3 equivalent calls inferred from this helper
		result2.duration = os.clock() - lastTime
		return result2
	end

	local function fn2(): boolean -- 2 equivalent calls inferred from this helper
		return os.clock() - lastTime > 0.2
	end

	for _, v5 in ipairs(reportAdInfo) do
		if fn2() then -- inferred equivalent call
			return result, fn() -- inferred equivalent call
		end

		local basePart = v5.basePart
		local adUnitName = v5.adUnitName
		local assetId = v5.assetId
		local encryptedAdTrackingData = v5.encryptedAdTrackingData
		local encryptionMetadata = v5.encryptionMetadata

		if encryptedAdTrackingData == "" or encryptionMetadata == "" or assetId == "11307989327" then
			result2.checkedAds += 1
		else
			local assetCorners = v5.assetCorners

			if assetCorners and not (#assetCorners < 4) then
				local adCenterAndScreenArea, v6 = getAdCenterAndScreenArea(assetCorners, currentCamera)

				local magnitude = (adCenterAndScreenArea - v3).Magnitude

				if not ((adCenterAndScreenArea - currentCamera.CFrame.Position):Dot(currentCamera.CFrame.LookVector) < 0) then
					local unit = (assetCorners[1] - assetCorners[2]):Cross(assetCorners[1] - assetCorners[3]).Unit

					if unit:Dot(adCenterAndScreenArea - basePart.Position) < 0 then
						unit = -unit
					end

					if not ((currentCamera.CFrame.Position - adCenterAndScreenArea):Dot(unit) < 0) then
						local viewportCorners, max = IdentificationUtils.getViewportCorners(
							assetCorners,
							currentCamera,
							viewportInfo
						)

						if viewportCorners ~= IdentificationUtils.defaultMin and not (v6 < v) then
							local hitRate = checkVisibility(currentCamera, basePart, assetCorners, v2)

							if not (hitRate < 0.3) then
								if fn2() then -- inferred equivalent call
									return result, fn() -- inferred equivalent call
								end

								result[v4] = {
									distance = magnitude,
									boundingBox = { min = viewportCorners, max = max },
									hitRate = hitRate,
									visibleRegions = { createSingleVisibleRegionFromWorldSpaceCorners(
											assetCorners,
											currentCamera,
											viewportInfo
										) },
									adUnitName = adUnitName,
									assetId = assetId,
									encryptedAdTrackingData = encryptedAdTrackingData,
									encryptionMetadata = encryptionMetadata
								}

								default:logRobloxTelemetryEvent({
									eventName = "AdIdentifiedInAbuseReport",
									backends = { LoggingProtocol.TelemetryBackends.Points },
									throttlingPercentage = GetFIntAdIdentifiedTelemetryThrottleHundredthsPercent(),
									lastUpdated = { 24, 6, 25 },
									description = "Ad Identified in Report Anything Screenshot"
								}, nil, {
									assetId = assetId,
									encryptedAdTrackingData = encryptedAdTrackingData,
									encryptionMetadata = encryptionMetadata
								})

								result2.checkedAds += 1
								v4 += 1
								continue
							end
						end
					end
				end
			end

			result2.checkedAds += 1
		end
	end

	return result, fn() -- inferred equivalent call
end

return AdIdentification
