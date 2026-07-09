local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Roact = require(DiscoveryMonolithParent.Roact)
local RoactRodux = require(DiscoveryMonolithParent.RoactRodux)
local RoactServices = require(DiscoveryMonolithParent.RoactServices).RoactServices
local MessageBus = require(DiscoveryMonolithParent.MessageBus).MessageBus
local t = require(DiscoveryMonolithParent.t)
local AppLogging = require(DiscoveryMonolithParent.RoactServiceTags).AppLogging
local AppOmniRecommendationsRequest = require(DiscoveryMonolithParent.RoactServiceTags).AppOmniRecommendationsRequest
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local Modules = DiscoveryMonolith.Modules
local FetchDataOnGameExit = require(Modules.LuaApp.Thunks.Games.FetchDataOnGameExit)
local v13 = Roact.PureComponent:extend("OnGameLeaveReceiver")

function v13.init(p1) -- line: 18
	-- upvalues: MessageBus (copy), t (copy)
	function p1.returnedFromGame() -- line: 19
		-- upvalues: p1 (copy)
		local networking = p1.props.networking
		local omniRecommendationsRequest = p1.props.omniRecommendationsRequest

		p1.props.fetchDataOnGameExit(networking, omniRecommendationsRequest, p1.props.loggingProtocol)
	end

	p1.subscriber = MessageBus.Subscriber.new()
	p1.subscriber:subscribe({
		mid = MessageBus.getMessageId("Game", "onGameLeave"),
		validateParams = t.table
	}, function(_) -- line: 29
		-- upvalues: p1 (copy)
		p1.returnedFromGame()
	end)
end
function v13.render(_) -- line: 35
end

local v14 = RoactServices.connect({
	networking = RoactNetworking,
	omniRecommendationsRequest = AppOmniRecommendationsRequest,
	loggingProtocol = AppLogging
})(v13)

return RoactRodux.connect(nil, function(p4) -- line: 43
	-- upvalues: FetchDataOnGameExit (copy)
	return {
		fetchDataOnGameExit = function(p5, p6, p7) -- line: 45
			-- upvalues: p4 (copy), FetchDataOnGameExit (copy)
			p4(FetchDataOnGameExit(p5, p6, p7))
		end
	}
end)(v14)
