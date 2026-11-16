local BehaviorKind = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/BehaviorKind")
require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Types")

local frozen = table.freeze({ kind = BehaviorKind.Contained })

return table.freeze({ Contained = frozen })
