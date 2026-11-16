local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)

local defineFastInt = game:DefineFastInt("InExperienceShopTooltipPriority", 3500)

local defineFastString = game:DefineFastString("InExperienceShopTooltipStorageKey", "InExperienceShopTooltipStorageKey")
local defineFastInt2 = game:DefineFastInt("InExperienceShopTooltipShowDelay", 1000)
local defineFastInt3 = game:DefineFastInt("InExperienceShopTooltipDismissDelay", 7000)

local function InExperienceShopFtuxTooltip(p)
	local v = Service:integrations()[Constants.IN_EXPERIENCE_SHOP_ID]
	local v2

	if v then
		v2 = v.availability
	end

	return useMappedSignal(v2) == Service.AvailabilitySignal.Available and CommonFtuxTooltip({
		id = "IN_EXPERIENCE_SHOP_TOOLTIP",
		priority = defineFastInt,
		isIconVisible = p.visible,
		headerKey = "CoreScripts.FTUX.Heading.InExperienceShop",
		bodyKey = "CoreScripts.FTUX.Label.InExperienceShopDescription",
		localStorageKey = defineFastString,
		showDelay = defineFastInt2,
		dismissDelay = defineFastInt3
	})
end

return InExperienceShopFtuxTooltip
