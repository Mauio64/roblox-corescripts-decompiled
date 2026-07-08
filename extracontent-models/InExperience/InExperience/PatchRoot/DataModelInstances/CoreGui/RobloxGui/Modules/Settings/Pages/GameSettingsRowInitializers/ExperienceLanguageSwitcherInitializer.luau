local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Utility = require(RobloxGui.Modules.Settings.Utility)
local v10 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local EngineFeature = game:GetEngineFeature("UgcLocaleFromGameJoinEnabled")
local t1 = {
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

return function(p1, p2, p3) -- line: 76
	-- upvalues: Players (copy), Url (copy), HttpService (copy), Utility (copy), RobloxTranslator (copy), v10 (copy), EngineFeature (copy), LocalPlayer (copy), RunService (copy), t1 (copy)
	local n1 = 1
	local n2 = 1
	local u19 = false
	local u20 = nil
	local v21 = Players.LocalPlayer.LocaleId:gsub("-", "_")
	local u22 = nil
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local v29 = Url.LOCALE_URL .. string.format("v1/locales?displayValueLocale=%s", Players.LocalPlayer.LocaleId:gsub("-", "_"))
	local v30 = HttpService:RequestInternal({
		Method = "GET",
		Url = v29
	})
	local v31 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
	local v32 = HttpService:RequestInternal({
		Method = "GET",
		Url = v31
	})
	local v33 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/supported-languages/games/%d/in-experience-language-selection", game.GameId)
	local v34 = HttpService:RequestInternal({
		Method = "GET",
		Url = v33
	})
	local v35 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
	local v36 = HttpService:RequestInternal({
		Method = "GET",
		Url = v35
	})

	local function tryGetErrorMessage(p4, p5) -- line: 135
		local StatusCode = nil

		if not p4 or (not p5 or not p5.StatusCode) then
			return "Connection error"
		end

		if p5.StatusCode == 401 then
			return "Unauthorized"
		end

		if p5.StatusCode < 200 or p5.StatusCode >= 400 then
			StatusCode = p5.StatusCode
		end

		return StatusCode
	end
	local function createSessionDormantLanguageSwitcherRow() -- line: 148
		-- upvalues: p1 (copy), Utility (copy), RobloxTranslator (copy), p2 (copy)
		local v46 = p1
		local v47 = p1
		local v48 = p1
		local v49, v50, v51 = Utility:AddNewRow(p1, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable") }, 1)

		v46.LanguageSelectorFrame = v49
		v47.LanguageSelectorLabel = v50
		v48.LanguageSelectorMode = v51
		p1.LanguageSelectorMode:SetInteractable(false)
		p1.LanguageSelectorFrame.LayoutOrder = p2.LanguageSelectorFrame
	end
	local function userExperienceLanguageSettingsCallback(p6, p7) -- line: 164
		-- upvalues: v10 (copy), createSessionDormantLanguageSwitcherRow (copy), t3 (copy), u22 (ref), u20 (ref), t7 (copy), t4 (copy), t2 (copy), n1 (ref), n2 (ref), p1 (copy), Utility (copy), RobloxTranslator (copy), p2 (copy), EngineFeature (copy), LocalPlayer (copy), p3 (copy), Url (copy), HttpService (copy), u19 (ref), RunService (copy)
		if not p6 then
			if p7 == nil then
				p7 = "Execution path did not set earliest error to non-nil value."
			end

			v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p7)
			createSessionDormantLanguageSwitcherRow()

			return
		end

		local v54 = false

		for _, v56 in t3 do
			if v56 == u22 then
				v54 = true
			end

			if v56 ~= u20 then
				table.insert(t7, t4[v56].localeName)
			end
		end

		table.sort(t7)

		local v57 = true

		if u20 == nil or t4[u20].localeName == nil then
			v57 = false
		end

		if not v57 then
			createSessionDormantLanguageSwitcherRow()

			return
		end

		table.insert(t7, 1, t4[u20].localeName .. " (Original)")

		if v54 == true then
			for v58, v59 in t7 do
				if v58 ~= 1 and t2[v59] == u22 then
					n1 = v58
					n2 = v58
				end
			end
		end

		local v60 = p1
		local v61 = p1
		local v62 = p1
		local v63, v64, v65 = Utility:AddNewRow(p1, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", t7, n1)

		v60.LanguageSelectorFrame = v63
		v61.LanguageSelectorLabel = v64
		v62.LanguageSelectorMode = v65
		p1.LanguageSelectorFrame.LayoutOrder = p2.LanguageSelectorFrame

		if not EngineFeature then
			if n1 == 1 then
				LocalPlayer:SetExperienceSettingsLocaleId(u20)
			else
				local v66 = t2[t7[n1]]

				LocalPlayer:SetExperienceSettingsLocaleId(v66)
			end
		end

		p1.LanguageSelectorMode.CurrentLocale = p1.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

		local function toggleTranslation(p8) -- line: 252
			-- upvalues: p1 (copy), t4 (copy), u20 (ref), t2 (copy), t7 (copy), p3 (copy), Url (copy), HttpService (copy), n2 (ref), LocalPlayer (copy), v10 (copy), u19 (ref), RunService (copy)
			p1.LanguageSelectorMode:SetInteractable(false)

			local v87 = if p8 ~= 1 or t4[u20] == nil then t4[t2[t7[p8]]].localeId else t4[u20].localeId
			local CurrentLocale = p1.LanguageSelectorMode.CurrentLocale
			local v89 = t7[p8]

			if CurrentLocale ~= v89 then
				p1.LanguageSelectorMode.CurrentLocale = v89
				p3("experience_locale", CurrentLocale, v89)
			end

			local t8 = {
				settingValue = {
					settingType = "SupportedLocale",
					settingTargetId = v87
				}
			}
			local v91 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
			local v92 = HttpService:RequestInternal({
				Method = "POST",
				Url = v91,
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = HttpService:JSONEncode(t8)
			})

			local function userExperienceLanguageSettingsUpdateCallback(p9, p10) -- line: 301
				-- upvalues: n2 (ref), p8 (copy), LocalPlayer (copy), u20 (ref), t2 (copy), t7 (copy), v10 (copy), u19 (ref), p1 (copy)
				if p9 then
					n2 = p8

					if p8 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(u20)
					else
						local v135 = t2[t7[p8]]

						LocalPlayer:SetExperienceSettingsLocaleId(v135)
					end
				else
					v10:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p10)
					u19 = true
					p1.LanguageSelectorMode:SetSelectionIndex(n2)
				end

				p1.LanguageSelectorMode:SetInteractable(true)
			end

			if RunService:IsStudio() then
				n2 = p8

				if p8 == 1 then
					LocalPlayer:SetExperienceSettingsLocaleId(u20)
				else
					local v94 = t2[t7[p8]]

					LocalPlayer:SetExperienceSettingsLocaleId(v94)
				end

				p1.LanguageSelectorMode:SetInteractable(true)

				return
			end

			if u19 then
				u19 = false
				n2 = p8

				if p8 == 1 then
					LocalPlayer:SetExperienceSettingsLocaleId(u20)
				else
					local v95 = t2[t7[p8]]

					LocalPlayer:SetExperienceSettingsLocaleId(v95)
				end

				p1.LanguageSelectorMode:SetInteractable(true)

				return
			end

			if v87 == nil then
				v10:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. nil)
				u19 = true
				p1.LanguageSelectorMode:SetSelectionIndex(n2)
				p1.LanguageSelectorMode:SetInteractable(true)

				return
			end

			v92:Start(function(p11, p12) -- line: 345
				-- upvalues: v10 (copy), v91 (copy), userExperienceLanguageSettingsUpdateCallback (copy)
				local v138 = false
				local s1 = nil

				if not p11 or (not p12 or not p12.StatusCode) then
					s1 = "Connection error"
				elseif p12.StatusCode == 401 then
					s1 = "Unauthorized"
				elseif p12.StatusCode < 200 or p12.StatusCode >= 400 then
					s1 = p12.StatusCode
				end

				if s1 ~= nil then
					s1 = "User Experience Language Settings Update Request: " .. s1
					v10:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. v91 .. " with error message: " .. s1)
				else
					v10:info("User Experience Language Settings Update Request: " .. "Succeeded with code - " .. p12.StatusCode)
					v138 = true
				end

				userExperienceLanguageSettingsUpdateCallback(v138, s1)
			end)
		end

		p1.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
	end
	local function experienceSourceLanguageCallback(p13, p14) -- line: 374
		-- upvalues: v36 (copy), HttpService (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy), v10 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
		if p13 then
			v36:Start(function(p15, p16) -- line: 376
				-- upvalues: HttpService (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy), v10 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy)
				local v98 = false
				local s2 = nil

				if not p15 or (not p16 or not p16.StatusCode) then
					s2 = "Connection error"
				elseif p16.StatusCode == 401 then
					s2 = "Unauthorized"
				elseif p16.StatusCode < 200 or p16.StatusCode >= 400 then
					s2 = p16.StatusCode
				end

				local v100

				if s2 ~= nil then
					v100 = "User Experience Language Setting Get Request: " .. s2
				else
					v98, v100 = pcall(function() -- line: 385
						-- upvalues: HttpService (copy), p16 (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy)
						local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p16.Body).userUniverseLocalizationSettingValue

						if userUniverseLocalizationSettingValue == nil then
							u22 = v21

							return
						end

						local settingTargetId = userUniverseLocalizationSettingValue.settingTargetId
						local settingType = userUniverseLocalizationSettingValue.settingType

						if settingTargetId == nil then
							u22 = v21
						end

						if settingType == "SourceOrTranslation" then
							if settingTargetId == 1 then
								u22 = u20

								return
							end

							u22 = v21

							return
						end

						if settingType == "LanguageFamily" then
							if t6[settingTargetId] == nil then
								u22 = v21

								return
							end

							u22 = t5[t6[settingTargetId]]

							return
						end

						if settingType == "SupportedLocale" then
							if t5[settingTargetId] == nil then
								u22 = v21

								return
							end

							u22 = t5[settingTargetId]
						end
					end)
				end

				if not v98 then
					v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v35 .. " with error message: " .. v100)
				end

				userExperienceLanguageSettingsCallback(v98, v100)
			end)

			return
		end

		if p14 == nil then
			p14 = "Execution path did not set earliest error to non-nil value."
		end

		v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p14)
		createSessionDormantLanguageSwitcherRow()
	end
	local function experienceSupportedLanguagesCallback(p17, p18) -- line: 451
		-- upvalues: v32 (copy), HttpService (copy), u20 (ref), t1 (copy), v10 (copy), v31 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
		if p17 then
			v32:Start(function(p19, p20) -- line: 453
				-- upvalues: HttpService (copy), u20 (ref), t1 (copy), v10 (copy), v31 (copy), p18 (ref), p17 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
				local v103 = false
				local s3 = nil

				if not p19 or (not p20 or not p20.StatusCode) then
					s3 = "Connection error"
				elseif p20.StatusCode == 401 then
					s3 = "Unauthorized"
				elseif p20.StatusCode < 200 or p20.StatusCode >= 400 then
					s3 = p20.StatusCode
				end

				local v105

				if s3 ~= nil then
					v105 = "Experience Source Language Request: " .. s3
				else
					v103, v105 = pcall(function() -- line: 462
						-- upvalues: HttpService (copy), p20 (copy), u20 (ref), t1 (copy)
						u20 = t1[HttpService:JSONDecode(p20.Body).languageCode]
					end)
				end

				if not v103 then
					v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v31 .. " with error message: " .. v105)
				end

				if p18 == nil then
					p18 = v105
				end

				local v106 = v103 and p17
				local v107 = p18

				if v106 then
					v36:Start(function(p21, p22) -- line: 376
						-- upvalues: HttpService (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy), v10 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy)
						local v145 = false
						local s4 = nil

						if not p21 or (not p22 or not p22.StatusCode) then
							s4 = "Connection error"
						elseif p22.StatusCode == 401 then
							s4 = "Unauthorized"
						elseif p22.StatusCode < 200 or p22.StatusCode >= 400 then
							s4 = p22.StatusCode
						end

						local v147

						if s4 ~= nil then
							v147 = "User Experience Language Setting Get Request: " .. s4
						else
							v145, v147 = pcall(function() -- line: 385
								-- upvalues: HttpService (copy), p22 (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy)
								local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p22.Body).userUniverseLocalizationSettingValue

								if userUniverseLocalizationSettingValue == nil then
									u22 = v21

									return
								end

								local settingTargetId = userUniverseLocalizationSettingValue.settingTargetId
								local settingType = userUniverseLocalizationSettingValue.settingType

								if settingTargetId == nil then
									u22 = v21
								end

								if settingType == "SourceOrTranslation" then
									if settingTargetId == 1 then
										u22 = u20

										return
									end

									u22 = v21

									return
								end

								if settingType == "LanguageFamily" then
									if t6[settingTargetId] == nil then
										u22 = v21

										return
									end

									u22 = t5[t6[settingTargetId]]

									return
								end

								if settingType == "SupportedLocale" then
									if t5[settingTargetId] == nil then
										u22 = v21

										return
									end

									u22 = t5[settingTargetId]
								end
							end)
						end

						if not v145 then
							v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v35 .. " with error message: " .. v147)
						end

						userExperienceLanguageSettingsCallback(v145, v147)
					end)

					return
				end

				if v107 == nil then
					v107 = "Execution path did not set earliest error to non-nil value."
				end

				v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v107)
				createSessionDormantLanguageSwitcherRow()
			end)
		else
			local v73 = p18

			if v73 == nil then
				v73 = "Execution path did not set earliest error to non-nil value."
			end

			v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v73)
			createSessionDormantLanguageSwitcherRow()
		end
	end
	local function localeInformationCallback(p23, p24) -- line: 493
		-- upvalues: v34 (copy), HttpService (copy), t4 (copy), t3 (copy), v10 (copy), v33 (copy), v32 (copy), u20 (ref), t1 (copy), v31 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
		if p23 then
			v34:Start(function(p25, p26) -- line: 495
				-- upvalues: HttpService (copy), t4 (copy), t3 (copy), v10 (copy), v33 (copy), p24 (ref), p23 (copy), v32 (copy), u20 (ref), t1 (copy), v31 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
				local v110 = false
				local s5 = nil

				if not p25 or (not p26 or not p26.StatusCode) then
					s5 = "Connection error"
				elseif p26.StatusCode == 401 then
					s5 = "Unauthorized"
				elseif p26.StatusCode < 200 or p26.StatusCode >= 400 then
					s5 = p26.StatusCode
				end

				local v112

				if s5 ~= nil then
					v112 = "Experience Supported Language Language Request: " .. s5
				else
					v110, v112 = pcall(function() -- line: 503
						-- upvalues: HttpService (copy), p26 (copy), t4 (copy), t3 (copy)
						local data = HttpService:JSONDecode(p26.Body)
						local t9 = {}

						for k, v in pairs(data.data) do
							t9[k] = v.languageCode
						end

						for _, v153 in t9 do
							for v154, v155 in t4 do
								if v153 == v155.languageCode then
									table.insert(t3, v154)
								end
							end
						end
					end)
				end

				if not v110 then
					v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v33 .. " with error message: " .. v112)
				end

				if p24 == nil then
					p24 = v112
				end

				local v113 = v110 and p23
				local u114 = p24

				if v113 then
					v32:Start(function(p27, p28) -- line: 453
						-- upvalues: HttpService (copy), u20 (ref), t1 (copy), v10 (copy), v31 (copy), u114 (ref), v113 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
						local v158 = false
						local s6 = nil

						if not p27 or (not p28 or not p28.StatusCode) then
							s6 = "Connection error"
						elseif p28.StatusCode == 401 then
							s6 = "Unauthorized"
						elseif p28.StatusCode < 200 or p28.StatusCode >= 400 then
							s6 = p28.StatusCode
						end

						local v160

						if s6 ~= nil then
							v160 = "Experience Source Language Request: " .. s6
						else
							v158, v160 = pcall(function() -- line: 462
								-- upvalues: HttpService (copy), p28 (copy), u20 (ref), t1 (copy)
								u20 = t1[HttpService:JSONDecode(p28.Body).languageCode]
							end)
						end

						if not v158 then
							v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v31 .. " with error message: " .. v160)
						end

						if u114 == nil then
							u114 = v160
						end

						local v161 = v158 and v113
						local v162 = u114

						if v161 then
							v36:Start(function(p29, p30) -- line: 376
								-- upvalues: HttpService (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy), v10 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy)
								local v183 = false
								local s7 = nil

								if not p29 or (not p30 or not p30.StatusCode) then
									s7 = "Connection error"
								elseif p30.StatusCode == 401 then
									s7 = "Unauthorized"
								elseif p30.StatusCode < 200 or p30.StatusCode >= 400 then
									s7 = p30.StatusCode
								end

								local v185

								if s7 ~= nil then
									v185 = "User Experience Language Setting Get Request: " .. s7
								else
									v183, v185 = pcall(function() -- line: 385
										-- upvalues: HttpService (copy), p30 (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy)
										local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p30.Body).userUniverseLocalizationSettingValue

										if userUniverseLocalizationSettingValue == nil then
											u22 = v21

											return
										end

										local settingTargetId = userUniverseLocalizationSettingValue.settingTargetId
										local settingType = userUniverseLocalizationSettingValue.settingType

										if settingTargetId == nil then
											u22 = v21
										end

										if settingType == "SourceOrTranslation" then
											if settingTargetId == 1 then
												u22 = u20

												return
											end

											u22 = v21

											return
										end

										if settingType == "LanguageFamily" then
											if t6[settingTargetId] == nil then
												u22 = v21

												return
											end

											u22 = t5[t6[settingTargetId]]

											return
										end

										if settingType == "SupportedLocale" then
											if t5[settingTargetId] == nil then
												u22 = v21

												return
											end

											u22 = t5[settingTargetId]
										end
									end)
								end

								if not v183 then
									v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v35 .. " with error message: " .. v185)
								end

								userExperienceLanguageSettingsCallback(v183, v185)
							end)

							return
						end

						if v162 == nil then
							v162 = "Execution path did not set earliest error to non-nil value."
						end

						v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v162)
						createSessionDormantLanguageSwitcherRow()
					end)
				else
					local v115 = u114

					if v115 == nil then
						v115 = "Execution path did not set earliest error to non-nil value."
					end

					v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v115)
					createSessionDormantLanguageSwitcherRow()
				end
			end)
		else
			local v77 = p24

			if v77 == nil then
				v77 = "Execution path did not set earliest error to non-nil value."
			end

			v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v77)
			createSessionDormantLanguageSwitcherRow()
		end
	end

	v30:Start(function(p31, p32) -- line: 542
		-- upvalues: HttpService (copy), t1 (copy), t6 (copy), t4 (copy), t5 (copy), t2 (copy), v10 (copy), v29 (copy), v34 (copy), t3 (copy), v33 (copy), v32 (copy), u20 (ref), v31 (copy), v36 (copy), u22 (ref), v21 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
		local v80 = false
		local s8 = nil

		if not p31 or (not p32 or not p32.StatusCode) then
			s8 = "Connection error"
		elseif p32.StatusCode == 401 then
			s8 = "Unauthorized"
		elseif p32.StatusCode < 200 or p32.StatusCode >= 400 then
			s8 = p32.StatusCode
		end

		local v82

		if s8 ~= nil then
			v82 = "Locale Information Request: " .. s8
		else
			v80, v82 = pcall(function() -- line: 551
				-- upvalues: HttpService (copy), p32 (copy), t1 (copy), t6 (copy), t4 (copy), t5 (copy), t2 (copy)
				local data = HttpService:JSONDecode(p32.Body)

				for _, v in pairs(data.data) do
					local languageCode = v.locale.language.languageCode
					local id = v.locale.language.id
					local name = v.locale.language.name
					local locale = v.locale.locale
					local id2 = v.locale.id
					local name2 = v.locale.name

					if locale == t1[languageCode] then
						t6[id] = id2
					end

					t4[locale] = {
						localeName = name2,
						localeId = id2,
						languageName = name,
						languageId = id,
						languageCode = languageCode
					}
					t5[id2] = locale
					t2[name2] = locale
				end
			end)
		end

		if not v80 then
			v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v29 .. " with error message: " .. v82)
		end

		local v83 = v80
		local u84 = v82

		if v83 then
			v34:Start(function(p33, p34) -- line: 495
				-- upvalues: HttpService (copy), t4 (copy), t3 (copy), v10 (copy), v33 (copy), u84 (ref), v83 (copy), v32 (copy), u20 (ref), t1 (copy), v31 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
				local v127 = false
				local s9 = nil

				if not p33 or (not p34 or not p34.StatusCode) then
					s9 = "Connection error"
				elseif p34.StatusCode == 401 then
					s9 = "Unauthorized"
				elseif p34.StatusCode < 200 or p34.StatusCode >= 400 then
					s9 = p34.StatusCode
				end

				local v129

				if s9 ~= nil then
					v129 = "Experience Supported Language Language Request: " .. s9
				else
					v127, v129 = pcall(function() -- line: 503
						-- upvalues: HttpService (copy), p34 (copy), t4 (copy), t3 (copy)
						local data = HttpService:JSONDecode(p34.Body)
						local t10 = {}

						for k, v in pairs(data.data) do
							t10[k] = v.languageCode
						end

						for _, v168 in t10 do
							for v169, v170 in t4 do
								if v168 == v170.languageCode then
									table.insert(t3, v169)
								end
							end
						end
					end)
				end

				if not v127 then
					v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v33 .. " with error message: " .. v129)
				end

				if u84 == nil then
					u84 = v129
				end

				local v130 = v127 and v83
				local u131 = u84

				if v130 then
					v32:Start(function(p35, p36) -- line: 453
						-- upvalues: HttpService (copy), u20 (ref), t1 (copy), v10 (copy), v31 (copy), u131 (ref), v130 (copy), v36 (copy), u22 (ref), v21 (copy), t6 (copy), t5 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy), createSessionDormantLanguageSwitcherRow (copy)
						local v173 = false
						local s10 = nil

						if not p35 or (not p36 or not p36.StatusCode) then
							s10 = "Connection error"
						elseif p36.StatusCode == 401 then
							s10 = "Unauthorized"
						elseif p36.StatusCode < 200 or p36.StatusCode >= 400 then
							s10 = p36.StatusCode
						end

						local v175

						if s10 ~= nil then
							v175 = "Experience Source Language Request: " .. s10
						else
							v173, v175 = pcall(function() -- line: 462
								-- upvalues: HttpService (copy), p36 (copy), u20 (ref), t1 (copy)
								u20 = t1[HttpService:JSONDecode(p36.Body).languageCode]
							end)
						end

						if not v173 then
							v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v31 .. " with error message: " .. v175)
						end

						if u131 == nil then
							u131 = v175
						end

						local v176 = v173 and v130
						local v177 = u131

						if v176 then
							v36:Start(function(p37, p38) -- line: 376
								-- upvalues: HttpService (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy), v10 (copy), v35 (copy), userExperienceLanguageSettingsCallback (copy)
								local v188 = false
								local s11 = nil

								if not p37 or (not p38 or not p38.StatusCode) then
									s11 = "Connection error"
								elseif p38.StatusCode == 401 then
									s11 = "Unauthorized"
								elseif p38.StatusCode < 200 or p38.StatusCode >= 400 then
									s11 = p38.StatusCode
								end

								local v190

								if s11 ~= nil then
									v190 = "User Experience Language Setting Get Request: " .. s11
								else
									v188, v190 = pcall(function() -- line: 385
										-- upvalues: HttpService (copy), p38 (copy), u22 (ref), v21 (copy), u20 (ref), t6 (copy), t5 (copy)
										local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p38.Body).userUniverseLocalizationSettingValue

										if userUniverseLocalizationSettingValue == nil then
											u22 = v21

											return
										end

										local settingTargetId = userUniverseLocalizationSettingValue.settingTargetId
										local settingType = userUniverseLocalizationSettingValue.settingType

										if settingTargetId == nil then
											u22 = v21
										end

										if settingType == "SourceOrTranslation" then
											if settingTargetId == 1 then
												u22 = u20

												return
											end

											u22 = v21

											return
										end

										if settingType == "LanguageFamily" then
											if t6[settingTargetId] == nil then
												u22 = v21

												return
											end

											u22 = t5[t6[settingTargetId]]

											return
										end

										if settingType == "SupportedLocale" then
											if t5[settingTargetId] == nil then
												u22 = v21

												return
											end

											u22 = t5[settingTargetId]
										end
									end)
								end

								if not v188 then
									v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v35 .. " with error message: " .. v190)
								end

								userExperienceLanguageSettingsCallback(v188, v190)
							end)

							return
						end

						if v177 == nil then
							v177 = "Execution path did not set earliest error to non-nil value."
						end

						v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v177)
						createSessionDormantLanguageSwitcherRow()
					end)
				else
					local v132 = u131

					if v132 == nil then
						v132 = "Execution path did not set earliest error to non-nil value."
					end

					v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v132)
					createSessionDormantLanguageSwitcherRow()
				end
			end)
		else
			local v85 = u84

			if v85 == nil then
				v85 = "Execution path did not set earliest error to non-nil value."
			end

			v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v85)
			createSessionDormantLanguageSwitcherRow()
		end
	end)
end
