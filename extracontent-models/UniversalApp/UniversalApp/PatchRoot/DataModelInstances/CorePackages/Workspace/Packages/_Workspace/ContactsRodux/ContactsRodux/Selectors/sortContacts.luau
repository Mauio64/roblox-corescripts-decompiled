local ParentParent = script.Parent.Parent.Parent
local getDeepValue = require(ParentParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue

return function(p1) -- line: 6
	-- upvalues: getDeepValue (copy)
	local keyPath = p1.keyPath

	return function(p2) -- line: 8
		-- upvalues: getDeepValue (copy), keyPath (copy)
		local v6 = getDeepValue(p2, keyPath .. ".byContactId") or {}
		local t1 = {}

		for k, v in pairs(v6) do
			table.insert(t1, {
				contactId = k,
				contactName = v.contactName,
				headshotThumbnailUrl = v.headshotThumbnailUrl,
				avatarThumbnailUrl = v.avatarThumbnailUrl
			})
		end

		table.sort(t1, function(p3, p4) -- line: 20
			if p3.contactName and (p4.contactName and p3.contactName ~= p4.contactName) then
				return p3.contactName < p4.contactName
			end

			return p3.contactId < p4.contactId
		end)

		return t1
	end
end
