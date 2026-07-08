local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ShareGame = Modules.Settings.Pages.ShareGame
local App = require(ShareGame.Components.App)
local AppReducer = require(ShareGame.AppReducer)
local InviteStore = require(ShareGame.InviteStore)
local GetFFlagEnableSharedInviteStore = require(Modules.Flags.GetFFlagEnableSharedInviteStore)

return {
	createApp = function(p1, p2) -- line: 17
		-- upvalues: GetFFlagEnableSharedInviteStore (copy), InviteStore (copy), Rodux (copy), AppReducer (copy), Roact (copy), RoactRodux (copy), App (copy)
		local t1 = {
			store = if not GetFFlagEnableSharedInviteStore() then Rodux.Store.new(AppReducer, nil, { Rodux.thunkMiddleware }) else InviteStore
		}

		t1._instanceHandle = Roact.mount(Roact.createElement(RoactRodux.StoreProvider, {
			store = t1.store
		}, {
			App = Roact.createElement(App, {
				analytics = p2,
				pageTarget = p1
			})
		}))

		return t1
	end
}
