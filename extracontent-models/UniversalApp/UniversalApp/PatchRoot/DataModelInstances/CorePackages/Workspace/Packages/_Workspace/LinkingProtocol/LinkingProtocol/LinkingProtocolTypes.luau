local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.MessageBus)
require(scriptParent.Enums.SettingsRoute)

return nil
