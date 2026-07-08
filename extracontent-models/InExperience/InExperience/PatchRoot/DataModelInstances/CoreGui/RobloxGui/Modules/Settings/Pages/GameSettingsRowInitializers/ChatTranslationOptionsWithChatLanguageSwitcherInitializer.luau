local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local GameSettings = UserSettings().GameSettings
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Utility = require(RobloxGui.Modules.Settings.Utility)
local v11 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v13 = game:DefineFastFlag("FixChatLanguageSwitcherLabel", false)
local GetFStringChatTranslationEnabledLocales = require(RobloxGui.Modules.Flags.GetFStringChatTranslationEnabledLocales)
local EngineFeature = game:GetEngineFeature("TextChatServiceSettingsSaved")
local v16 = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")

return function(p1, p2, p3) -- line: 29
	-- upvalues: Url (copy), Players (copy), HttpService (copy), v11 (copy), v13 (copy), Utility (copy), RobloxTranslator (copy), v16 (copy), GameSettings (copy), LocalPlayer (copy), TextChatService (copy), EngineFeature (copy), GetFStringChatTranslationEnabledLocales (copy)
	local t1 = {
		[1] = "en_us"
	}
	local t2 = {
		en_us = 1
	}
	local t3 = { "English" }
	local v23 = Url.LOCALE_URL .. string.format("v1/locales?displayValueLocale=%s", Players.LocalPlayer.LocaleId:gsub("-", "_"))

	local function localeCodeToLanguageCodeMappingCallback(p4, p5) -- line: 53
		-- upvalues: v11 (copy), v13 (copy), p1 (copy), Utility (copy), RobloxTranslator (copy), v16 (copy), p2 (copy), GameSettings (copy), t1 (copy), LocalPlayer (copy), TextChatService (copy), t3 (copy), p3 (copy), EngineFeature (copy)
		if not p4 then
			if p5 == nil then
				p5 = "Locales call did not set error message to non-nil value"
			end

			v11:warning("GameSettings chat language selector initialization failed to get all required information; defaulting to unavailable for the remainder of this session. Error message: " .. p5)

			if v13 then
				local v27 = p1
				local v28 = p1
				local v29 = p1
				local v30, v31, v32 = Utility:AddNewRow(p1, RobloxTranslator:FormatByKey("Feature.SettingsHub.Chat.ChatLanguageSelectionLabel"), "DropDown", { v16 }, 1)

				v27.ChatLanguageSelectorFrame = v30
				v28.ChatLanguageSelectorLabel = v31
				v29.ChatLanguageSelectorMode = v32
			else
				local v33 = p1
				local v34 = p1
				local v35 = p1
				local v36, v37, v38 = Utility:AddNewRow(p1, "Chat Language", "DropDown", { v16 }, 1)

				v33.ChatLanguageSelectorFrame = v36
				v34.ChatLanguageSelectorLabel = v37
				v35.ChatLanguageSelectorMode = v38
			end

			p1.ChatLanguageSelectorFrame.LayoutOrder = p2.ChatLanguageSelectorFrame
		end

		local v39 = nil
		local ChatTranslationLocale = GameSettings.ChatTranslationLocale

		if ChatTranslationLocale ~= "" then
			for v41, v42 in t1 do
				if v42 == ChatTranslationLocale then
					v39 = v41
				end
			end
		end

		if ChatTranslationLocale == "" or v39 == nil then
			for v43, v44 in t1 do
				if v44 == LocalPlayer.LocaleId:gsub("-", "_") then
					v39 = v43
					TextChatService.ChatTranslationEnabled = true
				end
			end
		end

		if v39 == nil then
			TextChatService.ChatTranslationEnabled = false
			v39 = 1
		else
			GameSettings.ChatTranslationLocale = t1[v39]
		end

		LocalPlayer:SetChatTranslationSettingsLocaleId(t1[v39])

		local u45 = t1[v39]

		if v13 then
			local v46 = p1
			local v47 = p1
			local v48 = p1
			local v49, v50, v51 = Utility:AddNewRow(p1, "Chat Translation Language", "DropDown", t3, v39)

			v46.ChatLanguageSelectorFrame = v49
			v47.ChatLanguageSelectorLabel = v50
			v48.ChatLanguageSelectorMode = v51
		else
			local v52 = p1
			local v53 = p1
			local v54 = p1
			local v55, v56, v57 = Utility:AddNewRow(p1, "Chat Language", "DropDown", t3, v39)

			v52.ChatLanguageSelectorFrame = v55
			v53.ChatLanguageSelectorLabel = v56
			v54.ChatLanguageSelectorMode = v57
		end

		p1.ChatLanguageSelectorFrame.LayoutOrder = p2.ChatLanguageSelectorFrame

		local function onChatSelectionIndexUpdated(p6) -- line: 134
			-- upvalues: GameSettings (copy), t1 (copy), LocalPlayer (copy), u45 (ref), p3 (copy)
			local ChatTranslationLocale2 = GameSettings.ChatTranslationLocale
			local v79 = t1[p6]

			GameSettings.ChatTranslationLocale = v79
			LocalPlayer:SetChatTranslationSettingsLocaleId(v79)
			u45 = v79
			p3("chat_translation_locale", ChatTranslationLocale2, v79)
		end

		p1.ChatLanguageSelectorMode.IndexChanged:connect(onChatSelectionIndexUpdated)

		local v59 = not TextChatService.ChatTranslationToggleEnabled and 2 or 1
		local v60 = p1
		local v61 = p1
		local v62 = p1
		local v63, v64, v65 = Utility:AddNewRow(p1, RobloxTranslator:FormatByKey("Feature.SettingsHub.Chat.TranslationToggleSetting"), "Selector", {
			"On",
			"Off"
		}, v59)

		v60.ChatTranslationToggleFrame = v63
		v61.ChatTranslationToggleLabel = v64
		v62.ChatTranslationToggleEnabler = v65
		p1.ChatTranslationToggleFrame.LayoutOrder = p2.ChatTranslationToggleFrame
		p1.ChatTranslationToggleEnabler.IndexChanged:connect(function(p7) -- line: 161
			-- upvalues: TextChatService (copy), EngineFeature (copy), GameSettings (copy), p3 (copy), u45 (ref)
			local v81 = p7 == 1
			local ChatTranslationToggleEnabled = TextChatService.ChatTranslationToggleEnabled

			if v81 ~= ChatTranslationToggleEnabled then
				if EngineFeature then
					GameSettings.ChatTranslationToggleEnabled = v81
				else
					TextChatService.ChatTranslationToggleEnabled = v81
				end

				p3("chat_translation_toggle", ChatTranslationToggleEnabled, v81, {
					locale_id = u45
				})
			end
		end)

		local v66 = not TextChatService.ChatTranslationEnabled and 2 or 1

		if v66 == 2 then
			p1.ChatLanguageSelectorFrame.Visible = false
			p1.ChatTranslationToggleFrame.Visible = false
		end

		local v67 = p1
		local v68 = p1
		local v69 = p1
		local v70, v71, v72 = Utility:AddNewRow(p1, RobloxTranslator:FormatByKey("Feature.SettingsHub.Chat.TranslationSetting"), "Selector", {
			"On",
			"Off"
		}, v66)

		v67.ChatTranslationFrame = v70
		v68.ChatTranslationLabel = v71
		v69.ChatTranslationEnabler = v72
		p1.ChatTranslationFrame.LayoutOrder = p2.ChatTranslationFrame
		p1.ChatTranslationEnabler.IndexChanged:connect(function(p8) -- line: 198
			-- upvalues: TextChatService (copy), EngineFeature (copy), GameSettings (copy), p3 (copy), LocalPlayer (copy), p1 (copy)
			local v84 = p8 == 1
			local ChatTranslationEnabled = TextChatService.ChatTranslationEnabled

			if EngineFeature then
				GameSettings.ChatTranslationEnabled = v84
			else
				TextChatService.ChatTranslationEnabled = v84
			end

			p3("chat_translation", ChatTranslationEnabled, v84, {
				locale_id = LocalPlayer.LocaleId
			})

			if p8 == 1 then
				p1.ChatLanguageSelectorFrame.Visible = true
				p1.ChatTranslationToggleFrame.Visible = true

				return
			end

			p1.ChatLanguageSelectorFrame.Visible = false
			p1.ChatTranslationToggleFrame.Visible = false
		end)
	end

	HttpService:RequestInternal({
		Method = "GET",
		Url = v23
	}):Start(function(p9, p10) -- line: 223
		-- upvalues: HttpService (copy), GetFStringChatTranslationEnabledLocales (copy), t3 (copy), t1 (copy), t2 (copy), v11 (copy), v23 (copy), localeCodeToLanguageCodeMappingCallback (copy)
		local v75 = false
		local s1

		if not p9 then
			s1 = "Locale Code to Language Code Mapping Request: Connection error"
		elseif p10.StatusCode == 401 then
			s1 = "Locale Code to Language Code Mapping Request: Unauthorized"
		elseif p10.StatusCode < 200 or p10.StatusCode >= 400 then
			s1 = "Locale Code to Language Code Mapping Request Status code: " .. p10.StatusCode
		else
			v75, s1 = pcall(function() -- line: 234
				-- upvalues: HttpService (copy), p10 (copy), GetFStringChatTranslationEnabledLocales (copy), t3 (copy), t1 (copy), t2 (copy)
				local data = HttpService:JSONDecode(p10.Body)
				local t4 = {}
				local g98 = nil
				local v97 = nil

				for match in GetFStringChatTranslationEnabledLocales():gmatch("([^,]+)") do
					table.insert(t4, match)
				end

				local function shouldAddLocaleAsChatTranslationOption(p11) -- line: 244
					-- upvalues: t4 (copy)
					for _, v101 in t4 do
						if v101 == p11 then
							return true
						end
					end

					return false
				end

				local n1 = 2

				for _, v in pairs(data.data) do
					local locale = v.locale.locale
					local name = v.locale.language.name

					if locale == "en_us" then
						t3[1] = name
					else
						for _, v96 in t4 do
							if v96 == locale then
								v97 = true
								g98 = true
							end

							if g98 then
								break
							end
						end

						if not g98 then
							v97 = false
						end

						g98 = false

						if v97 then
							table.insert(t3, name)
							t1[n1] = locale
							t2[locale] = n1
							n1 += 1
						end
					end
				end
			end)
		end

		if not v75 then
			v11:warning("GameSettings chat language selector initialization: Failed to get response from Localization API for " .. v23 .. " with error message: " .. s1)
		end

		localeCodeToLanguageCodeMappingCallback(v75, s1)
	end)
end
