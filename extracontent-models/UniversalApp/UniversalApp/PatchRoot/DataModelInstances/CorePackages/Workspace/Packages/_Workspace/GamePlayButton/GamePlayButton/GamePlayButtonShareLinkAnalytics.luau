local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local t = require(Parent.t)
local mutedError = require(Parent.Loggers).mutedError
local v4 = t.strictInterface({
	placeId = t.string,
	playButtonState = t.string,
	universeId = t.string
})

return function(p1, p2) -- line: 16
	-- upvalues: v4 (copy), mutedError (copy)
	local v7, v8 = v4(p2)

	if not v7 then
		mutedError(v8)
	end

	p1.EventStream:setRBXEventStream("GamePlayButton", "shareLinkGameJoin", p2)
	p1.Diag:reportCounter("shareLinkGameJoin", 1)
end
