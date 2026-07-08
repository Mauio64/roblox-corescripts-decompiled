local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Types = require(script.Parent.Parent.Types)
local maybeAssert = require(script.Parent.maybeAssert)
local _ = script.Parent.Parent.Parent.Parent.Flags

local function getSettingsForMessage(p1, p2) -- line: 12
	-- upvalues: maybeAssert (copy), Types (copy), t (copy)
	maybeAssert(Types.IChatSettings(p1))
	maybeAssert(t.optional(Types.IMessage)(p2))

	local UserSpecificSettings = p1.UserSpecificSettings

	if not UserSpecificSettings or not p2 then
		return p1
	end

	return UserSpecificSettings[p2.userId] or (not p2.adornee or UserSpecificSettings[p2.adornee:GetFullName()]) or p1
end

return getSettingsForMessage
