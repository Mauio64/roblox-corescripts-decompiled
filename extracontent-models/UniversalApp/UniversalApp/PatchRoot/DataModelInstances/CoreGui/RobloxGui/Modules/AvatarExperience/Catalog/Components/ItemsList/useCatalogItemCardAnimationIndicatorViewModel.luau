local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics

require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)

local tutils = require(CorePackages.Packages.tutils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ClearAnimationPreview = require(Modules.AvatarExperience.Common.Actions.ClearAnimationPreview)
local SetAnimationPreview = require(Modules.AvatarExperience.Common.Actions.SetAnimationPreview)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local t1 = {
	Constants.AssetTypeIdStrings.IdleAnimation,
	Constants.AssetTypeIdStrings.WalkAnimation,
	Constants.AssetTypeIdStrings.RunAnimation,
	Constants.AssetTypeIdStrings.JumpAnimation,
	Constants.AssetTypeIdStrings.FallAnimation,
	Constants.AssetTypeIdStrings.ClimbAnimation,
	Constants.AssetTypeIdStrings.SwimAnimation
}

local function getAssetIds(p1) -- line: 43
	-- upvalues: Constants (copy)
	local t2 = {}

	if p1.items then
		for _, v26 in p1.items do
			if v26.type == Constants.ItemType.Asset then
				table.insert(t2, v26.id)
			end
		end
	end

	return t2
end
local function getAssetInfoByAssetType(t3: {[any]: any}, t4: {[any]: any}) -- line: 56
	local t5 = {}

	for _, v31 in t4 do
		local v32 = t3[v31]

		if not v32 or not v32.assetType then
			return nil
		end

		t5[v32.assetType] = v32
	end

	return t5
end
local function getItemAnimationAssetTypes(t6: {[any]: any}) -- line: 73
	-- upvalues: t1 (copy)
	local t7 = {}

	for _, v36 in t1 do
		if t6[v36] then
			table.insert(t7, v36)
		end
	end

	return t7
end
local function selectAssetInfosByAssetType(p2, t8: {[any]: any}) -- line: 83
	-- upvalues: getAssetInfoByAssetType (copy)
	local AssetInfos = p2.AvatarExperience.Common.AssetInfos

	return (getAssetInfoByAssetType(AssetInfos, t8))
end
local function useItemCardAnimationStates(p3) -- line: 88
	-- upvalues: useRoactService (copy), RoactNetworking (copy), RoactAnalytics (copy), useLocalization (copy), Constants (copy), useDispatch (copy), React (copy), getAssetIds (copy), getAssetInfoByAssetType (copy), useSelector (copy), tutils (copy), t1 (copy), SetAnimationPreview (copy), ClearAnimationPreview (copy), FetchAssetOrBundleInfo (copy)
	local v41 = useRoactService(RoactNetworking)
	local v42 = useRoactService(RoactAnalytics)
	local v43 = useLocalization({
		[Constants.AssetTypeIdStrings.IdleAnimation] = "Feature.Avatar.Label.Idle",
		[Constants.AssetTypeIdStrings.WalkAnimation] = "Feature.Avatar.Label.Walk",
		[Constants.AssetTypeIdStrings.RunAnimation] = "Feature.Avatar.Label.Run",
		[Constants.AssetTypeIdStrings.JumpAnimation] = "Feature.Avatar.Label.Jump",
		[Constants.AssetTypeIdStrings.FallAnimation] = "Feature.Avatar.Label.Fall",
		[Constants.AssetTypeIdStrings.ClimbAnimation] = "Feature.Avatar.Label.Climb",
		[Constants.AssetTypeIdStrings.SwimAnimation] = "Feature.Avatar.Label.Swim"
	})
	local v44 = useDispatch()
	local v45, v46 = React.useState(1)
	local v47 = React.useMemo(function() -- line: 104
		-- upvalues: getAssetIds (copy), p3 (copy)
		return (getAssetIds(p3))
	end, { p3 })
	local v48 = React.useCallback(function(p4) -- line: 108
		-- upvalues: v47 (copy), getAssetInfoByAssetType (copy)
		local v56 = v47
		local AssetInfos = p4.AvatarExperience.Common.AssetInfos

		return (getAssetInfoByAssetType(AssetInfos, v56))
	end, { v47 })
	local v49 = useSelector(v48, tutils.deepEqual)
	local v50 = React.useMemo(function() -- line: 114
		-- upvalues: v49 (copy), t1 (copy)
		local v58 = v49 or {}
		local t9 = {}

		for _, v61 in t1 do
			if v58[v61] then
				table.insert(t9, v61)
			end
		end

		return t9
	end, { v49 })
	local v51 = v50[v45]
	local v52 = if not v51 or not v49 then nil else v49[v51]
	local v53 = if not v52 then nil else v52.id

	React.useEffect(function() -- line: 124
		-- upvalues: v53 (copy), v51 (copy), v44 (copy), SetAnimationPreview (copy), ClearAnimationPreview (copy)
		if v53 and v51 then
			v44(SetAnimationPreview(v53, v51))
		end

		return function() -- line: 128
			-- upvalues: v44 (copy), ClearAnimationPreview (copy)
			v44(ClearAnimationPreview())
		end
	end, {
		v44,
		v53,
		v51
	})

	local v54 = #v50

	React.useEffect(function() -- line: 134
		-- upvalues: v54 (copy), v46 (copy)
		local connection = nil

		if v54 ~= 0 then
			v46(1)

			local n1 = 0

			connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 139
				-- upvalues: n1 (ref), v46 (copy), v54 (copy)
				n1 += dt

				if n1 > 2 then
					n1 -= 2
					v46(function(p5) -- line: 143
						-- upvalues: v54 (copy)
						return p5 % v54 + 1
					end)
				end
			end)
		end

		return function() -- line: 149
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v54 })
	React.useEffect(function() -- line: 156
		-- upvalues: v47 (copy), v44 (copy), FetchAssetOrBundleInfo (copy), v41 (copy), v42 (copy), Constants (copy)
		for _, v65 in v47 do
			v44(FetchAssetOrBundleInfo(v41, v42, v65, Constants.ItemType.Asset))
		end
	end, {
		v41,
		v42,
		v47,
		v44
	})

	return {
		states = React.useMemo(function() -- line: 162
			-- upvalues: v50 (copy), v51 (copy), v43 (copy)
			local t10 = {}

			for _, v68 in v50 do
				table.insert(t10, {
					isSelected = v68 == v51,
					text = v43[v68]
				})
			end

			return t10
		end, {
			v51,
			v50,
			v43
		})
	}
end

return useItemCardAnimationStates
