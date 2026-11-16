local module = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/BehaviorKind")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Behaviors")
require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Types")
return { BehaviorKind = module, Behaviors = module2, Window = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Window") }
