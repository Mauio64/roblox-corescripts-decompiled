local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
local ArgCheck = require(parent.ArgCheck)
local Display = require(parent.Display)
local GetDisplayStore = Display.GetDisplayStore

require(SduiCoreSystem.SduiBuilderTypes)
local SduiConditionalPropTypes = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local SduiConditionKey = SduiConditionalPropTypes.SduiConditionKey
local SduiErrors = require(SduiCoreSystem.SduiErrors)

local defineFastString = game:DefineFastString("SduiForcePerfLevel", "")

local defineFastString2 = game:DefineFastString("SduiForceImageQualityLevel", "")

local v = {
	low = 1,
	Low = 1,
	medium = 2,
	Medium = 2,
	high = 3,
	High = 3
}

local v2 = {
	[Enum.DeviceLevel.Low] = 1,
	[Enum.DeviceLevel.Medium] = 2,
	[Enum.DeviceLevel.High] = 3
}

local devicePerformanceValue = nil
local v3 = nil

local function getDevicePerformanceValue()
	if devicePerformanceValue ~= nil then
		return devicePerformanceValue
	end

	if defineFastString == "" then
		devicePerformanceValue = v2[UserInputService:GetDeviceLevel()] or 3
	else
		devicePerformanceValue = v[defineFastString] or 3
	end

	return devicePerformanceValue
end

local function getImageQualityValue()
	if defineFastString2 ~= "" then
		return v[defineFastString2] or 3
	end

	if devicePerformanceValue == nil then
		if defineFastString == "" then
			devicePerformanceValue = v2[UserInputService:GetDeviceLevel()] or v.High
		else
			devicePerformanceValue = v[defineFastString] or v.High
		end
	end

	local v4 = devicePerformanceValue

	if v4 == 1 then
		return 1
	elseif v4 == 2 then
		return 2
	end

	if v4 ~= 3 then
		ArgCheck.assert(true, `Unexpected performanceLevel {v4}`)
		return 3
	end

	if v3 == nil then
		v3 = GuiService:GetResolutionScale()
	end

	return if v3 >= 2 then 3 else 2
end

local SduiResponsiveHelpers = {}

function SduiResponsiveHelpers.shouldIncludeKey(p: string): boolean
	return p ~= "imageQualityLevel" and p ~= "performanceLevel"
end

function SduiResponsiveHelpers.shouldFailConditionEarly(name: string, p, p2): boolean
	if name == "performanceLevel" then
		if devicePerformanceValue == nil then
			if defineFastString == "" then
				devicePerformanceValue = v2[UserInputService:GetDeviceLevel()] or v.High
			else
				devicePerformanceValue = v[defineFastString] or v.High
			end
		end

		local v4 = devicePerformanceValue

		local v5 = v[p]

		if v5 then
			return v4 ~= v5
		end

		p2.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.InvalidResponsiveCondition,
			{ name = name, value = p },
			p2.appPage
		)
		return false
	else
		if name ~= "imageQualityLevel" then
			return false
		end

		local imageQualityValue = getImageQualityValue()
		local v4 = v[p]

		if v4 then
			return imageQualityValue ~= v4
		end

		p2.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.InvalidResponsiveCondition,
			{ name = name, value = p },
			p2.appPage
		)
		return false
	end
end

SduiResponsiveHelpers.PERF_KEY = "performanceLevel"
SduiResponsiveHelpers.IMAGE_QUALITY_KEY = "imageQualityLevel"

function SduiResponsiveHelpers.setDeviceLevelValueForTests(p: number?)
	devicePerformanceValue = p
end

function SduiResponsiveHelpers.setResolutionScaleForTests(p: number?)
	v3 = p
end

function SduiResponsiveHelpers.adaptThumbnailDimensions(p: number, p2: number, p3: number, p4: number, p5: string)
	local imageQualityValue = getImageQualityValue()

	if imageQualityValue == 3 then
		return p, p2
	elseif imageQualityValue == 1 then
		return p3, p4
	end

	if imageQualityValue == 2 then
		if p == 1320 and p2 == 440 then
			if p3 <= 660 and p4 <= 220 then
				return 660, 220
			end
		elseif p == 384 and p2 == 216 then
			if (p5 == "GameThumbnail" or p5 == "Asset") and p3 <= 256 and p4 <= 144 then
				return 256, 144
			end
		elseif p == 768 and p2 == 432 or p == 576 and p2 == 324 then
			if (p5 == "GameThumbnail" or p5 == "Asset") and p3 <= 384 and p4 <= 216 then
				return 384, 216
			end
		elseif p == 512 and p2 == 512 then
			if p5 == "GameIcon" and p3 <= 256 and p4 <= 256 then
				return 256, 256
			end
		elseif p == 700 and p2 == 700 and p5 == "Asset" and p3 <= 420 and p4 <= 420 then
			return 420, 420
		end
	else
		ArgCheck.assert(true, `Unexpected imageQualityLevel {imageQualityValue}`)
	end

	return p, p2
end

function SduiResponsiveHelpers.checkResponsiveConditions(items, vector2: Vector2, p: string, p2: string, flag: boolean, p3)
	local result = {}

	if not items then
		return result
	end

	assert(items, "allConditionalProps must exist")

	for k, item in items do
		local v4 = nil

		if item.conditions then
			for k2, condition in item.conditions do
				if k2 == SduiConditionKey.minScreenWidth then
					if vector2.X < condition then
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.maxScreenWidth then
					if condition < vector2.X then
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.isPortrait then
					if condition and vector2.X > vector2.Y or not condition and vector2.X < vector2.Y then
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.lastInput then
					if condition ~= p then
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.preferredInput then
					if condition ~= p2 then
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.isSpatial then
					if not flag and condition or flag and not condition then
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.imageQualityLevel then
					local imageQualityValue = getImageQualityValue()
					local v5 = v[condition]

					if v5 then
						if imageQualityValue ~= v5 then
							v4 = true
							break
						end
					else
						p3.dependencies.logger.reportError(
							SduiErrors.SduiErrorType.InvalidResponsiveCondition,
							{ name = k2, value = condition },
							p3.appPage
						)
						v4 = true
						break
					end
				elseif k2 == SduiConditionKey.performanceLevel then
					if devicePerformanceValue == nil then
						if defineFastString == "" then
							devicePerformanceValue = v2[UserInputService:GetDeviceLevel()] or v.High
						else
							devicePerformanceValue = v[defineFastString] or v.High
						end
					end

					local v5 = devicePerformanceValue

					local v6 = v[condition]

					if v6 then
						if v5 ~= v6 then
							v4 = true
							break
						end
					else
						p3.dependencies.logger.reportError(
							SduiErrors.SduiErrorType.InvalidResponsiveCondition,
							{ name = k2, value = condition },
							p3.appPage
						)
						v4 = true
						break
					end
				end
			end
		end

		result[k] = v4
	end

	return result
end

function SduiResponsiveHelpers.isPortraitOrientation(): boolean
	local viewportSize = GetDisplayStore(false).getViewportSize(false)
	return viewportSize.X < viewportSize.Y
end

return SduiResponsiveHelpers
