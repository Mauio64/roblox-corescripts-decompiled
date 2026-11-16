local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarEditorPromptsApp = require(script.Components.AvatarEditorPromptsApp)
local Reducer = require(script.Reducer)

local GetGameName = require(script.Thunks.GetGameName)
local AvatarEditorPromptsPolicy = require(script.AvatarEditorPromptsPolicy)

local RoactGlobalConfig = require(script.RoactGlobalConfig)

local ConnectAvatarEditorServiceEvents = require(script.ConnectAvatarEditorServiceEvents)

local class = {}
class.__index = class

function class.new()
	local self = setmetatable({}, class)

	if RoactGlobalConfig.propValidation then
		Roact.setGlobalConfig({ propValidation = true })
	end

	if RoactGlobalConfig.elementTracing then
		Roact.setGlobalConfig({ elementTracing = true })
	end

	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	self.store:dispatch(GetGameName)

	local element = Roact.createElement(RoactRodux.StoreProvider, { store = self.store }, {
		LocalizationProvider = Roact.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{
				FoundationProvider = Roact.createElement(
					Foundation.FoundationProvider,
					{ colorMode = Foundation.Enums.ColorMode.Dark },
					{
						PolicyProvider = Roact.createElement(AvatarEditorPromptsPolicy.Provider, {
							policy = { AvatarEditorPromptsPolicy.Mapper }
						}, {
							ThemeProvider = renderWithCoreScriptsStyleProvider({
								AvatarEditorPromptsApp = Roact.createElement(AvatarEditorPromptsApp)
							})
						})
					}
				)
			}
		)
	})

	self.root = Roact.createElement("Folder", { Name = "AvatarEditorPromptsApp" }, element)

	self.element = Roact.mount(self.root, CoreGui, "AvatarEditorPrompts")

	self.serviceConnections = ConnectAvatarEditorServiceEvents(self.store)

	return self
end

return class.new()
