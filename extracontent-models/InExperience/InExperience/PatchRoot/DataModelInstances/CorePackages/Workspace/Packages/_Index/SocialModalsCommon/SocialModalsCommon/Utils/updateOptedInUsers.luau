local Constants = require(script.Parent.Parent.Constants)
local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local UpdateOptedInUsers = {}

function UpdateOptedInUsers.clearLocalStorage(_, object)
	if not engineFeature then
		return
	end

	pcall(function()
		object:SetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS, "")
		object:Flush()
	end)
end

function UpdateOptedInUsers.addUserToLocalStorage(_, object, p)
	if not engineFeature then
		return
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS)
	end)

	if success then
		local v = { p }

		if result ~= nil and result ~= "" then
			local v2 = #v + 1

			for k in string.gmatch(result, "([^,]+)") do
				if k == p then
					return
				end

				v[v2] = k
				v2 += 1
			end
		end

		local v2 = table.concat(v, ","):gsub("%s+", "")
		pcall(function()
			object:SetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS, v2)
			object:Flush()
		end)
	end
end

return UpdateOptedInUsers
