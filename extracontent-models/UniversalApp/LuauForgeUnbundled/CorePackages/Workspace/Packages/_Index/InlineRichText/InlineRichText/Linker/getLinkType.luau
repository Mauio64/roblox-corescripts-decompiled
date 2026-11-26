local LinkType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/LinkType")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/LinkingProtocol").LinkingProtocol.default

local v5 = {
	{
		isLinkType = function(value): boolean
			return string.match(value, "^https://") ~= nil
		end,
		type = LinkType.Http
	},
	{
		isLinkType = function(p2)
			local v6, v7 = default:isURLRegistered(p2):await()
			return v6 and v7
		end,
		type = LinkType.LinkingProtocolRegistered
	},
	{
		isLinkType = function(p2): boolean
			return true
		end,
		type = LinkType.Default
	}
}

local function getLinkType(p2)
	for k, v6 in v5 do
		if v6.isLinkType(p2) then
			return v6.type
		end
	end

	return LinkType.Default
end

return getLinkType
