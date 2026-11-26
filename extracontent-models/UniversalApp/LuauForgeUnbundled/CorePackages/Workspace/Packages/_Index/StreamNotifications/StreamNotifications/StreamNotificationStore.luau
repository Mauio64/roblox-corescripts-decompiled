local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Signals")

local signal, v5 = Signals.createSignal(false)

local signal2, v6 = Signals.createSignal(nil)

local function isBellActive(p2, p3, p4, p5, p6): boolean
	if not p2 or p6 == false then
		return false
	end

	if p3 == "StreamNotificationPrimaryBell" then
		return p5 == true
	end

	if p3 == p4 then
		return true
	end

	return p3 == nil and p5 == true
end

return {
	setStreamPresented = v5,
	getStreamPresented = signal,
	getActiveBellId = signal2,
	setActiveBellId = v6,
	PrimaryBellId = "StreamNotificationPrimaryBell",
	isBellActive = isBellActive
}
