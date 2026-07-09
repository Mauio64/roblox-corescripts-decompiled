local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(Modules.Common.Rodux)
local UpdateAccountPinUnlockTimeout = require(Modules.LuaApp.Actions.AccountSecurity.UpdateAccountPinUnlockTimeout)
local UpdatePromptType = require(Modules.LuaApp.Actions.AccountSecurity.UpdatePromptType)
local t1 = {
	isGeneric = nil,
	promptType = nil,
	metadata = nil,
	lastUpdatedPromptTypeAt = nil,
	accountPinUnlockedUntil = nil
}

return Rodux.createReducer(t1, {
	[UpdateAccountPinUnlockTimeout.name] = function(p1, p2) -- line: 20
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			accountPinUnlockedUntil = p2.accountPinUnlockedUntil or Cryo.None
		})
	end,
	[UpdatePromptType.name] = function(p3, p4) -- line: 26
		-- upvalues: Cryo (copy)
		local v12 = Cryo.Dictionary.join(p3, {
			isGeneric = p4.isGeneric or Cryo.None,
			promptType = p4.promptType or Cryo.None,
			metadata = p4.metadata or Cryo.None
		})

		if p3.promptType ~= p4.promptType then
			v12 = Cryo.Dictionary.join(v12, {
				lastUpdatedPromptTypeAt = p4.lastUpdatedPromptTypeAt
			})
		end

		return v12
	end
})
