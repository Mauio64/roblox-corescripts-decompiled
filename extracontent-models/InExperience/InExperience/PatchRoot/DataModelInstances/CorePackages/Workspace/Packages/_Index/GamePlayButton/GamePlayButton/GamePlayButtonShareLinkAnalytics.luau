local parent = script:FindFirstAncestor("GamePlayButton").Parent

local t = require(parent.t)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local strictInterface = t.strictInterface({
	placeId = t.string,
	playButtonState = t.string,
	universeId = t.string
})

return function(p, p2)
	local v, v2 = strictInterface(p2)

	if not v then
		mutedError(v2)
	end

	p.EventStream:setRBXEventStream("GamePlayButton", "shareLinkGameJoin", p2)

	p.Diag:reportCounter("shareLinkGameJoin", 1)
end
