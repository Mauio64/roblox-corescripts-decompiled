local ProfileCustomizationNetworking = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/ProfileCustomizationNetworking")
local ProfileRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Networking/ProfileRoduxNetworking")

return (ProfileCustomizationNetworking.config({ roduxNetworking = ProfileRoduxNetworking }))
