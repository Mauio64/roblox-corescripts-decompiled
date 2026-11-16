local module = require("@luauforge/bundled/dyk")
local GetIcons = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Requests/Games/GetIcons")
local module3 = require("@luauforge/deferred/fWU")
local module4 = require("@luauforge/deferred/fWV")

local module5 = require("@luauforge/bundled/fWW")
local module6 = require("@luauforge/deferred/fWT")

local fFlagLuaAppProcessGameSocialLinks = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppProcessGameSocialLinks

return function(p2, p3)
	return function(object)
		return GetIcons(p2, p3):andThen(function(p4)
			local data = p4.responseBody.data
			local v5 = {}
			local v6 = nil

			if fFlagLuaAppProcessGameSocialLinks then
				object:dispatch(module(p3, (module6(data, (tostring(p3))))))
				return
			end

			for i, v7 in ipairs(data) do
				local v8 = module3.fromJsonData(v7)
				local kind = v8.type
				local flag = true
				local flag2

				for k, v9 in pairs(module4) do
					if kind == v9 then
						flag2 = true
						flag = false
						break
					end
				end

				if flag then
					flag2 = false
				end

				if flag2 then
					if v8.type == module4.RobloxGroup then
						if v6 then
							warn("Detected multiple " .. v8.type .. " links for universe " .. p3 .. "!")
						else
							if module5.FFlagIsSetupEnabled and v8.url ~= nil then
								local v9 = string.split(v8.url, "/")
								local v10 = v9[#v9]

								if tonumber(v10) ~= nil then
									v8.communityId = v10
								end
							end

							v6 = v8
						end
					else
						table.insert(v5, v8)
					end
				else
					warn("Can NOT recognize " .. v8.type .. " as a valid Social Link Type!")
				end
			end

			object:dispatch(module(p3, { externalLinks = v5, groupLink = v6 }))
		end)
	end
end
