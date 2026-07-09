local CorePackages = game:GetService("CorePackages")
local Lighting = game:GetService("Lighting")
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local t1 = {
	LightTheme = {
		SkyboxAssetLocation = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
	},
	DarkTheme = {
		SkyboxAssetLocation = "rbxasset://textures/ui/AvatarExperience/AvatarExperienceSkyboxDarkTheme.png"
	}
}

local function getSkyTexture(p1) -- line: 21
	-- upvalues: t1 (copy)
	if p1.SelectedTheme:lower() == "dark" then
		return t1.DarkTheme.SkyboxAssetLocation
	end

	return t1.LightTheme.SkyboxAssetLocation
end

local v11 = Roact.Component:extend("AvatarSceneSky")

v11.defaultProps = {
	isVRAppBuild = IsVRAppBuild()
}
v11.validateProps = t.interface({
	notificationService = t.any,
	lightingService = t.optional(t.Instance),
	isVRAppBuild = t.boolean
})

function v11.init(p2) -- line: 42
	-- upvalues: t1 (copy)
	p2.state = {
		skyTexture = if p2.props.notificationService.SelectedTheme:lower() ~= "dark" then t1.LightTheme.SkyboxAssetLocation else t1.DarkTheme.SkyboxAssetLocation
	}

	function p2.onThemeChanged() -- line: 46
		-- upvalues: p2 (copy), t1 (copy)
		p2:setState({
			skyTexture = if p2.props.notificationService.SelectedTheme:lower() ~= "dark" then t1.LightTheme.SkyboxAssetLocation else t1.DarkTheme.SkyboxAssetLocation
		})
	end
end
function v11.render(p3) -- line: 53
	-- upvalues: Lighting (copy), Roact (copy), ExternalEventConnection (copy)
	local props = p3.props
	local notificationService = props.notificationService
	local skyTexture = p3.state.skyTexture
	local v18 = props.lightingService or Lighting

	return Roact.createElement(Roact.Portal, {
		target = v18
	}, {
		SelectedThemeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = notificationService:GetPropertyChangedSignal("SelectedTheme"),
			callback = p3.onThemeChanged
		}),
		AvatarSceneSky = if p3.props.isVRAppBuild then nil else Roact.createElement("Sky", {
			CelestialBodiesShown = true,
			StarCount = 3000,
			SkyboxBk = skyTexture,
			SkyboxDn = skyTexture,
			SkyboxFt = skyTexture,
			SkyboxLf = skyTexture,
			SkyboxRt = skyTexture,
			SkyboxUp = skyTexture
		})
	})
end
function v11.didMount(p4) -- line: 82
	p4.onThemeChanged()
end

return (RoactServices.connect({
	notificationService = AppNotificationService
})(v11))
