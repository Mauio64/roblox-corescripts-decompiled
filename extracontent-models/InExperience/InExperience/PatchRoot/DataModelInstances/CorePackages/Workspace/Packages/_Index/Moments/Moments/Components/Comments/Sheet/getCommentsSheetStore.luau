local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Signals = require(parent.Signals)
local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)

local GetCommentCollectionStore = require(Moments.Components.Comments.GetCommentCollectionStore)
local createCommentsSheetStore = require(script.Parent.createCommentsSheetStore)

local momentsGetMomentsCommentsStore = MomentsGetMomentsCommentsStore(false)
local commentCollectionStore = GetCommentCollectionStore(false)
local v = momentsGetMomentsCommentsStore.getOwnerGeneration(false)

local v2 = { store = createCommentsSheetStore(), stopObservingOwner = nil }

v2.stopObservingOwner = Signals.createEffect(function(p)
	local ownerGeneration = momentsGetMomentsCommentsStore.getOwnerGeneration(p)

	if ownerGeneration == v then
		return
	end

	v = ownerGeneration
	v2.store.reset()
	commentCollectionStore.clear()
end)

return Signals.createComputed(function(_)
	return v2.store
end)
