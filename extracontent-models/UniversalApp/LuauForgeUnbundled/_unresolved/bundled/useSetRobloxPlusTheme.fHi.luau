local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require("@luauforge/bundled/fBQ")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module = require("@luauforge/bundled/dSY")

local module2 = require("@luauforge/bundled/fBO")
local module3 = require("@luauforge/bundled/fHj")

local fFlagSeedAccountThemeFromDisk = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSeedAccountThemeFromDisk

local v5 = if fFlagSeedAccountThemeFromDisk then require("@luauforge/bundled/fBR") else nil

local module4 = require("@luauforge/bundled/fHn")

local function useSetRobloxPlusTheme()
	if not fFlagSeedAccountThemeFromDisk then
		return React.useCallback(function(p2, p3)
			local v6 = module2(false)

			if v6.getWriteStatus(false) == "Pending" then
				return
			end

			if p3 then
				module3.setThemeKey(p2)
				v6.setColorThemeKey(p2)
			else
				local colorThemeKey = v6.getColorThemeKey(false)
				v6.setColorThemeKey(p2)
				v6.setWriteStatus("Pending")

				module.UserSettings.getUserSettingsStore(false).updateAccountTheme(p2):andThen(function()
					v6.setWriteStatus("Idle")
				end):catch(function(p4)
					v6.setColorThemeKey(colorThemeKey)
					v6.setWriteStatus("Error")
					logger:warning("[RobloxPlusTheme] Failed to persist account theme " .. p2 .. ": " .. tostring(p4))
				end)
			end
		end, {})
	end

	local v6 = module4()

	return React.useCallback(function(p2, p3)
		local v7 = module2(false)

		if v7.getWriteStatus(false) == "Pending" then
			return
		end

		if p3 then
			module3.setThemeKey(p2)
			v7.setColorThemeKey(p2)
		else
			local colorThemeKey = v7.getColorThemeKey(false)
			v7.setColorThemeKey(p2)
			v7.setWriteStatus("Pending")

			v5.setPersistedAccountTheme(v6, p2)

			module.UserSettings.getUserSettingsStore(false).updateAccountTheme(p2):andThen(function()
				v7.setWriteStatus("Idle")
			end):catch(function(p4)
				v7.setColorThemeKey(colorThemeKey)
				v7.setWriteStatus("Error")
				v5.setPersistedAccountTheme(v6, colorThemeKey)
				logger:warning("[RobloxPlusTheme] Failed to persist account theme " .. p2 .. ": " .. tostring(p4))
			end)
		end
	end, { v6 })
end

return useSetRobloxPlusTheme
