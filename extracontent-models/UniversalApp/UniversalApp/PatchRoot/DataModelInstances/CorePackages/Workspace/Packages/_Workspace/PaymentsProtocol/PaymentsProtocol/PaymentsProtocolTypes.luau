local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParent.Enums.IAPEventType)
require(scriptParent.Enums.ProductType)
require(scriptParentParent.LuauPolyfill)

return nil
