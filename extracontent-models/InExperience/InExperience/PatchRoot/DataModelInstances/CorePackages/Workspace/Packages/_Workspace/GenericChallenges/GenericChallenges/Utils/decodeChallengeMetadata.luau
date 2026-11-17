local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent

local HttpService = game:GetService("HttpService")

local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64

require(GenericChallenges.Types.ChallengeMetadata)

local function decodeChallengeMetadata(p: string?)
	if p == nil or p == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(Base64.Decode(p))
	end)

	return if success and typeof(result) == "table" then result else nil
end

return decodeChallengeMetadata
