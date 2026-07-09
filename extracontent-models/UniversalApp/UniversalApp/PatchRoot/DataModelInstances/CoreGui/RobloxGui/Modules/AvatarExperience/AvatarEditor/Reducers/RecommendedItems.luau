local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SetRecommendedItemsV2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRecommendedItemsV2)
local ReducerUtils = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Utils.ReducerUtils
local GetFFlagAXEnableRecommendationTypeAllInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableRecommendationTypeAllInCustomize)

return Rodux.createReducer({}, {
	[SetRecommendedItemsV2.name] = function(p1, p2) -- line: 20
		-- upvalues: GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), ArgCheck (copy), ReducerUtils (copy), Cryo (copy)
		if GetFFlagAXEnableRecommendationTypeAllInCustomize() then
			ArgCheck.isType(p2.recommendationsType, "string", "recommendationsType must be a string.")
			ArgCheck.isType(p2.itemTypeId, "string", "itemTypeId must be a string.")
			ArgCheck.isType(p2.items, "table", "items data must be a table.")

			local v11 = ReducerUtils.generateRecommendedItemsKey(p2.itemTypeId, p2.recommendationsType)
			local t1 = {}

			for _, v14 in p2.items do
				local id = v14.id
				local itemType = v14.itemType

				if id and itemType then
					table.insert(t1, {
						itemId = tostring(id),
						itemType = itemType
					})
				end
			end

			return Cryo.Dictionary.join(p1, {
				[v11] = t1
			})
		end

		ArgCheck.isType(p2.itemTypeId, "string", "itemTypeId must be a string.")
		ArgCheck.isType(p2.items, "table", "items data must be a table.")

		local itemTypeId = p2.itemTypeId
		local t2 = {}

		for _, v20 in p2.items do
			local id = v20.id

			if id then
				t2[#t2 + 1] = tostring(id)
			end
		end

		return Cryo.Dictionary.join(p1, {
			[itemTypeId] = t2
		})
	end
})
