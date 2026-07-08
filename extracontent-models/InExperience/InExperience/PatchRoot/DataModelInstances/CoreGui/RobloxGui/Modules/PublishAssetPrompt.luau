local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local renderWithCoreScriptsStyleProvider = require(script.Parent.Common.renderWithCoreScriptsStyleProvider)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PublishAssetPromptApp = require(script.Components.PublishAssetPromptApp)
local Reducer = require(script.Reducer)
local ConnectAssetServiceEvents = require(script.ConnectAssetServiceEvents)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 24
	-- upvalues: t1 (copy), Roact (copy), PublishAssetPromptApp (copy), Rodux (copy), Reducer (copy), RoactRodux (copy), renderWithCoreScriptsStyleProvider (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), CoreGui (copy), ConnectAssetServiceEvents (copy)
	local self = setmetatable({}, t1)
	local v15 = Roact.createElement(PublishAssetPromptApp)

	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	local v16 = Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store
	}, {
		ThemeProvider = renderWithCoreScriptsStyleProvider({
			LocalizationProvider = Roact.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				PublishAssetPromptApp = v15
			})
		})
	})

	self.root = Roact.createElement("Folder", {
		Name = "PublishAssetPrompt"
	}, v16)
	self.element = Roact.mount(self.root, CoreGui, "PublishAssetPrompt")
	self.serviceConnections = ConnectAssetServiceEvents(self.store)

	return self
end

return t1.new()
