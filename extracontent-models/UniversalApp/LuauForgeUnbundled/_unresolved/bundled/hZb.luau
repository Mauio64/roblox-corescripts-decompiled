local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local MemStorageService = game:GetService("MemStorageService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/fDH")
local module2 = require("@luauforge/bundled/fBn")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/eda")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module4 = require("@luauforge/bundled/fBr")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local appearanceContext = require("@game/CorePackages/Workspace/Packages/Style").AppearanceContext

local systemThemeEnabled = require("@luauforge/bundled/fyV").GetSystemThemeEnabled()

local fFlagMoveForceThemeToThemeChangeEventReceiver = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMoveForceThemeToThemeChangeEventReceiver

local module6 = require("@luauforge/bundled/hWE")

local v5 = { ThemeUpdate = "ThemeUpdate" }

local extended = Roact.Component:extend("ThemeUpdater")

function extended:init()
	local robloxEventReceiver = self.props.RobloxEventReceiver
	local networking = self.props.networking

	function self.changeTheme(selectedTheme)
		if systemThemeEnabled then
			return
		end

		if self.props.themeOverride then
			selectedTheme = self.props.themeOverride
		end

		NotificationService.SelectedTheme = selectedTheme

		self.props.themeContext.setTheme(selectedTheme)

		module6:updateSharedAttributes({ AppTheme = selectedTheme })
	end

	function self.updateTheme()
		local function cacheAndChangeTheme(themeOverride)
			MemStorageService:Fire(module4.ThemeUpdate, themeOverride)
			self.changeTheme(themeOverride)

			module2.setAuthenticatedTheme(themeOverride)
			module2.flush()
		end

		if self.props.themeOverride then
			return cacheAndChangeTheme(self.props.themeOverride)
		end

		return module(networking, Players.LocalPlayer.UserId):andThen(function(p2)
			MemStorageService:Fire(module4.ThemeUpdate, p2)
			self.changeTheme(p2)

			module2.setAuthenticatedTheme(p2)
			module2.flush()
		end)
	end

	self.tokens = {
		robloxEventReceiver:observeEvent("UserThemeTypeChangeNotification", function(p2, p3)
			if (p2.Type or p3) == "ThemeUpdate" then
				self.updateTheme()
			end
		end),
		MemStorageService:Bind(module4.ThemeUpdate, function(p2)
			self.changeTheme(p2)
		end)
	}
end

function extended.render(p2) end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

return roactServices.connect({ networking = module3, guiService = appGuiService })(function(p2)
	local v6 = useAppPolicy(function(p3)
		return p3.getForceTheme()
	end)

	local v7 = React.useContext(appearanceContext)

	if fFlagMoveForceThemeToThemeChangeEventReceiver then
		local setTheme = v7.setTheme
		React.useLayoutEffect(function()
			if v6 and not systemThemeEnabled then
				NotificationService.SelectedTheme = v6
				setTheme(v6)
			end
		end, { v6, setTheme })
	end

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p2, { themeOverride = v6, themeContext = v7 })
	)
end)
