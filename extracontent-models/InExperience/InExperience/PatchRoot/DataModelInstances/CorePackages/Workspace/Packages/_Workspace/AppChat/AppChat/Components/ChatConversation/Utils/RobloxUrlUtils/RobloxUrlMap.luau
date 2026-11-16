local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local UrlMatching = require(parent.UrlMatching)

local Regex = UrlMatching.Regex

local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)
local FFlagAppChatPlusReferralAssetCard = require(AppChat.Flags.FFlagAppChatPlusReferralAssetCard)
local FFlagAppChatEarlyTestingLinks = require(AppChat.Flags.FFlagAppChatEarlyTestingLinks)

local v = { "ExperienceDetails" }

local function createGameLinkMessage(p)
	return {
		placeId = p.id,
		isEarlyTesting = FFlagAppChatEarlyTestingLinks and p.isEarlyTesting == "true" and true or nil
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

local queryParams

if FFlagAppChatResolveShareLinkV2 then
	queryParams = {
		{ name = "code", pattern = "[a-fA-F0-9-]+" },
		{ name = "type", pattern = Regex.oneOf(v), optional = true },
		{
			name = "v",
			pattern = Regex.oneOf({ "v2" }),
			optional = true
		}
	}
else
	queryParams = {
		{ name = "code", pattern = "[a-fA-F0-9]+" },
		{ name = "type", pattern = Regex.oneOf(v) }
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
	["/share"] = { queryParams = queryParams, paramCallback = createShareLinkMessage },
	["/plus-referral"] = FFlagAppChatPlusReferralAssetCard and {
		queryParams = queryParams,
		paramCallback = function(p)
			if p.code and p.code ~= "" then
				return {
					shareLink = { linkId = p.code, linkType = "PlusReferral", version = 2 }
				}
			end

			return nil
		end
	} or nil
}
