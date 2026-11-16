local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Cryo")

local EditProfileImageAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Analytics/EditProfileImageAnalytics")

local AvatarEditorService = game:GetService("AvatarEditorService")

local function getEmoteLabel(p2)
	local name = p2.Name or p2.name

	if typeof(name) == "string" and name ~= "" then
		return name
	end

	return ""
end

local function getCurrentPageItems(object)
	local currentPageItems = {}

	for k, v5 in object:GetCurrentPage() do
		local v6 = { id = tostring(v5.AssetId), label = 0 }
		local name = v5.Name or v5.name
		v6.label = (typeof(name) ~= "string" or name == "") and "" or name
		table.insert(currentPageItems, v6)
	end

	return currentPageItems
end

local function useOwnedEmotes()
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(0)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	local v5 = React.useCallback(function(p2, value)
		setState(function(items)
			for k, item in items do
				if item.id == p2 then
					return items
				end
			end

			return Cryo.List.join({
				{
					id = p2,
					label = value or ""
				}
			}, items)
		end)
	end, {})

	local v6 = React.useCallback(function()
		ref.current = nil
		ref2.current = false
		setState2(true)
		setState3(false)
		setState4(false)
		setState5(false)
		setState6(false)
		setState7(function(p2)
			return p2 + 1
		end)
	end, {})

	local v7 = React.useCallback(function()
		local current = ref.current

		if current == nil or current.IsFinished or ref2.current then
			return
		end

		ref2.current = true
		setState5(true)
		setState6(false)
		task.spawn(function()
			local success, result = pcall(function()
				current:AdvanceToNextPageAsync()
				return getCurrentPageItems(current)
			end)

			ref2.current = false
			setState5(false)

			if not success then
				setState6(true)

				return
			end

			setState(function(p2)
				return Cryo.List.join(p2, result)
			end)

			setState4(not current.IsFinished)
		end)
	end, {})

	React.useEffect(function()
		local flag = false
		ref.current = nil
		ref2.current = false
		setState5(false)
		setState6(false)

		task.spawn(function()
			local success, result = pcall(function()
				local inventoryAsync = AvatarEditorService:GetInventoryAsync({ Enum.AvatarAssetType.EmoteAnimation })
				return {
					items = getCurrentPageItems(inventoryAsync),
					pageObject = inventoryAsync
				}
			end)

			if flag then
				return
			end

			if success then
				ref.current = result.pageObject
				setState(result.items)
				setState4(not result.pageObject.IsFinished)
			else
				EditProfileImageAnalytics.logFetchFailure({ assetType = "emotes" })

				setState3(true)
				setState4(false)
			end

			setState2(false)
		end)

		return function()
			flag = true
		end
	end, { state7 })

	return {
		emoteItems = state,
		isLoading = state2,
		hasError = state3,
		refetch = v6,
		onMoreEmotes = v7,
		hasMoreEmotes = state4,
		isLoadingMoreEmotes = state5,
		hasLoadMoreError = state6,
		markEmoteOwned = v5
	}
end

return useOwnedEmotes
