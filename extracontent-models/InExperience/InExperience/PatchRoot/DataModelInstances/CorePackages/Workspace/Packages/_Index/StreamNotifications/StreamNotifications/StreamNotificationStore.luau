local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local Signals = require(Parent.Signals)
local v3, v4 = Signals.createSignal(false)
local v5, v6 = Signals.createSignal(nil)

return {
	PrimaryBellId = "StreamNotificationPrimaryBell",
	setStreamPresented = v4,
	getStreamPresented = v3,
	getActiveBellId = v5,
	setActiveBellId = v6,
	isBellActive = function(b1: boolean, s1: string?, s2: string?, b2: boolean?, b3: boolean?) -- line: 26
		if not b1 or b3 == false then
			return false
		end

		if s1 == "StreamNotificationPrimaryBell" then
			return b2 == true
		end

		if s1 == s2 then
			return true
		end

		return s1 == nil and b2 == true
	end
}
