local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local withStyle = InGameMenuDependencies.UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent.Parent
local Page = require(script.Parent.Parent.Page)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local VRComfortAutoToggleEntry = nil
local ComfortSettingsEntry = nil

if game:GetEngineFeature("VRMoreComfortSettings") then
	VRComfortAutoToggleEntry = require(script.Parent.VRComfortAutoToggleEntry)
	ComfortSettingsEntry = require(script.Parent.ComfortSettingsEntry)
end

local v12 = Roact.PureComponent:extend("VRComfortSettingsPage")

v12.validateProps = t.strictInterface({
	closeMenu = t.callback,
	pageTitle = t.string
})

local function createLayoutOrderGenerator() -- line: 26
	local n1 = 0

	return function() -- line: 28
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end
end

function v12.render(p1) -- line: 34
	-- upvalues: withStyle (copy), Roact (copy), Page (copy), ComfortSettingsEntry (ref), VRComfortAutoToggleEntry (ref)
	return withStyle(function(_) -- line: 35
		-- upvalues: Roact (copy), Page (copy), p1 (copy), ComfortSettingsEntry (ref), VRComfortAutoToggleEntry (ref)
		local n2 = 0

		local function v19() -- line: 28
			-- upvalues: n2 (ref)
			n2 += 1

			return n2
		end

		return Roact.createElement(Page, {
			zIndex = 2,
			pageTitle = p1.props.pageTitle,
			position = p1.props.position
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			VRComfortSettings = if not game:GetEngineFeature("VRMoreComfortSettings") then nil else Roact.createElement(ComfortSettingsEntry, {
				LayoutOrder = v19()
			}),
			VignetteEnabled = if not game:GetEngineFeature("VRMoreComfortSettings") then nil else Roact.createElement(VRComfortAutoToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.VignetteEnabled",
				customValueKey = "VignetteEnabledCustomOption",
				derivedValueKey = "VignetteEnabled",
				LayoutOrder = v19()
			}),
			VRSteppedRotationEnabled = if not game:GetEngineFeature("VRMoreComfortSettings") then nil else Roact.createElement(VRComfortAutoToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled",
				customValueKey = "VRSmoothRotationEnabledCustomOption",
				derivedValueKey = "VRSmoothRotationEnabled",
				checkedValue = false,
				LayoutOrder = v19()
			}),
			VRThirdPersonFixedCamEnabled = if not game:GetEngineFeature("VRMoreComfortSettings") then nil else Roact.createElement(VRComfortAutoToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled",
				customValueKey = "VRThirdPersonFollowCamEnabledCustomOption",
				derivedValueKey = "VRThirdPersonFollowCamEnabled",
				checkedValue = false,
				LayoutOrder = v19()
			})
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p3) -- line: 83
	-- upvalues: CloseMenu (copy)
	return {
		closeMenu = function() -- line: 85
			-- upvalues: p3 (copy), CloseMenu (copy)
			p3(CloseMenu)
		end
	}
end)(v12)
