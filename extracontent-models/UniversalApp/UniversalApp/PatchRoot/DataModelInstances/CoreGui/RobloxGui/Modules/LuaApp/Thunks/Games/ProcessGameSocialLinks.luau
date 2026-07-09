local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GameSocialLink = require(Modules.LuaApp.Models.GamesApi.GameSocialLink)
local SocialMediaType = require(Modules.LuaApp.Enum.SocialMediaType)
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)

local function ProcessGameSocialLinks(p1, s1: string) -- line: 17
	-- upvalues: GameSocialLink (copy), SocialMediaType (copy), EnableCommunityProfilePageIXP (copy)
	local t1 = {}
	local v13 = nil
	local g21 = nil
	local v20 = nil

	for _, v in ipairs(p1) do
		local v16 = GameSocialLink.fromJsonData(v)
		local type = v16.type

		for _, v2 in pairs(SocialMediaType) do
			if type == v2 then
				v20 = true
				g21 = true
			end

			if g21 then
				break
			end
		end

		if not g21 then
			v20 = false
		end

		g21 = false

		if not v20 then
			warn("Can NOT recognize " .. v16.type .. " as a valid Social Link Type!")
		elseif v16.type == SocialMediaType.RobloxGroup then
			if not v13 then
				v13 = v16

				if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and v13.url ~= nil then
					local parts = string.split(v13.url, "/")
					local v23 = parts[#parts]

					if tonumber(v23) ~= nil then
						v13.communityId = v23
					end
				end
			else
				warn("Detected multiple " .. v16.type .. " links for universe " .. s1 .. "!")
			end
		else
			table.insert(t1, v16)
		end
	end

	return {
		externalLinks = t1,
		groupLink = v13
	}
end

return ProcessGameSocialLinks
