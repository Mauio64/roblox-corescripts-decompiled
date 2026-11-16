local isPioneerLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheetUtils/PioneerUtils").isPioneerLaunch

return game:DefineFastFlag("EnableSideSheet8", false) or isPioneerLaunch()
