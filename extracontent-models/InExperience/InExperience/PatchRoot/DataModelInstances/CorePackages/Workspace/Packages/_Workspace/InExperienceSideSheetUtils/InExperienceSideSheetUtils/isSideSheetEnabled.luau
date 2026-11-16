local parent = script:FindFirstAncestor("InExperienceSideSheetUtils").Parent

local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

return game:DefineFastFlag("EnableSideSheet8", false) or isPioneerLaunch()
