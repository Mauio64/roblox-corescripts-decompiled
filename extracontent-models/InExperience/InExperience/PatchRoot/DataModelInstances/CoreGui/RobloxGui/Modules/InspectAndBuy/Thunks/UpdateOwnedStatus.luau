local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Constants = require(parent.Constants)
local BundleInfo = require(parent.Models.BundleInfo)
local AssetInfo = require(parent.Models.AssetInfo)
local SetBundles = require(parent.Actions.SetBundles)
local SetAssets = require(parent.Actions.SetAssets)

local function UpdateOwnedStatus(p, p2)
	return Thunk.new(script.Name, {}, function(object, _)
		local state = object:getState()

		if p2 == Constants.ItemType.Asset then
			if state.assets[p] then
				object:dispatch(SetAssets({ (AssetInfo.fromPurchaseSuccess(p)) }))
			end
		elseif p2 == Constants.ItemType.Bundle and state.bundles[p] then
			object:dispatch(SetBundles({ (BundleInfo.fromPurchaseSuccess(p)) }))
		end
	end)
end

return UpdateOwnedStatus
