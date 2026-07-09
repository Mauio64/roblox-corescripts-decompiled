local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local Cryo = require(CrossPlayParent.Cryo)
local CrossPlayCapabilities = require(CrossPlayParent.UniversalAppPolicy).Enum.CrossPlayCapabilities
local Constants = require(CrossPlay.Hooks.Constants)
local CrossPlaySetPrivileges = require(script.Parent.CrossPlaySetPrivileges)
local PrivilegeCheckResults = Constants.PrivilegeCheckResults

local function CrossPlayStubSystemPrivileges(p1) -- line: 10
	-- upvalues: Cryo (copy), CrossPlayCapabilities (copy), PrivilegeCheckResults (copy), CrossPlaySetPrivileges (copy)
	local v10 = Cryo.Dictionary.join(p1 or {}, {
		[CrossPlayCapabilities.CrossPlatform] = {
			CanJoinGame = true,
			Success = true,
			PrivilegeCheckResult = PrivilegeCheckResults.NO_ISSUE
		}
	})

	return CrossPlaySetPrivileges(v10)
end

return CrossPlayStubSystemPrivileges
