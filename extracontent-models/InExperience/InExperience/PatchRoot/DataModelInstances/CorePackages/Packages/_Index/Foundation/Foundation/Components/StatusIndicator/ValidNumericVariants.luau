local Foundation = script:FindFirstAncestor("Foundation")

local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)

return { [StatusIndicatorVariant.Emphasis] = true, [StatusIndicatorVariant.Standard] = true }
