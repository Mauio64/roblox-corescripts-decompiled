local module = require("@luauforge/bundled/hSF")
local crossPlayCapabilities = require("@luauforge/bundled/hSJ").Enum.CrossPlayCapabilities
local module2 = require("@luauforge/bundled/hTa")
local module3 = require("@luauforge/bundled/hSX")

local privilegeCheckResults = module2.PrivilegeCheckResults

local function CrossPlayStubSystemPrivileges(options)
	return module3((module.Dictionary.join(options or {}, {
		[crossPlayCapabilities.CrossPlatform] = {
			CanJoinGame = true,
			PrivilegeCheckResult = privilegeCheckResults.NO_ISSUE,
			Success = true
		}
	})))
end

return CrossPlayStubSystemPrivileges
