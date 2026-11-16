local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXFavoritePillOnItemDetails = AvatarExperienceFlags.FFlagAXFavoritePillOnItemDetails
local fFlagAXFavoritesPillExposureLogging = AvatarExperienceFlags.FFlagAXFavoritesPillExposureLogging
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module2 = require("@luauforge/deferred/gkt")

local module3 = require("@luauforge/deferred/gkV")

local module4 = require("@luauforge/deferred/gld")

require("@luauforge/bundled/dMc")
local module5 = require("@luauforge/bundled/dMx")
local module6 = require("@luauforge/deferred/goj")

local module7 = require("@luauforge/deferred/gok")
local module8 = require("@luauforge/deferred/gom")

local module9 = require("@luauforge/deferred/gol")

local useStyle = UIBlox.Core.Style.useStyle

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local function LookDetailsContainerInnards(props)
	local v5 = useStyle()
	local size_600 = v5.Tokens.Size.Size_600
	local size_300 = v5.Tokens.Size.Size_300
	local theme = v5.Theme

	local lookDetails = props.lookDetails
	local lookId = props.lookId

	local name = if lookDetails and lookDetails.name then lookDetails.name else nil

	local description = if lookDetails and lookDetails.description then lookDetails.description else nil

	local listPadding = props.listPadding or size_300

	local square = roactFitComponents.Rect.square(size_600)
	square.top = 0

	local v6 = not (lookId == nil) and lookDetails == nil
	local v7 = props.lookId == module5.DraftLookId
	local v8 = if props.width then props.width else v5.Tokens.Size.Size_600

	local v9 = not v6

	if fFlagAXFavoritesPillExposureLogging then
		local v10 = useAppPolicy(function(p2)
			return p2.getEnableAggregateLikesFavoritesCount()
		end)
		v9 = v9 and v10
	end

	local createElement = React.createElement
	local v11 = {
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, listPadding),
		margin = 0,
		FillDirection = 0,
		HorizontalAlignment = 0,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = 0
	}

	if module9() then
		square = nil
	end

	v11.margin = square
	v11.FillDirection = Enum.FillDirection.Vertical
	v11.HorizontalAlignment = Enum.HorizontalAlignment.Left

	v11.BackgroundColor3 = theme.BackgroundDefault.Color
	v11.BackgroundTransparency = theme.BackgroundDefault.Transparency

	v11.Position = UDim2.new(0, 0, 0, 0)

	local createElement2 = Roact.createElement
	local v14 = {
		name = name,
		lookId = props.lookId,
		lookDetails = lookDetails,
		isLoading = v6,
		width = 0,
		innerPadding = 0,
		renderViewport = 0
	}

	local v15 = if not module9() then v8 else nil
	v14.width = v15
	local v16 = if module9() then size_600 else nil
	v14.innerPadding = v16
	v14.renderViewport = v7
	local v12 = {
		LookDetailsImageAndName = createElement2(module8, v14),
		FavoritePillExposure = 0,
		FavoritePill = 0,
		LookDescription = 0,
		ItemStatistics = 0,
		LookInfoList = 0
	}

	local v17 = if fFlagAXFavoritesPillExposureLogging and v9 then React.createElement(module4) else nil
	v12.FavoritePillExposure = v17
	local v18

	if v9 and fFlagAXFavoritePillOnItemDetails then
		local createElement3 = React.createElement

		local v20 = {
			kind = module5.ItemType.Look,
			itemId = lookId,
			favoritesCount = not lookDetails and 0 or lookDetails.favoriteCount,
			lookType = 0,
			LayoutOrder = 3
		}
		local v21 = if lookDetails then lookDetails.lookType else nil
		v20.lookType = v21
		v18 = createElement3(module3, v20)
	end

	v12.FavoritePill = v18

	local v19 = if v6 or description and description ~= "" then Roact.createElement(module6, {
		compactNumberOfLines = 3,
		isLoading = v6,
		descriptionText = description,
		LayoutOrder = 4
	}) else nil
	v12.LookDescription = v19

	local v20 = if v9 and not fFlagAXFavoritePillOnItemDetails then Roact.createElement(module2, {
		favoritesCount = not lookDetails and 0 or lookDetails.favoriteCount,
		LayoutOrder = 5,
		listPadding = listPadding,
		width = v8 - size_600 * 2
	}) else nil
	v12.ItemStatistics = v20
	local v21

	if not v6 then
		local createElement3 = Roact.createElement
		local v23 = {
			lookId = props.lookId,
			lookDetails = lookDetails,
			LayoutOrder = 6,
			innerPadding = 0,
			disableInteractions = 0,
			isTryOn = 0
		}

		if not module9() then
			size_600 = nil
		end

		v23.innerPadding = size_600
		v23.disableInteractions = v7
		v23.isTryOn = props.isTryOn
		v21 = createElement3(module7, v23)
	end

	v12.LookInfoList = v21
	return createElement(fitFrameVertical, v11, v12)
end

return LookDetailsContainerInnards
