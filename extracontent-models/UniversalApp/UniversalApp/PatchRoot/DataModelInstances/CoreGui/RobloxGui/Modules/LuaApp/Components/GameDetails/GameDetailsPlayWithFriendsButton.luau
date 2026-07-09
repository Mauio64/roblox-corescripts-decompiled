local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local OpenCentralOverlayForGameDetailsPlayWithFriends = require(Modules.LuaApp.Thunks.OpenCentralOverlayForGameDetailsPlayWithFriends)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local uDim2 = UDim2.new(0, 44, 0, 44)
local uDim2_2 = UDim2.new(0, 37, 0, 37)
local rect = Rect.new(8, 8, 9, 9)
local v22 = Roact.PureComponent:extend("GameDetailsPlayWithFriendsButton")

v22.validateProps = t.strictInterface({
	universeId = t.string,
	leftPadding = t.number,
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	screenWidth = t.number,
	isLoading = t.boolean,
	isDisabled = t.boolean,
	openContextualMenu = t.callback
})

function v22.getMoreMenuPosition(p1) -- line: 51
	local screenWidth = p1.props.screenWidth
	local leftPadding = p1.props.leftPadding
	local current = p1.moreButtonRef.current

	if current == nil then
		return UDim2.new(0, 0, 0, 0)
	end

	local v27 = current.AbsolutePosition.X + current.AbsoluteSize.X / 2
	local AbsolutePositionY = current.AbsolutePosition.Y
	local v29 = (screenWidth - 300) / 2
	local v30 = if not (screenWidth < 600) then if not (v27 < leftPadding + 150) then v27 - 150 - v29 else leftPadding - v29 else 0
	local v31 = AbsolutePositionY - 15

	return UDim2.new(0, v30, 0, v31)
end
function v22.init(p2) -- line: 83
	-- upvalues: Roact (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	p2.moreButtonRef = Roact.createRef()

	local openContextualMenu = p2.props.openContextualMenu

	function p2.onActivated() -- line: 88
		-- upvalues: p2 (copy), openContextualMenu (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
		local universeId = p2.props.universeId

		if p2.props.isDisabled then
			return
		end

		local v53 = p2:getMoreMenuPosition()

		openContextualMenu(universeId, v53, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp)
	end
end
function v22.render(p3) -- line: 105
	-- upvalues: withStyle (copy)
	return withStyle(function(p4) -- line: 106
		-- upvalues: p3 (copy)
		return p3:renderWithStyle(p4)
	end)
end
function v22.renderWithStyle(p5, p6) -- line: 111
	-- upvalues: Roact (copy), ImageSetButton (copy), uDim2 (copy), Images (copy), rect (copy), ImageSetLabel (copy), uDim2_2 (copy)
	local Theme = p6.Theme
	local isLoading = p5.props.isLoading
	local isDisabled = p5.props.isDisabled
	local v40 = if not isLoading and not isDisabled then Theme.BackgroundDefault.Transparency else 0.5

	return Roact.createElement(ImageSetButton, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = uDim2,
		Image = Images["component_assets/circle_17"],
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = v40,
		ImageColor3 = Theme.BackgroundDefault.Color,
		LayoutOrder = 1,
		ClipsDescendants = false,
		[Roact.Event.Activated] = p5.onActivated,
		[Roact.Ref] = p5.moreButtonRef
	}, {
		Icon = Roact.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = uDim2_2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = Images["icons/actions/friends/friendsplaying"],
			ImageTransparency = Theme.IconEmphasis.Transparency,
			ImageColor3 = Theme.IconEmphasis.Color
		})
	})
end

return RoactRodux.connect(function(p7, p8) -- line: 154
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy), GameInfosReducer (copy), RetrievalStatus (copy), CentralOverlayType (copy)
	local v47 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p8.shouldHydrateLegacyIxp) then ApiFetchGameDetails.GetFetchingStatus(p7, p8.universeId) else ApiFetchExperienceDetailsPage.GetFetchingStatus(p7, p8.universeId)
	local OverlayType = p7.CentralOverlay.OverlayType
	local v49 = p7.Personalization[GameInfosReducer.key][p8.universeId]
	local t1 = {
		screenWidth = p7.ScreenSize.X
	}

	t1.isLoading = v47 == RetrievalStatus.NotStarted or v47 == RetrievalStatus.Fetching
	t1.isDisabled = v47 == RetrievalStatus.Failed and not v49 or (OverlayType == CentralOverlayType.GameDetailMore or OverlayType == CentralOverlayType.GameDetailsPlayWithFriends)

	return t1
end, function(p9) -- line: 173
	-- upvalues: OpenCentralOverlayForGameDetailsPlayWithFriends (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	return {
		openContextualMenu = function(p10, p11, p12) -- line: 175
			-- upvalues: p9 (copy), OpenCentralOverlayForGameDetailsPlayWithFriends (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
			p9(OpenCentralOverlayForGameDetailsPlayWithFriends(p10, p11, nil, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p12))
		end
	}
end)(v22)
