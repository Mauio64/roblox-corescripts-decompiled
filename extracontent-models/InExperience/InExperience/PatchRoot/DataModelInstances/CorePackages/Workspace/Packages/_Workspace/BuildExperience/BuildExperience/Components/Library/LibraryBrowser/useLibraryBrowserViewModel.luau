local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
local LibraryCategories = require(script.Parent.Parent.LibraryCategories)
require(script.Parent.LibraryBrowserView)
require(script.Parent.Parent.LibraryTypes)
local useLibraryStrings = require(script.Parent.Parent.useLibraryStrings)
local useLibraryItems = require(script.Parent.Parent.useLibraryItems)
local getFolderPreview = require(script.Parent.Parent.getFolderPreview)
require(script.Parent.Parent.LibraryWorldCutout.LibraryWorldCutoutView)

local function useCarousel(library, p, p2, query: string)
	local items, hasMore, v = useLibraryItems(library, p, p2, query, 6)
	return {
		items = items,
		hasMore = hasMore,
		onScrollChanged = React.useCallback(function(data)
			if
				data.AbsoluteWindowSize.X > 0
				and data.AbsoluteCanvasSize.X > 0
				and data.CanvasPosition.X + data.AbsoluteWindowSize.X >= data.AbsoluteCanvasSize.X - 192
			then
				v()
			end
		end, { v })
	}
end

local function useLibraryBrowserViewModel(data)
	local strings = useLibraryStrings()
	local v = SignalsReact.useSignalState(data.library.getItems)
	local query = data.query
	local v2 = {
		Model = useCarousel(data.library, v, "Model", query),
		Image = useCarousel(data.library, v, "Image", query),
		Sound = useCarousel(data.library, v, "Sound", query)
	}
	local v3 = {}

	for _, v4 in v2 do
		for _, item in v4.items do
			table.insert(v3, item)
		end
	end

	local status = data.isReady and "Ready" or "Loading"
	local categoryEntries = {}

	for _, v4 in LibraryCategories.fromItems(v3, strings) do
		local v5 = v2[v4.itemKind]
		local tileEntries = {}

		for _, item in v5.items do
			local v6 = item
			table.insert(tileEntries, {
				tileKey = `library-item-{item.id}`,
				itemId = item.id,
				itemKind = item.kind,
				isFolder = item.className == "Folder",
				folderPreview = getFolderPreview(item, v),
				displayName = item.displayName,
				unavailableText = strings.modelUnavailable,
				thumbnail = item.image,
				model = item.model,
				onActivated = (data.onOpenItem ~= nil or data.onOpenCategory ~= nil) and function()
					if v6.className == "Folder" then
						if data.onOpenCategory ~= nil then
							data.onOpenCategory(v6.kind, v6.id, v6.displayName, v6.id)
						end
					elseif data.onOpenItem ~= nil then
						data.onOpenItem(v6.id, v6.kind)
					end
				end or nil
			})
		end

		local fn = data.onOpenCategory ~= nil and function()
			data.onOpenCategory(v4.itemKind, v4.key, v4.title)
		end or nil
		table.insert(categoryEntries, {
			categoryKey = v4.key,
			itemKind = v4.itemKind,
			title = v4.title,
			items = tileEntries,
			status = status,
			hasMore = v5.hasMore,
			onScrollChanged = v5.onScrollChanged,
			onOpenCategory = fn
		})
	end

	return {
		categories = categoryEntries,
		status = status,
		strings = strings,
		worldCutout = data.worldCutout
	}
end

return useLibraryBrowserViewModel
