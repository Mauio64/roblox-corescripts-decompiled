local ContentProvider = game:GetService("ContentProvider")

local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)

local defineFastString = game:DefineFastString("MyStatsExperienceStatsBaseUrl", "")

local function buildRobloxlabsAcpUrl(p: number) -- 1 equivalent call inferred from this helper
	return `https://apis.sitetest{p}.robloxlabs.com{AcpProtocol.ACP_PATH}`
end

local function parseSitetestRobloxlabsNumber(value: string) -- 2 equivalent calls inferred from this helper
	local v = string.match(value, "sitetest(%d+)%.robloxlabs%.com")

	if v == nil then
		return nil
	end

	return (tonumber(v))
end

local function resolveCreatorAgentAcp()
	local url = defineFastString

	if typeof(url) == "string" and url ~= "" then
		return {
			url = url,
			gateway = "robloxlabs-v1",
			sitetestNumber = parseSitetestRobloxlabsNumber(url) -- inferred equivalent call
		}
	else
		local success, result = pcall(function()
			return ContentProvider.BaseUrl
		end)

		if success and typeof(result) == "string" then
			local sitetestNumber = parseSitetestRobloxlabsNumber(result) -- inferred equivalent call

			if sitetestNumber ~= nil then
				return {
					url = buildRobloxlabsAcpUrl(sitetestNumber), -- inferred equivalent call
					gateway = "robloxlabs-v1",
					sitetestNumber = sitetestNumber
				}
			end
		end

		return { url = AcpProtocol.acpUrl(), gateway = "robloxlabs-v1", sitetestNumber = nil }
	end
end

return {
	resolveCreatorAgentAcp = resolveCreatorAgentAcp,
	resolveCreatorAgentAcpUrl = function()
		return resolveCreatorAgentAcp().url
	end,
	parseSitetestRobloxlabsNumber = parseSitetestRobloxlabsNumber,
	buildRobloxlabsAcpUrl = buildRobloxlabsAcpUrl
}
