local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local gameSettings = UserSettings().GameSettings
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Utility = require(RobloxGui.Modules.Settings.Utility)
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local defineFastFlag = game:DefineFastFlag("FixChatLanguageSwitcherLabel", false)
local GetFStringChatTranslationEnabledLocales = require(RobloxGui.Modules.Flags.GetFStringChatTranslationEnabledLocales)
local engineFeature = game:GetEngineFeature("TextChatServiceSettingsSaved")

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")

return function(state, data, callback)
	local locales = { "en_us" }

	local v2 = { en_us = 1 }

	local names = { "English" }

	local url = Url.LOCALE_URL .. string.format(
		"v1/locales?displayValueLocale=%s",
		Players.LocalPlayer.LocaleId:gsub("-", "_")
	)

	local function localeCodeToLanguageCodeMappingCallback(success, result)
		if not success then
			v:warning("GameSettings chat language selector initialization failed to get all required information; defaulting to unavailable for the remainder of this session. Error message: " .. (result == nil and "Locales call did not set error message to non-nil value" or result))

			if defineFastFlag then
				local chatLanguageSelectorFrame, chatLanguageSelectorLabel, chatLanguageSelectorMode = Utility:AddNewRow(
					state,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.Chat.ChatLanguageSelectionLabel"),
					"DropDown",
					{ formatByKey },
					1
				)
				state.ChatLanguageSelectorFrame = chatLanguageSelectorFrame
				state.ChatLanguageSelectorLabel = chatLanguageSelectorLabel
				state.ChatLanguageSelectorMode = chatLanguageSelectorMode
			else
				local chatLanguageSelectorFrame, chatLanguageSelectorLabel, chatLanguageSelectorMode = Utility:AddNewRow(
					state,
					"Chat Language",
					"DropDown",
					{ formatByKey },
					1
				)
				state.ChatLanguageSelectorFrame = chatLanguageSelectorFrame
				state.ChatLanguageSelectorLabel = chatLanguageSelectorLabel
				state.ChatLanguageSelectorMode = chatLanguageSelectorMode
			end

			state.ChatLanguageSelectorFrame.LayoutOrder = data.ChatLanguageSelectorFrame
		end

		local v3 = nil

		local chatTranslationLocale = gameSettings.ChatTranslationLocale

		if chatTranslationLocale ~= "" then
			for k, v4 in locales do
				if v4 == chatTranslationLocale then
					v3 = k
				end
			end
		end

		if chatTranslationLocale == "" or v3 == nil then
			for k, v4 in locales do
				if v4 ~= LocalPlayer.LocaleId:gsub("-", "_") then
					continue
				end

				TextChatService.ChatTranslationEnabled = true
				v3 = k
			end
		end

		if v3 == nil then
			TextChatService.ChatTranslationEnabled = false
			v3 = 1
		else
			gameSettings.ChatTranslationLocale = locales[v3]
		end

		LocalPlayer:SetChatTranslationSettingsLocaleId(locales[v3])

		local locale_id = locales[v3]

		if defineFastFlag then
			local chatLanguageSelectorFrame, chatLanguageSelectorLabel, chatLanguageSelectorMode = Utility:AddNewRow(
				state,
				"Chat Translation Language",
				"DropDown",
				names,
				v3
			)
			state.ChatLanguageSelectorFrame = chatLanguageSelectorFrame
			state.ChatLanguageSelectorLabel = chatLanguageSelectorLabel
			state.ChatLanguageSelectorMode = chatLanguageSelectorMode
		else
			local chatLanguageSelectorFrame, chatLanguageSelectorLabel, chatLanguageSelectorMode = Utility:AddNewRow(
				state,
				"Chat Language",
				"DropDown",
				names,
				v3
			)
			state.ChatLanguageSelectorFrame = chatLanguageSelectorFrame
			state.ChatLanguageSelectorLabel = chatLanguageSelectorLabel
			state.ChatLanguageSelectorMode = chatLanguageSelectorMode
		end

		state.ChatLanguageSelectorFrame.LayoutOrder = data.ChatLanguageSelectorFrame

		local function onChatSelectionIndexUpdated(p)
			local chatTranslationLocale2 = gameSettings.ChatTranslationLocale
			local chatTranslationLocale3 = locales[p]
			gameSettings.ChatTranslationLocale = chatTranslationLocale3
			LocalPlayer:SetChatTranslationSettingsLocaleId(chatTranslationLocale3)
			locale_id = chatTranslationLocale3
			callback("chat_translation_locale", chatTranslationLocale2, chatTranslationLocale3)
		end

		state.ChatLanguageSelectorMode.IndexChanged:connect(onChatSelectionIndexUpdated)

		local v4 = TextChatService.ChatTranslationToggleEnabled and 1 or 2

		local chatTranslationToggleFrame, chatTranslationToggleLabel, chatTranslationToggleEnabler = Utility:AddNewRow(
			state,
			RobloxTranslator:FormatByKey("Feature.SettingsHub.Chat.TranslationToggleSetting"),
			"Selector",
			{ "On", "Off" },
			v4
		)
		state.ChatTranslationToggleFrame = chatTranslationToggleFrame
		state.ChatTranslationToggleLabel = chatTranslationToggleLabel
		state.ChatTranslationToggleEnabler = chatTranslationToggleEnabler

		state.ChatTranslationToggleFrame.LayoutOrder = data.ChatTranslationToggleFrame

		state.ChatTranslationToggleEnabler.IndexChanged:connect(function(p)
			local chatTranslationToggleEnabled2 = p == 1
			local chatTranslationToggleEnabled = TextChatService.ChatTranslationToggleEnabled

			if chatTranslationToggleEnabled2 ~= chatTranslationToggleEnabled then
				if engineFeature then
					gameSettings.ChatTranslationToggleEnabled = chatTranslationToggleEnabled2
				else
					TextChatService.ChatTranslationToggleEnabled = chatTranslationToggleEnabled2
				end

				callback("chat_translation_toggle", chatTranslationToggleEnabled, chatTranslationToggleEnabled2, {
					locale_id = locale_id
				})
			end
		end)

		local v5 = TextChatService.ChatTranslationEnabled and 1 or 2

		if v5 == 2 then
			state.ChatLanguageSelectorFrame.Visible = false
			state.ChatTranslationToggleFrame.Visible = false
		end

		local chatTranslationFrame, chatTranslationLabel, chatTranslationEnabler = Utility:AddNewRow(
			state,
			RobloxTranslator:FormatByKey("Feature.SettingsHub.Chat.TranslationSetting"),
			"Selector",
			{ "On", "Off" },
			v5
		)
		state.ChatTranslationFrame = chatTranslationFrame
		state.ChatTranslationLabel = chatTranslationLabel
		state.ChatTranslationEnabler = chatTranslationEnabler

		state.ChatTranslationFrame.LayoutOrder = data.ChatTranslationFrame

		state.ChatTranslationEnabler.IndexChanged:connect(function(p)
			local chatTranslationEnabled2 = p == 1
			local chatTranslationEnabled = TextChatService.ChatTranslationEnabled

			if engineFeature then
				gameSettings.ChatTranslationEnabled = chatTranslationEnabled2
			else
				TextChatService.ChatTranslationEnabled = chatTranslationEnabled2
			end

			callback("chat_translation", chatTranslationEnabled, chatTranslationEnabled2, {
				locale_id = LocalPlayer.LocaleId
			})

			if p == 1 then
				state.ChatLanguageSelectorFrame.Visible = true
				state.ChatTranslationToggleFrame.Visible = true
			else
				state.ChatLanguageSelectorFrame.Visible = false
				state.ChatTranslationToggleFrame.Visible = false
			end
		end)
	end

	HttpService:RequestInternal({ Url = url, Method = "GET" }):Start(function(p, p2)
		local success = false
		local result

		if p then
			if p2.StatusCode == 401 then
				result = "Locale Code to Language Code Mapping Request: Unauthorized"
			elseif p2.StatusCode < 200 or p2.StatusCode >= 400 then
				result = "Locale Code to Language Code Mapping Request Status code: " .. p2.StatusCode
			else
				success, result = pcall(function()
					local jsonDecode = HttpService:JSONDecode(p2.Body)

					local v3 = GetFStringChatTranslationEnabledLocales():gmatch("([^,]+)")
					local v4 = {}

					for k in v3 do
						table.insert(v4, k)
					end

					local function shouldAddLocaleAsChatTranslationOption(locale): boolean -- 1 equivalent call inferred from this helper
						for _, v5 in v4 do
							if v5 == locale then
								return true
							end
						end

						return false
					end

					local v5 = 2

					for _, v6 in pairs(jsonDecode.data) do
						local locale = v6.locale.locale
						local name = v6.locale.language.name

						if locale == "en_us" then
							names[1] = name
						elseif shouldAddLocaleAsChatTranslationOption(locale) then -- inferred equivalent call
							table.insert(names, name)
							locales[v5] = locale
							v2[locale] = v5
							v5 += 1
						end
					end
				end)
			end
		else
			result = "Locale Code to Language Code Mapping Request: Connection error"
		end

		if not success then
			v:warning("GameSettings chat language selector initialization: Failed to get response from Localization API for " .. url .. " with error message: " .. result)
		end

		localeCodeToLanguageCodeMappingCallback(success, result)
	end)
end
