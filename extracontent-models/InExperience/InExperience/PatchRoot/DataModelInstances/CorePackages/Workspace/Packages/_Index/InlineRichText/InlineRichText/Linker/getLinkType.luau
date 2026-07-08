local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local LinkType = require(InlineRichText.Enums.LinkType)
local default = require(InlineRichTextParent.LinkingProtocol).LinkingProtocol.default
local t1 = {
	{
		isLinkType = function(s1: string) -- line: 11
			return string.match(s1, "^https://") ~= nil
		end,
		type = LinkType.Http
	},
	{
		isLinkType = function(s2: string) -- line: 18
			-- upvalues: default (copy)
			local v9, v10 = default:isURLRegistered(s2):await()

			return v9 and v10
		end,
		type = LinkType.LinkingProtocolRegistered
	},
	{
		isLinkType = function(_: string) -- line: 26
			return true
		end,
		type = LinkType.Default
	}
}

local function getLinkType(s4: string) -- line: 33
	-- upvalues: t1 (copy), LinkType (copy)
	for _, v14 in t1 do
		if v14.isLinkType(s4) then
			return v14.type
		end
	end

	return LinkType.Default
end

return getLinkType
