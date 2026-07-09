local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local FFlagAXFavoritePillOnItemDetails = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFavoritePillOnItemDetails
local ItemStatistics = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemStatistics)
local FavoritePillContainer = require(Modules.AvatarExperience.Common.Components.ItemDetails.FavoritePill.FavoritePillContainer)
local AvatarExperience = Modules.AvatarExperience
local Common = AvatarExperience.Common

require(Common.Types)

local Constants = require(Common.Constants)
local LookDescription = require(AvatarExperience.Catalog.Components.LookDetails.LookDetails.LookDescription)
local LookInfoList = require(AvatarExperience.Catalog.Components.LookDetails.LookDetails.LookInfo.LookInfoList)
local LookDetailsImageAndName = require(AvatarExperience.Catalog.Components.LookDetails.LookDetails.LookDetailsImageAndName)
local GetFFlagLooksAvatarPDPImageDimensions = require(Modules.AvatarExperience.Flags.GetFFlagLooksAvatarPDPImageDimensions)
local GetFFlagEnableLookFavoriting = require(Modules.AvatarExperience.Flags.GetFFlagEnableLookFavoriting)
local useStyle = UIBlox.Core.Style.useStyle
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical

local function LookDetailsContainerInnards(t1: {[any]: any}) -- line: 62
	-- upvalues: useStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), RoactFitComponents (copy), Constants (copy), React (copy), FitFrameVertical (copy), GetFFlagLooksAvatarPDPImageDimensions (copy), Roact (copy), LookDetailsImageAndName (copy), LookDescription (copy), GetFFlagEnableLookFavoriting (copy), FFlagAXFavoritePillOnItemDetails (copy), FavoritePillContainer (copy), ItemStatistics (copy), LookInfoList (copy)
	local v24 = useStyle()
	local v25 = if not FFlagRenameDeprecatedUIBloxTokens then v24.Tokens.Global.Space_300 else v24.Tokens.Size.Size_600
	local v26 = if not FFlagRenameDeprecatedUIBloxTokens then v24.Tokens.Global.Space_150 else v24.Tokens.Size.Size_300
	local Theme = v24.Theme
	local lookDetails = t1.lookDetails
	local lookId = t1.lookId
	local name = nil

	if lookDetails and lookDetails.name then
		name = lookDetails.name
	end

	local description = nil

	if lookDetails and lookDetails.description then
		description = lookDetails.description
	end

	local v32 = t1.listPadding or v26
	local v33 = RoactFitComponents.Rect.square(v25)

	v33.top = 0

	local v34 = lookId ~= nil and lookDetails == nil
	local v35 = t1.lookId == Constants.DraftLookId
	local v36 = if not t1.width then if not FFlagRenameDeprecatedUIBloxTokens then v24.Tokens.Global.Space_300 else v24.Tokens.Size.Size_600 else t1.width

	return React.createElement(FitFrameVertical, {
		BorderSizePixel = 0,
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, v32),
		margin = if not GetFFlagLooksAvatarPDPImageDimensions() then v33 else nil,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		Position = UDim2.new(0, 0, 0, 0)
	}, {
		LookDetailsImageAndName = Roact.createElement(LookDetailsImageAndName, {
			name = name,
			lookId = t1.lookId,
			lookDetails = lookDetails,
			isLoading = v34,
			width = if not GetFFlagLooksAvatarPDPImageDimensions() then v36 else nil,
			innerPadding = if not GetFFlagLooksAvatarPDPImageDimensions() then nil else v25,
			renderViewport = v35
		}),
		LookDescription = if not v34 and (not description or description == "") then nil else Roact.createElement(LookDescription, {
			compactNumberOfLines = 3,
			LayoutOrder = 4,
			isLoading = v34,
			descriptionText = description
		}),
		ItemStatistics = if not GetFFlagEnableLookFavoriting() or v34 then nil else if not FFlagAXFavoritePillOnItemDetails then Roact.createElement(ItemStatistics, {
			LayoutOrder = 5,
			favoritesCount = not lookDetails and 0 or lookDetails.favoriteCount,
			listPadding = v32,
			width = v36 - v25 * 2
		}) else React.createElement(FavoritePillContainer, {
			LayoutOrder = 5,
			kind = Constants.ItemType.Look,
			itemId = lookId,
			favoritesCount = not lookDetails and 0 or lookDetails.favoriteCount,
			lookType = if not lookDetails then nil else lookDetails.lookType
		}),
		LookInfoList = if not v34 then Roact.createElement(LookInfoList, {
			lookId = t1.lookId,
			lookDetails = lookDetails,
			LayoutOrder = not GetFFlagEnableLookFavoriting() and 5 or 6,
			innerPadding = if not GetFFlagLooksAvatarPDPImageDimensions() then nil else v25,
			disableInteractions = v35,
			isTryOn = t1.isTryOn
		}) else nil
	})
end

return LookDetailsContainerInnards
