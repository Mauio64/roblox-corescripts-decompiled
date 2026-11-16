local parent = script:FindFirstAncestor("StreamNotifications").Parent
local Signals = require(parent.Signals)

local signal, setStreamPresented = Signals.createSignal(false)

local signal2, setActiveBellId = Signals.createSignal(nil)

local function isBellActive(flag: boolean, p: string?, p2: string?, flag2: boolean?, flag3: boolean?): boolean
	if not flag or flag3 == false then
		return false
	end

	if p == "StreamNotificationPrimaryBell" then
		return flag2 == true
	end

	return p == p2 or p == nil and flag2 == true
end

return {
	setStreamPresented = setStreamPresented,
	getStreamPresented = signal,
	getActiveBellId = signal2,
	setActiveBellId = setActiveBellId,
	PrimaryBellId = "StreamNotificationPrimaryBell",
	isBellActive = isBellActive
}
