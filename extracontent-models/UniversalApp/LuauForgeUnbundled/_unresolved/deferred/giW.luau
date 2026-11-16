local module = require("@luauforge/deferred/giX")

return {
	Api = {
		getFolders = require("@luauforge/deferred/gja"),
		createFolder = require("@luauforge/deferred/gjg"),
		renameFolder = require("@luauforge/deferred/gjh"),
		deleteFolder = require("@luauforge/deferred/gji"),
		addAvatarItemsToFolder = require("@luauforge/deferred/gjj"),
		removeAvatarItemsFromFolder = require("@luauforge/deferred/gjk")
	},
	Stores = { createFoldersStore = require("@luauforge/deferred/gjl") },
	Context = { FoldersStoreContext = require("@luauforge/deferred/gjo") },
	Hooks = {
		useFoldersStore = require("@luauforge/deferred/gjo").useFoldersStore,
		useFolderItemIdsFilter = require("@luauforge/deferred/gjq"),
		useRefreshFolders = require("@luauforge/deferred/gju"),
		useFolderSettingsActions = require("@luauforge/deferred/gjv"),
		useReconcileDeletedOutfits = require("@luauforge/deferred/gjx")
	},
	Components = { FolderNavigationBar = require("@luauforge/deferred/gjy") },
	Utils = {
		isFolderNameValid = require("@luauforge/deferred/gjG"),
		mapFolderMutationError = require("@luauforge/deferred/gjI")
	},
	Enums = {
		LoadStatus = require("@game/CorePackages/Packages/_Index/MomentsCommon/MomentsCommon/Enums/LoadingState"),
		FolderErrorReason = require("@luauforge/deferred/giZ")
	},
	Constants = require("@luauforge/deferred/gjF"),
	Types = module
}
