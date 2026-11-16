local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)

local Types = require(script.Parent.Parent.Types)
local maybeAssert = require(script.Parent.maybeAssert)

local Flags = script.Parent.Parent.Parent.Parent.Flags

local function getSettingsForMessage(p, p2)
	maybeAssert(Types.IChatSettings(p))
	maybeAssert(t.optional(Types.IMessage)(p2))

	local userSpecificSettings = p.UserSpecificSettings

	if not (userSpecificSettings and p2) then
		return p
	end

	local v = userSpecificSettings[p2.userId]

	if not v and p2.adornee then
		v = userSpecificSettings[p2.adornee:GetFullName()]
	end

	return v or p
end

return getSettingsForMessage
