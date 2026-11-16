local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Signals = require(parent.Signals)
require(BuildExperience.Chat.chatTypes)

local function targetsMatch(p, p2: number?, p3: string?): boolean -- 1 equivalent call inferred from this helper
	return p.universeId == p2 and (p.sessionId == nil or p.sessionId == p3)
end

local function createBuildPromptDraftStore()
	local signal, v = Signals.createSignal(nil)

	return {
		getPendingDraft = signal,
		queueDraft = function(p)
			v(p)
		end,
		consumeDraft = function(p: number?, p2: string?)
			local v2 = signal()

			if v2 ~= nil and targetsMatch(v2, p, p2) then -- inferred equivalent call
				v(nil)
				return v2.text
			end

			return nil
		end,
		reset = function()
			v(nil)
		end
	}
end

return createBuildPromptDraftStore
