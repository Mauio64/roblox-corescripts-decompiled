local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local parent = script.Parent.Parent.Parent
local Page = require(script.Parent.Parent.Page)
local CloseMenu = require(parent.Thunks.CloseMenu)
local VRComfortAutoToggleEntry, ComfortSettingsEntry

if game:GetEngineFeature("VRMoreComfortSettings") then
	VRComfortAutoToggleEntry = require(script.Parent.VRComfortAutoToggleEntry)
	ComfortSettingsEntry = require(script.Parent.ComfortSettingsEntry)
else
	ComfortSettingsEntry = nil
	VRComfortAutoToggleEntry = nil
end

local extended = Roact.PureComponent:extend("VRComfortSettingsPage")

extended.validateProps = t.strictInterface({ closeMenu = t.callback, pageTitle = t.string })

local function createLayoutOrderGenerator() -- 1 equivalent call inferred from this helper
	local count = 0
	return function()
		count += 1
		return count
	end
end

function extended.render(p)
	return withFoundationOrUIBloxStyle(function(_)
		return {}
	end, function(_)
		local layoutOrderGenerator = createLayoutOrderGenerator() -- inferred equivalent call
		local createElement = Roact.createElement
		local v = { pageTitle = p.props.pageTitle, zIndex = 2, position = p.props.position }
		local v2 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			VRComfortSettings = 0,
			VignetteEnabled = 0,
			VRSteppedRotationEnabled = 0,
			VRThirdPersonFixedCamEnabled = 0
		}
		local vrComfortSettings

		if game:GetEngineFeature("VRMoreComfortSettings") then
			vrComfortSettings = Roact.createElement(ComfortSettingsEntry, {
				LayoutOrder = layoutOrderGenerator()
			})
		end

		v2.VRComfortSettings = vrComfortSettings
		local vignetteEnabled

		if game:GetEngineFeature("VRMoreComfortSettings") then
			vignetteEnabled = Roact.createElement(VRComfortAutoToggleEntry, {
				LayoutOrder = layoutOrderGenerator(),
				labelKey = "CoreScripts.InGameMenu.GameSettings.VignetteEnabled",
				customValueKey = "VignetteEnabledCustomOption",
				derivedValueKey = "VignetteEnabled"
			})
		end

		v2.VignetteEnabled = vignetteEnabled
		local vrSteppedRotationEnabled

		if game:GetEngineFeature("VRMoreComfortSettings") then
			vrSteppedRotationEnabled = Roact.createElement(VRComfortAutoToggleEntry, {
				LayoutOrder = layoutOrderGenerator(),
				labelKey = "CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled",
				customValueKey = "VRSmoothRotationEnabledCustomOption",
				derivedValueKey = "VRSmoothRotationEnabled",
				checkedValue = false
			})
		end

		v2.VRSteppedRotationEnabled = vrSteppedRotationEnabled
		local vrThirdPersonFixedCamEnabled

		if game:GetEngineFeature("VRMoreComfortSettings") then
			vrThirdPersonFixedCamEnabled = Roact.createElement(VRComfortAutoToggleEntry, {
				LayoutOrder = layoutOrderGenerator(),
				labelKey = "CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled",
				customValueKey = "VRThirdPersonFollowCamEnabledCustomOption",
				derivedValueKey = "VRThirdPersonFollowCamEnabled",
				checkedValue = false
			})
		end

		v2.VRThirdPersonFixedCamEnabled = vrThirdPersonFixedCamEnabled
		return createElement(Page, v, v2)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		closeMenu = function()
			callback(CloseMenu)
		end
	}
end)(extended)
