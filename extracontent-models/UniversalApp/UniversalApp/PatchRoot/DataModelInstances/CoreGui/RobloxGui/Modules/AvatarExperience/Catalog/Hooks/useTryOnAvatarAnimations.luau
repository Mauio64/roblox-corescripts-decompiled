local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetAnimationPreview = require(Modules.AvatarExperience.Common.Actions.SetAnimationPreview)
local useEffectOnMount = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useEffectOnMount
local tutils = require(CorePackages.Packages.tutils)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local t1 = {
	{
		Label = "Feature.Avatar.Label.Idle",
		AssetType = Constants.AssetTypeIdStrings.IdleAnimation
	},
	{
		Label = "Feature.Avatar.Label.Walk",
		AssetType = Constants.AssetTypeIdStrings.WalkAnimation
	},
	{
		Label = "Feature.Avatar.Label.Run",
		AssetType = Constants.AssetTypeIdStrings.RunAnimation
	},
	{
		Label = "Feature.Avatar.Label.Jump",
		AssetType = Constants.AssetTypeIdStrings.JumpAnimation
	},
	{
		Label = "Feature.Avatar.Label.Fall",
		AssetType = Constants.AssetTypeIdStrings.FallAnimation
	},
	{
		Label = "Feature.Avatar.Label.Climb",
		AssetType = Constants.AssetTypeIdStrings.ClimbAnimation
	},
	{
		Label = "Feature.Avatar.Label.Swim",
		AssetType = Constants.AssetTypeIdStrings.SwimAnimation
	}
}

local function getAssetIds(p1) -- line: 74
	-- upvalues: Constants (copy)
	local t2 = {}

	if p1 and p1.items then
		for _, v20 in p1.items do
			if v20.type == Constants.ItemType.Asset then
				t2[#t2 + 1] = v20.id
			end
		end
	end

	return t2
end
local function getAssetInfosByAssetType(p2, p3) -- line: 88
	-- upvalues: getAssetIds (copy)
	local t3 = {}
	local v24 = false

	for _, v26 in (getAssetIds(p3)) do
		local v27 = p2[v26]

		if not v27 then
			return nil
		end

		if not v27.assetType then
			return nil
		end

		assert(v27.assetType, "silence type checker")
		t3[v27.assetType] = v27
		v24 = true
	end

	if v24 then
		return t3
	end

	return nil
end
local function selectAssetInfos(p4) -- line: 113
	return p4.AvatarExperience.Common.AssetInfos
end
local function useTryOnAvatarAnimations() -- line: 117
	-- upvalues: useDispatch (copy), React (copy), useEffectOnMount (copy), ItemData (copy), useSelector (copy), getUseSelectorDeepEquals (copy), selectAssetInfos (copy), getAssetInfosByAssetType (copy), tutils (copy), t1 (copy), SetAnimationPreview (copy)
	local v29 = useDispatch()
	local v30, v31 = React.useState(0)
	local v32 = React.useRef(false)
	local v33 = React.useRef({})
	local v34 = React.useRef(nil)
	local v35, v36 = React.useState(nil)
	local v37, v38 = React.useState(nil)

	useEffectOnMount(function() -- line: 127
		-- upvalues: v32 (copy)
		return function() -- line: 128
			-- upvalues: v32 (copy)
			v32.current = false
		end
	end)

	local v39 = React.useCallback(function(p5) -- line: 134
		-- upvalues: v35 (copy), v37 (copy), ItemData (copy)
		if not v35 or not v37 then
			return nil
		end

		return ItemData(p5.AvatarExperience.Common, v35, v37)
	end, {
		v35,
		v37
	})
	local v40 = useSelector(v39, getUseSelectorDeepEquals())
	local v41 = useSelector(selectAssetInfos, getUseSelectorDeepEquals())

	React.useEffect(function() -- line: 145
		-- upvalues: v40 (copy), getAssetInfosByAssetType (copy), v41 (copy), tutils (copy), v34 (copy), t1 (copy), v33 (copy)
		if v40 ~= nil then
			local v43 = getAssetInfosByAssetType(v41, v40)

			if not tutils.deepEqual(v43, v34.current) then
				v34.current = v43

				if v43 then
					local t4 = {}

					for _, v46 in t1 do
						if v43[v46.AssetType] then
							t4[#t4 + 1] = v46
						end
					end

					v33.current = t4

					return
				end

				v33.current = {}
			end
		end
	end, {
		v40,
		v41
	})
	React.useEffect(function() -- line: 169
		-- upvalues: v30 (copy), v33 (copy), v34 (copy), v29 (copy), SetAnimationPreview (copy)
		if v30 > 0 and #v33.current > 0 then
			local v47 = v33.current[v30]
			local v48 = if not v47 or (not v34.current or not v34.current[v47.AssetType]) then nil else v34.current[v47.AssetType]

			if v48 then
				v29(SetAnimationPreview(v48.id, v47.AssetType))
			end
		end
	end, { v30 })

	return (React.useCallback(function(p6, p7, p8) -- line: 184
		-- upvalues: v36 (copy), v38 (copy), v32 (copy), v31 (copy), v33 (copy)
		v36(p6)
		v38(p7)

		if p8 == "2" and not v32.current then
			v32.current = true
			task.spawn(function() -- line: 193
				-- upvalues: v31 (copy), v32 (copy), v33 (copy)
				v31(function(p9) -- line: 194
					if p9 == 0 then
						return 1
					end

					return p9
				end)

				while v32.current do
					task.wait(2)
					v31(function(p10) -- line: 204
						-- upvalues: v33 (copy)
						local v54 = p10 + 1

						if v54 > #v33.current then
							return 1
						end

						return v54
					end)
				end
			end)
		end
	end, {}))
end

return useTryOnAvatarAnimations
