local CorePackages = game:GetService("CorePackages")

local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

return game:DefineFastFlag("RemoveExitModal", false) or isPioneerLaunch()
