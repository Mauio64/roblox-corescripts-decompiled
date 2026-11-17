local createAvatarSceneStage = require(script.Parent.createAvatarSceneStage)

local avatarSceneStage = nil

local function getAvatarSceneStage()
	if avatarSceneStage == nil then
		avatarSceneStage = createAvatarSceneStage()
	end

	return avatarSceneStage
end

return getAvatarSceneStage
