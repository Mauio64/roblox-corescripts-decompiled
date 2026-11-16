local FFlagEditProfileImageRigTypeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageRigTypeOverride")
local FFlagAXSaveManagerOutsideAX = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXSaveManagerOutsideAX")

return game:DefineFastFlag("EditProfileImageR15UpgradePrompt", false) and FFlagEditProfileImageRigTypeOverride and FFlagAXSaveManagerOutsideAX
