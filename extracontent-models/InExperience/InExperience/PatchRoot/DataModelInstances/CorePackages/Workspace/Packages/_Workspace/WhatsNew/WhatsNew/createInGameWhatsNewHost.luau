local Parent = script:FindFirstAncestor("WhatsNew").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.InExperienceLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local ensureWhatsNewStoreInitialized = require(script.Parent.store.ensureWhatsNewStoreInitialized)

require(script.Parent.registry.ScopeActions)

local WhatsNewScreenHost = require(script.Parent.components.WhatsNewScreenHost)
local LocalizationService = game:GetService("LocalizationService")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "InGameWhatsNew"
ScreenGui.DisplayOrder = 16
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local u11 = nil

return {
	createInGameWhatsNewHost = function(t1: {[any]: any}) -- line: 36
		-- upvalues: u11 (ref), ensureWhatsNewStoreInitialized (copy), React (copy), Foundation (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), ScreenGui (copy), WhatsNewScreenHost (copy), ReactRoblox (copy)
		if u11 ~= nil then
			return u11
		end

		ensureWhatsNewStoreInitialized.ensureWhatsNewStoreInitialized({
			scopeActions = t1.scopeActions
		})

		local v13 = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				Overlay = React.createElement(Foundation.OverlayProvider, {
					gui = ScreenGui
				}, {
					Host = React.createElement(WhatsNewScreenHost, {
						screenScopeId = "InGame",
						isEnabled = true,
						scopeActions = t1.scopeActions
					})
				})
			})
		})
		local v14 = ReactRoblox.createRoot(ScreenGui)
		local ok, result = pcall(function() -- line: 65
			-- upvalues: v14 (copy), v13 (copy)
			v14:render(v13)
		end)

		if not ok then
			warn(`WhatsNew createInGameWhatsNewHost render failed: { result }`)
		end

		u11 = v14

		return v14
	end,
	resetForTests = function() -- line: 77
		-- upvalues: u11 (ref)
		u11 = nil
	end
}
