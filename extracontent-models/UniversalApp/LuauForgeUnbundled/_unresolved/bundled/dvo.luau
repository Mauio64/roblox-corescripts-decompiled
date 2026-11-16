local makeActionCreator = require("@luauforge/bundled/dqu").makeActionCreator
local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@luauforge/bundled/dqB").FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

return makeActionCreator("SetGameGridFlexFeedItemInput", function(p2, p3, p4, p5, p6, isLastGameGrid)
	if not fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		isLastGameGrid = nil
	end

	return {
		topicId = p2,
		sortIndex = p3,
		numberOfRows = p4,
		itemsPerRow = p5,
		entries = p6,
		isLastGameGrid = isLastGameGrid
	}
end)
