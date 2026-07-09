local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local AvatarExperience = Modules.AvatarExperience
local Common = AvatarExperience.Common
local Catalog = AvatarExperience.Catalog

require(Common.Types)

local ToggleTryOnThunk = require(Common.Thunks.ToggleTryOnThunk)
local NavigateDownToAvatarScreen = require(Common.Components.RoactNavigation.AppRouterWrapper.NavigateDownToAvatarScreen)
local CatalogUtils = require(Catalog.CatalogUtils)
local Analytics = require(Catalog.Services.Analytics)
local FFlagAXThumbTypeNilCheck = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXThumbTypeNilCheck
local LoadableImage = UIBlox.App.Loading.LoadableImage
local useStyle = UIBlox.Core.Style.useStyle
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function ItemImageFrame(t1: {[any]: any}) -- line: 61
	-- upvalues: useStyle (copy), useLocalization (copy), useNavigation (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useDispatch (copy), useAvatarRoute (copy), React (copy), ToggleTryOnThunk (copy), NavigateDownToAvatarScreen (copy), AvatarScreen (copy), CatalogUtils (copy), FFlagAXThumbTypeNilCheck (copy), getRbxthumbWithTypeSizeAndOptions (copy), TextService (copy), Roact (copy), LoadableImage (copy), Button (copy), ButtonType (copy)
	local v31 = useStyle()
	local Theme = v31.Theme
	local Font = v31.Font
	local v34 = useLocalization({
		tryOn = "Feature.Avatar.Action.TryOn"
	})
	local v35 = useNavigation()
	local v36 = useRoactService(RoactNetworking)
	local v37 = useRoactService(Analytics)
	local v38 = useDispatch()
	local v39 = useAvatarRoute()
	local v40 = React.useCallback(function() -- line: 75
		-- upvalues: t1 (copy), v38 (copy), ToggleTryOnThunk (copy), v36 (copy), v37 (copy), v39 (copy), v35 (copy), NavigateDownToAvatarScreen (copy), AvatarScreen (copy)
		local t2 = {
			mountAsFullView = false,
			mountAnimation = false,
			itemId = t1.itemId,
			itemType = t1.itemType,
			itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
			resultsListRef = t1.resultsListRef
		}
		local v51 = t1.itemType .. t1.itemId

		v38(ToggleTryOnThunk(v36, v37, t1.itemType, t1.itemSubType, t1.itemId, true, v39, v35))
		v38(NavigateDownToAvatarScreen(AvatarScreen.TryOnItem, v51, t2))
	end, {
		v36,
		v37,
		v39,
		v35,
		t1
	})
	local v41 = t1.width * 9 / 16
	local itemType = t1.itemType
	local itemId = t1.itemId
	local v44 = CatalogUtils.GetRbxThumbType(itemType)
	local v45 = if not FFlagAXThumbTypeNilCheck or not v44 then getRbxthumbWithTypeSizeAndOptions(itemId, v44, 420) else getRbxthumbWithTypeSizeAndOptions(itemId, v44, 420)
	local v46 = v35.getParam("fromProfile")
	local tryOn = v34.tryOn
	local v48 = Font.BaseSize * Font.Header2.RelativeSize
	local v49 = 16 + TextService:GetTextSize(tryOn, v48, Font.Header2.Font, Vector2.new(10000, 10000)).X

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		ZIndex = 0,
		Size = UDim2.new(1, 0, 0, v41)
	}, {
		ItemBackground = Roact.createElement("Frame", {
			ZIndex = 0,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, 48, 1, 0),
			BackgroundColor3 = Theme.BackgroundMuted.Color,
			BackgroundTransparency = Theme.BackgroundMuted.Transparency
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Rotation = -90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.4, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		Image = Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			Image = v45,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(v41, v41)
		}),
		TryOnButtonFrame = if not v46 then nil else Roact.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			TryOnButton = Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				position = UDim2.new(1, -v49 - 8, 1, -44),
				size = UDim2.fromOffset(v49, 36),
				text = tryOn,
				onActivated = v40
			})
		})
	})
end

return ItemImageFrame
