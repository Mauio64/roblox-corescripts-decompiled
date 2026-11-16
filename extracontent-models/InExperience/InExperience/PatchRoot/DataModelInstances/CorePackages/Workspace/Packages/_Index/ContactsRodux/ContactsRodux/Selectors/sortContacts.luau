local parent = script.Parent.Parent.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

return function(p)
	local keyPath = p.keyPath
	return function(p2)
		local v = getDeepValue(p2, keyPath .. ".byContactId") or {}
		local result = {}

		for k, v2 in pairs(v) do
			table.insert(result, {
				contactId = k,
				contactName = v2.contactName,
				headshotThumbnailUrl = v2.headshotThumbnailUrl,
				avatarThumbnailUrl = v2.avatarThumbnailUrl
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
