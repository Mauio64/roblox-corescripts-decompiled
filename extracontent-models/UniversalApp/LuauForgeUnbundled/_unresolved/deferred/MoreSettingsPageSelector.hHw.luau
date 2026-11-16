local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local module2 = require("@luauforge/deferred/hHx")
local module3 = require("@luauforge/deferred/hHC")
local module4 = require("@luauforge/deferred/hIQ")

local module5 = require("@luauforge/deferred/hIS")
local module6 = require("@luauforge/deferred/hIT")

local v5 = false

local function MoreSettingsPageSelector(p2)
	local v6 = useIsSpatial()

	local v7 = if module5 then RobloxAppHooks.useUiModeInfo().uiMode == uiMode.TenFoot else false

	if module6 then
		React.useEffect(function()
			if not (v6 or v7 or v5) then
				v5 = true
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.SettingsRootPageExposureLayer)
			end
		end, { v6, v7 })
	end

	if v6 then
		return React.createElement(module2, p2)
	end

	if module5 and not v7 then
		return React.createElement(module4, p2)
	end

	return React.createElement(module3, p2)
end

return MoreSettingsPageSelector
