require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local isCanonicalNonzeroUuid = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/isCanonicalNonzeroUuid")

return {
	resolveEmoteIdForReaction = function(items, value)
		local v5 = string.gsub(string.lower(value), "%-", "")
		local v6 = v5 == "crying" and "cry" or v5

		for k, item in items do
			if item.id == value then
				return item.id
			end

			local name = item.name
			local v7 = string.gsub(string.lower(name), "%-", "")

			if (v7 == "crying" and "cry" or v7) == v6 then
				return item.id
			end
		end

		return value
	end,
	resolveOptionalEmoteIdForReaction = function(items, value)
		local v5 = string.gsub(string.lower(value), "%-", "")
		local v6 = v5 == "crying" and "cry" or v5

		for k, item in items do
			local name = item.name
			local v7 = string.gsub(string.lower(name), "%-", "")

			if (v7 == "crying" and "cry" or v7) == v6 and isCanonicalNonzeroUuid(item.id) then
				return item.id
			end
		end

		return nil
	end,
	reactionTypeForEmoteId = function(items, p2)
		for k, item in items do
			if item.id == p2 then
				local name = item.name
				local v5 = string.gsub(string.lower(name), "%-", "")

				if v5 == "crying" then
					return "cry"
				end

				return v5
			end
		end

		return p2
	end,
	normalizeName = function(value)
		local v5 = string.gsub(string.lower(value), "%-", "")

		if v5 == "crying" then
			return "cry"
		end

		return v5
	end
}
