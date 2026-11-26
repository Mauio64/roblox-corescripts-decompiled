local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local messageBus = require("@luauforge/bundled/ggr").MessageBus
local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/egx")

local module2 = require("@luauforge/bundled/ijG")
local module3 = require("@luauforge/bundled/ijI")
local module4 = require("@luauforge/bundled/dSY")

local extended = Roact.PureComponent:extend("ReturnFromGameReceiver")

function extended:init()
	self.launchedUniverseId = nil

	function self.reloadFavoriteAndFollowing()
		local networking = self.props.networking
		local launchedUniverseId = self.launchedUniverseId
		return self.props.fetchFavoriteAndFollowingData(networking, launchedUniverseId)
	end

	function self.returnedFromGame()
		if self.props.onGameReturned then
			self.props.onGameReturned(self.launchedUniverseId)
		end

		self:reloadFavoriteAndFollowing()
	end

	self.subscriber = messageBus.Subscriber.new()
	self.subscriber:subscribe(
		{
			mid = messageBus.getMessageId("Game", "onGameLeave"),
			validateParams = t.table
		},
		function(p2)
			self.launchedUniverseId = nil
			self.launchedUniverseId = module4.Game.getGameInfoStore(false).getUniverseIdForPlaceId(p2.placeId)

			if self.launchedUniverseId then
				self:returnedFromGame()
				self.launchedUniverseId = nil
			end
		end
	)
end

function extended.render(p2) end

local v5 = roactServices.connect({ networking = module })(extended)

return RoactRodux.connect(function(p2)
	return { gameDetails = p2.GameDetails }
end, function(callback)
	return {
		fetchFavoriteAndFollowingData = function(p2, p3)
			callback(module2(p2, p3))
			callback(module3(p2, p3))
		end
	}
end)(v5)
