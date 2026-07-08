local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local useMappedSignal = require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)
local v7 = game:DefineFastInt("InExperienceShopTooltipPriority", 3500)
local v8 = game:DefineFastString("InExperienceShopTooltipStorageKey", "InExperienceShopTooltipStorageKey")
local v9 = game:DefineFastInt("InExperienceShopTooltipShowDelay", 1000)
local v10 = game:DefineFastInt("InExperienceShopTooltipDismissDelay", 7000)

local function InExperienceShopFtuxTooltip(t1: {[any]: any}) -- line: 20
	-- upvalues: Service (copy), Constants (copy), useMappedSignal (copy), CommonFtuxTooltip (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy)
	local v13 = Service:integrations()[Constants.IN_EXPERIENCE_SHOP_ID]
	local v14 = if not v13 then nil else v13.availability

	return useMappedSignal(v14) == Service.AvailabilitySignal.Available and CommonFtuxTooltip({
		id = "IN_EXPERIENCE_SHOP_TOOLTIP",
		headerKey = "CoreScripts.FTUX.Heading.InExperienceShop",
		bodyKey = "CoreScripts.FTUX.Label.InExperienceShopDescription",
		priority = v7,
		isIconVisible = t1.visible,
		localStorageKey = v8,
		showDelay = v9,
		dismissDelay = v10
	})
end

return InExperienceShopFtuxTooltip
