local parent = script:FindFirstAncestor("Moments").Parent

local SharedFlags = require(parent.SharedFlags)

return game:DefineFastFlag("MomentsCommentsAttachSheetScroller", false) and SharedFlags.FFlagMomentsComments
