local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local parent = script.Parent.Parent
local Colors = require(parent.Colors)
local CreateFavoriteForAsset = require(parent.Thunks.CreateFavoriteForAsset)
local DeleteFavoriteForAsset = require(parent.Thunks.DeleteFavoriteForAsset)
local CreateFavoriteForBundle = require(parent.Thunks.CreateFavoriteForBundle)
local DeleteFavoriteForBundle = require(parent.Thunks.DeleteFavoriteForBundle)
local GetFavoriteForAsset = require(parent.Thunks.GetFavoriteForAsset)
local GetFavoriteForBundle = require(parent.Thunks.GetFavoriteForBundle)
local GotFavoriteForDetailsItem = require(parent.Selectors.GotFavoriteForDetailsItem)
local IsDetailsItemPartOfBundleAndOffsale = require(parent.Selectors.IsDetailsItemPartOfBundleAndOffsale)
local GetIsFavorite = require(parent.Selectors.GetIsFavorite)
local UtilityFunctions = require(parent.UtilityFunctions)
local getSelectionImageObjectRounded = require(parent.getSelectionImageObjectRounded)

local ControllerShortcutKeycodes = require(script.Parent.Common.ControllerShortcutKeycodes)
local Favorite = ControllerShortcutKeycodes.Favorite

local extended = Roact.PureComponent:extend("FavoritesButton")

function extended:init()
	self.selectedImage = getSelectionImageObjectRounded()
	self.fetchFavoriteRetries = 0

	ContextActionService:BindCoreAction("FavoriteGamepadShortcut", function(_, p, _)
		if p ~= Enum.UserInputState.End then
			return Enum.ContextActionResult.Pass
		end

		self:activateButton()
		return Enum.ContextActionResult.Sink
	end, false, Favorite)
end

function extended:willUpdate(p)
	local gotFavoriteForDetailsItem = p.gotFavoriteForDetailsItem
	local getFavoriteForAsset = self.props.getFavoriteForAsset
	local getFavoriteForBundle = self.props.getFavoriteForBundle

	if p and p.assetInfo and not gotFavoriteForDetailsItem and self.fetchFavoriteRetries < 10 then
		local assetInfo = p.assetInfo
		local v = assetInfo and assetInfo.parentBundleId ~= nil

		coroutine.wrap(function()
			if v then
				getFavoriteForBundle((UtilityFunctions.getBundleId(assetInfo)))
			else
				getFavoriteForAsset(assetInfo.assetId)
			end
		end)()
		self.fetchFavoriteRetries += 1
	end
end

function extended:activateButton()
	local isFavorited = self.props.isFavorited
	local isDetailsItemPartOfBundleAndOffsale = self.props.IsDetailsItemPartOfBundleAndOffsale
	local createFavoriteForAsset = self.props.createFavoriteForAsset
	local deleteFavoriteForAsset = self.props.deleteFavoriteForAsset
	local createFavoriteForBundle = self.props.createFavoriteForBundle
	local deleteFavoriteForBundle = self.props.deleteFavoriteForBundle
	local assetInfo = self.props.assetInfo

	if isFavorited then
		if isDetailsItemPartOfBundleAndOffsale then
			deleteFavoriteForBundle((UtilityFunctions.getBundleId(assetInfo)))
		else
			deleteFavoriteForAsset(assetInfo.assetId)
		end
	elseif isDetailsItemPartOfBundleAndOffsale then
		createFavoriteForBundle((UtilityFunctions.getBundleId(assetInfo)))
	else
		createFavoriteForAsset(assetInfo.assetId)
	end
end

function extended.willUnmount(_)
	ContextActionService:UnbindCoreAction("FavoriteGamepadShortcut")
end

function extended:render()
	local isFavorited = self.props.isFavorited
	local favoriteButtonRef = self.props.favoriteButtonRef

	return Roact.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 44, 0, 44),
		LayoutOrder = 1,
		Image = "rbxasset://textures/ui/InspectMenu/Button_outline.png",
		ImageColor3 = Colors.White,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(5, 5, 120, 20),
		SelectionImageObject = self.selectedImage,
		Visible = true,
		[Roact.Ref] = favoriteButtonRef,
		[Roact.Event.Activated] = function()
			self:activateButton()
		end
	}, {
		FavoriteIcon = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 26, 0, 26),
			Position = UDim2.new(0, 22, 0, 22),
			Image = isFavorited and "rbxasset://textures/ui/InspectMenu/ico_favorite.png" or "rbxasset://textures/ui/InspectMenu/ico_favorite_off.png",
			ImageColor3 = Colors.White
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		view = data.view,
		assetInfo = data.assets[assetId],
		bundleInfo = data.bundles,
		gotFavoriteForDetailsItem = GotFavoriteForDetailsItem(data),
		isFavorited = GetIsFavorite(data),
		IsDetailsItemPartOfBundleAndOffsale = IsDetailsItemPartOfBundleAndOffsale(data)
	}
end, function(callback)
	return {
		createFavoriteForAsset = function(p)
			callback(CreateFavoriteForAsset(p))
		end,
		deleteFavoriteForAsset = function(p)
			callback(DeleteFavoriteForAsset(p))
		end,
		createFavoriteForBundle = function(p)
			callback(CreateFavoriteForBundle(p))
		end,
		deleteFavoriteForBundle = function(p)
			callback(DeleteFavoriteForBundle(p))
		end,
		getFavoriteForAsset = function(p)
			callback(GetFavoriteForAsset(p))
		end,
		getFavoriteForBundle = function(p)
			callback(GetFavoriteForBundle(p))
		end
	}
end)(extended)
