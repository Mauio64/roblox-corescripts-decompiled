local defineFastFlag = game:DefineFastFlag("AXSpawnEffectSaveRoundTrip", false)

local v = Enum.AvatarAssetType:FromValue(97) ~= nil

return defineFastFlag and v
