local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

local function getLicenses()
	return Promise.new(function(callback, callback2)
		task.spawn(function()
			local success, result = pcall(function()
				local coreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")
				local result2 = {}

				for i, child in pairs(coreScripts:GetChildren()) do
					local match, v5 = child.Name:match("^(%d*)-(.*)")
					local match2 = child.Value:match("(.-)\n*$")

					result2[match + 1] = { key = v5, value = match2:split("\n") }
				end

				return result2
			end)

			if success then
				callback(result)
			else
				callback2(result)
			end
		end)
	end)
end

local function useLicenseData()
	local state, setState = React.useState({
		licenseList = {},
		initialLicense = nil,
		initialLicenseKey = nil
	})

	React.useLayoutEffect(function()
		Promise.new(function(callback, callback2)
			task.spawn(function()
				local success, result = pcall(function()
					local coreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")
					local result2 = {}

					for i, child in pairs(coreScripts:GetChildren()) do
						local match, v5 = child.Name:match("^(%d*)-(.*)")
						local match2 = child.Value:match("(.-)\n*$")

						result2[match + 1] = { key = v5, value = match2:split("\n") }
					end

					return result2
				end)

				if success then
					callback(result)
				else
					callback2(result)
				end
			end)
		end):andThen(function(list)
			local v6 = {
				licenseList = list,
				initialLicense = list[1],
				initialLicenseKey = 0
			}
			local v7 = if list[1] then list[1].key else nil
			v6.initialLicenseKey = v7
			setState(v6)
		end):catch(function(p2)
			warn("Failed to retrieve license data: ", p2)
		end)
	end, {})

	return state
end

return useLicenseData
