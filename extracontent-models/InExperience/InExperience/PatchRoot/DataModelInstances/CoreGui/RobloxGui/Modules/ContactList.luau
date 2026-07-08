local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local renderWithCoreScriptsStyleProvider = require(script.Parent.Common.renderWithCoreScriptsStyleProvider)
local React = require(CorePackages.Packages.React)
local Rodux = require(CorePackages.Packages.Rodux)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local CallProtocol = require(CorePackages.Workspace.Packages.CallProtocol)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local ApolloProvider = require(CorePackages.Packages.ApolloClient).ApolloProvider
local ApolloClient = require(RobloxGui.Modules.ApolloClient)
local initCall = require(script.initCall)
local Reducer = require(script.Reducer)
local ContactListApp = require(script.Components.ContactListApp)
local Context = require(script.Context)
local Analytics = require(script.Analytics)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 34
	-- upvalues: t1 (copy), Analytics (copy), initCall (copy), CallProtocol (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), Rodux (copy), Reducer (copy), RoactRodux (copy), renderWithCoreScriptsStyleProvider (copy), ApolloProvider (copy), ApolloClient (copy), Roact (copy), Context (copy), ContactListApp (copy), CoreGui (copy)
	local self = setmetatable({}, t1)
	local t2 = {
		fireAnalyticsEvent = Analytics.Analytics().fireAnalyticsEvent
	}

	initCall(CallProtocol.CallProtocol.default)
	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })
	self.root = React.createElement("ScreenGui", {
		AutoLocalize = false,
		DisplayOrder = -1,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Content = React.createElement(RoactRodux.StoreProvider, {
			store = self.store
		}, {
			ThemeProvider = renderWithCoreScriptsStyleProvider({
				ApolloProvider = React.createElement(ApolloProvider, {
					client = ApolloClient
				}, {
					ContextProvider = Roact.createElement(Context.Provider, {
						value = t2
					}, {
						ContactListApp = (function(p1) -- line: 46
							-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy)
							return React.createElement(LocalizationProvider, {
								localization = Localization.new(LocalizationService.RobloxLocaleId)
							}, {
								App = p1
							})
						end)(React.createElement(ContactListApp))
					})
				})
			})
		})
	})
	self.element = Roact.mount(self.root, CoreGui, "ContactList")

	return self
end

return t1.new()
