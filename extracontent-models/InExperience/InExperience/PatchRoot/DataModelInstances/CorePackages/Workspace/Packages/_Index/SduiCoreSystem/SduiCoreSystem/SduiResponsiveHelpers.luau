local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local ArgCheck = require(SduiCoreSystemParent.ArgCheck)
local GetDisplayStore = require(SduiCoreSystemParent.Display).GetDisplayStore

require(SduiCoreSystem.SduiBuilderTypes)

local SduiConditionKey = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes).SduiConditionKey
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local v9 = game:DefineFastString("SduiForcePerfLevel", "")
local v10 = game:DefineFastString("SduiForceImageQualityLevel", "")
local t1 = {
	low = 1,
	Low = 1,
	medium = 2,
	Medium = 2,
	high = 3,
	High = 3
}
local t2 = {
	[Enum.DeviceLevel.Low] = 1,
	[Enum.DeviceLevel.Medium] = 2,
	[Enum.DeviceLevel.High] = 3
}
local u13 = nil
local ResolutionScale = nil

local function getDevicePerformanceValue() -- line: 48
	-- upvalues: u13 (ref), v9 (copy), t1 (copy), UserInputService (copy), t2 (copy)
	if u13 == nil then
		if v9 ~= "" then
			u13 = t1[v9] or t1.High
		else
			u13 = t2[UserInputService:GetDeviceLevel()] or t1.High
		end
	end

	return u13
end
local function getImageQualityValue() -- line: 60
	-- upvalues: v10 (copy), t1 (copy), u13 (ref), v9 (copy), UserInputService (copy), t2 (copy), ResolutionScale (ref), GuiService (copy), ArgCheck (copy)
	if v10 ~= "" then
		return t1[v10] or t1.High
	end

	if u13 == nil then
		if v9 ~= "" then
			u13 = t1[v9] or t1.High
		else
			u13 = t2[UserInputService:GetDeviceLevel()] or t1.High
		end
	end

	local v17 = u13

	if v17 == t1.Low then
		return t1.Low
	end

	if v17 == t1.Medium then
		return t1.Medium
	end

	if v17 == t1.High then
		if ResolutionScale == nil then
			ResolutionScale = GuiService:GetResolutionScale()
		end

		if ResolutionScale >= 2 then
			return t1.High
		end

		return t1.Medium
	end

	ArgCheck.assert(true, `Unexpected performanceLevel { v17 }`)

	return t1.High
end

return {
	PERF_KEY = "performanceLevel",
	IMAGE_QUALITY_KEY = "imageQualityLevel",
	shouldIncludeKey = function(s1: string) -- line: 117
		if s1 == "imageQualityLevel" or s1 == "performanceLevel" then
			return false
		end

		return true
	end,
	shouldFailConditionEarly = function(s2: string, p1, p2) -- line: 87
		-- upvalues: u13 (ref), v9 (copy), t1 (copy), UserInputService (copy), t2 (copy), SduiErrors (copy), getImageQualityValue (copy)
		if s2 == "performanceLevel" then
			if u13 == nil then
				if v9 ~= "" then
					u13 = t1[v9] or t1.High
				else
					u13 = t2[UserInputService:GetDeviceLevel()] or t1.High
				end
			end

			local v21 = u13
			local v22 = t1[p1]

			if not v22 then
				p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidResponsiveCondition, {
					name = s2,
					value = p1
				}, p2.appPage)

				return false
			end

			return v21 ~= v22
		end

		if s2 == "imageQualityLevel" then
			local v23 = getImageQualityValue()
			local v24 = t1[p1]

			if not v24 then
				p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidResponsiveCondition, {
					name = s2,
					value = p1
				}, p2.appPage)

				return false
			end

			return v23 ~= v24
		end

		return false
	end,
	setDeviceLevelValueForTests = function(n1: number?) -- line: 286
		-- upvalues: u13 (ref)
		u13 = n1
	end,
	setResolutionScaleForTests = function(n2: number?) -- line: 291
		-- upvalues: ResolutionScale (ref)
		ResolutionScale = n2
	end,
	adaptThumbnailDimensions = function(n3: number, n4: number, n5: number, n6: number, s3: string) -- line: 125
		-- upvalues: getImageQualityValue (copy), t1 (copy), ArgCheck (copy)
		local v31 = getImageQualityValue()

		if v31 == t1.High then
			return n3, n4
		end

		if v31 == t1.Low then
			return n5, n6
		end

		if v31 == t1.Medium then
			if n3 == 1320 and n4 == 440 then
				if n5 <= 660 and n6 <= 220 then
					return 660, 220
				end
			elseif n3 == 384 and n4 == 216 then
				if (s3 == "GameThumbnail" or s3 == "Asset") and n5 <= 256 and n6 <= 144 then
					return 256, 144
				end
			elseif n3 == 768 and n4 == 432 or n3 == 576 and n4 == 324 then
				if (s3 == "GameThumbnail" or s3 == "Asset") and n5 <= 384 and n6 <= 216 then
					return 384, 216
				end
			elseif n3 == 512 and n4 == 512 then
				if s3 == "GameIcon" and n5 <= 256 and n6 <= 256 then
					return 256, 256
				end
			elseif n3 == 700 and n4 == 700 and s3 == "Asset" and n5 <= 420 and n6 <= 420 then
				return 420, 420
			end
		else
			ArgCheck.assert(true, `Unexpected imageQualityLevel { v31 }`)
		end

		return n3, n4
	end,
	checkResponsiveConditions = function(t3: {[any]: any}?, vector2: Vector2, s4: string, s5: string, b1: boolean, p3) -- line: 174
		-- upvalues: SduiConditionKey (copy), getImageQualityValue (copy), t1 (copy), SduiErrors (copy), u13 (ref), v9 (copy), UserInputService (copy), t2 (copy)
		local t4 = {}

		if not t3 then
			return t4
		end

		assert(t3, "allConditionalProps must exist")

		for v39, v40 in t3 do
			local v41 = nil

			if v40.conditions then
				for v42, v43 in v40.conditions do
					if v42 ~= SduiConditionKey.minScreenWidth then
						if v42 == SduiConditionKey.maxScreenWidth then
							if not (v43 < vector2.X) then
								continue
							end

							v41 = true

							break
						end

						if v42 == SduiConditionKey.isPortrait then
							if v43 and vector2.X > vector2.Y then
								v41 = true

								break
							end

							if v43 or not (vector2.X < vector2.Y) then
								continue
							end

							v41 = true

							break
						end

						if v42 == SduiConditionKey.lastInput then
							if v43 == s4 then
								continue
							end

							v41 = true

							break
						end

						if v42 == SduiConditionKey.preferredInput then
							if v43 == s5 then
								continue
							end

							v41 = true

							break
						end

						if v42 == SduiConditionKey.isSpatial then
							if (b1 or not v43) and (not b1 or v43) then
								continue
							end

							v41 = true

							break
						end

						if v42 == SduiConditionKey.imageQualityLevel then
							local v44 = getImageQualityValue()
							local v45 = t1[v43]

							if not v45 then
								p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidResponsiveCondition, {
									name = v42,
									value = v43
								}, p3.appPage)
								v41 = true

								break
							end

							if v44 == v45 then
								continue
							end

							v41 = true

							break
						end

						if v42 ~= SduiConditionKey.performanceLevel then
							continue
						end

						if u13 == nil then
							if v9 ~= "" then
								u13 = t1[v9] or t1.High
							else
								u13 = t2[UserInputService:GetDeviceLevel()] or t1.High
							end
						end

						local v46 = u13
						local v47 = t1[v43]

						if not v47 then
							p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidResponsiveCondition, {
								name = v42,
								value = v43
							}, p3.appPage)
							v41 = true

							break
						end

						if v46 == v47 then
							continue
						end

						v41 = true

						break
					end

					if v43 > vector2.X then
						v41 = true

						break
					end
				end
			end

			t4[v39] = v41
		end

		return t4
	end,
	isPortraitOrientation = function() -- line: 273
		-- upvalues: GetDisplayStore (copy)
		local v48 = GetDisplayStore(false).getViewportSize(false)

		return v48.X < v48.Y
	end
}
