local parent = script.Parent.Parent

local SetPromptState = require(parent.Actions.SetPromptState)
local PromptState = require(parent.Enums.PromptState)
local PlatformInterface = require(parent.Services.PlatformInterface)
local Thunk = require(parent.Thunk)

local v = { PlatformInterface }

local function openRobuxStore()
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[PlatformInterface]

		object:dispatch(SetPromptState(PromptState.UpsellInProgress))
		v2.openRobuxStore()
	end)
end

return openRobuxStore
