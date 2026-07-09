local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local EventStreamActionList = require(ProfileQRCode.Analytics.EventStreamActionList)
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local Dash = require(ProfileQRCodeParent.Dash)

return function(p1, p2) -- line: 7
	-- upvalues: EventNames (copy), EventStreamActionList (copy), Dash (copy)
	assert(EventNames.isEnumValue(p1), "Invalid event name")

	local v8 = EventStreamActionList[p1]

	return v8.context, v8.eventType, Dash.join(v8.additionalInfo, {
		btn = if not v8.additionalInfo or not v8.additionalInfo.btn then nil else v8.additionalInfo.btn.rawValue()
	}, p2)
end
