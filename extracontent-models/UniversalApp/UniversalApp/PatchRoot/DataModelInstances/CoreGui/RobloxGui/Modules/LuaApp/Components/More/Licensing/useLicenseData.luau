local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

local function getLicenses() -- line: 8
	-- upvalues: Promise (copy), InsertService (copy)
	return Promise.new(function(resolve, reject) -- line: 9
		-- upvalues: InsertService (copy)
		task.spawn(function() -- line: 10
			-- upvalues: InsertService (copy), resolve (copy), reject (copy)
			local ok, result = pcall(function() -- line: 13
				-- upvalues: InsertService (copy)
				local t1 = {}
				local CoreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")

				for _, child in pairs(CoreScripts:GetChildren()) do
					local v21, v22 = child.Name:match("^(%d*)-(.*)")
					local v23 = child.Value:match("(.-)\n*$")

					t1[v21 + 1] = {
						key = v22,
						value = v23:split("\n")
					}
				end

				return t1
			end)

			if ok then
				resolve(result)

				return
			end

			reject(result)
		end)
	end)
end
local function useLicenseData() -- line: 48
	-- upvalues: React (copy), Promise (copy), InsertService (copy)
	local v7, v8 = React.useState({
		initialLicense = nil,
		initialLicenseKey = nil,
		licenseList = {}
	})

	React.useLayoutEffect(function() -- line: 55
		-- upvalues: Promise (copy), InsertService (copy), v8 (copy)
		Promise.new(function(resolve, reject) -- line: 9
			-- upvalues: InsertService (copy)
			task.spawn(function() -- line: 10
				-- upvalues: InsertService (copy), resolve (copy), reject (copy)
				local ok, result = pcall(function() -- line: 13
					-- upvalues: InsertService (copy)
					local t2 = {}
					local CoreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")

					for _, child in pairs(CoreScripts:GetChildren()) do
						local v30, v31 = child.Name:match("^(%d*)-(.*)")
						local v32 = child.Value:match("(.-)\n*$")

						t2[v30 + 1] = {
							key = v31,
							value = v32:split("\n")
						}
					end

					return t2
				end)

				if ok then
					resolve(result)

					return
				end

				reject(result)
			end)
		end):andThen(function(t3: {[any]: any}) -- line: 57
			-- upvalues: v8 (copy)
			v8({
				licenseList = t3,
				initialLicense = t3[1],
				initialLicenseKey = if not t3[1] then nil else t3[1].key
			})
		end):catch(function(p1) -- line: 64
			warn("Failed to retrieve license data: ", p1)
		end)
	end, {})

	return v7
end

return useLicenseData
