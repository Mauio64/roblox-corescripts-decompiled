local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)

local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local ContactImporterModalInfoUpdater = {}

function ContactImporterModalInfoUpdater.addSeenCount(_, object, p: string)
	if not engineFeature then
		return
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT)
	end)

	if success then
		local v = ""

		if result == "" then
			v = p .. ":1"
		else
			local v2 = false

			for k in string.gmatch(result or "", "([^,]+)") do
				local v3 = string.split(k, ":")
				local v4 = v3[1]
				local v5 = tonumber(v3[2]) or 0

				if v4 == p then
					v5 += 1
					v2 = true
				end

				local v6 = v4 .. ":" .. tostring(v5)

				if v == "" then
					v = v6
				else
					v ..= "," .. v6
				end
			end

			if not v2 then
				v ..= "," .. p .. ":1"
			end
		end

		pcall(function()
			object:SetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT, v)
			object:Flush()
		end)
	end
end

function ContactImporterModalInfoUpdater.updateTimestamp(_, object, p: string, p2: number)
	if not engineFeature then
		return
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP)
	end)

	if success then
		local v = ""

		if result == "" then
			v = p .. ":" .. tostring(p2)
		else
			local v2 = false

			for k in string.gmatch(result or "", "([^,]+)") do
				local v3 = string.split(k, ":")
				local v4 = v3[1]
				local v5 = v3[2]

				if v4 == p then
					v5 = tostring(p2)
					v2 = true
				end

				local v6 = v4 .. ":" .. tostring(v5)

				if v == "" then
					v = v6
				else
					v ..= "," .. v6
				end
			end

			if not v2 then
				v ..= "," .. p .. ":" .. tostring(p2)
			end
		end

		pcall(function()
			object:SetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP, v)
			object:Flush()
		end)
	end
end

return ContactImporterModalInfoUpdater
