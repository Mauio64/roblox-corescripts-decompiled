local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local SetEquippedAssets = require(ParentParent.Actions.SetEquippedAssets)
local Constants = require(ParentParent.Constants)
local GetAvatarPreview = require(ParentParent.Thunks.GetAvatarPreview)
local CorePackages = game:GetService("CorePackages")
local FFlagAXInspectAndBuyMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXInspectAndBuyMakeupSupport
local t1 = {}

local function getAssetIds(p1) -- line: 19
	-- upvalues: Constants (copy), AssetInfo (copy), FFlagAXInspectAndBuyMakeupSupport (copy)
	local t2 = {}
	local v14 = false

	for v15, v16 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToAccessoryTypeEnum[v15] == nil then
			local v17 = p1[v16] or ""
			local v18 = v15 == tostring(Enum.AssetType.Head.Value) or v15 == tostring(Enum.AssetType.DynamicHead.Value)

			if not v14 or not v18 then
				if v18 then
					v14 = true
				end

				for _, v20 in string.split(v17) do
					if tonumber(v20) and v20 ~= "0" then
						table.insert(t2, AssetInfo.fromHumanoidDescription(v20))
					end
				end
			end
		end
	end

	for _, v22 in (p1:GetAccessories(true)) do
		t2[#t2 + 1] = AssetInfo.fromHumanoidDescriptionAccessory(v22)
	end

	for _, v24 in (p1:GetEmotes()) do
		for _, v26 in v24 do
			t2[#t2 + 1] = AssetInfo.fromHumanoidDescription(v26)
		end
	end

	if FFlagAXInspectAndBuyMakeupSupport then
		for _, child in p1:GetChildren() do
			if child:IsA("MakeupDescription") and child.AssetId > 0 then
				t2[#t2 + 1] = AssetInfo.fromHumanoidDescription(child.AssetId)
			end
		end
	end

	return t2
end
local function GetAssetsFromHumanoidDescriptionV2(p2, p3) -- line: 83
	-- upvalues: Thunk (copy), t1 (copy), getAssetIds (copy), GetAvatarPreview (copy), SetEquippedAssets (copy)
	return Thunk.new(script.Name, t1, function(p4, _) -- line: 84
		-- upvalues: getAssetIds (copy), p2 (copy), p3 (copy), GetAvatarPreview (copy), SetEquippedAssets (copy)
		local v33 = getAssetIds(p2)

		if not p3 then
			p4:dispatch(GetAvatarPreview(v33))

			return
		end

		p4:dispatch(SetEquippedAssets(v33))
	end)
end

return GetAssetsFromHumanoidDescriptionV2
