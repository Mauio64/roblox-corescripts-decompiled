local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Regex = require(AppChatParent.UrlMatching).Regex
local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)
local t1 = { "ExperienceDetails" }

local function createGameLinkMessage(t2: {[any]: any}) -- line: 16
	return {
		placeId = t2.id
	}
end
local function createShareLinkMessage(t3: {[any]: any}) -- line: 22
	-- upvalues: FFlagAppChatResolveShareLinkV2 (copy)
	if FFlagAppChatResolveShareLinkV2 then
		if t3.v == "v2" then
			return {
				shareLink = {
					version = 2,
					linkId = t3.code
				}
			}
		end

		if t3.type then
			return {
				shareLink = {
					version = 1,
					linkId = t3.code,
					linkType = t3.type
				}
			}
		end

		return nil
	end

	return {
		shareLink = {
			linkId = t3.code,
			linkType = t3.type
		}
	}
end

local v8 = if not FFlagAppChatResolveShareLinkV2 then {
	{
		name = "code",
		pattern = "[a-fA-F0-9]+"
	},
	{
		name = "type",
		pattern = Regex.oneOf(t1)
	}
} else {
	{
		name = "code",
		pattern = "[a-fA-F0-9-]+"
	},
	{
		name = "type",
		optional = true,
		pattern = Regex.oneOf(t1)
	},
	{
		name = "v",
		optional = true,
		pattern = Regex.oneOf({ "v2" })
	}
}

return {
	["/games"] = {
		pathParams = {
			{
				name = "path",
				pattern = "games"
			},
			{
				name = "id",
				pattern = "[0-9]+"
			},
			{
				name = "name",
				pattern = "[a-zA-Z0-9_-]+",
				optional = true
			}
		},
		paramCallback = createGameLinkMessage
	},
	["/share"] = {
		queryParams = v8,
		paramCallback = createShareLinkMessage
	}
}
