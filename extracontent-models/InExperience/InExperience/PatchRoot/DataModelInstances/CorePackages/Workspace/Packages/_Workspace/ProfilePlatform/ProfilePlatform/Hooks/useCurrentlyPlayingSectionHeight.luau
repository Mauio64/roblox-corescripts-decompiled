local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent.SharedFlags)
local FFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy

return function(p)
	local v = useTokens()

	if p == nil or p.universeId == nil then
		return 0
	end

	local v2 = v.Size.Size_1000 + 2 * v.Padding.Large

	if FFlagJoinabilityCTAContextCopy then
		local joinability = p.joinability

		if joinability == "Joinable" or joinability == "NotJoinable" then
			return v2 + (v.Typography.BodyMedium.FontSize + v.Gap.XSmall)
		end
	end

	return v2
end
