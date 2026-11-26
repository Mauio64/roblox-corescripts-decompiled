local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

require("@luauforge/deferred/gOE")
local module = require("@luauforge/bundled/dXh")

local module2 = require("@luauforge/deferred/gNB")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local useFoldersStore = module2.Hooks.useFoldersStore
local loadStatus = module2.Enums.LoadStatus

local function useSelectFolderMenuProps()
	local v5 = useNavigation()
	local v6 = useFoldersStore()

	local v7 = SignalsReact.useSignalState(v6.getFolders)
	local v8 = SignalsReact.useSignalState(v6.getStatus)

	local loadFolders = v6.loadFolders
	React.useEffect(function()
		loadFolders()
	end, { loadFolders })

	local v9 = v5.getParam("outfitIds") or {}

	local v10 = React.useMemo(function()
		local result = {}

		for k, v11 in v9 do
			local v12 = tonumber(v11)

			if v12 ~= nil then
				table.insert(result, v12)
			end
		end

		return result
	end, { v9 })

	local v11 = {
		title = "Feature.Avatar.Title.SelectSet",
		loading = "Feature.Avatar.Label.LoadingSets",
		empty = "Feature.Avatar.Label.NoSets"
	}

	for k, v12 in v7 do
		v11[v12.id] = {
			"Feature.Avatar.Label.SetAvatarCount",
			itemCount = #v12.itemIds
		}
	end

	local v12 = useLocalization(v11)

	local v13 = React.useCallback(function()
		module.closeOverlay(v5)
	end, { v5 })

	local v14 = React.useCallback(function()
		v5.navigate(avatarScreen.FolderItemsErrorDialog)
	end, { v5 })

	local addItemsToFolder = v6.addItemsToFolder
	local v15 = React.useMemo(function()
		local result = {}

		for k, v16 in v7 do
			local v17 = true

			for k2, v19 in v9 do
				local v20 = tonumber(v19)

				if v20 == nil or table.find(v16.itemIds, v20) == nil then
					v17 = false
					break
				end
			end

			local id = v16.id
			table.insert(result, {
				id = id,
				name = v16.name,
				itemCountText = v12[id],
				isDisabled = v17,
				onAdd = function()
					v13()
					addItemsToFolder(id, v10):catch(v14)
				end
			})
		end

		return result
	end, { v7, v9, v10, v12, addItemsToFolder, v13, v14 })

	return {
		titleText = v12.title,
		loadingText = v12.loading,
		emptyText = v12.empty,
		isLoading = #v7 == 0 and v8 ~= loadStatus.Success and v8 ~= loadStatus.Failed,
		folders = v15,
		onClose = v13
	}
end

return useSelectFolderMenuProps
