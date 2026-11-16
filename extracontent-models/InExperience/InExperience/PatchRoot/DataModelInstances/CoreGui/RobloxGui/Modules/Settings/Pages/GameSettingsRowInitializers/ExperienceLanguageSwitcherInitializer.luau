local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Utility = require(RobloxGui.Modules.Settings.Utility)
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local engineFeature = game:GetEngineFeature("UgcLocaleFromGameJoinEnabled")

local v2 = {
	sq = "sq_al",
	ar = "ar_001",
	bn = "bn_bd",
	nb = "nb_no",
	bs = "bs_ba",
	bg = "bg_bg",
	my = "my_mm",
	["zh-hans"] = "zh_cn",
	["zh-hant"] = "zh_tw",
	hr = "hr_hr",
	cs = "cs_cz",
	da = "da_dk",
	nl = "nl_nl",
	en = "en_us",
	et = "et_ee",
	fil = "fil_ph",
	fi = "fi_fi",
	fr = "fr_fr",
	ka = "ka_ge",
	de = "de_de",
	el = "el_gr",
	hi = "hi_in",
	hu = "hu_hu",
	id = "id_id",
	it = "it_it",
	ja = "ja_jp",
	kk = "kk_kz",
	km = "km_kh",
	ko = "ko_kr",
	lv = "lv_lv",
	lt = "lt_lt",
	ms = "ms_my",
	pl = "pl_pl",
	pt = "pt_br",
	ro = "ro_ro",
	ru = "ru_ru",
	sr = "sr_rs",
	si = "si_lk",
	sk = "sk_sk",
	sl = "sl_sl",
	es = "es_es",
	sv = "sv_se",
	th = "th_th",
	tr = "tr_tr",
	uk = "uk_ua",
	vi = "vi_vn"
}

return function(state, p, callback)
	local v3 = 1
	local v4 = 1
	local flag = false

	local v5 = nil
	local v6 = Players.LocalPlayer.LocaleId:gsub("-", "_")
	local v7 = nil
	local localesByName = {}
	local v8 = {}

	local v9 = {}
	local localesById = {}

	local idsById = {}

	local v10 = {}

	local url = Url.LOCALE_URL .. string.format(
		"v1/locales?displayValueLocale=%s",
		Players.LocalPlayer.LocaleId:gsub("-", "_")
	)
	local internal = HttpService:RequestInternal({ Url = url, Method = "GET" })

	local url2 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
	local internal2 = HttpService:RequestInternal({ Url = url2, Method = "GET" })

	local url3 = Url.GAME_INTERNATIONALIZATION_URL .. string.format(
		"v1/supported-languages/games/%d/in-experience-language-selection",
		game.GameId
	)
	local internal3 = HttpService:RequestInternal({ Url = url3, Method = "GET" })

	local url4 = Url.GAME_INTERNATIONALIZATION_URL .. string.format(
		"v1/user-localization-settings/universe/%d",
		game.GameId
	)
	local internal4 = HttpService:RequestInternal({ Url = url4, Method = "GET" })

	local function tryGetErrorMessage(p2, p3) -- 5 equivalent calls inferred from this helper
		local statusCode = nil

		if not (p2 and p3 and p3.StatusCode) then
			return "Connection error"
		end

		if p3.StatusCode == 401 then
			return "Unauthorized"
		end

		if p3.StatusCode < 200 or p3.StatusCode >= 400 then
			statusCode = p3.StatusCode
		end

		return statusCode
	end

	local function createSessionDormantLanguageSwitcherRow()
		local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
			state,
			RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
			"DropDown",
			{ RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable") },
			1
		)
		state.LanguageSelectorFrame = languageSelectorFrame
		state.LanguageSelectorLabel = languageSelectorLabel
		state.LanguageSelectorMode = languageSelectorMode

		state.LanguageSelectorMode:SetInteractable(false)
		state.LanguageSelectorFrame.LayoutOrder = p.LanguageSelectorFrame
	end

	local function userExperienceLanguageSettingsCallback(success, result) -- 4 equivalent calls inferred from this helper
		if success then
			local v11 = false

			for _, v12 in v8 do
				v11 = v12 == v7 or v11

				if v12 ~= v5 then
					table.insert(v10, v9[v12].localeName)
				end
			end

			table.sort(v10)

			if v5 == nil or v9[v5].localeName == nil then
				createSessionDormantLanguageSwitcherRow()
				return
			end

			table.insert(v10, 1, v9[v5].localeName .. " (Original)")

			if v11 == true then
				for k, v12 in v10 do
					if not (k ~= 1 and localesByName[v12] == v7) then
						continue
					end

					v3 = k
					v4 = k
				end
			end

			local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
				state,
				RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
				"DropDown",
				v10,
				v3
			)
			state.LanguageSelectorFrame = languageSelectorFrame
			state.LanguageSelectorLabel = languageSelectorLabel
			state.LanguageSelectorMode = languageSelectorMode

			state.LanguageSelectorFrame.LayoutOrder = p.LanguageSelectorFrame

			if not engineFeature then
				if v3 == 1 then
					LocalPlayer:SetExperienceSettingsLocaleId(v5)
				else
					LocalPlayer:SetExperienceSettingsLocaleId(localesByName[v10[v3]])
				end
			end

			state.LanguageSelectorMode.CurrentLocale = state.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

			local function toggleTranslation(p2)
				state.LanguageSelectorMode:SetInteractable(false)
				local localeId

				if p2 == 1 and v9[v5] ~= nil then
					localeId = v9[v5].localeId
				else
					localeId = v9[localesByName[v10[p2]]].localeId
				end

				local currentLocale = state.LanguageSelectorMode.CurrentLocale
				local currentLocale2 = v10[p2]

				if currentLocale ~= currentLocale2 then
					state.LanguageSelectorMode.CurrentLocale = currentLocale2
					callback("experience_locale", currentLocale, currentLocale2)
				end

				local url5 = Url.GAME_INTERNATIONALIZATION_URL .. string.format(
					"v1/user-localization-settings/universe/%d",
					game.GameId
				)
				local internal5 = HttpService:RequestInternal({
					Url = url5,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService:JSONEncode({
						settingValue = {
							settingType = "SupportedLocale",
							settingTargetId = localeId
						}
					})
				})

				local function userExperienceLanguageSettingsUpdateCallback(p3, p4)
					if p3 then
						v4 = p2

						if p2 == 1 then
							LocalPlayer:SetExperienceSettingsLocaleId(v5)
						else
							LocalPlayer:SetExperienceSettingsLocaleId(localesByName[v10[p2]])
						end
					else
						v:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p4)

						flag = true
						state.LanguageSelectorMode:SetSelectionIndex(v4)
					end

					state.LanguageSelectorMode:SetInteractable(true)
				end

				if RunService:IsStudio() then
					v4 = p2

					if p2 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(v5)
					else
						LocalPlayer:SetExperienceSettingsLocaleId(localesByName[v10[p2]])
					end
				elseif flag then
					flag = false
					v4 = p2

					if p2 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(v5)
					else
						LocalPlayer:SetExperienceSettingsLocaleId(localesByName[v10[p2]])
					end
				else
					if localeId ~= nil then
						internal5:Start(function(p3, p4)
							local v12 = false
							local v13 = tryGetErrorMessage(p3, p4) -- inferred equivalent call

							if v13 == nil then
								v:info("User Experience Language Settings Update Request: " .. "Succeeded with code - " .. p4.StatusCode)
								v12 = true
							else
								v13 = "User Experience Language Settings Update Request: " .. v13
								v:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. url5 .. " with error message: " .. v13)
							end

							userExperienceLanguageSettingsUpdateCallback(v12, v13)
						end)

						return
					end

					v:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. nil)

					flag = true
					state.LanguageSelectorMode:SetSelectionIndex(v4)
				end

				state.LanguageSelectorMode:SetInteractable(true)
			end

			state.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
		else
			v:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (result == nil and "Execution path did not set earliest error to non-nil value." or result))

			createSessionDormantLanguageSwitcherRow()
		end
	end

	local function experienceSourceLanguageCallback(p2, p3) -- 1 equivalent call inferred from this helper
		if p2 then
			internal4:Start(function(p4, p5)
				local success = false
				local v11 = tryGetErrorMessage(p4, p5) -- inferred equivalent call
				local result

				if v11 == nil then
					success, result = pcall(function()
						local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p5.Body).userUniverseLocalizationSettingValue

						if userUniverseLocalizationSettingValue == nil then
							v7 = v6
							return
						end

						local settingTargetId = userUniverseLocalizationSettingValue.settingTargetId
						local settingType = userUniverseLocalizationSettingValue.settingType

						if settingTargetId == nil then
							v7 = v6
						end

						if settingType == "SourceOrTranslation" then
							v7 = if settingTargetId == 1 then v5 else v6
						elseif settingType == "LanguageFamily" then
							if idsById[settingTargetId] == nil then
								v7 = v6
							else
								v7 = localesById[idsById[settingTargetId]]
							end
						elseif settingType == "SupportedLocale" then
							if localesById[settingTargetId] == nil then
								v7 = v6
							else
								v7 = localesById[settingTargetId]
							end
						end
					end)
				else
					result = "User Experience Language Setting Get Request: " .. v11
				end

				if not success then
					v:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. url4 .. " with error message: " .. result)
				end

				userExperienceLanguageSettingsCallback(success, result)
			end)
			return
		end

		userExperienceLanguageSettingsCallback(false, p3) -- inferred equivalent call
	end

	local function experienceSupportedLanguagesCallback(p2, p3) -- 1 equivalent call inferred from this helper
		if p2 then
			internal2:Start(function(p4, p5)
				local success = false
				local v11 = tryGetErrorMessage(p4, p5) -- inferred equivalent call
				local result

				if v11 == nil then
					success, result = pcall(function()
						v5 = v2[HttpService:JSONDecode(p5.Body).languageCode]
					end)
				else
					result = "Experience Source Language Request: " .. v11
				end

				if not success then
					v:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. url2 .. " with error message: " .. result)
				end

				if p3 == nil then
					p3 = result
				end

				local v12 = p3

				if success and p2 then
					experienceSourceLanguageCallback(true) -- inferred equivalent call
					return
				end

				userExperienceLanguageSettingsCallback(false, v12) -- inferred equivalent call
			end)
		else
			userExperienceLanguageSettingsCallback(false, p3) -- inferred equivalent call
		end
	end

	local function localeInformationCallback(success, result) -- 1 equivalent call inferred from this helper
		if success then
			internal3:Start(function(p2, p3)
				local success2 = false
				local v11 = tryGetErrorMessage(p2, p3) -- inferred equivalent call
				local result2

				if v11 == nil then
					success2, result2 = pcall(function()
						local jsonDecode = HttpService:JSONDecode(p3.Body)
						local languageCodes = {}

						for k, v12 in pairs(jsonDecode.data) do
							languageCodes[k] = v12.languageCode
						end

						for _, v12 in languageCodes do
							for k, v13 in v9 do
								if v13.languageCode == v12 then
									table.insert(v8, k)
								end
							end
						end
					end)
				else
					result2 = "Experience Supported Language Language Request: " .. v11
				end

				if not success2 then
					v:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. url3 .. " with error message: " .. result2)
				end

				if result == nil then
					result = result2
				end

				experienceSupportedLanguagesCallback(success2 and success, result) -- inferred equivalent call
			end)
		else
			userExperienceLanguageSettingsCallback(false, result) -- inferred equivalent call
		end
	end

	internal:Start(function(p2, p3)
		local success = false
		local v11 = tryGetErrorMessage(p2, p3) -- inferred equivalent call
		local result

		if v11 == nil then
			success, result = pcall(function()
				local jsonDecode = HttpService:JSONDecode(p3.Body)

				for _, v12 in pairs(jsonDecode.data) do
					local languageCode = v12.locale.language.languageCode
					local id = v12.locale.language.id
					local name = v12.locale.language.name
					local locale = v12.locale.locale
					local id2 = v12.locale.id
					local name2 = v12.locale.name

					if v2[languageCode] == locale then
						idsById[id] = id2
					end

					v9[locale] = {
						localeName = name2,
						localeId = id2,
						languageName = name,
						languageId = id,
						languageCode = languageCode
					}

					localesById[id2] = locale
					localesByName[name2] = locale
				end
			end)
		else
			result = "Locale Information Request: " .. v11
		end

		if not success then
			v:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. url .. " with error message: " .. result)
		end

		localeInformationCallback(success, result) -- inferred equivalent call
	end)
end
