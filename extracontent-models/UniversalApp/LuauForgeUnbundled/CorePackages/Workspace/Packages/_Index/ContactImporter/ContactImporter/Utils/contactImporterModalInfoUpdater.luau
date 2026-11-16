local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")

local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	addSeenCount = function(self, object, p3)
		if not engineFeature then
			return
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT)
		end)

		if success then
			local v5 = ""

			if result == "" then
				v5 = p3 .. ":1"
			else
				local v6 = false

				for k in string.gmatch(result or "", "([^,]+)") do
					local v7 = string.split(k, ":")
					local v8 = v7[1]
					local v9 = tonumber(v7[2]) or 0

					if v8 == p3 then
						v9 += 1
						v6 = true
					end

					local v10 = v8 .. ":" .. tostring(v9)
					v5 = if v5 == "" then v10 else v5 .. "," .. v10
				end

				if not v6 then
					v5 ..= "," .. p3 .. ":1"
				end
			end

			pcall(function()
				object:SetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT, v5)
				object:Flush()
			end)
		end
	end,
	updateTimestamp = function(self, object, p3, p4)
		if not engineFeature then
			return
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP)
		end)

		if success then
			local v5 = ""

			if result == "" then
				v5 = p3 .. ":" .. tostring(p4)
			else
				local v6 = false

				for k in string.gmatch(result or "", "([^,]+)") do
					local v7 = string.split(k, ":")
					local v8 = v7[1]
					local v9 = v7[2]

					if v8 == p3 then
						v9 = tostring(p4)
						v6 = true
					end

					local v10 = v8 .. ":" .. tostring(v9)
					v5 = if v5 == "" then v10 else v5 .. "," .. v10
				end

				if not v6 then
					v5 ..= "," .. p3 .. ":" .. tostring(p4)
				end
			end

			pcall(function()
				object:SetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP, v5)
				object:Flush()
			end)
		end
	end
}
