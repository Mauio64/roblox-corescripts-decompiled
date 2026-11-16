local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.LibraryCategories)
require(script.Parent.LibraryCategoryView)
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
require(script.Parent.Parent.LibraryTypes)
local useLibraryStrings = require(script.Parent.Parent.useLibraryStrings)
local useLibraryItems = require(script.Parent.Parent.useLibraryItems)
local getFolderPreview = require(script.Parent.Parent.getFolderPreview)

local function useLibraryCategoryViewModel(data)
	local v = useLibraryStrings()
	local v2 = SignalsReact.useSignalState(data.library.getItems)
	local v3, v4, onLoadMore = useLibraryItems(
		data.library,
		v2,
		data.itemKind,
		data.query,
		24,
		data.categoryKey,
		data.folderId
	)

	local tileEntries = {}

	for _, v5 in v3 do
		table.insert(tileEntries, {
			tileKey = `library-item-{v5.id}`,
			itemId = v5.id,
			itemKind = v5.kind,
			isFolder = v5.className == "Folder",
			folderPreview = getFolderPreview(v5, v2),
			displayName = v5.displayName,
			unavailableText = v.modelUnavailable,
			thumbnail = v5.image,
			model = v5.model,
			onActivated = function()
				if v5.className == "Folder" then
					if data.onOpenCategory ~= nil then
						data.onOpenCategory(v5.kind, v5.id, v5.displayName, v5.id)
					end
				else
					data.onOpenItem(v5.id, v5.kind)
				end
			end
		})
	end

	local v5 = {
		items = tileEntries,
		status = data.isReady and "Ready" or "Loading",
		hasMore = data.isReady and v4,
		strings = 0,
		onLoadMore = 0
	}

	local empty = if data.query == "" then v.empty else v.searchEmpty
	v5.strings = { empty = empty }

	v5.onLoadMore = onLoadMore
	return v5
end

return useLibraryCategoryViewModel
