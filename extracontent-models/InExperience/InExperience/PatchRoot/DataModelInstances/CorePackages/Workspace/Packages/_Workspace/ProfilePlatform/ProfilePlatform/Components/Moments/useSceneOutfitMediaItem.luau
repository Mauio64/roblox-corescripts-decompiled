local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.MomentsCommon)
require(parent.DataHydration.MomentsStoreTypes)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)
local UserLib = require(parent.UserLib)

local readSceneOutfitIdFromPost = require(script.Parent.readSceneOutfitIdFromPost)

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local RbxthumbTypes = UserLib.Utils.Constants.RbxthumbTypes

local signal = Signals.createSignal(nil)

local function useSceneOutfitMediaItem(p, mediaItem)
	local isMomentScene = p.metadata.isMomentScene == true
	local v = (not isMomentScene or p.postAsset == nil) and 0 or p.postAsset.postAssetId
	local useSignalState = SignalsReact.useSignalState
	local v2

	if v > 0 then
		v2 = MomentsGetPostAssetStore(false).getAndFetchPostAsset(v).data
	else
		v2 = signal
	end

	local v3 = useSignalState(v2)

	local scenePoster = React.useMemo(function()
		local v4

		if v3 ~= nil then
			v4 = readSceneOutfitIdFromPost(v3)
		end

		if v4 == nil then
			return nil
		end

		return Content.fromUri(getRbxthumbWithTypeSizeAndOptions(tostring(v4), RbxthumbTypes.Outfit, 420))
	end, { v3 })

	if not isMomentScene then
		return { mediaItem = mediaItem, scenePoster = nil }
	end

	local clone = table.clone(mediaItem)
	clone.captureType = Enum.CaptureType.Screenshot
	clone.posterContent = nil
	return { mediaItem = clone, scenePoster = scenePoster }
end

return useSceneOutfitMediaItem
