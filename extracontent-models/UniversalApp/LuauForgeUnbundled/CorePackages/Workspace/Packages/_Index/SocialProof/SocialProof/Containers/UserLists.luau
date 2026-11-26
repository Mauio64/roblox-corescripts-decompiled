local module = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Containers/UserLists/FriendsOwnedUserList")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Containers/UserLists/SocialProofVerticalUserListSheet")

if not require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagEnableSocialProofVerticalUserListSheet then
	module2 = nil
end

return { FriendsOwnedUserList = module, SocialProofVerticalUserListSheet = module2 }
