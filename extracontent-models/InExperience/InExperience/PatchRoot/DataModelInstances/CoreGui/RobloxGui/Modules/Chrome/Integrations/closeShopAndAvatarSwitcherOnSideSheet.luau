local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)

local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility

local v = { Constants.IN_EXPERIENCE_SHOP_ID, Constants.AVATAR_SWITCHER_ID }

local v2 = nil

local function bindCloseShopAndAvatarSwitcherOnSideSheet()
	local function canToggleWindow(p: string): boolean -- 2 equivalent calls inferred from this helper
		local v3 = Service:integrations()[p]
		local components

		if v3 then
			components = v3.components
		end

		return components ~= nil and components.Window ~= nil
	end

	local function closeIfOpen(p: string)
		if canToggleWindow(p) and Service:isWindowOpen(p) then -- inferred equivalent call
			Service:toggleWindow(p)
		end
	end

	local effect = Signals.createEffect(function(p)
		if not getSideSheetVisibility(p) then
			return
		end

		for _, v3 in v do
			if canToggleWindow(v3) and Service:isWindowOpen(v3) then -- inferred equivalent call
				Service:toggleWindow(v3)
			end
		end
	end)
	local function fn()
		if v2 == fn then
			v2 = nil
		end

		effect()
	end
	v2 = fn

	return fn
end

return bindCloseShopAndAvatarSwitcherOnSideSheet
