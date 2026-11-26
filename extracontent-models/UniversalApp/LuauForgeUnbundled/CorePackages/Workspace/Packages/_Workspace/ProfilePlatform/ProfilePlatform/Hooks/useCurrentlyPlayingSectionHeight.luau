local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Hooks.useTokens
local fFlagJoinabilityCTAContextCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagJoinabilityCTAContextCopy

return function(p2)
	local v5 = useTokens()

	if p2 == nil or p2.universeId == nil then
		return 0
	end

	local v6 = v5.Size.Size_1000 + 2 * v5.Padding.Large

	if fFlagJoinabilityCTAContextCopy then
		local joinability = p2.joinability

		if joinability == "Joinable" or joinability == "NotJoinable" then
			v6 += v5.Typography.BodyMedium.FontSize + v5.Gap.XSmall
		end
	end

	return v6
end
