local CorePackages = game:GetService("CorePackages")
local AvatarEditorService = game:GetService("AvatarEditorService")

local Promise = require(CorePackages.Packages.Promise)

return function(p)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return AvatarEditorService:GetBatchItemDetailsAsync(p, Enum.AvatarItemType.Asset)
		end)

		if not success then
			callback2()

			return
		end

		local namesById = {}

		for _, v in ipairs(result) do
			namesById[v.Id] = v.Name
		end

		callback(namesById)
	end)
end
