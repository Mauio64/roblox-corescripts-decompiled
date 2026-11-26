local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")

local GetCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore")
local createCommentsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/createCommentsSheetStore")

local v5 = MomentsGetMomentsCommentsStore(false)
local v6 = GetCommentCollectionStore(false)
local v7 = v5.getOwnerGeneration(false)

local v8 = { store = createCommentsSheetStore(), stopObservingOwner = nil }

v8.stopObservingOwner = Signals.createEffect(function(p2)
	local ownerGeneration = v5.getOwnerGeneration(p2)

	if ownerGeneration == v7 then
		return
	end

	v7 = ownerGeneration
	v8.store.reset()
	v6.clear()
end)

return Signals.createComputed(function(p2)
	return v8.store
end)
