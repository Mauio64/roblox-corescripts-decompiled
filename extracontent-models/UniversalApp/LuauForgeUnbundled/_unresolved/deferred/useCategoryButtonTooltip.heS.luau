local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local safeAppStorageService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Lib.SafeAppStorageService

local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module2 = require("@luauforge/bundled/dPN")

local defineFastFlag = game:DefineFastFlag("AXCategoryButtonTooltipUseMemStorage", false)
local defineFastInt = game:DefineFastInt("AXCategoryButtonTooltipTimeToDismiss", 5)

local v5 = {
	enableTooltip = false,
	titleText = nil,
	FTUXStorageKey = "",
	tooltipSeen = ""
}
local v6 = {
	BodyCategoryCatalogTooltip = {
		enableTooltip = true,
		titleText = "Feature.Catalog.Message.BodyCategoryTooltip",
		FTUXStorageKey = "AXAvatarsTabFtux",
		tooltipSeen = game:DefineFastString("AXBodyCategoryTooltipSeen", "BodyCategoryTooltipSeen")
	}
}

local function useCategoryButtonTooltip(p2, p3, p4)
	local v7 = v6[p4] or v5
	local v8 = useIsSpatial()
	local v9 = useAvatarRoute()

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)

	local v10 = safeAppStorageService.getItem(v7.FTUXStorageKey, defineFastFlag) == v7.tooltipSeen

	local state, setState = React.useState(v10)

	local v11 = React.useCallback(function()
		setState(true)
		safeAppStorageService.setItem(v7.FTUXStorageKey, v7.tooltipSeen, defineFastFlag)

		safeAppStorageService.flush()

		if not ref2.current then
			sendAXCounterV2(module2.Counter.CategoryButtonTooltip.ClickDismiss, {
				FTUXStorageKey = v7.FTUXStorageKey,
				FStringTooltipSeen = v7.tooltipSeen
			})

			ref2.current = true
		end
	end, { v7 })

	React.useEffect(function()
		if v7.enableTooltip and not (v10 or v8) then
			task.spawn(function()
				task.wait(defineFastInt)

				if not ref2.current then
					sendAXCounterV2(module2.Counter.CategoryButtonTooltip.AutoDismiss, {
						FTUXStorageKey = v7.FTUXStorageKey,
						FStringTooltipSeen = v7.tooltipSeen
					})

					ref2.current = true
				end

				v11()
			end)
		end
	end, {})

	local v12 = v7.enableTooltip and not v8

	if v12 then
		v12 = v9.opaque.name == p3 and not state
	end

	if v12 and not ref.current then
		sendAXCounterV2(module2.Counter.CategoryButtonTooltip.Seen, {
			FTUXStorageKey = v7.FTUXStorageKey,
			FStringTooltipSeen = v7.tooltipSeen
		})

		ref.current = true
	end

	return v12, v11, v7.titleText
end

return useCategoryButtonTooltip
