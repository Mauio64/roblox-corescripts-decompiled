local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Actions = Modules.LuaApp.Actions
local SetGameSocialLinks = require(Actions.Games.SetGameSocialLinks)
local GamesGetSocialLinks = require(Modules.LuaApp.Http.Requests.GamesApi.GamesGetSocialLinks)
local GameSocialLink = require(Modules.LuaApp.Models.GamesApi.GameSocialLink)
local SocialMediaType = require(Modules.LuaApp.Enum.SocialMediaType)
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local ProcessGameSocialLinks = require(script.Parent.ProcessGameSocialLinks)
local FFlagLuaAppProcessGameSocialLinks = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppProcessGameSocialLinks

return function(p1, p2) -- line: 23
	-- upvalues: GamesGetSocialLinks (copy), FFlagLuaAppProcessGameSocialLinks (copy), ProcessGameSocialLinks (copy), SetGameSocialLinks (copy), GameSocialLink (copy), SocialMediaType (copy), EnableCommunityProfilePageIXP (copy)
	return function(p3) -- line: 24
		-- upvalues: GamesGetSocialLinks (copy), p1 (copy), p2 (copy), FFlagLuaAppProcessGameSocialLinks (copy), ProcessGameSocialLinks (copy), SetGameSocialLinks (copy), GameSocialLink (copy), SocialMediaType (copy), EnableCommunityProfilePageIXP (copy)
		return GamesGetSocialLinks(p1, p2):andThen(function(p4) -- line: 25
			-- upvalues: FFlagLuaAppProcessGameSocialLinks (copy), ProcessGameSocialLinks (copy), p2 (copy), p3 (copy), SetGameSocialLinks (copy), GameSocialLink (copy), SocialMediaType (copy), EnableCommunityProfilePageIXP (copy)
			local data = p4.responseBody.data
			local t1 = {}
			local v20 = nil

			if FFlagLuaAppProcessGameSocialLinks then
				local v21 = ProcessGameSocialLinks(data, (tostring(p2)))

				p3:dispatch(SetGameSocialLinks(p2, v21))

				return
			end

			local g29 = nil
			local v28 = nil

			for _, v in ipairs(data) do
				local v24 = GameSocialLink.fromJsonData(v)
				local type = v24.type

				for _, v2 in pairs(SocialMediaType) do
					if type == v2 then
						v28 = true
						g29 = true
					end

					if g29 then
						break
					end
				end

				if not g29 then
					v28 = false
				end

				g29 = false

				if not v28 then
					warn("Can NOT recognize " .. v24.type .. " as a valid Social Link Type!")
				elseif v24.type == SocialMediaType.RobloxGroup then
					if not v20 then
						v20 = v24

						if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and v20.url ~= nil then
							local parts = string.split(v20.url, "/")
							local v31 = parts[#parts]

							if tonumber(v31) ~= nil then
								v20.communityId = v31
							end
						end
					else
						warn("Detected multiple " .. v24.type .. " links for universe " .. p2 .. "!")
					end
				else
					table.insert(t1, v24)
				end
			end

			local t2 = {
				externalLinks = t1,
				groupLink = v20
			}

			p3:dispatch(SetGameSocialLinks(p2, t2))
		end)
	end
end
