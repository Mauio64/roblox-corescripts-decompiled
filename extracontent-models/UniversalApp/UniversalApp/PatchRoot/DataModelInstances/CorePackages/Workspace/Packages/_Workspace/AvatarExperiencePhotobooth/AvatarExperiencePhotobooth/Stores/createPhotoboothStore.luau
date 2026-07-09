local Parent = script:FindFirstAncestor("AvatarExperiencePhotobooth").Parent
local Signals = require(Parent.Signals)

local function createPhotoboothStore() -- line: 19
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal("")

	return {
		getSelectedSceneId = v4,
		selectScene = function(s1: string) -- line: 22
			-- upvalues: v5 (copy)
			v5(s1)
		end,
		clearSelection = function() -- line: 26
			-- upvalues: v5 (copy)
			v5("")
		end
	}
end

return createPhotoboothStore
