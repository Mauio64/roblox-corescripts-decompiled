local Parent = script:FindFirstAncestor("AppChat").Parent
local Regex = require(Parent.UrlMatching).Regex

local function createGameLinkMessage(t1: {[any]: any}) -- line: 10
	return {
		placeId = t1.id
	}
end
local function createShareLinkMessage(t2: {[any]: any}) -- line: 16
	return {
		shareLink = {
			linkId = t2.code,
			linkType = t2.type
		}
	}
end

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
		queryParams = {
			{
				name = "code",
				pattern = "[a-fA-F0-9]+"
			},
			{
				name = "type",
				pattern = Regex.oneOf({ "ExperienceDetails" })
			}
		},
		paramCallback = createShareLinkMessage
	}
}
