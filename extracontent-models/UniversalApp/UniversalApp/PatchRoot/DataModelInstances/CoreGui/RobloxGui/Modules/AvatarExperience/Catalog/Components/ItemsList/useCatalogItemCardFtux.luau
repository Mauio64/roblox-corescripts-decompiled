local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceTimedOptions = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local WearTimeConstants = AvatarExperienceTimedOptions.WearTimeConstants
local WearTimeFTUXStatusSessionEnum = AvatarExperienceCatalog.Enums.WearTimeFTUXStatusSessionEnum
local WearTimeFTUXStatusEnum = AvatarExperienceCommon.Components.CatalogItemCard.WearTimeFTUXStatusEnum
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local FFlagAXTimedOptionsFTUXModalUseMemStorage = AvatarExperienceFlags.FFlagAXTimedOptionsFTUXModalUseMemStorage
local FFlagAXWearTimeSupport = SharedFlags.FFlagAXWearTimeSupport

require(Modules.AvatarExperience.Common.Types)

local function useCatalogItemCardFtux(t1: {[any]: any}) -- line: 32
	-- upvalues: useDispatch (copy), FFlagAXWearTimeSupport (copy), FFlagAXTimedOptionsFTUXModalUseMemStorage (copy), React (copy), SafeAppStorageService (copy), WearTimeConstants (copy), WearTimeFTUXStatusSessionEnum (copy), WearTimeFTUXStatusEnum (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy)
	local v22 = useDispatch()

	if FFlagAXWearTimeSupport then
		local v23 = t1.itemData ~= nil and (t1.itemData.timedOptions ~= nil and #t1.itemData.timedOptions > 0)

		if FFlagAXTimedOptionsFTUXModalUseMemStorage or game:GetEngineFeature("AXWearTimeFTUXTooltipStorageKey") then
			React.useEffect(function() -- line: 44
				-- upvalues: t1 (copy), v23 (copy), SafeAppStorageService (copy), WearTimeConstants (copy), WearTimeFTUXStatusSessionEnum (copy), FFlagAXTimedOptionsFTUXModalUseMemStorage (copy), WearTimeFTUXStatusEnum (copy), v22 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy)
				if t1.isSelected and (v23 and SafeAppStorageService.getItem(WearTimeConstants.TOOLTIP_FTUX_SESSION_TRACKER_KEY, true) ~= WearTimeFTUXStatusSessionEnum.Shown) then
					local v24 = SafeAppStorageService.getItem(WearTimeConstants.TOOLTIP_FTUX_APP_STORAGE_KEY, FFlagAXTimedOptionsFTUXModalUseMemStorage)

					if v24 == WearTimeFTUXStatusEnum.Undefined or v24 == WearTimeFTUXStatusEnum.Displayed then
						v22(SetCentralOverlay(CentralOverlayType.WearTimeInfoModal, {
							onClose = function() -- line: 61
								-- upvalues: SafeAppStorageService (copy), WearTimeConstants (copy), WearTimeFTUXStatusEnum (copy), FFlagAXTimedOptionsFTUXModalUseMemStorage (copy), v22 (copy), CloseCentralOverlay (copy)
								SafeAppStorageService.setItem(WearTimeConstants.TOOLTIP_FTUX_APP_STORAGE_KEY, WearTimeFTUXStatusEnum.Dismissed, FFlagAXTimedOptionsFTUXModalUseMemStorage)
								v22(CloseCentralOverlay())
							end
						}))
						SafeAppStorageService.setItem(WearTimeConstants.TOOLTIP_FTUX_SESSION_TRACKER_KEY, WearTimeFTUXStatusSessionEnum.Shown, true)

						if v24 == WearTimeFTUXStatusEnum.Undefined then
							SafeAppStorageService.setItem(WearTimeConstants.TOOLTIP_FTUX_APP_STORAGE_KEY, WearTimeFTUXStatusEnum.Displayed, FFlagAXTimedOptionsFTUXModalUseMemStorage)

							return
						end

						if v24 == WearTimeFTUXStatusEnum.Displayed then
							SafeAppStorageService.setItem(WearTimeConstants.TOOLTIP_FTUX_APP_STORAGE_KEY, WearTimeFTUXStatusEnum.DisplayedTwice, FFlagAXTimedOptionsFTUXModalUseMemStorage)
						end
					end
				end
			end, {
				v22,
				t1.isSelected,
				v23
			})
		end
	end
end

return useCatalogItemCardFtux
