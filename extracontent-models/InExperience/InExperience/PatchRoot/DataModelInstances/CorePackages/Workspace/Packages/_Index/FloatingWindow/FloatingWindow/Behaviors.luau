local BehaviorKind = require(script.Parent.BehaviorKind)
require(script.Parent.Types)

local frozen = table.freeze({ kind = BehaviorKind.Contained })

return table.freeze({ Contained = frozen })
