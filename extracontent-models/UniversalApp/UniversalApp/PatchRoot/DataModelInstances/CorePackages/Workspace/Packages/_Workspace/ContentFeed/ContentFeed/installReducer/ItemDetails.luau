local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local Cryo = require(ParentParentParent.Cryo)
local NetworkingCurrentlyWearing = require(ParentParent.App.Networking).NetworkingCurrentlyWearing
local getAssetInfo = require(ParentParent.Utils.getAssetInfo)

return Rodux.createReducer({}, {
	[NetworkingCurrentlyWearing.GetItemDetails.Succeeded.name] = function(p1, p2) -- line: 15
		-- upvalues: getAssetInfo (copy), Cryo (copy)
		local t1 = {}

		for _, v11 in p2.responseBody.data do
			local v12 = getAssetInfo.fromAsset(v11)

			t1[v12.id] = v12
		end

		return Cryo.Dictionary.join(p1, t1)
	end
})
