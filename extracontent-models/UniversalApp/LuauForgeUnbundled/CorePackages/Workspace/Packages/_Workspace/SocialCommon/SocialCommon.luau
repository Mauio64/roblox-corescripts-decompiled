local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Enums")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Actions")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/CarouselUserTile/CarouselUserTile")

return {
	Actions = module2,
	Components = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components"),
	Enums = module,
	Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils"),
	Hooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Hooks")
}
