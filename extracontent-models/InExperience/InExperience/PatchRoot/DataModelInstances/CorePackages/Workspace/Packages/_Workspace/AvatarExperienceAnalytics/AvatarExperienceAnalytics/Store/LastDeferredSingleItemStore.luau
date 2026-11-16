local snapshot = nil
local LastDeferredSingleItemStore = {}

function LastDeferredSingleItemStore.setSnapshot(p)
	snapshot = p
end

function LastDeferredSingleItemStore.getSnapshot()
	return snapshot
end

function LastDeferredSingleItemStore.clearSnapshot()
	snapshot = nil
end

return LastDeferredSingleItemStore
