local module = require("@luauforge/bundled/hIw")

local module2 = require("@luauforge/bundled/hHY")
local module3 = require("@luauforge/bundled/hIy")
local crossPlayCapabilities = require("@luauforge/bundled/hIc").Enum.CrossPlayCapabilities
local privilegeCodes = require("@luauforge/bundled/hIt").PrivilegeCodes

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
