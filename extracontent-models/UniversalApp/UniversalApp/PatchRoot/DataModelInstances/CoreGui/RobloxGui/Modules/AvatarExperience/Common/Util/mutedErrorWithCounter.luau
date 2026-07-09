local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function mutedErrorWithCounter(s1: string, s2: string?) -- line: 13
	-- upvalues: mutedError (copy), Constants (copy), sendAXCounterV2 (copy)
	mutedError(`[AXNilGuard] { s1 }{ s2 == nil and "" or " :: " .. s2 }`)

	local v10 = Constants.Counter.NilGuard[s1]

	if v10 ~= nil then
		sendAXCounterV2(v10)
	end
end

return mutedErrorWithCounter
