local HttpService = game:GetService("HttpService")

local base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AuthCommon").Utils.Base64

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeMetadata")

local function decodeChallengeMetadata(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(base64.Decode(p2))
	end)

	if success and typeof(result) == "table" then
		return result
	end

	return nil
end

return decodeChallengeMetadata
