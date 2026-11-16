local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local LinkType = require(InlineRichText.Enums.LinkType)
local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default

local v = {
	{
		isLinkType = function(value: string): boolean
			return string.match(value, "^https://") ~= nil
		end,
		type = LinkType.Http
	},
	{
		isLinkType = function(p: string)
			local v, v2 = default:isURLRegistered(p):await()
			return v and v2
		end,
		type = LinkType.LinkingProtocolRegistered
	},
	{
		isLinkType = function(_: string): boolean
			return true
		end,
		type = LinkType.Default
	}
}

local function getLinkType(p: string)
	for _, v2 in v do
		if v2.isLinkType(p) then
			return v2.type
		end
	end

	return LinkType.Default
end

return getLinkType
