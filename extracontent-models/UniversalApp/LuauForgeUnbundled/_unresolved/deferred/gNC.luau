local module = require("@luauforge/deferred/gND")

return {
	Api = {
		getFolders = require("@luauforge/deferred/gNG"),
		createFolder = require("@luauforge/deferred/gNM"),
		renameFolder = require("@luauforge/deferred/gNN"),
		deleteFolder = require("@luauforge/deferred/gNO"),
		addAvatarItemsToFolder = require("@luauforge/deferred/gNP"),
		removeAvatarItemsFromFolder = require("@luauforge/deferred/gNQ")
	},
	Stores = { createFoldersStore = require("@luauforge/deferred/gNR") },
	Context = { FoldersStoreContext = require("@luauforge/deferred/gNU") },
	Hooks = {
		useFoldersStore = require("@luauforge/deferred/gNU").useFoldersStore,
		useFolderItemIdsFilter = require("@luauforge/deferred/gNW"),
		useRefreshFolders = require("@luauforge/deferred/gOa"),
		useFolderSettingsActions = require("@luauforge/deferred/gOb"),
		useReconcileDeletedOutfits = require("@luauforge/deferred/gOd")
	},
	Components = { FolderNavigationBar = require("@luauforge/deferred/gOe") },
	Utils = {
		isFolderNameValid = require("@luauforge/deferred/gOm"),
		mapFolderMutationError = require("@luauforge/deferred/gOo")
	},
	Enums = {
		LoadStatus = require("@game/CorePackages/Packages/_Index/MomentsCommon/MomentsCommon/Enums/LoadingState"),
		FolderErrorReason = require("@luauforge/deferred/gNF")
	},
	Constants = require("@luauforge/deferred/gOl"),
	Types = module
}
