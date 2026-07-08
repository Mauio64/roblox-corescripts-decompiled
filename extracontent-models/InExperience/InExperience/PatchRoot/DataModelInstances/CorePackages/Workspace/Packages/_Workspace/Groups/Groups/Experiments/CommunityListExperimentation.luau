local IXPService = game:GetService("IXPService")
local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local SharedFlags = require(GroupsParent.SharedFlags)
local Flags = require(Groups.Flags)
local GetFStringSocialCommunityAppLayer = Flags.GetFStringSocialCommunityAppLayer
local GetFStringLuaCommunityListVariant = Flags.GetFStringLuaCommunityListVariant
local GetFFlagForceEnableLuaCommunityList = Flags.GetFFlagForceEnableLuaCommunityList
local GetFFlagEnableCommunityListExperimentation = SharedFlags.GetFFlagEnableCommunityListExperimentation

local function getIsUserInTreatment(s1: string) -- line: 14
	-- upvalues: IXPService (copy), GetFStringSocialCommunityAppLayer (copy)
	local UserLayerVariables = IXPService:GetUserLayerVariables(GetFStringSocialCommunityAppLayer())

	if UserLayerVariables and UserLayerVariables[s1] ~= nil then
		return UserLayerVariables[s1]
	end

	return false
end

return {
	getCommunityListEnabled = function() -- line: 23
		-- upvalues: GetFFlagForceEnableLuaCommunityList (copy), GetFFlagEnableCommunityListExperimentation (copy), GetFStringLuaCommunityListVariant (copy), IXPService (copy), GetFStringSocialCommunityAppLayer (copy)
		local v13 = GetFFlagForceEnableLuaCommunityList()

		if not v13 then
			v13 = GetFFlagEnableCommunityListExperimentation()

			if v13 then
				local v14 = GetFStringLuaCommunityListVariant()
				local UserLayerVariables = IXPService:GetUserLayerVariables(GetFStringSocialCommunityAppLayer())

				if UserLayerVariables and UserLayerVariables[v14] ~= nil then
					return UserLayerVariables[v14]
				end

				v13 = false
			end
		end

		return v13
	end,
	logExposure = function() -- line: 28
		-- upvalues: GetFFlagEnableCommunityListExperimentation (copy), IXPService (copy), GetFStringSocialCommunityAppLayer (copy)
		if GetFFlagEnableCommunityListExperimentation() then
			IXPService:LogUserLayerExposure(GetFStringSocialCommunityAppLayer())
		end
	end
}
