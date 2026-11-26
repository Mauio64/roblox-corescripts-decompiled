local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue

return function(p2)
	local keyPath = p2.keyPath
	return function(p3)
		local v5 = getDeepValue(p3, keyPath .. ".byContactId") or {}
		local result = {}

		for k, v6 in pairs(v5) do
			table.insert(result, {
				contactId = k,
				contactName = v6.contactName,
				headshotThumbnailUrl = v6.headshotThumbnailUrl,
				avatarThumbnailUrl = v6.avatarThumbnailUrl
			})
		end

		table.sort(result, function(a, b): boolean
			if a.contactName and b.contactName and a.contactName ~= b.contactName then
				return a.contactName < b.contactName
			end

			return a.contactId < b.contactId
		end)

		return result
	end
end
