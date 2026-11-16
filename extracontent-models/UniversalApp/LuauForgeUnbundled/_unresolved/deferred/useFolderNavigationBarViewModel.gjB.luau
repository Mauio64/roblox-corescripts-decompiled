local module = require("@luauforge/deferred/gjp")
local module2 = require("@luauforge/deferred/gjr")
local useLocalization = require("@luauforge/deferred/gjC").Hooks.useLocalization
local useNavigation = require("@luauforge/deferred/gjD").useNavigation
local avatarScreen = require("@luauforge/deferred/gjE").Enums.AvatarScreen

require("@luauforge/deferred/gjz")
local useFoldersStore = require("@luauforge/deferred/gjo").useFoldersStore
local module3 = require("@luauforge/deferred/gjw")
local module4 = require("@luauforge/deferred/gjF")
local LoadingState = require("@game/CorePackages/Packages/_Index/MomentsCommon/MomentsCommon/Enums/LoadingState")
require("@luauforge/deferred/giX")

local function useFolderNavigationBarViewModel(p2)
	local v5 = useFoldersStore()
	local v6 = useNavigation()

	local v7 = module2.useSignalState(v5.getFolders)

	local v8 = module2.useSignalState(v5.getStatus)
	local v9 = module2.useSignalState(v5.getSelectedFolderId)

	local v10 = useLocalization({
		allLabel = "Feature.Avatar.Label.AllAvatarSets",
		createSetLabel = "Feature.Avatar.Action.CreateSetFirstRun"
	})

	local v11 = module.useMemo(function()
		return module3(v7)
	end, { v7 })

	local v12 = module.useCallback(function(p3): boolean
		return v11[p3] == true
	end, { v11 })

	local createFolder = v5.createFolder
	local setSelectedFolderId = v5.setSelectedFolderId

	local v13 = module.useCallback(function(p3)
		return createFolder(p3):andThen(function(p4)
			setSelectedFolderId(p4.id)
			return p4
		end)
	end, { createFolder, setSelectedFolderId })

	local v14 = #v7 >= module4.MAX_FOLDERS
	local v15 = module.useCallback(function()
		if v14 then
			v6.navigate(avatarScreen.FolderLimitReachedDialog)
		else
			v6.navigate(avatarScreen.CreateFolderDialog, {
				onSubmit = v13,
				checkIsDuplicateFolderName = v12
			})
		end
	end, { v6, v13, v12, v14 })

	local v16 = v8 == LoadingState.Success

	local v17 = v16 and #v7 == 0

	local v18 = {
		folders = v7,
		status = v8,
		selectedFolderId = v9,
		allLabel = v10.allLabel,
		clearSelection = v5.clearSelection,
		onSelectFolder = v5.setSelectedFolderId,
		onCreatePressed = 0,
		createLabel = 0,
		LayoutOrder = 0
	}

	if not v16 then
		v15 = nil
	end

	v18.onCreatePressed = v15
	local v19 = if v17 then v10.createSetLabel else nil
	v18.createLabel = v19
	v18.LayoutOrder = p2.LayoutOrder
	return v18
end

return useFolderNavigationBarViewModel
