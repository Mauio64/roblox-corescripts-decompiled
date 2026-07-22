local NO_BACKGROUND_ASSET_ID = require(script.Parent.constants).NO_BACKGROUND_ASSET_ID

local function normalizeBackgroundId(n1: number?) -- line: 5
	-- upvalues: NO_BACKGROUND_ASSET_ID (copy)
	if n1 == nil or n1 == NO_BACKGROUND_ASSET_ID then
		return nil
	end

	return n1
end

return normalizeBackgroundId
