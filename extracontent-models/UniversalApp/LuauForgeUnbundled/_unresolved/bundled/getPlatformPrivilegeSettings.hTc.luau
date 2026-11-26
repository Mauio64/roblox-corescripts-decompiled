local module = require("@luauforge/bundled/hTd")

local module2 = require("@luauforge/bundled/hSF")
local module3 = require("@luauforge/bundled/hTf")
local crossPlayCapabilities = require("@luauforge/bundled/hSJ").Enum.CrossPlayCapabilities
local privilegeCodes = require("@luauforge/bundled/hTa").PrivilegeCodes

local function getPlatformPrivilegeSettings(options)
	local joined = module2.List.join({ crossPlayCapabilities.CrossPlatform }, options or {})

	return module3.new(function(callback, callback2)
		local success, result = pcall(function()
			return module2.List.foldLeft(joined, function(p2, p3)
				return module2.Dictionary.join(p2, {
					[p3] = module:BeginCheckXboxPrivilege(privilegeCodes[p3])
				})
			end, {})
		end)

		if success then
			callback(result)
		else
			callback2(result)
		end
	end)
end

return getPlatformPrivilegeSettings
