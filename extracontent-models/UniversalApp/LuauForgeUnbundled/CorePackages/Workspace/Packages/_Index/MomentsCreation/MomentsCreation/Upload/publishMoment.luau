require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local isAvatarMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/isAvatarMoment")
local makeMomentMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeMomentMetadata")
local makeRegistrationInfo = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeRegistrationInfo")
local createMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/createMoment")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts

local function publishMoment(p2, p3, p4, p5, p6, p7)
	if fFlagMomentsCreateAvatarPosts and isAvatarMoment(p2) then
		return require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/createAvatarMoment")(p2, p3, p4, p5, p7)
	end

	local v5 = makeMomentMetadata(p2, p4, p3, p6, p7)
	createMoment(p2, v5, makeRegistrationInfo(p2, v5), p5)
	return nil
end

return publishMoment
