local GameSettings = UserSettings().GameSettings
local v2 = game:DefineFastFlag("IGMResetGfxQuality", false)
local v3 = game:DefineFastFlag("IGMRevertGfxQuality", false)
local v4 = game:DefineFastFlag("IGMRevertGfxLv5Only", false)
local v5 = game:DefineFastFlag("IGMResetGfxLv5Only", false)
local v6 = game:DefineFastFlag("IGMAlwaysResetGfxLv5", false)
local v7 = game:DefineFastInt("IGMTempOverrideGfxLv5", 0)

local function SavedQualitySettingEnumFromValue(p1) -- line: 16
	for _, v11 in (Enum.SavedQualitySetting:GetEnumItems()) do
		if p1 == v11.Value then
			return v11
		end
	end

	return Enum.SavedQualitySetting.Automatic
end

function applicationId() -- line: 67
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local Item = AppStorageService:GetItem("AppInstallationId")
	local v24 = typeof(Item)

	if v24 == "number" then
		return tonumber(Item) or nil
	end

	if v24 == "string" then
		if string.len(Item) <= 0 then
			return nil
		end

		return (tonumber((string.sub(Item, -string.len((tostring(1000)))))))
	end

	return nil
end

return {
	RunGfxReset = function() -- line: 26
		-- upvalues: v6 (copy), GameSettings (copy), v3 (copy), v4 (copy), v2 (copy), v5 (copy)
		local v12 = v6
		local v13 = GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.QualityLevel5
		local g18 = nil
		local v17 = nil

		if v12 and v13 then
			GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
		end

		if game:GetEngineFeature("QualityLevelReset") then
			if v3 then
				if GameSettings.QualityResetLevel >= 0 then
					local QualityResetLevel = GameSettings.QualityResetLevel

					for _, v16 in (Enum.SavedQualitySetting:GetEnumItems()) do
						if QualityResetLevel == v16.Value then
							v17 = v16
							g18 = true
						end

						if g18 then
							break
						end
					end

					if not g18 then
						v17 = Enum.SavedQualitySetting.Automatic
					end

					g18 = false

					if v4 and v17 == Enum.SavedQualitySetting.QualityLevel5 or v4 == false then
						GameSettings.SavedQualityLevel = v17
						GameSettings.QualityResetLevel = -1

						return
					end
				end
			elseif v2 then
				local v19 = v5
				local QualityResetLevel = GameSettings.QualityResetLevel

				if QualityResetLevel < 0 or QualityResetLevel == nil then
					local SavedQualityLevelValue = GameSettings.SavedQualityLevel.Value

					if v13 and v19 or v19 == false then
						GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
					end

					GameSettings.QualityResetLevel = SavedQualityLevelValue
				end
			end
		end
	end,
	TemporaryOverride = function(p2) -- line: 93
		-- upvalues: v7 (copy)
		if ((applicationId() or 0) + 329) % 1000 < v7 and (p2 == Enum.SavedQualitySetting.QualityLevel5 or p2 == Enum.SavedQualitySetting.QualityLevel5.Value) then
			return true, Enum.SavedQualitySetting.Automatic.Value
		end

		return false, Enum.SavedQualitySetting.Automatic.Value
	end
}
