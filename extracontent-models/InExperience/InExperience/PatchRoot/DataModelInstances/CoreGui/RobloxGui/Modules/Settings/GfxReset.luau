local gameSettings = UserSettings().GameSettings

local defineFastFlag = game:DefineFastFlag("IGMResetGfxQuality", false)
local defineFastFlag2 = game:DefineFastFlag("IGMRevertGfxQuality", false)
local defineFastFlag3 = game:DefineFastFlag("IGMRevertGfxLv5Only", false)

local defineFastFlag4 = game:DefineFastFlag("IGMResetGfxLv5Only", false)
local defineFastFlag5 = game:DefineFastFlag("IGMAlwaysResetGfxLv5", false)
local defineFastInt = game:DefineFastInt("IGMTempOverrideGfxLv5", 0)

local function SavedQualitySettingEnumFromValue(qualityResetLevel) -- 1 equivalent call inferred from this helper
	local enumItems = Enum.SavedQualitySetting:GetEnumItems()

	for _, enumItem in enumItems do
		if enumItem.Value == qualityResetLevel then
			return enumItem
		end
	end

	return Enum.SavedQualitySetting.Automatic
end

function applicationId()
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local item = AppStorageService:GetItem("AppInstallationId")
	local typeName = typeof(item)

	if typeName == "number" then
		return tonumber(item) or nil
	end

	if typeName ~= "string" or string.len(item) <= 0 then
		return nil
	end

	return (tonumber((string.sub(item, -string.len((tostring(1000)))))))
end

local GfxReset = {}

function GfxReset.RunGfxReset()
	local v = gameSettings.SavedQualityLevel == Enum.SavedQualitySetting.QualityLevel5

	if defineFastFlag5 and v then
		gameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
	end

	if game:GetEngineFeature("QualityLevelReset") then
		if defineFastFlag2 then
			if gameSettings.QualityResetLevel >= 0 then
				local savedQualityLevel = SavedQualitySettingEnumFromValue(gameSettings.QualityResetLevel) -- inferred equivalent call

				if
					defineFastFlag3 and savedQualityLevel == Enum.SavedQualitySetting.QualityLevel5
					or defineFastFlag3 == false
				then
					gameSettings.SavedQualityLevel = savedQualityLevel
					gameSettings.QualityResetLevel = -1
				end
			end
		elseif defineFastFlag then
			local v2 = defineFastFlag4
			local qualityResetLevel = gameSettings.QualityResetLevel

			if qualityResetLevel < 0 or qualityResetLevel == nil then
				local qualityResetLevel2 = gameSettings.SavedQualityLevel.Value

				if v and v2 or v2 == false then
					gameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
				end

				gameSettings.QualityResetLevel = qualityResetLevel2
			end
		end
	end
end

function GfxReset.TemporaryOverride(p)
	if
		((applicationId() or 0) + 329) % 1000 < defineFastInt
		and (p == Enum.SavedQualitySetting.QualityLevel5 or p == Enum.SavedQualitySetting.QualityLevel5.Value)
	then
		return true, Enum.SavedQualitySetting.Automatic.Value
	end

	return false, Enum.SavedQualitySetting.Automatic.Value
end

return GfxReset
