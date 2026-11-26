local defineFastFlag = game:DefineFastFlag("AXSpawnEffectSaveRoundTrip", false)

local v5 = Enum.AvatarAssetType:FromValue(97) ~= nil

return defineFastFlag and v5
