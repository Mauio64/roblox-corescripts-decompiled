local regex = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UrlMatching").Regex

local FFlagAppChatResolveShareLinkV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatResolveShareLinkV2")
local FFlagAppChatPlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralAssetCard")
local FFlagAppChatEarlyTestingLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEarlyTestingLinks")

local v5 = { "ExperienceDetails" }

local function createGameLinkMessage(p2)
	return {
		placeId = p2.id,
		isEarlyTesting = FFlagAppChatEarlyTestingLinks and p2.isEarlyTesting == "true" and true or nil
	}
end

local function createShareLinkMessage(data)
	if not FFlagAppChatResolveShareLinkV2 then
		return {
			shareLink = { linkId = data.code, linkType = data.type }
		}
	end

	if data.v == "v2" then
		return {
			shareLink = { linkId = data.code, version = 2 }
		}
	end

	if data.type then
		return {
			shareLink = { linkId = data.code, linkType = data.type, version = 1 }
		}
	end

	return nil
end

local v6

if FFlagAppChatResolveShareLinkV2 then
	v6 = {
		{ name = "code", pattern = "[a-fA-F0-9-]+" },
		{ name = "type", pattern = regex.oneOf(v5), optional = true },
		{
			name = "v",
			pattern = regex.oneOf({ "v2" }),
			optional = true
		}
	}
else
	v6 = {
		{ name = "code", pattern = "[a-fA-F0-9]+" },
		{ name = "type", pattern = regex.oneOf(v5) }
	}
end

return {
	["/games"] = {
		pathParams = {
			{ name = "path", pattern = "games" },
			{ name = "id", pattern = "[0-9]+" },
			{ name = "name", pattern = "[a-zA-Z0-9_-]+", optional = true }
		},
		queryParams = FFlagAppChatEarlyTestingLinks and {
			{ name = "isEarlyTesting", pattern = "true", optional = true }
		} or nil,
		paramCallback = createGameLinkMessage
	},
	["/share"] = { queryParams = v6, paramCallback = createShareLinkMessage },
	["/plus-referral"] = FFlagAppChatPlusReferralAssetCard and {
		queryParams = v6,
		paramCallback = function(p2)
			if p2.code and p2.code ~= "" then
				return {
					shareLink = {
						linkId = p2.code,
						linkType = "PlusReferral",
						version = 2
					}
				}
			end

			return nil
		end
	} or nil
}
