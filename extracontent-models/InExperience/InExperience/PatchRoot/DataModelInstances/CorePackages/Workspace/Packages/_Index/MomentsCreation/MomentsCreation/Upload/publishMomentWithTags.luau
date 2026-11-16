local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)
local isStudio = require(parent.MomentsCommon.isStudio)

local createMoment = require(MomentsCreation.Upload.createMoment)
local getTagsForMoment = require(MomentsCreation.Utils.getTagsForMoment)
local makeMomentMetadata = require(MomentsCreation.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreation.Utils.makeRegistrationInfo)

local function publishMomentWithTags(p, p2, p3: string, p4: string?, p5: number?, flag: boolean?, callback): boolean
	if isStudio() then
		print(`[moments-creation] dev publish (not uploaded): "{p3}"`)
		return false
	end

	local momentMetadata = makeMomentMetadata(p, p3, p2, p5, flag)
	local registrationInfo = makeRegistrationInfo(p, momentMetadata, getTagsForMoment(momentMetadata))

	task.spawn(function()
		if not createMoment(p, momentMetadata, registrationInfo, p4) and callback ~= nil then
			task.defer(function()
				callback()
			end)
		end
	end)
	return true
end

return publishMomentWithTags
