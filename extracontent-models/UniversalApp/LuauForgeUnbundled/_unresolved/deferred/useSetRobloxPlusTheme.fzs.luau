local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fup")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module2 = require("@luauforge/bundled/dPI")

local module3 = require("@luauforge/bundled/fun")
local module4 = require("@luauforge/bundled/fzt")
local module5 = require("@luauforge/bundled/fyV")

local fFlagSeedAccountThemeFromDisk = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSeedAccountThemeFromDisk
local module6 = require("@luauforge/bundled/fzx")
local module7 = require("@luauforge/bundled/fzy")

local systemThemeService = module5.GetSystemThemeService()
local v5

if fFlagSeedAccountThemeFromDisk then
	v5 = require("@luauforge/bundled/fuq")
else
	v5 = nil
end

local module8 = require("@luauforge/bundled/fzz")

local function setNativeAppIcon(p2)
	if systemThemeService then
		systemThemeService:setAppIcon(p2 == module.Halloween2026 and "Halloween2026" or "")
	end
end

local function useSetRobloxPlusTheme()
	if not fFlagSeedAccountThemeFromDisk then
		return React.useCallback(function(p2, p3)
			local v6 = module3(false)

			if v6.getWriteStatus(false) == "Pending" then
				return
			end

			if module6 and not module7 and systemThemeService then
				systemThemeService:setAppIcon(p2 == module.Halloween2026 and "Halloween2026" or "")
			end

			if p3 then
				module4.setThemeKey(p2)
				v6.setColorThemeKey(p2)
			else
				local colorThemeKey = v6.getColorThemeKey(false)
				v6.setColorThemeKey(p2)
				v6.setWriteStatus("Pending")

				module2.UserSettings.getUserSettingsStore(false).updateAccountTheme(p2):andThen(function()
					v6.setWriteStatus("Idle")
				end):catch(function(p4)
					v6.setColorThemeKey(colorThemeKey)
					v6.setWriteStatus("Error")

					if module6 and not module7 then
						local v7 = colorThemeKey

						if systemThemeService then
							systemThemeService:setAppIcon(v7 == module.Halloween2026 and "Halloween2026" or "")
						end
					end

					logger:warning("[RobloxPlusTheme] Failed to persist account theme " .. p2 .. ": " .. tostring(p4))
				end)
			end
		end, {})
	end

	local v6 = module8()

	return React.useCallback(function(p2, p3)
		local v7 = module3(false)

		if v7.getWriteStatus(false) == "Pending" then
			return
		end

		if module6 and not module7 and systemThemeService then
			systemThemeService:setAppIcon(p2 == module.Halloween2026 and "Halloween2026" or "")
		end

		if p3 then
			module4.setThemeKey(p2)
			v7.setColorThemeKey(p2)
		else
			local colorThemeKey = v7.getColorThemeKey(false)
			v7.setColorThemeKey(p2)
			v7.setWriteStatus("Pending")

			v5.setPersistedAccountTheme(v6, p2)

			module2.UserSettings.getUserSettingsStore(false).updateAccountTheme(p2):andThen(function()
				v7.setWriteStatus("Idle")
			end):catch(function(p4)
				v7.setColorThemeKey(colorThemeKey)
				v7.setWriteStatus("Error")
				v5.setPersistedAccountTheme(v6, colorThemeKey)

				if module6 and not module7 then
					local v8 = colorThemeKey

					if systemThemeService then
						systemThemeService:setAppIcon(v8 == module.Halloween2026 and "Halloween2026" or "")
					end
				end

				logger:warning("[RobloxPlusTheme] Failed to persist account theme " .. p2 .. ": " .. tostring(p4))
			end)
		end
	end, { v6 })
end

return useSetRobloxPlusTheme
