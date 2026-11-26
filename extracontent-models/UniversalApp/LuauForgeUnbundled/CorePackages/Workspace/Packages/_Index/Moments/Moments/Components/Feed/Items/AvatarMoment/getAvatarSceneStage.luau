local createAvatarSceneStage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/createAvatarSceneStage")

local avatarSceneStage = nil

local function getAvatarSceneStage()
	if avatarSceneStage == nil then
		avatarSceneStage = createAvatarSceneStage()
	end

	return avatarSceneStage
end

return getAvatarSceneStage
