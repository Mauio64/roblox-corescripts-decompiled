local module = require("@luauforge/deferred/gBR")
local module2 = require("@luauforge/deferred/gBS")

local module3 = require("@luauforge/bundled/fIU")

local function ProcessGameSocialLinks(list, p2)
	local v5 = nil
	local v6 = {}

	for i, item in ipairs(list) do
		local v7 = module.fromJsonData(item)
		local kind = v7.type
		local flag = true
		local flag2

		for k, v8 in pairs(module2) do
			if kind == v8 then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			if v7.type == module2.RobloxGroup then
				if v5 then
					warn("Detected multiple " .. v7.type .. " links for universe " .. p2 .. "!")
				else
					if module3.FFlagIsSetupEnabled and v7.url ~= nil then
						local v8 = string.split(v7.url, "/")
						local v9 = v8[#v8]

						if tonumber(v9) ~= nil then
							v7.communityId = v9
						end
					end

					v5 = v7
				end
			else
				table.insert(v6, v7)
			end
		else
			warn("Can NOT recognize " .. v7.type .. " as a valid Social Link Type!")
		end
	end

	return { externalLinks = v6, groupLink = v5 }
end

return ProcessGameSocialLinks
