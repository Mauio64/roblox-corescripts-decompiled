local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UserLib = require(ProfilePlatformParent.UserLib)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLazyFmod = require(ProfilePlatformParent.MediaPlayback).useLazyFmod
local VideoTile = require(ProfilePlatform.Components.Videos.VideoTile)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)
local Constants = require(ProfilePlatform.Common.Constants)
local NetworkingAsset = require(ProfilePlatform.Networking.NetworkingAsset)
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), useDispatch (copy), useLazyFmod (copy), useSelector (copy), Constants (copy), React (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants2 (copy), NetworkingAsset (copy), VideoTile (copy)
	local v17 = useProfileJsonComponent(Enums.Components.Videos)
	local v18 = useDispatch()

	useLazyFmod()

	local t2 = {}

	if v17 and (v17.assetIds and #v17.assetIds > 0) then
		t2 = v17.assetIds
	end

	local v20 = useSelector(function(p1) -- line: 45
		-- upvalues: Constants (copy)
		return p1[Constants.RODUX_KEY].AssetData or {}
	end)
	local v21 = React.useMemo(function() -- line: 49
		-- upvalues: t2 (ref), v20 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants2 (copy)
		local t3 = {}

		for _, v25 in t2 do
			local v26 = v20[tostring(v25)]

			if v26 then
				table.insert(t3, {
					videoId = "rbxassetid://" .. tostring(v25),
					title = v26.displayName or "",
					thumbnailImage = getRbxthumbWithTypeSizeAndOptions(tostring(v25), Constants2.RbxthumbTypes.Asset, 150)
				})
			end
		end

		return t3
	end, {
		t2,
		v20
	})

	React.useEffect(function() -- line: 69
		-- upvalues: t2 (ref), v20 (copy), v18 (copy), NetworkingAsset (copy)
		for _, v28 in t2 do
			if not v20[tostring(v28)] then
				v18(NetworkingAsset.GetAssetDetails.API((tostring(v28)))):catch(function() -- line: 72
				end)
			end
		end
	end, {
		t2,
		v20
	})

	if #v21 == 0 then
		return React.None
	end

	return React.createElement(VideoTile, {
		layoutOrder = t1.layoutOrder,
		videos = v21
	})
end
