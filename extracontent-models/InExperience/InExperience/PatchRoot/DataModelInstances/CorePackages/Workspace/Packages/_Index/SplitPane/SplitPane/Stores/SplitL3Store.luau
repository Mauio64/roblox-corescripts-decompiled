local parent = script:FindFirstAncestor("SplitPane").Parent

local Signals = require(parent.Signals)

local function createSplitL3Store()
	local signal, setPendingSplitSubPaneTag = Signals.createSignal(nil)
	local signal2, setPendingSplitSubPaneDetail = Signals.createSignal(nil)
	local signal3, setSplitL2SessionVersion = Signals.createSignal(0)
	local signal4, setSplitL3AppliedDetail = Signals.createSignal(nil)

	return {
		getPendingSplitSubPaneTag = signal,
		setPendingSplitSubPaneTag = setPendingSplitSubPaneTag,
		getPendingSplitSubPaneDetail = signal2,
		setPendingSplitSubPaneDetail = setPendingSplitSubPaneDetail,
		getSplitL2SessionVersion = signal3,
		setSplitL2SessionVersion = setSplitL2SessionVersion,
		getSplitL3AppliedDetail = signal4,
		setSplitL3AppliedDetail = setSplitL3AppliedDetail
	}
end

local store = nil
return {
	getStore = function()
		if store == nil then
			store = createSplitL3Store()
		end

		return store
	end
}
