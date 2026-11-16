local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/dMx")
local setAnimationPreview = require("@luauforge/bundled/dHL").Actions.SetAnimationPreview

local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useEffectOnMount
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local v5 = {
	{
		AssetType = module.AssetTypeIdStrings.IdleAnimation,
		Label = "Feature.Avatar.Label.Idle"
	},
	{
		AssetType = module.AssetTypeIdStrings.WalkAnimation,
		Label = "Feature.Avatar.Label.Walk"
	},
	{
		AssetType = module.AssetTypeIdStrings.RunAnimation,
		Label = "Feature.Avatar.Label.Run"
	},
	{
		AssetType = module.AssetTypeIdStrings.JumpAnimation,
		Label = "Feature.Avatar.Label.Jump"
	},
	{
		AssetType = module.AssetTypeIdStrings.FallAnimation,
		Label = "Feature.Avatar.Label.Fall"
	},
	{
		AssetType = module.AssetTypeIdStrings.ClimbAnimation,
		Label = "Feature.Avatar.Label.Climb"
	},
	{
		AssetType = module.AssetTypeIdStrings.SwimAnimation,
		Label = "Feature.Avatar.Label.Swim"
	}
}

local function getAssetIds(p2)
	local ids = {}

	if p2 and p2.items then
		for k, item in p2.items do
			if item.type == module.ItemType.Asset then
				ids[#ids + 1] = item.id
			end
		end
	end

	return ids
end

local function getAssetInfosByAssetType(p2, p3)
	local assetIds = getAssetIds(p3)

	local result = {}
	local flag = false

	for k, assetId in assetIds do
		local v6 = p2[assetId]

		if not (v6 and v6.assetType) then
			return nil
		end

		assert(v6.assetType, "silence type checker")
		result[v6.assetType] = v6
		flag = true
	end

	if flag then
		return result
	end

	return nil
end

local function selectAssetInfos(p2)
	return p2.AvatarExperience.Common.AssetInfos
end

local function useTryOnAvatarAnimations()
	local v6 = useDispatch()

	local state, setState = React.useState(0)
	local ref = React.useRef(false)
	local ref2 = React.useRef({})
	local ref3 = React.useRef(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)

	useEffectOnMount(function()
		return function()
			ref.current = false
		end
	end)

	local v7 = useSelector(React.useCallback(function(p2)
		if state2 and state3 then
			return itemData(p2.AvatarExperience.Common, state2, state3)
		end

		return nil
	end, { state2, state3 }), getUseSelectorDeepEquals())

	local v8 = useSelector(selectAssetInfos, getUseSelectorDeepEquals())

	React.useEffect(function()
		if v7 ~= nil then
			local assetInfosByAssetType = getAssetInfosByAssetType(v8, v7)

			if not tutils.deepEqual(assetInfosByAssetType, ref3.current) then
				ref3.current = assetInfosByAssetType

				if assetInfosByAssetType then
					local v9 = {}

					for k, v10 in v5 do
						if assetInfosByAssetType[v10.AssetType] then
							v9[#v9 + 1] = v10
						end
					end

					ref2.current = v9
				else
					ref2.current = {}
				end
			end
		end
	end, { v7, v8 })

	React.useEffect(function()
		if state > 0 and #ref2.current > 0 then
			local v9 = ref2.current[state]
			local v10

			if v9 and ref3.current and ref3.current[v9.AssetType] then
				v10 = ref3.current[v9.AssetType]
			end

			if v10 then
				v6(setAnimationPreview(v10.id, v9.AssetType))
			end
		end
	end, { state })

	return (React.useCallback(function(p2, p3, p4)
		setState2(p2)
		setState3(p3)

		if p4 == "2" and not ref.current then
			ref.current = true

			task.spawn(function()
				setState(function(p5)
					if p5 == 0 then
						return 1
					end

					return p5
				end)

				while ref.current do
					task.wait(2)

					setState(function(p5)
						local v9 = p5 + 1

						if #ref2.current < v9 then
							return 1
						end

						return v9
					end)
				end
			end)
		end
	end, {}))
end

return useTryOnAvatarAnimations
