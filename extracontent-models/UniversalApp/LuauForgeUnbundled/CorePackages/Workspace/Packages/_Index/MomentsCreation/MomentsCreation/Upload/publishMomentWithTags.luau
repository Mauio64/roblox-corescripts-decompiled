require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCommon/isStudio")

local createMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/createMoment")
local getTagsForMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/getTagsForMoment")
local makeMomentMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeMomentMetadata")
local makeRegistrationInfo = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeRegistrationInfo")

local function publishMomentWithTags(p2, p3, p4, p5, p6, p7, callback): boolean
	if isStudio() then
		print(`[moments-creation] dev publish (not uploaded): "{p4}"`)
		return false
	end

	local v5 = makeMomentMetadata(p2, p4, p3, p6, p7)
	local v6 = makeRegistrationInfo(p2, v5, getTagsForMoment(v5))

	task.spawn(function()
		if not createMoment(p2, v5, v6, p5) and callback ~= nil then
			task.defer(function()
				callback()
			end)
		end
	end)
	return true
end

return publishMomentWithTags
