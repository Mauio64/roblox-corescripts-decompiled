local parent = script.Parent
local parent2 = parent.Parent

require(parent2.MessageBus)
require(parent.Enums.DeepLinkSource)
require(parent.Enums.SettingsRoute)

return nil
