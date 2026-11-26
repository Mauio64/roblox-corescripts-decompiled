local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local fFlagMomentsRespectAccountTheme = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsRespectAccountTheme
local fFlagSeedAccountThemeFromDisk = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSeedAccountThemeFromDisk

local module = require("@luauforge/bundled/fBQ")
local module2 = require("@luauforge/bundled/fHp")
local themeName = Foundation.Enums.ThemeName

local module3 = require("@luauforge/bundled/fBO")
local module4 = require("@luauforge/bundled/fHg")

local function useCoreContentThemeName()
	local v5 = useAppPolicy(function(p2)
		if not game.Players.LocalPlayer or game.Players.LocalPlayer.UserId <= 0 then
			return "Roblox"
		end

		local getAccountType = p2.getAccountType

		if getAccountType then
			return (getAccountType())
		end

		return nil
	end)

	local v6 = module3(false)
	local v7 = useSignalState(v6.getColorThemeKey)

	local v8 = module4()
	local v9 = v8.isRobloxPlusUpsellEligible and v8.hasRobloxPlusSubscription

	local v10 = if fFlagSeedAccountThemeFromDisk then v8.isRobloxPlusUpsellEligible else false

	local v11 = useSignalState(v6.getPreviewColorThemeKey)

	if v11 ~= nil and v8.isRobloxPlusUpsellEligible then
		v7 = v11
		v9 = true
	end

	if fFlagMomentsRespectAccountTheme and useSignalState(v6.getSuppressAccountTheme) then
		v7 = module.Default
	end

	local v12 = module2.getThemeAccess(v7, v8.hasRobloxPlusSubscription, not v8.canSeeExclusiveThemes) == module2.ThemeAccess.Device

	local v13 = not (v7 == module.Default) and (fFlagSeedAccountThemeFromDisk and v10 or v9 or v12)

	if v13 then
		return v7
	end

	if v5 then
		return themeName[v5]
	end

	return nil
end

return useCoreContentThemeName
