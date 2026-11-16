local constants = require(script.Parent.constants)
local NO_BACKGROUND_ASSET_ID = constants.NO_BACKGROUND_ASSET_ID

local function normalizeBackgroundId(p: number?)
	if p == nil or p == NO_BACKGROUND_ASSET_ID then
		return nil
	end

	return p
end

return normalizeBackgroundId
