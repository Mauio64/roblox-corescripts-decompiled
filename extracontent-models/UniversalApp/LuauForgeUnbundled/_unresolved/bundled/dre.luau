local module = require("@luauforge/bundled/drf")
local module2 = require("@luauforge/bundled/drg")
local roactServices = require("@luauforge/bundled/drh").RoactServices
local messageBus = require("@luauforge/bundled/dri").MessageBus
local module3 = require("@luauforge/bundled/drj")
local appLogging = require("@luauforge/bundled/drk").AppLogging
local appOmniRecommendationsRequest = require("@luauforge/bundled/drk").AppOmniRecommendationsRequest
local roactNetworking = require("@luauforge/bundled/drk").RoactNetworking
local hoverTileCoordinator = require("@luauforge/bundled/drl").HoverTileCoordinator

local module4 = require("@luauforge/bundled/drm")

local fFlagLuaAppEnableSduiHomePage = require("@luauforge/bundled/dqB").FFlagLuaAppEnableSduiHomePage
local fFlagResetHoverTileOnGameLeave = require("@luauforge/bundled/dqB").FFlagResetHoverTileOnGameLeave

local extended = module.PureComponent:extend("OnGameLeaveReceiver")

function extended:init()
	function self.returnedFromGame()
		if fFlagLuaAppEnableSduiHomePage then
			local module5 = require("@luauforge/bundled/drL")
			local v5 = module5.refreshHomePage(module5.HomeConstants.RequestIntent.GameExit, nil, false)

			if v5 then
				v5:catch(function(p2)
					warn("We failed to refresh omni recommendations on game exit!", p2)
				end)
			end
		else
			local networking = self.props.networking
			local omniRecommendationsRequest = self.props.omniRecommendationsRequest
			self.props.fetchDataOnGameExit(
				networking,
				omniRecommendationsRequest,
				self.props.loggingProtocol
			)
		end

		if fFlagResetHoverTileOnGameLeave then
			hoverTileCoordinator.default:reset()
		end
	end

	self.subscriber = messageBus.Subscriber.new()
	self.subscriber:subscribe(
		{
			mid = messageBus.getMessageId("Game", "onGameLeave"),
			validateParams = module3.table
		},
		function(p2)
			self.returnedFromGame()
		end
	)
end

function extended.render(p2) end

local v5 = roactServices.connect({
	networking = roactNetworking,
	omniRecommendationsRequest = appOmniRecommendationsRequest,
	loggingProtocol = appLogging
})(extended)

return module2.connect(nil, function(callback)
	return {
		fetchDataOnGameExit = function(p2, p3, p4)
			callback(module4(p2, p3, p4))
		end
	}
end)(v5)
