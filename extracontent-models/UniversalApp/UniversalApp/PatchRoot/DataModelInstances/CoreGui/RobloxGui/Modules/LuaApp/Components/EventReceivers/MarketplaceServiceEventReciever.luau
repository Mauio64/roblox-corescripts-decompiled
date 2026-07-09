local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local NativePurchaseComplete = require(Modules.LuaApp.Thunks.NativePurchaseComplete)
local NativePurchaseCompleteDEP = require(Modules.LuaApp.Thunks.NativePurchaseCompleteDEP)
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local v13 = Roact.PureComponent:extend("MarketplaceServiceEventReciever")

function v13.render(p1) -- line: 18
	-- upvalues: Roact (copy), ExternalEventConnection (copy), MarketplaceService (copy)
	if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
		return Roact.createFragment({
			Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedWithLocalPlayer,
				callback = function(p2, p3) -- line: 23
					-- upvalues: p1 (copy)
					p1.props.nativePurchaseFinishedWithLocalPlayer(p1.props.networking, p2, p3)
				end
			}),
			Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinished,
				callback = function(p4, p5, p6) -- line: 29
					-- upvalues: p1 (copy)
					p1.props.nativePurchaseFinishedWithNetwork(p1.props.networking, p4, p5, p6)
				end
			})
		})
	end

	return Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.NativePurchaseFinished,
		callback = function(p7, p8, p9) -- line: 37
			-- upvalues: p1 (copy)
			p1.props.nativePurchaseFinishedWithNetwork(p1.props.networking, p7, p8, p9)
		end
	})
end

local v14 = RoactServices.connect({
	networking = RoactNetworking
})(v13)

return RoactRodux.connect(nil, function(p10) -- line: 48
	-- upvalues: NativePurchaseCompleteDEP (copy), NativePurchaseStatus (copy), NativePurchaseComplete (copy)
	return {
		nativePurchaseFinished = function(_, p12, p13) -- line: 50
			-- upvalues: p10 (copy), NativePurchaseCompleteDEP (copy)
			return p10(NativePurchaseCompleteDEP(p12, p13))
		end,
		nativePurchaseFinishedWithNetwork = function(p14, _, p16, p17) -- line: 53
			-- upvalues: NativePurchaseStatus (copy), p10 (copy), NativePurchaseComplete (copy)
			local v32 = if not p17 then NativePurchaseStatus.Failed else NativePurchaseStatus.Success

			return p10(NativePurchaseComplete(p14, p16, v32))
		end,
		nativePurchaseFinishedWithLocalPlayer = function(p18, p19, p20) -- line: 57
			-- upvalues: NativePurchaseStatus (copy), p10 (copy), NativePurchaseComplete (copy)
			local v36 = if not p20 then NativePurchaseStatus.Failed else NativePurchaseStatus.Success

			return p10(NativePurchaseComplete(p18, p19, v36))
		end
	}
end)(v14)
