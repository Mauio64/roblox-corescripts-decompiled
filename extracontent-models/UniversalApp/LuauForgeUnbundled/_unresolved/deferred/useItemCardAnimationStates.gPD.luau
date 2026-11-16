local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local roactAnalytics = RoactServiceTags.RoactAnalytics
require("@luauforge/deferred/gkN")
local tutils = require(CorePackages.Packages.tutils)

local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/bundled/dLY")
local setAnimationPreview = require("@luauforge/bundled/dHL").Actions.SetAnimationPreview
local module5 = require("@luauforge/bundled/fuC")
require("@luauforge/bundled/dHK")
require("@luauforge/bundled/dMc")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local v5 = {
	module3.AssetTypeIdStrings.IdleAnimation,
	module3.AssetTypeIdStrings.WalkAnimation,
	module3.AssetTypeIdStrings.RunAnimation,
	module3.AssetTypeIdStrings.JumpAnimation,
	module3.AssetTypeIdStrings.FallAnimation,
	module3.AssetTypeIdStrings.ClimbAnimation,
	module3.AssetTypeIdStrings.SwimAnimation
}

local function getAssetIds(p2)
	local ids = {}

	if p2.items then
		for k, item in p2.items do
			if item.type == module3.ItemType.Asset then
				table.insert(ids, item.id)
			end
		end
	end

	return ids
end

local function getAssetInfoByAssetType(assetInfos, items)
	local result = {}

	for k, item in items do
		local v6 = assetInfos[item]

		if v6 and v6.assetType then
			result[v6.assetType] = v6
		else
			return nil
		end
	end

	return result
end

local function getItemAnimationAssetTypes(p2)
	local itemAnimationAssetTypes = {}

	for k, v6 in v5 do
		if p2[v6] then
			table.insert(itemAnimationAssetTypes, v6)
		end
	end

	return itemAnimationAssetTypes
end

local function selectAssetInfosByAssetType(p2, p3)
	return getAssetInfoByAssetType(p2.AvatarExperience.Common.AssetInfos, p3)
end

local function useItemCardAnimationStates(p2)
	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(roactAnalytics)
	local v10 = useLocalization({
		[module3.AssetTypeIdStrings.IdleAnimation] = "Feature.Avatar.Label.Idle",
		[module3.AssetTypeIdStrings.WalkAnimation] = "Feature.Avatar.Label.Walk",
		[module3.AssetTypeIdStrings.RunAnimation] = "Feature.Avatar.Label.Run",
		[module3.AssetTypeIdStrings.JumpAnimation] = "Feature.Avatar.Label.Jump",
		[module3.AssetTypeIdStrings.FallAnimation] = "Feature.Avatar.Label.Fall",
		[module3.AssetTypeIdStrings.ClimbAnimation] = "Feature.Avatar.Label.Climb",
		[module3.AssetTypeIdStrings.SwimAnimation] = "Feature.Avatar.Label.Swim"
	})

	local v11 = useDispatch()
	local state, setState = React.useState(1)

	local v12 = React.useMemo(function()
		return getAssetIds(p2)
	end, { p2 })

	local v13 = useSelector(React.useCallback(function(p3)
		return getAssetInfoByAssetType(p3.AvatarExperience.Common.AssetInfos, v12)
	end, { v12 }), tutils.deepEqual)

	local v14 = React.useMemo(function()
		local v15 = v13 or {}
		local result = {}

		for k, v16 in v5 do
			if v15[v16] then
				table.insert(result, v16)
			end
		end

		return result
	end, { v13 })

	local v15 = v14[state]

	local v16 = if v15 and v13 then v13[v15] else nil

	local id = if v16 then v16.id else nil

	React.useEffect(function()
		if id and v15 then
			v11(setAnimationPreview(id, v15))
		end

		return function()
			v11(module4())
		end
	end, { v11, id, v15 })

	local count = #v14
	React.useEffect(function()
		local heartbeatConnection

		if count == 0 then
			heartbeatConnection = nil
		else
			setState(1)
			local v17 = 0
			local RunService = game:GetService("RunService")
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				v17 += dt

				if v17 > 2 then
					v17 -= 2
					setState(function(p3)
						return p3 % count + 1
					end)
				end
			end)
		end

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end
	end, { count })

	React.useEffect(function()
		for k, v17 in v12 do
			v11(module5(v6, v7, v17, module3.ItemType.Asset))
		end
	end, { v6, v7, v12, v11 })

	return {
		states = React.useMemo(function()
			local result = {}

			for k, v17 in v14 do
				table.insert(result, {
					isSelected = v17 == v15,
					text = v10[v17]
				})
			end

			return result
		end, { v15, v14, v10 })
	}
end

return useItemCardAnimationStates
