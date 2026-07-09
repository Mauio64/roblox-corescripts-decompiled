local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)
local v12 = game:DefineFastFlag("AXCategoryButtonTooltipUseMemStorage", false)
local v13 = game:DefineFastInt("AXCategoryButtonTooltipTimeToDismiss", 5)
local v14 = game:DefineFastString("AXBodyCategoryTooltipSeen", "BodyCategoryTooltipSeen")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local t1 = {
	enableTooltip = false,
	titleText = nil,
	FTUXStorageKey = "",
	tooltipSeen = ""
}
local t2 = {
	[if not FFlagAXCatalogCategoryTooltip then if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Body else CatalogCategories.Body:rawValue() else "BodyCategoryCatalogTooltip"] = {
		enableTooltip = true,
		titleText = "Feature.Catalog.Message.BodyCategoryTooltip",
		FTUXStorageKey = "AXAvatarsTabFtux",
		tooltipSeen = v14
	}
}

local function useCategoryButtonTooltip(p1, p2, p3) -- line: 45
	-- upvalues: t2 (copy), FFlagAXCatalogCategoryTooltip (copy), t1 (copy), useIsSpatial (copy), useAvatarRoute (copy), React (copy), SafeAppStorageService (copy), v12 (copy), sendAXCounterV2 (copy), Constants (copy), v13 (copy)
	local v24 = t2[(if not FFlagAXCatalogCategoryTooltip then p1 else p3)] or t1
	local v25 = useIsSpatial()
	local v26 = useAvatarRoute()
	local v27 = React.useRef(false)
	local v28 = React.useRef(false)
	local v29 = SafeAppStorageService.getItem(v24.FTUXStorageKey, v12) == v24.tooltipSeen
	local v30, v31 = React.useState(v29)
	local v32 = React.useCallback(function() -- line: 62
		-- upvalues: v31 (copy), SafeAppStorageService (copy), v24 (copy), v12 (copy), v28 (copy), sendAXCounterV2 (copy), Constants (copy)
		v31(true)
		SafeAppStorageService.setItem(v24.FTUXStorageKey, v24.tooltipSeen, v12)
		SafeAppStorageService.flush()

		if not v28.current then
			sendAXCounterV2(Constants.Counter.CategoryButtonTooltip.ClickDismiss, {
				FTUXStorageKey = v24.FTUXStorageKey,
				FStringTooltipSeen = v24.tooltipSeen
			})
			v28.current = true
		end
	end, { v24 })

	React.useEffect(function() -- line: 79
		-- upvalues: v24 (copy), v29 (copy), v25 (copy), v13 (copy), v28 (copy), sendAXCounterV2 (copy), Constants (copy), v32 (copy)
		if v24.enableTooltip and (not v29 and not v25) then
			task.spawn(function() -- line: 81
				-- upvalues: v13 (copy), v28 (copy), sendAXCounterV2 (copy), Constants (copy), v24 (copy), v32 (copy)
				task.wait(v13)

				if not v28.current then
					sendAXCounterV2(Constants.Counter.CategoryButtonTooltip.AutoDismiss, {
						FTUXStorageKey = v24.FTUXStorageKey,
						FStringTooltipSeen = v24.tooltipSeen
					})
					v28.current = true
				end

				v32()
			end)
		end
	end, {})

	local v33 = v24.enableTooltip and (not v25 and (p2 == v26.opaque.name and not v30))

	if v33 and not v27.current then
		sendAXCounterV2(Constants.Counter.CategoryButtonTooltip.Seen, {
			FTUXStorageKey = v24.FTUXStorageKey,
			FStringTooltipSeen = v24.tooltipSeen
		})
		v27.current = true
	end

	return v33, v32, v24.titleText
end

return useCategoryButtonTooltip
