local ContentProvider = game:GetService("ContentProvider")

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")

local defineFastString = game:DefineFastString("MyStatsExperienceStatsBaseUrl", "")

local function resolveCreatorAgentAcp()
	local v5 = defineFastString

	if typeof(v5) == "string" and v5 ~= "" then
		local v7 = string.match(v5, "sitetest(%d+)%.robloxlabs%.com")

		local v8 = if v7 ~= nil then tonumber(v7) else nil

		return { url = v5, gateway = "robloxlabs-v1", sitetestNumber = v8 }
	else
		local success, result = pcall(function()
			return ContentProvider.BaseUrl
		end)

		if success and typeof(result) == "string" then
			local v6 = string.match(result, "sitetest(%d+)%.robloxlabs%.com")

			local v7 = if v6 ~= nil then tonumber(v6) else nil

			if v7 ~= nil then
				return {
					url = `https://apis.sitetest{v7}.robloxlabs.com{module.ACP_PATH}`,
					gateway = "robloxlabs-v1",
					sitetestNumber = v7
				}
			end
		end

		return {
			url = AcpProtocol.acpUrl(),
			gateway = "robloxlabs-v1",
			sitetestNumber = nil
		}
	end
end

return {
	resolveCreatorAgentAcp = resolveCreatorAgentAcp,
	resolveCreatorAgentAcpUrl = function()
		return resolveCreatorAgentAcp().url
	end,
	parseSitetestRobloxlabsNumber = function(value)
		local v5 = string.match(value, "sitetest(%d+)%.robloxlabs%.com")

		if v5 == nil then
			return nil
		end

		return (tonumber(v5))
	end,
	buildRobloxlabsAcpUrl = function(p2)
		return `https://apis.sitetest{p2}.robloxlabs.com{module.ACP_PATH}`
	end
}
