local CorePackages = game:GetService("CorePackages")
local Lighting = game:GetService("Lighting")

local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local fFlagAXSkyboxFromBackgroundAsset = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSkyboxFromBackgroundAsset

local v5 = {
	LightTheme = {
		SkyboxAssetLocation = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
	},
	DarkTheme = {
		SkyboxAssetLocation = "rbxasset://textures/ui/AvatarExperience/AvatarExperienceSkyboxDarkTheme.png"
	}
}

local v6 = nil
local bindableEvent = if fFlagAXSkyboxFromBackgroundAsset then Instance.new("BindableEvent") else nil

local function getActiveSkyTexture(p2)
	if v6 ~= nil then
		return v6
	end

	if p2.SelectedTheme:lower() == "dark" then
		return v5.DarkTheme.SkyboxAssetLocation
	end

	return v5.LightTheme.SkyboxAssetLocation
end

local function setSkyboxOverride(p2)
	v6 = p2

	if bindableEvent then
		bindableEvent:Fire()
	end
end

local function clearSkyboxOverride()
	if v6 == nil then
		return
	end

	v6 = nil

	if bindableEvent then
		bindableEvent:Fire()
	end
end

local function isSkyboxOverrideActive(): boolean
	return v6 ~= nil
end

local extended = Roact.Component:extend("AvatarSceneSky")

extended.defaultProps = { isVRAppBuild = isVRAppBuild() }

extended.validateProps = t.interface({
	notificationService = t.any,
	lightingService = t.optional(t.Instance),
	isVRAppBuild = t.boolean
})

function extended:init()
	local notificationService = self.props.notificationService
	local v8

	if fFlagAXSkyboxFromBackgroundAsset then
		if v6 == nil then
			if notificationService.SelectedTheme:lower() == "dark" then
				v8 = v5.DarkTheme.SkyboxAssetLocation
			else
				v8 = v5.LightTheme.SkyboxAssetLocation
			end
		else
			v8 = v6
		end
	elseif notificationService.SelectedTheme:lower() == "dark" then
		v8 = v5.DarkTheme.SkyboxAssetLocation
	else
		v8 = v5.LightTheme.SkyboxAssetLocation
	end

	self.state = { skyTexture = v8 }

	function self.onThemeChanged()
		local v11

		if fFlagAXSkyboxFromBackgroundAsset then
			local notificationService2 = self.props.notificationService

			if v6 == nil then
				if notificationService2.SelectedTheme:lower() == "dark" then
					v11 = v5.DarkTheme.SkyboxAssetLocation
				else
					v11 = v5.LightTheme.SkyboxAssetLocation
				end
			else
				v11 = v6
			end
		elseif self.props.notificationService.SelectedTheme:lower() == "dark" then
			v11 = v5.DarkTheme.SkyboxAssetLocation
		else
			v11 = v5.LightTheme.SkyboxAssetLocation
		end

		self:setState({ skyTexture = v11 })
	end
end

function extended.render(props)
	local props2 = props.props
	local notificationService = props2.notificationService
	local lightingService = props2.lightingService or Lighting
	local v7

	if not props.props.isVRAppBuild then
		local skyTexture = props.state.skyTexture
		v7 = Roact.createElement("Sky", {
			CelestialBodiesShown = true,
			StarCount = 3000,
			SkyboxBk = skyTexture,
			SkyboxDn = skyTexture,
			SkyboxFt = skyTexture,
			SkyboxLf = skyTexture,
			SkyboxRt = skyTexture,
			SkyboxUp = skyTexture
		})
	end

	local createElement = Roact.createElement
	local portal = Roact.Portal

	local v9 = {
		SelectedThemeChangedConnection = Roact.createElement(externalEventConnection, {
			event = notificationService:GetPropertyChangedSignal("SelectedTheme"),
			callback = props.onThemeChanged
		}),
		SkyboxOverrideChangedConnection = 0,
		AvatarSceneSky = 0
	}

	local v10 = if fFlagAXSkyboxFromBackgroundAsset and bindableEvent then Roact.createElement(externalEventConnection, {
		event = bindableEvent.Event,
		callback = props.onThemeChanged
	}) else nil
	v9.SkyboxOverrideChangedConnection = v10

	v9.AvatarSceneSky = v7
	return createElement(portal, { target = lightingService }, v9)
end

function extended.didMount(p2)
	p2.onThemeChanged()
end

local v7 = roactServices.connect({ notificationService = appNotificationService })(extended)

v7.ThemeInformation = v5
v7.getActiveSkyTexture = getActiveSkyTexture

function v7.getThemeSkyTexture(p2)
	if p2.SelectedTheme:lower() == "dark" then
		return v5.DarkTheme.SkyboxAssetLocation
	end

	return v5.LightTheme.SkyboxAssetLocation
end
v7.setSkyboxOverride = setSkyboxOverride
v7.clearSkyboxOverride = clearSkyboxOverride
v7.isSkyboxOverrideActive = isSkyboxOverrideActive

return v7
