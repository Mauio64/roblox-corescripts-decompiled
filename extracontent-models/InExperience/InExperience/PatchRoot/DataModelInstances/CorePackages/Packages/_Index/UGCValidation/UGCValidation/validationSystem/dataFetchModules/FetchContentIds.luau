local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
local ParseContentIds = require(parent.util.ParseContentIds)
require(parent.util.Types)

local getFFlagUGCValidateVersionedContentIds = require(parent.flags.getFFlagUGCValidateVersionedContentIds)

return {
	getData = function(p)
		local rootInstance = p.rootInstance

		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)
		local data = {}

		for _, descendant in descendants do
			local v = Constants.CONTENT_ID_FIELDS[descendant.ClassName]

			if not v then
				continue
			end

			for _, fieldName in v do
				local v2 = descendant[fieldName]

				if v2 == "" then
					continue
				end

				local version = nil
				local v3

				if getFFlagUGCValidateVersionedContentIds() then
					v3, version = ParseContentIds.tryParseContentId(v2)
				else
					v3 = ParseContentIds.tryGetAssetIdFromContentId(v2)
				end

				if v3 == nil then
					continue
				end

				if data[v3] == nil then
					data[v3] = {}
				end

				table.insert(data[v3], {
					fieldName = fieldName,
					instance = descendant,
					version = version
				})
			end

			local v2 = Constants.CONTENT_FIELDS_WITHOUT_CONTENTID[descendant.ClassName]

			if not v2 then
				continue
			end

			for _, fieldName in v2 do
				local v3 = descendant[fieldName]

				if v3.SourceType ~= Enum.ContentSourceType.Uri then
					continue
				end

				local version = nil
				local v4

				if getFFlagUGCValidateVersionedContentIds() then
					v4, version = ParseContentIds.tryParseContentId(v3.Uri)
				else
					v4 = ParseContentIds.tryGetAssetIdFromContentId(v3.Uri)
				end

				if v4 == nil then
					continue
				end

				if data[v4] == nil then
					data[v4] = {}
				end

				table.insert(data[v4], {
					fieldName = fieldName,
					instance = descendant,
					version = version
				})
			end
		end

		return data
	end
}
