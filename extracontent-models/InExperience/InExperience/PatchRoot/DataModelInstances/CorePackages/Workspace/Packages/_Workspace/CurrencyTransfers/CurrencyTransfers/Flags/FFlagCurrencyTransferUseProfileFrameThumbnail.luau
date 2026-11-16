local parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("CurrencyTransferUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
