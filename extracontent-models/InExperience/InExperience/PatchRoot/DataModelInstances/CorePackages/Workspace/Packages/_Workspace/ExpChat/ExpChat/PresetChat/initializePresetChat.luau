local TextChatService = game:GetService("TextChatService")
local gameSettings = UserSettings().GameSettings

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)

local v = ExpChatShared.Logger:new("ExpChat/PresetChat/initializePresetChat")

local function getPresetsFromEngine()
	return TextChatService:GetPresetsAsync()
end

local function fetchPresets(data, flag: boolean?, callback) -- 3 equivalent calls inferred from this helper
	task.spawn(function()
		local success, result = pcall(callback)

		if flag then
			if not success then
				v:warning("GetPresetsAsync failed: {}", (tostring(result)))
			end
		elseif success then
			if not result then
				data.setIsLoading(false)
				return
			end

			local v2

			if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
				v2 = result.status
			else
				v2 = result.accessLevel
			end

			local v3 = v2 or "Disabled"
			data.setAccessLevel(v3)

			if v3 ~= "Disabled" then
				local version = result.version

				if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint or version and version ~= "" then
					local categoryGroups = result.categoryGroups

					if categoryGroups and #categoryGroups > 0 then
						data.setCategoryGroups(categoryGroups)
						data.setVersion(version or "")
						data.setIsEnabled(true)
					end
				else
					v:warning("Missing version in GetPresetsAsync response, treating as disabled")
					data.setAccessLevel("Disabled")
					data.setIsLoading(false)
					return
				end
			end

			data.setIsLoading(false)
		else
			v:warning("GetPresetsAsync failed: {}", (tostring(result)))
			data.setIsLoading(false)
		end
	end)
end

local function initializePresetChat(data, flag: boolean?, callback)
	local v2 = callback or getPresetsFromEngine
	fetchPresets(data, flag, v2) -- inferred equivalent call
	gameSettings:GetPropertyChangedSignal("ChatTranslationLocale"):Connect(function()
		if not flag then
			data.setIsLoading(true)
		end

		fetchPresets(data, flag, v2) -- inferred equivalent call
	end)

	gameSettings:GetPropertyChangedSignal("ChatTranslationEnabled"):Connect(function()
		if not flag then
			data.setIsLoading(true)
		end

		fetchPresets(data, flag, v2) -- inferred equivalent call
	end)
end

return initializePresetChat
