local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)
local CreateFavoriteForAsset = require(ParentParent.Thunks.CreateFavoriteForAsset)
local DeleteFavoriteForAsset = require(ParentParent.Thunks.DeleteFavoriteForAsset)
local CreateFavoriteForBundle = require(ParentParent.Thunks.CreateFavoriteForBundle)
local DeleteFavoriteForBundle = require(ParentParent.Thunks.DeleteFavoriteForBundle)
local GetFavoriteForAsset = require(ParentParent.Thunks.GetFavoriteForAsset)
local GetFavoriteForBundle = require(ParentParent.Thunks.GetFavoriteForBundle)
local GotFavoriteForDetailsItem = require(ParentParent.Selectors.GotFavoriteForDetailsItem)
local IsDetailsItemPartOfBundleAndOffsale = require(ParentParent.Selectors.IsDetailsItemPartOfBundleAndOffsale)
local GetIsFavorite = require(ParentParent.Selectors.GetIsFavorite)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local getSelectionImageObjectRounded = require(ParentParent.getSelectionImageObjectRounded)
local Favorite = require(script.Parent.Common.ControllerShortcutKeycodes).Favorite
local v19 = Roact.PureComponent:extend("FavoritesButton")

function v19.init(p1) -- line: 28
	-- upvalues: getSelectionImageObjectRounded (copy), ContextActionService (copy), Favorite (copy)
	p1.selectedImage = getSelectionImageObjectRounded()
	p1.fetchFavoriteRetries = 0
	ContextActionService:BindCoreAction("FavoriteGamepadShortcut", function(_, p3, _) -- line: 32
		-- upvalues: p1 (copy)
		if p3 == Enum.UserInputState.End then
			p1:activateButton()

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, Favorite)
end
function v19.willUpdate(p5, p6) -- line: 41
	-- upvalues: UtilityFunctions (copy)
	local gotFavoriteForDetailsItem = p6.gotFavoriteForDetailsItem
	local getFavoriteForAsset = p5.props.getFavoriteForAsset
	local getFavoriteForBundle = p5.props.getFavoriteForBundle

	if p6 and (p6.assetInfo and (not gotFavoriteForDetailsItem and p5.fetchFavoriteRetries < 10)) then
		local assetInfo = p6.assetInfo
		local v27 = assetInfo and assetInfo.parentBundleId ~= nil

		coroutine.wrap(function() -- line: 55
			-- upvalues: v27 (copy), getFavoriteForAsset (copy), assetInfo (copy), UtilityFunctions (copy), getFavoriteForBundle (copy)
			if not v27 then
				getFavoriteForAsset(assetInfo.assetId)

				return
			end

			local v47 = UtilityFunctions.getBundleId(assetInfo)

			getFavoriteForBundle(v47)
		end)()
		p5.fetchFavoriteRetries = p5.fetchFavoriteRetries + 1
	end
end
function v19.activateButton(p7) -- line: 67
	-- upvalues: UtilityFunctions (copy)
	local isFavorited = p7.props.isFavorited
	local IsDetailsItemPartOfBundleAndOffsale2 = p7.props.IsDetailsItemPartOfBundleAndOffsale
	local createFavoriteForAsset = p7.props.createFavoriteForAsset
	local deleteFavoriteForAsset = p7.props.deleteFavoriteForAsset
	local createFavoriteForBundle = p7.props.createFavoriteForBundle
	local deleteFavoriteForBundle = p7.props.deleteFavoriteForBundle
	local assetInfo = p7.props.assetInfo

	if isFavorited then
		if IsDetailsItemPartOfBundleAndOffsale2 then
			deleteFavoriteForBundle((UtilityFunctions.getBundleId(assetInfo)))

			return
		end

		deleteFavoriteForAsset(assetInfo.assetId)

		return
	end

	if IsDetailsItemPartOfBundleAndOffsale2 then
		createFavoriteForBundle((UtilityFunctions.getBundleId(assetInfo)))

		return
	end

	createFavoriteForAsset(assetInfo.assetId)
end
function v19.willUnmount(_) -- line: 93
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("FavoriteGamepadShortcut")
end
function v19.render(p9) -- line: 97
	-- upvalues: Roact (copy), Colors (copy)
	local isFavorited = p9.props.isFavorited
	local favoriteButtonRef = p9.props.favoriteButtonRef

	return Roact.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 44, 0, 44),
		LayoutOrder = 1,
		Image = "rbxasset://textures/ui/InspectMenu/Button_outline.png",
		ImageColor3 = Colors.White,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(5, 5, 120, 20),
		SelectionImageObject = p9.selectedImage,
		Visible = true,
		[Roact.Ref] = favoriteButtonRef,
		[Roact.Event.Activated] = function() -- line: 114
			-- upvalues: p9 (copy)
			p9:activateButton()
		end
	}, {
		FavoriteIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 26, 0, 26),
			Position = UDim2.new(0, 22, 0, 22),
			Image = not isFavorited and "rbxasset://textures/ui/InspectMenu/ico_favorite_off.png" or "rbxasset://textures/ui/InspectMenu/ico_favorite.png",
			ImageColor3 = Colors.White
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p10, _) -- line: 129
	-- upvalues: GotFavoriteForDetailsItem (copy), GetIsFavorite (copy), IsDetailsItemPartOfBundleAndOffsale (copy)
	local assetId = p10.detailsInformation.assetId

	return {
		view = p10.view,
		assetInfo = p10.assets[assetId],
		bundleInfo = p10.bundles,
		gotFavoriteForDetailsItem = GotFavoriteForDetailsItem(p10),
		isFavorited = GetIsFavorite(p10),
		IsDetailsItemPartOfBundleAndOffsale = IsDetailsItemPartOfBundleAndOffsale(p10)
	}
end, function(p12) -- line: 140
	-- upvalues: CreateFavoriteForAsset (copy), DeleteFavoriteForAsset (copy), CreateFavoriteForBundle (copy), DeleteFavoriteForBundle (copy), GetFavoriteForAsset (copy), GetFavoriteForBundle (copy)
	return {
		createFavoriteForAsset = function(p13) -- line: 142
			-- upvalues: p12 (copy), CreateFavoriteForAsset (copy)
			p12(CreateFavoriteForAsset(p13))
		end,
		deleteFavoriteForAsset = function(p14) -- line: 145
			-- upvalues: p12 (copy), DeleteFavoriteForAsset (copy)
			p12(DeleteFavoriteForAsset(p14))
		end,
		createFavoriteForBundle = function(p15) -- line: 148
			-- upvalues: p12 (copy), CreateFavoriteForBundle (copy)
			p12(CreateFavoriteForBundle(p15))
		end,
		deleteFavoriteForBundle = function(p16) -- line: 151
			-- upvalues: p12 (copy), DeleteFavoriteForBundle (copy)
			p12(DeleteFavoriteForBundle(p16))
		end,
		getFavoriteForAsset = function(p17) -- line: 154
			-- upvalues: p12 (copy), GetFavoriteForAsset (copy)
			p12(GetFavoriteForAsset(p17))
		end,
		getFavoriteForBundle = function(p18) -- line: 157
			-- upvalues: p12 (copy), GetFavoriteForBundle (copy)
			p12(GetFavoriteForBundle(p18))
		end
	}
end)(v19)
