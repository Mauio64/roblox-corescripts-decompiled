local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking

local module3 = require("@luauforge/deferred/gOP")
local module4 = require("@luauforge/bundled/dOo")
local module5 = require("@luauforge/bundled/dxy")

local v5 = module4()

local searchUuid = v5.SearchUuid

local function selectEmotes(p2)
	local ownedItemId = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[searchUuid]

	if not ownedItemId then
		return {}
	end

	local assetInfos = p2.AvatarExperience.Common.AssetInfos
	local result = {}

	for k, v6 in ownedItemId do
		local assetInfo = assetInfos[v6]

		if assetInfo and assetInfo.name then
			table.insert(result, { assetId = v6, name = assetInfo.name })
		end
	end

	return result
end

local function selectHasMore(p2): boolean
	return not p2.AvatarExperience.AvatarEditor.PageFinished[searchUuid]
end

local function usePhotoboothMomentsEmotes()
	local v6 = useDispatch()
	local v7 = useStore()
	local v8 = useNetworking()

	return {
		emotes = useSelector(selectEmotes, getUseSelectorDeepEquals()),
		hasMore = useSelector(selectHasMore),
		loadMore = React.useCallback(function()
			local state = v7:getState()

			if
				state.AvatarExperience.AvatarEditor.PageFinished[searchUuid]
				or performFetch.GetStatus(state, searchUuid) == module5.Fetching
			then
				return
			end

			v6(module3(v8, v5, searchUuid))
		end, { v7, v6, v8 })
	}
end

return usePhotoboothMomentsEmotes
