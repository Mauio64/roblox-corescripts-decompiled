local FFlagEditProfileImageRigTypeOverride = require(script.Parent.FFlagEditProfileImageRigTypeOverride)
local FFlagAXSaveManagerOutsideAX = require(script.Parent.FFlagAXSaveManagerOutsideAX)

return game:DefineFastFlag("EditProfileImageR15UpgradePrompt", false)
	and FFlagEditProfileImageRigTypeOverride
	and FFlagAXSaveManagerOutsideAX
