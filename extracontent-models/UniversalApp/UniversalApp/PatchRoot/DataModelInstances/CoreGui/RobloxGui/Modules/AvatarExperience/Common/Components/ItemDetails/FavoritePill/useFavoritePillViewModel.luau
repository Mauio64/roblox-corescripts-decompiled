local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux
local useSelector = RoactRodux.useSelector
local useDispatch = RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local ItemType = require(Modules.AvatarExperience.Common.Constants).ItemType

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local GetAssetFavorite = require(Modules.AvatarExperience.Catalog.Thunks.GetAssetFavorite)
local SetAssetFavorite = require(Modules.AvatarExperience.Catalog.Thunks.SetAssetFavorite)
local GetBundleFavorite = require(Modules.AvatarExperience.Catalog.Thunks.GetBundleFavorite)
local SetBundleFavorite = require(Modules.AvatarExperience.Catalog.Thunks.SetBundleFavorite)
local SetLookFavorite = require(Modules.AvatarExperience.Catalog.Thunks.SetLookFavorite)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)

require(script.Parent.FavoritePillView)

local function selectIsFavorited(p1, s1: string, s2: string) -- line: 72
	-- upvalues: ItemType (copy)
	if s1 == ItemType.Asset then
		return p1.AvatarExperience.Catalog.AssetFavorites[s2]
	end

	if s1 == ItemType.Bundle then
		return p1.AvatarExperience.Catalog.BundleFavorites[s2]
	end

	if s1 == ItemType.Look then
		local v25 = p1.AvatarExperience.AvatarScene.Looks[s2]

		if v25 ~= nil then
			return v25.isFavorited
		end

		return nil
	end

	return nil
end
local function useFavoritePillViewModel(t1: {[any]: any}) -- line: 84
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactLocalization (copy), Analytics (copy), useLocalization (copy), useSelector (copy), ItemType (copy), React (copy), GetAssetFavorite (copy), GetBundleFavorite (copy), SetAssetFavorite (copy), SetBundleFavorite (copy), SetLookFavorite (copy), SetNetworkingErrorToast (copy), NumberLocalization (copy)
	local kind = t1.kind
	local itemId = t1.itemId
	local lookType = t1.lookType
	local favoritesCount = t1.favoritesCount
	local v31 = useDispatch()
	local v32 = useRoactService(RoactNetworking)
	local v33 = useRoactService(RoactLocalization)
	local v34 = useRoactService(Analytics)
	local v35 = useLocalization({
		favoritesLabel = "Feature.Catalog.Label.Favorites"
	})
	local v36 = useSelector(function(p2) -- line: 101
		-- upvalues: kind (copy), itemId (copy), ItemType (copy)
		local v49 = kind
		local v50 = itemId

		if v49 == ItemType.Asset then
			return p2.AvatarExperience.Catalog.AssetFavorites[v50]
		end

		if v49 == ItemType.Bundle then
			return p2.AvatarExperience.Catalog.BundleFavorites[v50]
		end

		if v49 == ItemType.Look then
			local v51 = p2.AvatarExperience.AvatarScene.Looks[v50]

			if v51 ~= nil then
				return v51.isFavorited
			end

			return nil
		end

		return nil
	end)
	local v37, v38 = React.useState(false)
	local v39, v40 = React.useState(false)
	local v41 = if not v37 then v36 else v39

	React.useEffect(function() -- line: 117
		-- upvalues: v36 (copy), kind (copy), ItemType (copy), v31 (copy), GetAssetFavorite (copy), itemId (copy), GetBundleFavorite (copy)
		if v36 ~= nil then
			return
		end

		if kind == ItemType.Asset then
			v31(GetAssetFavorite(itemId))

			return
		end

		if kind == ItemType.Bundle then
			v31(GetBundleFavorite(itemId))
		end
	end, {
		v31,
		v36,
		itemId,
		kind
	})

	local v42, v43 = React.useState(nil)

	React.useEffect(function() -- line: 140
		-- upvalues: v36 (copy), favoritesCount (copy), v43 (copy)
		if v36 == nil or favoritesCount == nil then
			return
		end

		v43(function(p3) -- line: 144
			-- upvalues: favoritesCount (copy), v36 (copy)
			if p3 ~= nil and p3.count == favoritesCount then
				return p3
			end

			return {
				favorited = v36,
				count = favoritesCount
			}
		end)
	end, {
		v36,
		favoritesCount
	})

	local v44 = favoritesCount

	if v42 ~= nil and v41 ~= nil then
		local v45 = if v41 ~= v42.favorited then not v41 and -1 or 1 else 0

		v44 = v42.count + v45
	end

	local v46 = React.useCallback(function() -- line: 159
		-- upvalues: v37 (copy), v36 (copy), v38 (copy), v40 (copy), kind (copy), ItemType (copy), lookType (copy), v34 (copy), itemId (copy), v31 (copy), SetAssetFavorite (copy), SetBundleFavorite (copy), SetLookFavorite (copy), v32 (copy), SetNetworkingErrorToast (copy)
		if v37 or v36 == nil then
			return
		end

		local v52 = not v36

		v38(true)
		v40(v52)

		local function finish() -- line: 172
			-- upvalues: v38 (copy)
			v38(false)
		end

		local v54 = if kind ~= ItemType.Look then kind else lookType or kind

		v34.clickFavoriteItemButton(itemId, v54, v52)

		local v55 = nil

		if kind == ItemType.Asset then
			v55 = v31(SetAssetFavorite(itemId, v52))
		elseif kind == ItemType.Bundle then
			v55 = v31(SetBundleFavorite(itemId, v52))
		elseif kind == ItemType.Look then
			v55 = v31(SetLookFavorite(v32, itemId, v52, lookType))
		end

		if v55 == nil then
			v38(false)

			return
		end

		v55:andThen(function() -- line: 193
			-- upvalues: v38 (copy)
			v38(false)
		end, function() -- line: 206
			-- upvalues: v38 (copy), kind (copy), ItemType (copy), v31 (copy), SetNetworkingErrorToast (copy)
			v38(false)

			if kind == ItemType.Look then
				v31(SetNetworkingErrorToast({
					HttpError = Enum.HttpError.OK
				}))
			end
		end)
	end, {
		v37,
		v36,
		kind,
		itemId,
		lookType,
		v31,
		v32,
		v34
	})
	local v47 = React.useCallback(function(n1: number) -- line: 218
		-- upvalues: NumberLocalization (copy), v33 (copy)
		return NumberLocalization.abbreviate(n1, v33:GetLocale())
	end, { v33 })

	return {
		favoritesCount = v44,
		isFavorited = v41,
		isDisabled = v37 or v41 == nil,
		onActivated = v46,
		favoritesLabel = v35.favoritesLabel,
		formatCount = v47,
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId
	}
end

return useFavoritePillViewModel
