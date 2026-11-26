local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry")
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local getFFlagAmpV2WizardDebugUnknownNodes = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/getFFlagAmpV2WizardDebugUnknownNodes")
local isParentModeThemedNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/isParentModeThemedNode")
local getParentModeChromeThemeStore = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/getParentModeChromeThemeStore")
local FFlagAmpV2WizardServerParentFacing = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardServerParentFacing")
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/usePresentedOverPage")

local function useSyncParentModeChromeTheme(p2, p3, p4, p5, p6, p7)
	local v5 = false

	local v6 = not (p2 or p3)

	if v6 then
		v6 = not (p4 == nil) and (p6 ~= nil or getFFlagAmpV2WizardDebugUnknownNodes())
	end

	if v6 then
		if p7 ~= nil then
			p4 = p7.node
		end

		if FFlagAmpV2WizardServerParentFacing then
			v5 = not (p4.behavior == nil) and p4.behavior.parentFacing == true
		else
			v5 = isParentModeThemedNode(p4.type, p5)
		end
	end

	React.useLayoutEffect(function()
		getParentModeChromeThemeStore(false).setIsActive(v5)
	end, { v5 })

	React.useLayoutEffect(function()
		return function()
			getParentModeChromeThemeStore(false).setIsActive(false)
		end
	end, {})
end

return useSyncParentModeChromeTheme
