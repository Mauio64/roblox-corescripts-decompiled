local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsGetPostAssetStore")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")

local readSceneOutfitIdFromPost = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/readSceneOutfitIdFromPost")

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local rbxthumbTypes = UserLib.Utils.Constants.RbxthumbTypes

local signal = Signals.createSignal(nil)

local function useSceneOutfitMediaItem(p2, p3)
	local isMomentScene = p2.metadata.isMomentScene == true
	local v5 = (not isMomentScene or p2.postAsset == nil) and 0 or p2.postAsset.postAssetId
	local useSignalState = SignalsReact.useSignalState
	local v6 = if v5 > 0 then MomentsGetPostAssetStore(false).getAndFetchPostAsset(v5).data else signal
	local v7 = useSignalState(v6)

	local v8 = React.useMemo(function()
		local v9 = if v7 ~= nil then readSceneOutfitIdFromPost(v7) else nil

		if v9 == nil then
			return nil
		end

		return Content.fromUri(getRbxthumbWithTypeSizeAndOptions(tostring(v9), rbxthumbTypes.Outfit, 420))
	end, { v7 })

	if not isMomentScene then
		return { mediaItem = p3, scenePoster = nil }
	end

	local clone = table.clone(p3)
	clone.captureType = Enum.CaptureType.Screenshot
	clone.posterContent = nil
	return { mediaItem = clone, scenePoster = v8 }
end

return useSceneOutfitMediaItem
