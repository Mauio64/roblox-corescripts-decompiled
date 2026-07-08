local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)
local ParseContentIds = require(ParentParent.util.ParseContentIds)

require(ParentParent.util.Types)

local getFFlagUGCValidateAllowEmissives = require(ParentParent.flags.getFFlagUGCValidateAllowEmissives)

return {
	getData = function(p1) -- line: 11
		-- upvalues: Constants (copy), ParseContentIds (copy), getFFlagUGCValidateAllowEmissives (copy)
		local rootInstance = p1.rootInstance
		local t1 = {}
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v10 in descendants do
			local v11 = Constants.CONTENT_ID_FIELDS[v10.ClassName]

			if v11 then
				for _, v13 in v11 do
					local v14 = v10[v13]

					if v14 ~= "" then
						local v15 = ParseContentIds.tryGetAssetIdFromContentId(v14)

						if v15 ~= nil then
							if t1[v15] == nil then
								t1[v15] = {}
							end

							table.insert(t1[v15], {
								fieldName = v13,
								instance = v10
							})
						end
					end
				end

				if getFFlagUGCValidateAllowEmissives() then
					local v16 = Constants.CONTENT_FIELDS_WITHOUT_CONTENTID[v10.ClassName]

					if v16 then
						for _, v18 in v16 do
							local v19 = v10[v18]

							if v19.SourceType == Enum.ContentSourceType.Uri then
								local v20 = ParseContentIds.tryGetAssetIdFromContentId(v19.Uri)

								if v20 ~= nil then
									if t1[v20] == nil then
										t1[v20] = {}
									end

									table.insert(t1[v20], {
										fieldName = v18,
										instance = v10
									})
								end
							end
						end
					end
				end
			end
		end

		return t1
	end
}
