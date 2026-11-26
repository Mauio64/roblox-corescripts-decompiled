local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialModalsCommon/SocialModalsCommon/Constants")
local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	clearLocalStorage = function(p2, object)
		if not engineFeature then
			return
		end

		pcall(function()
			object:SetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS, "")
			object:Flush()
		end)
	end,
	addUserToLocalStorage = function(self, object, p3)
		if not engineFeature then
			return
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS)
		end)

		if success then
			local v5 = { p3 }

			if result ~= nil and result ~= "" then
				local v6 = #v5 + 1

				for k in string.gmatch(result, "([^,]+)") do
					if k == p3 then
						return
					end

					v5[v6] = k
					v6 += 1
				end
			end

			local v6 = table.concat(v5, ","):gsub("%s+", "")
			pcall(function()
				object:SetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS, v6)
				object:Flush()
			end)
		end
	end
}
