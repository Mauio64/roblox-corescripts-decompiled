local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local withStyle = UIBlox.Style.withStyle
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local OpenCentralOverlayForGameDetailMore = require(Modules.LuaApp.Thunks.OpenCentralOverlayForGameDetailMore)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local uDim2 = UDim2.new(0, 44, 0, 44)
local uDim2_2 = UDim2.new(0, 37, 0, 37)
local v23 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)
local v25 = Images["icons/menu/more_on"]
local v26 = Images["icons/menu/more_off"]
local v27 = Roact.PureComponent:extend("GameDetailMoreButton")

v27.validateProps = t.strictInterface({
	universeId = t.string,
	leftPadding = t.number,
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	screenWidth = t.number,
	isLoading = t.boolean,
	isDisabled = t.boolean,
	openContextualMenu = t.callback,
	testId = t.optional(t.string)
})

function v27.getMoreMenuPosition(p1) -- line: 58
	local screenWidth = p1.props.screenWidth
	local leftPadding = p1.props.leftPadding
	local current = p1.moreButtonRef.current

	if current == nil then
		return UDim2.new(0, 0, 0, 0)
	end

	local v32 = current.AbsolutePosition.x + current.AbsoluteSize.x / 2
	local AbsolutePositionY = current.AbsolutePosition.Y
	local v34 = (screenWidth - 300) / 2
	local v35 = if not (screenWidth < 600) then if not (v32 < leftPadding + 150) then v32 - 150 - v34 else leftPadding - v34 else 0
	local v36 = AbsolutePositionY - 15

	return UDim2.new(0, v35, 0, v36)
end
function v27.init(p2) -- line: 90
	-- upvalues: Roact (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	p2.moreButtonRef = Roact.createRef()

	function p2.deselectMoreButton() -- line: 92
		-- upvalues: p2 (copy)
		p2:setState({
			isMoreButtonSelected = false
		})
	end

	p2.deselectMoreButton()

	local openContextualMenu = p2.props.openContextualMenu

	function p2.onActivated() -- line: 102
		-- upvalues: p2 (copy), openContextualMenu (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
		local universeId = p2.props.universeId

		if p2.props.isDisabled then
			return
		end

		p2:setState({
			isMoreButtonSelected = true
		})

		local v60 = p2:getMoreMenuPosition()

		openContextualMenu(universeId, v60, p2.deselectMoreButton, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp)
	end
end
function v27.render(p3) -- line: 124
	-- upvalues: withStyle (copy)
	return withStyle(function(p4) -- line: 125
		-- upvalues: p3 (copy)
		return p3:renderWithStyle(p4)
	end)
end
function v27.renderWithStyle(p5, p6) -- line: 130
	-- upvalues: v25 (copy), v26 (copy), Roact (copy), Skeleton (copy), ImageSetLabel (copy), uDim2_2 (copy), ImageSetButton (copy), React (copy), uDim2 (copy), v23 (copy), rect (copy)
	local isLoading = p5.props.isLoading
	local isDisabled = p5.props.isDisabled
	local Theme = p6.Theme
	local v45 = if not isLoading and not isDisabled then Theme.BackgroundDefault.Transparency else 0.5
	local v46 = if not p5.state.isMoreButtonSelected then v26 else v25
	local v47 = if not isLoading then Roact.createElement(ImageSetLabel, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = uDim2_2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Image = v46,
		ImageTransparency = Theme.IconEmphasis.Transparency,
		ImageColor3 = Theme.IconEmphasis.Color
	}) else Roact.createElement(Skeleton, {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	})

	return Roact.createElement(ImageSetButton, {
		[React.Tag] = if not p5.props.testId then nil else `data-testid={ p5.props.testId }`,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = uDim2,
		Image = v23,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = v45,
		ImageColor3 = Theme.BackgroundDefault.Color,
		LayoutOrder = 1,
		ClipsDescendants = false,
		[Roact.Event.Activated] = p5.onActivated,
		[Roact.Ref] = p5.moreButtonRef
	}, { v47 })
end

return RoactRodux.connect(function(p7, p8) -- line: 186
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy), GameInfosReducer (copy), RetrievalStatus (copy), CentralOverlayType (copy)
	local v54 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p8.shouldHydrateLegacyIxp) then ApiFetchGameDetails.GetFetchingStatus(p7, p8.universeId) else ApiFetchExperienceDetailsPage.GetFetchingStatus(p7, p8.universeId)
	local v55 = p7.Personalization[GameInfosReducer.key][p8.universeId]
	local OverlayType = p7.CentralOverlay.OverlayType
	local t1 = {
		screenWidth = p7.ScreenSize.X
	}

	t1.isLoading = v54 == RetrievalStatus.NotStarted or v54 == RetrievalStatus.Fetching
	t1.isDisabled = v54 == RetrievalStatus.Failed and not v55 or (OverlayType == CentralOverlayType.GameDetailMore or OverlayType == CentralOverlayType.GameDetailsPlayWithFriends)

	return t1
end, function(p9) -- line: 206
	-- upvalues: OpenCentralOverlayForGameDetailMore (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	return {
		openContextualMenu = function(p10, p11, p12, p13) -- line: 208
			-- upvalues: p9 (copy), OpenCentralOverlayForGameDetailMore (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
			p9(OpenCentralOverlayForGameDetailMore(p10, p11, p12, nil, nil, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p13))
		end
	}
end)(v27)
