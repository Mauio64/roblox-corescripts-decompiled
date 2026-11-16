local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local function targetsMatch(p2, p3, p4): boolean
	if p2.universeId == p3 then
		return p2.sessionId == nil or p2.sessionId == p4
	end

	return false
end

local function createBuildPromptDraftStore()
	local signal, v5 = Signals.createSignal(nil)

	return {
		getPendingDraft = signal,
		queueDraft = function(p2)
			v5(p2)
		end,
		consumeDraft = function(p2, p3)
			local v6 = signal()

			if v6 == nil then
				return nil
			end

			local v7 = v6.universeId == p2 and (v6.sessionId == nil or v6.sessionId == p3)

			if v7 then
				v5(nil)
				return v6.text
			end

			return nil
		end,
		reset = function()
			v5(nil)
		end
	}
end

return createBuildPromptDraftStore
