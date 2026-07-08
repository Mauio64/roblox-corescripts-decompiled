local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local GetAssetFavoriteCount = require(ParentParent.Thunks.GetAssetFavoriteCount)
local GetBundleFavoriteCount = require(ParentParent.Thunks.GetBundleFavoriteCount)
local GotCurrentFavoriteCount = require(ParentParent.Selectors.GotCurrentFavoriteCount)
local getSelectionImageObjectRegular = require(ParentParent.getSelectionImageObjectRegular)
local v11 = Roact.PureComponent:extend("Favorites")

function v11.setText(p1) -- line: 22
	-- upvalues: UtilityFunctions (copy)
	local v13 = p1.props.assetInfo or {}
	local v14 = v13.parentBundleId ~= nil
	local bundleInfo = p1.props.bundleInfo

	if v14 then
		local v16 = UtilityFunctions.getBundleId(v13)

		if bundleInfo[v16] then
			p1.numFavorites = bundleInfo[v16].numFavorites

			return
		end
	elseif v13 then
		p1.numFavorites = v13.numFavorites
	end
end
function v11.init(p2) -- line: 38
	-- upvalues: getSelectionImageObjectRegular (copy)
	p2.numFavorites = ""
	p2.selectionImageObject = getSelectionImageObjectRegular()
end
function v11.willUpdate(p3, p4) -- line: 43
	-- upvalues: UtilityFunctions (copy)
	local getAssetFavoriteCount = p3.props.getAssetFavoriteCount
	local getBundleFavoriteCount = p3.props.getBundleFavoriteCount

	if p4.assetInfo then
		local assetInfo = p4.assetInfo
		local v23 = assetInfo.parentBundleId ~= nil

		if not p4.gotCurrentFavoriteCount then
			coroutine.wrap(function() -- line: 58
				-- upvalues: v23 (copy), getAssetFavoriteCount (copy), assetInfo (copy), UtilityFunctions (copy), getBundleFavoriteCount (copy)
				if not v23 then
					getAssetFavoriteCount(assetInfo.assetId)

					return
				end

				local v31 = UtilityFunctions.getBundleId(assetInfo)

				getBundleFavoriteCount(v31)
			end)()
		end
	end
end
function v11.render(p5) -- line: 70
	-- upvalues: Roact (copy), AppFonts (copy)
	p5:setText()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, 16)
	}, {
		FavoriteIcon = Roact.createElement("ImageButton", {
			Selectable = false,
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InspectMenu/ico_favorite.png",
			Size = UDim2.new(0, 16, 0, 16),
			SelectionImageObject = p5.selectionImageObject
		}),
		FavoriteText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextSize = 12,
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 21, 0, 0),
			Text = p5.numFavorites or "",
			Font = AppFonts.default:getDefault(),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1, 1, 1)
		})
	})
end
function v11.shouldUpdate(_, p7) -- line: 98
	if not p7.detailsInformation.viewingDetails then
		return false
	end

	return true
end

return RoactRodux.UNSTABLE_connect2(function(p8, _) -- line: 106
	-- upvalues: GotCurrentFavoriteCount (copy)
	local assetId = p8.detailsInformation.assetId

	return {
		detailsInformation = p8.detailsInformation,
		assetInfo = p8.assets[assetId],
		bundleInfo = p8.bundles,
		gotCurrentFavoriteCount = GotCurrentFavoriteCount(p8)
	}
end, function(p10) -- line: 115
	-- upvalues: GetAssetFavoriteCount (copy), GetBundleFavoriteCount (copy)
	return {
		getAssetFavoriteCount = function(p11) -- line: 117
			-- upvalues: p10 (copy), GetAssetFavoriteCount (copy)
			p10(GetAssetFavoriteCount(p11))
		end,
		getBundleFavoriteCount = function(p12) -- line: 120
			-- upvalues: p10 (copy), GetBundleFavoriteCount (copy)
			p10(GetBundleFavoriteCount(p12))
		end
	}
end)(v11)
