local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/edm")

local module2 = require("@luauforge/bundled/gdB")
local module3 = require("@luauforge/bundled/iaW")
local module4 = require("@luauforge/bundled/gdA")
local module5 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module6 = require("@luauforge/bundled/gdJ")

local fFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local extended = Roact.PureComponent:extend("MarketplaceServiceEventReciever")

extended.defaultProps = { marketplaceService = MarketplaceService }

function extended.render(p2)
	local marketplaceService = p2.props.marketplaceService

	if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
		local createFragment = Roact.createFragment
		local v5 = {
			[1] = nil,
			[1] = nil,
			Roact.createElement(module, {
				event = marketplaceService.NativePurchaseFinishedWithLocalPlayer,
				callback = function(p3, p4)
					p2.props.nativePurchaseFinishedWithLocalPlayer(p2.props.networking, p3, p4, nil)
				end
			}),
			(Roact.createElement(module, {
				event = marketplaceService.NativePurchaseFinished,
				callback = function(p3, p4, p5)
					p2.props.nativePurchaseFinishedWithNetwork(p2.props.networking, p3, p4, p5, nil)
				end
			}))
		}
		local v6

		if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			v6 = Roact.createElement(module, {
				event = marketplaceService.NativePurchaseFinishedWithLocalPlayerV2,
				callback = function(p3, p4, p5)
					p2.props.nativePurchaseFinishedWithLocalPlayer(p2.props.networking, p3, p4, p5)
				end
			})
		end

		v5.NativePurchaseFinishedWithLocalPlayerV2 = v6
		local v7

		if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			v7 = Roact.createElement(module, {
				event = marketplaceService.NativePurchaseFinishedV2,
				callback = function(p3, p4, p5, p6)
					p2.props.nativePurchaseFinishedWithNetwork(p2.props.networking, p3, p4, p5, p6)
				end
			})
		end

		v5.NativePurchaseFinishedV2 = v7
		return createFragment(v5)
	elseif fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
		return Roact.createFragment({
			NativePurchaseFinished = Roact.createElement(module, {
				event = marketplaceService.NativePurchaseFinished,
				callback = function(p3, p4, p5)
					p2.props.nativePurchaseFinishedWithNetwork(p2.props.networking, p3, p4, p5, nil)
				end
			}),
			NativePurchaseFinishedV2 = Roact.createElement(module, {
				event = marketplaceService.NativePurchaseFinishedV2,
				callback = function(p3, p4, p5, p6)
					p2.props.nativePurchaseFinishedWithNetwork(p2.props.networking, p3, p4, p5, p6)
				end
			})
		})
	else
		return Roact.createElement(module, {
			event = marketplaceService.NativePurchaseFinished,
			callback = function(p3, p4, p5)
				p2.props.nativePurchaseFinishedWithNetwork(p2.props.networking, p3, p4, p5, nil)
			end
		})
	end
end

local v5 = roactServices.connect({ networking = module5 })(extended)

return RoactRodux.connect(nil, function(callback)
	return {
		nativePurchaseFinished = function(p2, p3, p4)
			return callback(module3(p3, p4))
		end,
		nativePurchaseFinishedWithNetwork = function(p2, p3, p4, p5, p6)
			local v6 = if p5 then module4.Success else module4.Failed

			if not module6 then
				p6 = nil
			end

			return callback(module2(p2, p4, v6, p6))
		end,
		nativePurchaseFinishedWithLocalPlayer = function(p2, p3, p4, p5)
			local v6 = if p4 then module4.Success else module4.Failed

			if not module6 then
				p5 = nil
			end

			return callback(module2(p2, p3, v6, p5))
		end
	}
end)(v5)
