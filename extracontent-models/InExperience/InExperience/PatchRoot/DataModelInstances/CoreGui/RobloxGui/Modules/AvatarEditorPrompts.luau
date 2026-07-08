local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarEditorPromptsApp = require(script.Components.AvatarEditorPromptsApp)
local Reducer = require(script.Reducer)
local GetGameName = require(script.Thunks.GetGameName)
local AvatarEditorPromptsPolicy = require(script.AvatarEditorPromptsPolicy)
local RoactGlobalConfig = require(script.RoactGlobalConfig)
local ConnectAvatarEditorServiceEvents = require(script.ConnectAvatarEditorServiceEvents)
local FFlagAXAvatarTimeoutFlowIE = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE
local t1 = {}

t1.__index = t1

function t1.new() -- line: 33
	-- upvalues: t1 (copy), RoactGlobalConfig (copy), Roact (copy), Rodux (copy), Reducer (copy), GetGameName (copy), FFlagAXAvatarTimeoutFlowIE (copy), RoactRodux (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), Foundation (copy), AvatarEditorPromptsPolicy (copy), renderWithCoreScriptsStyleProvider (copy), AvatarEditorPromptsApp (copy), CoreGui (copy), ConnectAvatarEditorServiceEvents (copy)
	local self = setmetatable({}, t1)

	if RoactGlobalConfig.propValidation then
		Roact.setGlobalConfig({
			propValidation = true
		})
	end

	if RoactGlobalConfig.elementTracing then
		Roact.setGlobalConfig({
			elementTracing = true
		})
	end

	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })
	self.store:dispatch(GetGameName)

	local v21 = if not FFlagAXAvatarTimeoutFlowIE then Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store
	}, {
		PolicyProvider = Roact.createElement(AvatarEditorPromptsPolicy.Provider, {
			policy = { AvatarEditorPromptsPolicy.Mapper }
		}, {
			ThemeProvider = renderWithCoreScriptsStyleProvider({
				AvatarEditorPromptsApp = Roact.createElement(AvatarEditorPromptsApp)
			})
		})
	}) else Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store
	}, {
		LocalizationProvider = Roact.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			FoundationProvider = Roact.createElement(Foundation.FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark
			}, {
				PolicyProvider = Roact.createElement(AvatarEditorPromptsPolicy.Provider, {
					policy = { AvatarEditorPromptsPolicy.Mapper }
				}, {
					ThemeProvider = renderWithCoreScriptsStyleProvider({
						AvatarEditorPromptsApp = Roact.createElement(AvatarEditorPromptsApp)
					})
				})
			})
		})
	})

	self.root = Roact.createElement("Folder", {
		Name = "AvatarEditorPromptsApp"
	}, v21)
	self.element = Roact.mount(self.root, CoreGui, "AvatarEditorPrompts")
	self.serviceConnections = ConnectAvatarEditorServiceEvents(self.store)

	return self
end

return t1.new()
