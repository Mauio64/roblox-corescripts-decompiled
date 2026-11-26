local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

require("@luauforge/bundled/dTa")

local signal, v5 = Signals.createSignal(nil)

local count = 0

local function publishActiveStore(p2)
	count += 1
	v5(p2)
	return count
end

local function releaseActiveStore(p2)
	if count == p2 then
		v5(nil)
	end
end

local function setActiveStoreRef(p2)
	count += 1
	v5(p2)
end

return {
	activeStoreRef = signal,
	setActiveStoreRef = setActiveStoreRef,
	publishActiveStore = publishActiveStore,
	releaseActiveStore = releaseActiveStore
}
