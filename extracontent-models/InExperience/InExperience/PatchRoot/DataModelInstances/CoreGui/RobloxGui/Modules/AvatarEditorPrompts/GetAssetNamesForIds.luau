local CorePackages = game:GetService("CorePackages")
local AvatarEditorService = game:GetService("AvatarEditorService")
local Promise = require(CorePackages.Packages.Promise)

return function(p1) -- line: 6
	-- upvalues: Promise (copy), AvatarEditorService (copy)
	return Promise.new(function(resolve, reject) -- line: 7
		-- upvalues: AvatarEditorService (copy), p1 (copy)
		local ok, result = pcall(function() -- line: 8
			-- upvalues: AvatarEditorService (copy), p1 (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return AvatarEditorService:GetBatchItemDetailsAsync(p1, Enum.AvatarItemType.Asset)
			end

			return AvatarEditorService:GetBatchItemDetails(p1, Enum.AvatarItemType.Asset)
		end)

		if ok then
			local t1 = {}

			for _, v in ipairs(result) do
				t1[v.Id] = v.Name
			end

			resolve(t1)

			return
		end

		reject()
	end)
end
