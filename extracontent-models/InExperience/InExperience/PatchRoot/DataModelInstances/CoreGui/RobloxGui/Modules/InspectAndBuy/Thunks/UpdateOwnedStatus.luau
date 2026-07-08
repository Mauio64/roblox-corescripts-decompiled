local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Constants = require(ParentParent.Constants)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local SetBundles = require(ParentParent.Actions.SetBundles)
local SetAssets = require(ParentParent.Actions.SetAssets)

local function UpdateOwnedStatus(p1, p2) -- line: 12
	-- upvalues: Thunk (copy), Constants (copy), AssetInfo (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy)
	return Thunk.new(script.Name, {}, function(p3, _) -- line: 13
		-- upvalues: p2 (copy), Constants (copy), p1 (copy), AssetInfo (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy)
		local v13 = p3:getState()

		if p2 == Constants.ItemType.Asset then
			if v13.assets[p1] then
				local v14 = AssetInfo.fromPurchaseSuccess(p1)

				p3:dispatch(SetAssets({ v14 }))

				return
			end
		elseif p2 == Constants.ItemType.Bundle and v13.bundles[p1] then
			local v15 = BundleInfo.fromPurchaseSuccess(p1)

			p3:dispatch(SetBundles({ v15 }))
		end
	end)
end

return UpdateOwnedStatus
