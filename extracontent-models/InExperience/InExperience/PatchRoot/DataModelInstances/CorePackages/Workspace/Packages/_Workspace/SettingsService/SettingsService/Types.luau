local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParent.SettingEnum)
require(scriptParentParent.AppCommonLib)
require(scriptParentParent.Signals)

return nil
