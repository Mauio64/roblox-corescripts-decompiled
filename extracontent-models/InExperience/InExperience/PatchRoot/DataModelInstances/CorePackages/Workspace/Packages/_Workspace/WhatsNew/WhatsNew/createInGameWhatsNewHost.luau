local parent = script:FindFirstAncestor("WhatsNew").Parent

local Foundation = require(parent.Foundation)
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local ensureWhatsNewStoreInitialized = require(script.Parent.store.ensureWhatsNewStoreInitialized)
require(script.Parent.registry.ScopeActions)
local WhatsNewScreenHost = require(script.Parent.components.WhatsNewScreenHost)

local LocalizationService = game:GetService("LocalizationService")

local inGameWhatsNew = Instance.new("ScreenGui")
inGameWhatsNew.Name = "InGameWhatsNew"
inGameWhatsNew.DisplayOrder = 16
inGameWhatsNew.IgnoreGuiInset = true
inGameWhatsNew.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
inGameWhatsNew.ResetOnSpawn = false
inGameWhatsNew.Parent = game:GetService("CoreGui")

local v = nil
local CreateInGameWhatsNewHost = {}

function CreateInGameWhatsNewHost.createInGameWhatsNewHost(p)
	if v ~= nil then
		return v
	end

	ensureWhatsNewStoreInitialized.ensureWhatsNewStoreInitialized({ scopeActions = p.scopeActions })

	local element = React.createElement(
		Foundation.FoundationProvider,
		{ colorMode = Foundation.Enums.ColorMode.Dark },
		{
			LocalizationProvider = React.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					Overlay = React.createElement(Foundation.OverlayProvider, {
						gui = inGameWhatsNew
					}, {
						Host = React.createElement(WhatsNewScreenHost, {
							screenScopeId = "InGame",
							scopeActions = p.scopeActions,
							isEnabled = true
						})
					})
				}
			)
		}
	)

	local root = ReactRoblox.createRoot(inGameWhatsNew)
	local success, result = pcall(function()
		root:render(element)
	end)

	if not success then
		warn(`WhatsNew createInGameWhatsNewHost render failed: {result}`)
	end

	v = root
	return root
end

function CreateInGameWhatsNewHost.resetForTests()
	v = nil
end

return CreateInGameWhatsNewHost
