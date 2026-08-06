local v1 = game:DefineFastFlag("DebugMyStatsExperienceAgentSpec", false)

require(script.Parent.Types.acpSession)

local u2 = nil

return {
	isEnabled = function() -- line: 12
		-- upvalues: v1 (copy)
		return v1
	end,
	get = function() -- line: 15
		-- upvalues: u2 (ref)
		return u2
	end,
	set = function(s1: string?) -- line: 18
		-- upvalues: u2 (ref)
		u2 = if s1 ~= nil and (s1 ~= "" and s1 ~= "latest") then s1 else nil
	end,
	getExperiment = function() -- line: 22
		-- upvalues: v1 (copy), u2 (ref)
		if not v1 or u2 == nil then
			return nil
		end

		return {
			specVersion = u2,
			clientToolConfig = {
				mode = "exclude",
				tools = {}
			}
		}
	end
}
