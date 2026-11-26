local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ArgCheck")
local getDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Display").GetDisplayStore

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local sduiConditionKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropTypes").SduiConditionKey
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")

local defineFastString = game:DefineFastString("SduiForcePerfLevel", "")

local defineFastString2 = game:DefineFastString("SduiForceImageQualityLevel", "")

local v5 = {
	low = 1,
	Low = 1,
	medium = 2,
	Medium = 2,
	high = 3,
	High = 3
}

local v6 = {
	[Enum.DeviceLevel.Low] = 1,
	[Enum.DeviceLevel.Medium] = 2,
	[Enum.DeviceLevel.High] = 3
}

local devicePerformanceValue = nil
local v7 = nil

local function getDevicePerformanceValue()
	if devicePerformanceValue ~= nil then
		return devicePerformanceValue
	end

	if defineFastString == "" then
		devicePerformanceValue = v6[UserInputService:GetDeviceLevel()] or 3
	else
		devicePerformanceValue = v5[defineFastString] or 3
	end

	return devicePerformanceValue
end

local function getImageQualityValue()
	if defineFastString2 ~= "" then
		return v5[defineFastString2] or 3
	end

	if devicePerformanceValue == nil then
		if defineFastString == "" then
			devicePerformanceValue = v6[UserInputService:GetDeviceLevel()] or v5.High
		else
			devicePerformanceValue = v5[defineFastString] or v5.High
		end
	end

	local v8 = devicePerformanceValue

	if v8 == 1 then
		return 1
	elseif v8 == 2 then
		return 2
	end

	if v8 ~= 3 then
		ArgCheck.assert(true, `Unexpected performanceLevel {v8}`)
		return 3
	end

	if v7 == nil then
		v7 = GuiService:GetResolutionScale()
	end

	if v7 >= 2 then
		return 3
	end

	return 2
end

return {
	shouldIncludeKey = function(p2): boolean
		return p2 ~= "imageQualityLevel" and p2 ~= "performanceLevel"
	end,
	shouldFailConditionEarly = function(p2, p3, p4): boolean
		if p2 == "performanceLevel" then
			if devicePerformanceValue == nil then
				if defineFastString == "" then
					devicePerformanceValue = v6[UserInputService:GetDeviceLevel()] or v5.High
				else
					devicePerformanceValue = v5[defineFastString] or v5.High
				end
			end

			local v8 = devicePerformanceValue

			local v9 = v5[p3]

			if v9 then
				return v8 ~= v9
			end

			p4.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidResponsiveCondition,
				{ name = p2, value = p3 },
				p4.appPage
			)
			return false
		else
			if p2 ~= "imageQualityLevel" then
				return false
			end

			local imageQualityValue = getImageQualityValue()
			local v8 = v5[p3]

			if v8 then
				return imageQualityValue ~= v8
			end

			p4.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidResponsiveCondition,
				{ name = p2, value = p3 },
				p4.appPage
			)
			return false
		end
	end,
	PERF_KEY = "performanceLevel",
	IMAGE_QUALITY_KEY = "imageQualityLevel",
	setDeviceLevelValueForTests = function(p2)
		devicePerformanceValue = p2
	end,
	setResolutionScaleForTests = function(p2)
		v7 = p2
	end,
	adaptThumbnailDimensions = function(p2, p3, p4, p5, p6)
		local imageQualityValue = getImageQualityValue()

		if imageQualityValue == 3 then
			return p2, p3
		elseif imageQualityValue == 1 then
			return p4, p5
		end

		if imageQualityValue == 2 then
			if p2 == 1320 and p3 == 440 then
				if p4 <= 660 and p5 <= 220 then
					return 660, 220
				end
			elseif p2 == 384 and p3 == 216 then
				if (p6 == "GameThumbnail" or p6 == "Asset") and p4 <= 256 and p5 <= 144 then
					return 256, 144
				end
			elseif p2 == 768 and p3 == 432 or p2 == 576 and p3 == 324 then
				if (p6 == "GameThumbnail" or p6 == "Asset") and p4 <= 384 and p5 <= 216 then
					return 384, 216
				end
			elseif p2 == 512 and p3 == 512 then
				if p6 == "GameIcon" and p4 <= 256 and p5 <= 256 then
					return 256, 256
				end
			elseif p2 == 700 and p3 == 700 and p6 == "Asset" and p4 <= 420 and p5 <= 420 then
				return 420, 420
			end
		else
			ArgCheck.assert(true, `Unexpected imageQualityLevel {imageQualityValue}`)
		end

		return p2, p3
	end,
	checkResponsiveConditions = function(items, p2, p3, p4, p5, p6)
		local result = {}

		if not items then
			return result
		end

		assert(items, "allConditionalProps must exist")

		for k, item in items do
			local v8 = nil

			if item.conditions then
				for k2, condition in item.conditions do
					if k2 == sduiConditionKey.minScreenWidth then
						if p2.X < condition then
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.maxScreenWidth then
						if condition < p2.X then
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.isPortrait then
						if condition and p2.X > p2.Y or not condition and p2.X < p2.Y then
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.lastInput then
						if condition ~= p3 then
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.preferredInput then
						if condition ~= p4 then
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.isSpatial then
						if not p5 and condition or p5 and not condition then
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.imageQualityLevel then
						local imageQualityValue = getImageQualityValue()
						local v10 = v5[condition]

						if v10 then
							if imageQualityValue ~= v10 then
								v8 = true
								break
							end
						else
							p6.dependencies.logger.reportError(
								SduiErrors.SduiErrorType.InvalidResponsiveCondition,
								{ name = k2, value = condition },
								p6.appPage
							)
							v8 = true
							break
						end
					elseif k2 == sduiConditionKey.performanceLevel then
						if devicePerformanceValue == nil then
							if defineFastString == "" then
								devicePerformanceValue = v6[UserInputService:GetDeviceLevel()] or v5.High
							else
								devicePerformanceValue = v5[defineFastString] or v5.High
							end
						end

						local v10 = devicePerformanceValue

						local v11 = v5[condition]

						if v11 then
							if v10 ~= v11 then
								v8 = true
								break
							end
						else
							p6.dependencies.logger.reportError(
								SduiErrors.SduiErrorType.InvalidResponsiveCondition,
								{ name = k2, value = condition },
								p6.appPage
							)
							v8 = true
							break
						end
					end
				end
			end

			result[k] = v8
		end

		return result
	end,
	isPortraitOrientation = function(): boolean
		local viewportSize = getDisplayStore(false).getViewportSize(false)
		return viewportSize.X < viewportSize.Y
	end
}
