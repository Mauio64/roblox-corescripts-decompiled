local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

require(AmpV2Wizard.ComponentRegistry)
require(AmpV2Wizard.Types)
local getFFlagAmpV2WizardDebugUnknownNodes = require(AmpV2Wizard.getFFlagAmpV2WizardDebugUnknownNodes)
local isParentModeThemedNode = require(AmpV2Wizard.isParentModeThemedNode)
local getParentModeChromeThemeStore = require(AmpV2Wizard.getParentModeChromeThemeStore)
local FFlagAmpV2WizardServerParentFacing = require(AmpV2Wizard.FFlagAmpV2WizardServerParentFacing)
require(AmpV2Wizard.usePresentedOverPage)

local function useSyncParentModeChromeTheme(flag: boolean, flag2: boolean, p, p2: string?, p3, p4)
	local v = false

	local v2 = not (flag or flag2)

	if v2 then
		if p == nil then
			v2 = false
		else
			v2 = p3 ~= nil or getFFlagAmpV2WizardDebugUnknownNodes()
		end
	end

	if v2 then
		if p4 ~= nil then
			p = p4.node
		end

		if FFlagAmpV2WizardServerParentFacing then
			if p.behavior == nil then
				v = false
			else
				v = p.behavior.parentFacing == true
			end
		else
			v = isParentModeThemedNode(p.type, p2)
		end
	end

	React.useLayoutEffect(function()
		getParentModeChromeThemeStore(false).setIsActive(v)
	end, { v })

	React.useLayoutEffect(function()
		return function()
			getParentModeChromeThemeStore(false).setIsActive(false)
		end
	end, {})
end

return useSyncParentModeChromeTheme
