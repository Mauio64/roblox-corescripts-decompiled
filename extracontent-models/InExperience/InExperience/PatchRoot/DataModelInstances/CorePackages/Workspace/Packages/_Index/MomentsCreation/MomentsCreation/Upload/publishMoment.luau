local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)

local isAvatarMoment = require(MomentsCreation.Utils.isAvatarMoment)
local makeMomentMetadata = require(MomentsCreation.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreation.Utils.makeRegistrationInfo)
local createMoment = require(MomentsCreation.Upload.createMoment)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local function publishMoment(p, p2, p3: string, p4: string?, p5: number?, flag: boolean?)
	if FFlagMomentsCreateAvatarPosts and isAvatarMoment(p) then
		local createAvatarMoment = require(MomentsCreation.Upload.createAvatarMoment)
		return createAvatarMoment(p, p2, p3, p4, flag)
	end

	local momentMetadata = makeMomentMetadata(p, p3, p2, p5, flag)
	createMoment(p, momentMetadata, makeRegistrationInfo(p, momentMetadata), p4)
	return nil
end

return publishMoment
