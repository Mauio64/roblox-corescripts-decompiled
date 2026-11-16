local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)
local defineFastInt = game:DefineFastInt("AvatarSwitcherTooltipPriority", 3000)

local defineFastString = game:DefineFastString("AvatarSwitcherTooltipStorageKey", "AvatarSwitcherTooltipStorageKey")
local defineFastInt2 = game:DefineFastInt("AvatarSwitcherTooltipShowDelay", 1000)
local defineFastInt3 = game:DefineFastInt("AvatarSwitcherTooltipDismissDelay", 8500)

local function AvatarSwitcherFtuxTooltip(p)
	local v = Service:integrations()[Constants.AVATAR_SWITCHER_ID]
	local v2

	if v then
		v2 = v.availability
	end

	return useMappedSignal(v2) == Service.AvailabilitySignal.Available and CommonFtuxTooltip({
		id = "AVATAR_SWITCHER_TOOLTIP",
		priority = defineFastInt,
		isIconVisible = p.visible,
		headerKey = "CoreScripts.FTUX.Heading.NewAvatarSwitcher",
		bodyKey = "CoreScripts.FTUX.Label.AvatarSwitcherDescription",
		localStorageKey = defineFastString,
		showDelay = defineFastInt2,
		dismissDelay = defineFastInt3
	})
end

return AvatarSwitcherFtuxTooltip
