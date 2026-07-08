local ParentParent = script.Parent.Parent
local SetPromptState = require(ParentParent.Actions.SetPromptState)
local PromptState = require(ParentParent.Enums.PromptState)
local PlatformInterface = require(ParentParent.Services.PlatformInterface)
local Thunk = require(ParentParent.Thunk)
local t1 = { PlatformInterface }

local function openRobuxStore() -- line: 13
	-- upvalues: Thunk (copy), t1 (copy), PlatformInterface (copy), SetPromptState (copy), PromptState (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 14
		-- upvalues: PlatformInterface (copy), SetPromptState (copy), PromptState (copy)
		local v10 = p2[PlatformInterface]

		p1:dispatch(SetPromptState(PromptState.UpsellInProgress))
		v10.openRobuxStore()
	end)
end

return openRobuxStore
