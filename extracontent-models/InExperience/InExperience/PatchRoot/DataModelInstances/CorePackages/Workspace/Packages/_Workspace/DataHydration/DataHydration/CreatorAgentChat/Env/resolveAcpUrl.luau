local ContentProvider = game:GetService("ContentProvider")
local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)
local v3 = game:DefineFastString("MyStatsExperienceStatsBaseUrl", "")

local function resolveCreatorAgentAcp() -- line: 33
	-- upvalues: v3 (copy), ContentProvider (copy), AcpProtocol (copy)
	local v8 = v3

	if typeof(v8) == "string" and v8 ~= "" then
		local t1 = {
			gateway = "robloxlabs-v1",
			url = v8
		}
		local match = string.match(v8, "sitetest(%d+)%.robloxlabs%.com")

		t1.sitetestNumber = if match ~= nil then tonumber(match) else nil

		return t1
	end

	local ok, result = pcall(function() -- line: 43
		-- upvalues: ContentProvider (copy)
		return ContentProvider.BaseUrl
	end)

	if ok and typeof(result) == "string" then
		local match = string.match(result, "sitetest(%d+)%.robloxlabs%.com")
		local v14 = if match ~= nil then tonumber(match) else nil

		if v14 ~= nil then
			return {
				gateway = "robloxlabs-v1",
				url = `https://apis.sitetest{ v14 }.robloxlabs.com{ AcpProtocol.ACP_PATH }`,
				sitetestNumber = v14
			}
		end
	end

	return {
		gateway = "robloxlabs-v1",
		sitetestNumber = nil,
		url = AcpProtocol.acpUrl()
	}
end

return {
	resolveCreatorAgentAcp = resolveCreatorAgentAcp,
	resolveCreatorAgentAcpUrl = function() -- line: 64
		-- upvalues: resolveCreatorAgentAcp (copy)
		return resolveCreatorAgentAcp().url
	end,
	parseSitetestRobloxlabsNumber = function(s1: string) -- line: 25
		local match = string.match(s1, "sitetest(%d+)%.robloxlabs%.com")

		if match == nil then
			return nil
		end

		return (tonumber(match))
	end,
	buildRobloxlabsAcpUrl = function(n1: number) -- line: 21
		-- upvalues: AcpProtocol (copy)
		return `https://apis.sitetest{ n1 }.robloxlabs.com{ AcpProtocol.ACP_PATH }`
	end
}
