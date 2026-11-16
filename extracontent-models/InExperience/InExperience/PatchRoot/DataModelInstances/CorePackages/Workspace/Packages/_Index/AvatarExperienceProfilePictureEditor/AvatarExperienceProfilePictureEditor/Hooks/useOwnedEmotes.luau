local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local EditProfileImageAnalytics = require(AvatarExperienceProfilePictureEditor.Analytics.EditProfileImageAnalytics)

local AvatarEditorService = game:GetService("AvatarEditorService")

local function getEmoteLabel(p) -- 1 equivalent call inferred from this helper
	local name = p.Name or p.name
	return if typeof(name) == "string" and name ~= "" then name else ""
end

local function getCurrentPageItems(object)
	local currentPageItems = {}

	for _, v in object:GetCurrentPage() do
		local v2 = { id = tostring(v.AssetId), label = getEmoteLabel(v) } -- inferred equivalent call
		table.insert(currentPageItems, v2)
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

	local markEmoteOwned = React.useCallback(function(id: string, value: string?)
		setState(function(items)
			for _, item in items do
				if item.id == id then
					return items
				end
			end

			return Cryo.List.join({
				{
					id = id,
					label = value or ""
				}
			}, items)
		end)
	end, {})

	local refetch = React.useCallback(function()
		ref.current = nil
		ref2.current = false
		setState2(true)
		setState3(false)
		setState4(false)
		setState5(false)
		setState6(false)
		setState7(function(p)
			return p + 1
		end)
	end, {})

	local onMoreEmotes = React.useCallback(function()
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

			setState(function(p)
				return Cryo.List.join(p, result)
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
		refetch = refetch,
		onMoreEmotes = onMoreEmotes,
		hasMoreEmotes = state4,
		isLoadingMoreEmotes = state5,
		hasLoadMoreError = state6,
		markEmoteOwned = markEmoteOwned
	}
end

return useOwnedEmotes
