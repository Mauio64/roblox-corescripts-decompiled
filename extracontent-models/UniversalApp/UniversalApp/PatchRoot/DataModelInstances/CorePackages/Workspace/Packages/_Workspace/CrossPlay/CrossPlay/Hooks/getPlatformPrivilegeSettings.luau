local CrossPlay = script:FindFirstAncestor("CrossPlay")
local PlatformServiceOrStub = require(CrossPlay.ServiceWrappers.PlatformServiceOrStub)
local CrossPlayParent = CrossPlay.Parent
local Cryo = require(CrossPlayParent.Cryo)
local Promise = require(CrossPlayParent.Promise)
local CrossPlayCapabilities = require(CrossPlayParent.UniversalAppPolicy).Enum.CrossPlayCapabilities
local PrivilegeCodes = require(script.Parent.Constants).PrivilegeCodes

local function getPlatformPrivilegeSettings(t1: {[any]: any}) -- line: 14
	-- upvalues: Cryo (copy), CrossPlayCapabilities (copy), Promise (copy), PlatformServiceOrStub (copy), PrivilegeCodes (copy)
	local v10 = Cryo.List.join({ CrossPlayCapabilities.CrossPlatform }, t1 or {})

	return Promise.new(function(resolve, reject) -- line: 18
		-- upvalues: Cryo (copy), v10 (copy), PlatformServiceOrStub (copy), PrivilegeCodes (copy)
		local ok, result = pcall(function() -- line: 23
			-- upvalues: Cryo (copy), v10 (copy), PlatformServiceOrStub (copy), PrivilegeCodes (copy)
			return Cryo.List.foldLeft(v10, function(p1, p2) -- line: 24
				-- upvalues: Cryo (copy), PlatformServiceOrStub (copy), PrivilegeCodes (copy)
				return Cryo.Dictionary.join(p1, {
					[p2] = PlatformServiceOrStub:BeginCheckXboxPrivilege(PrivilegeCodes[p2])
				})
			end, {})
		end)

		if ok then
			resolve(result)

			return
		end

		reject(result)
	end)
end

return getPlatformPrivilegeSettings
