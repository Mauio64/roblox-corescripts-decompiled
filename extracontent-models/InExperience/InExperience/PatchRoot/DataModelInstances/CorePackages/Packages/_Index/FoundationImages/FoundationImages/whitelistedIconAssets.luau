local parent = script.Parent
local Flags = require(parent.Flags)

local v = string.split(Flags.FoundationImagesWhitelistedIconAssets, ",")
local WhitelistedIconAssets = {}

for _, v2 in v do
	WhitelistedIconAssets[v2] = true
end

return WhitelistedIconAssets
