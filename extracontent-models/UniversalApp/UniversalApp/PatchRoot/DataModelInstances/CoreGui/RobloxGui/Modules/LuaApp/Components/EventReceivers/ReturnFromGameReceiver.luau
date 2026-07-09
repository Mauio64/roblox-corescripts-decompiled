local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local t = require(CorePackages.Packages.t)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local ApiFetchGameIsFavorite = require(Modules.LuaApp.Thunks.Games.ApiFetchGameIsFavorite)
local ApiFetchGameFollowingStatus = require(Modules.LuaApp.Thunks.ApiFetchGameFollowingStatus)
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local v12 = Roact.PureComponent:extend("ReturnFromGameReceiver")

function v12.init(p1) -- line: 21
	-- upvalues: MessageBus (copy), t (copy)
	p1.launchedUniverseId = nil

	function p1.reloadFavoriteAndFollowing() -- line: 24
		-- upvalues: p1 (copy)
		local networking = p1.props.networking
		local launchedUniverseId = p1.launchedUniverseId

		return p1.props.fetchFavoriteAndFollowingData(networking, launchedUniverseId)
	end
	function p1.returnedFromGame() -- line: 30
		-- upvalues: p1 (copy)
		if p1.props.onGameReturned then
			p1.props.onGameReturned(p1.launchedUniverseId)
		end

		p1:reloadFavoriteAndFollowing()
	end

	p1.subscriber = MessageBus.Subscriber.new()
	p1.subscriber:subscribe({
		mid = MessageBus.getMessageId("Game", "onGameLeave"),
		validateParams = t.table
	}, function(p2) -- line: 41
		-- upvalues: p1 (copy)
		p1.launchedUniverseId = nil

		if p1.props.games then
			for k, v in pairs(p1.props.games) do
				if v.placeId == tostring(p2.placeId) then
					p1.launchedUniverseId = tostring(k)
				end
			end
		end

		if p1.launchedUniverseId then
			p1:returnedFromGame()
			p1.launchedUniverseId = nil
		end
	end)
end
function v12.render(_) -- line: 58
end

local v13 = RoactServices.connect({
	networking = RoactNetworking
})(v12)

return RoactRodux.connect(function(p4) -- line: 64
	-- upvalues: GameInfosReducer (copy)
	return {
		games = p4.Personalization[GameInfosReducer.key],
		gameDetails = p4.GameDetails
	}
end, function(p5) -- line: 70
	-- upvalues: ApiFetchGameIsFavorite (copy), ApiFetchGameFollowingStatus (copy)
	return {
		fetchFavoriteAndFollowingData = function(p6, p7) -- line: 72
			-- upvalues: p5 (copy), ApiFetchGameIsFavorite (copy), ApiFetchGameFollowingStatus (copy)
			p5(ApiFetchGameIsFavorite(p6, p7))
			p5(ApiFetchGameFollowingStatus(p6, p7))
		end
	}
end)(v13)
