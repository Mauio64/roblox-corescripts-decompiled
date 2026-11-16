local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local renderWithCoreScriptsStyleProvider = require(script.Parent.Common.renderWithCoreScriptsStyleProvider)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local PublishAssetPromptApp = require(script.Components.PublishAssetPromptApp)
local Reducer = require(script.Reducer)
local ConnectAssetServiceEvents = require(script.ConnectAssetServiceEvents)

local class = {}
class.__index = class

function class.new()
	local self = setmetatable({}, class)
	local element = Roact.createElement(PublishAssetPromptApp)

	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	local element2 = Roact.createElement(RoactRodux.StoreProvider, { store = self.store }, {
		ThemeProvider = renderWithCoreScriptsStyleProvider({
			LocalizationProvider = Roact.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{ PublishAssetPromptApp = element }
			)
		})
	})

	self.root = Roact.createElement("Folder", { Name = "PublishAssetPrompt" }, element2)

	self.element = Roact.mount(self.root, CoreGui, "PublishAssetPrompt")

	self.serviceConnections = ConnectAssetServiceEvents(self.store)

	return self
end

return class.new()
