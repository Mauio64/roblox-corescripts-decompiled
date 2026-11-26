return {
	Context = {
		AvatarSaveContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext"),
		AvatarSaveContextProvider = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContextProvider"),
		useAvatarSaveContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/useAvatarSaveContext")
	},
	Components = { SaveButton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/SaveButton/SaveButtonContainer") },
	Selectors = { selectCharacterData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Selectors/selectCharacterData") },
	Enums = { SaveStatusEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Enums/SaveStatusEnum") }
}
