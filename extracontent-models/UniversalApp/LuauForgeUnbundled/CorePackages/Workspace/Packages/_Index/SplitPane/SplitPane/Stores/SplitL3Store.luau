local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")

local function createSplitL3Store()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(nil)
	local signal3, v7 = Signals.createSignal(0)
	local signal4, v8 = Signals.createSignal(nil)

	return {
		getPendingSplitSubPaneTag = signal,
		setPendingSplitSubPaneTag = v5,
		getPendingSplitSubPaneDetail = signal2,
		setPendingSplitSubPaneDetail = v6,
		getSplitL2SessionVersion = signal3,
		setSplitL2SessionVersion = v7,
		getSplitL3AppliedDetail = signal4,
		setSplitL3AppliedDetail = v8
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
