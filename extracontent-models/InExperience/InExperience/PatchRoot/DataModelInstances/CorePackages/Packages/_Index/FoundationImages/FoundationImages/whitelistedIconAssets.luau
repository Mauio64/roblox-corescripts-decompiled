local scriptParent = script.Parent
local Flags = require(scriptParent.Flags)
local t1 = {}

for _, v5 in (string.split(Flags.FoundationImagesWhitelistedIconAssets, ",")) do
	t1[v5] = true
end

return t1
