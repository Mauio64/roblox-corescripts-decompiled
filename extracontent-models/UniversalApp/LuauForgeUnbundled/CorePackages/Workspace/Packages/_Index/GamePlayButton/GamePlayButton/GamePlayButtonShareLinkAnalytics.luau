local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/t")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Loggers").mutedError

local strictInterface = t.strictInterface({
	placeId = t.string,
	playButtonState = t.string,
	universeId = t.string
})

return function(p2, p3)
	local v5, v6 = strictInterface(p3)

	if not v5 then
		mutedError(v6)
	end

	p2.EventStream:setRBXEventStream("GamePlayButton", "shareLinkGameJoin", p3)

	p2.Diag:reportCounter("shareLinkGameJoin", 1)
end
