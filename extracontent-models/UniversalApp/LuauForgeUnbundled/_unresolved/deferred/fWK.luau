local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local apiFetchGameDetails = require("@luauforge/bundled/dyi").GameDetails.ApiFetchGameDetails
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton

local withStyle = UIBlox.Style.withStyle
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local module2 = require("@luauforge/deferred/fWL")
local module3 = require("@luauforge/deferred/fWX")

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local udim = UDim2.new(0, 44, 0, 44)
local udim2 = UDim2.new(0, 37, 0, 37)

local component_assetscircle_17 = images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)

local iconsmenumore_on = images["icons/menu/more_on"]
local iconsmenumore_off = images["icons/menu/more_off"]

local extended = Roact.PureComponent:extend("GameDetailMoreButton")

local strictInterface = t.strictInterface
local v5 = {
	universeId = t.string,
	leftPadding = t.number,
	shouldHydrateLegacyIxp = 0,
	screenWidth = 0,
	isLoading = 0,
	isDisabled = 0,
	isFetchFailed = 0,
	isOverlayBlocking = 0,
	openContextualMenu = 0,
	testId = 0
}
local v6 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v5.shouldHydrateLegacyIxp = v6

v5.screenWidth = t.number
v5.isLoading = t.boolean
local v7 = if not fFlagMigrateGameInfoToStore then t.boolean else nil
v5.isDisabled = v7
local v8 = if fFlagMigrateGameInfoToStore then t.boolean else nil
v5.isFetchFailed = v8
local v9 = if fFlagMigrateGameInfoToStore then t.boolean else nil
v5.isOverlayBlocking = v9

v5.openContextualMenu = t.callback
v5.testId = t.optional(t.string)
extended.validateProps = strictInterface(v5)

local function isGameInfoActionable(p2): boolean
	return p2 ~= nil and p2.rootPlaceId ~= nil
end

function extended:getMoreMenuPosition()
	local screenWidth = self.props.screenWidth
	local leftPadding = self.props.leftPadding
	local current = self.moreButtonRef.current

	if current == nil then
		return UDim2.new(0, 0, 0, 0)
	end

	local v10 = current.AbsolutePosition.x + current.AbsoluteSize.x / 2
	local y = current.AbsolutePosition.Y

	local v11 = (screenWidth - 300) / 2
	local v12

	if screenWidth < 600 then
		v12 = 0
	else
		v12 = if v10 < leftPadding + 150 then leftPadding - v11 else v10 - 150 - v11
	end

	local v13 = y - 15

	return UDim2.new(0, v12, 0, v13)
end

function extended:init()
	self.moreButtonRef = Roact.createRef()
	function self.deselectMoreButton()
		self:setState({ isMoreButtonSelected = false })
	end

	self.deselectMoreButton()

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
			universeId = self.props.universeId,
			onChange = function(p2)
				self:setState({
					gameInfo = p2.gameInfo or none
				})
			end
		})
	end

	local openContextualMenu = self.props.openContextualMenu

	function self.onActivated()
		local universeId = self.props.universeId
		local v10

		if fFlagMigrateGameInfoToStore then
			if self.props.isFetchFailed then
				local gameInfo = self.state.gameInfo
				v10 = gameInfo == nil or gameInfo.rootPlaceId == nil or self.props.isOverlayBlocking
			else
				v10 = self.props.isOverlayBlocking
			end
		else
			v10 = self.props.isDisabled
		end

		if v10 then
			return
		end

		self:setState({ isMoreButtonSelected = true })

		local moreMenuPosition = self:getMoreMenuPosition()

		local deselectMoreButton = self.deselectMoreButton
		local v12 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		openContextualMenu(universeId, moreMenuPosition, deselectMoreButton, v12)
	end
end

function extended.didUpdate(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.update(p2.props.universeId)
	end
end

function extended.willUnmount(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.dispose()
	end
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

function extended:renderWithStyle(p2)
	local isLoading = self.props.isLoading
	local v10

	if fFlagMigrateGameInfoToStore then
		if self.props.isFetchFailed then
			local gameInfo = self.state.gameInfo
			v10 = gameInfo == nil or gameInfo.rootPlaceId == nil or self.props.isOverlayBlocking
		else
			v10 = self.props.isOverlayBlocking
		end
	else
		v10 = self.props.isDisabled
	end

	local theme = p2.Theme
	local v11 = (isLoading or v10) and 0.5 or theme.BackgroundDefault.Transparency

	local v12 = if self.state.isMoreButtonSelected then iconsmenumore_on else iconsmenumore_off
	local v13

	if isLoading then
		v13 = Roact.createElement(skeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		})
	else
		v13 = Roact.createElement(imageSetLabel, {
			Size = udim2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Image = v12,
			ImageTransparency = theme.IconEmphasis.Transparency,
			ImageColor3 = theme.IconEmphasis.Color
		})
	end

	local createElement = Roact.createElement
	local tag = React.Tag
	local v16 = if self.props.testId then `data-testid={self.props.testId}` else nil
	return createElement(imageSetButton, {
		[tag] = v16,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = udim,
		Image = component_assetscircle_17,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = v11,
		ImageColor3 = theme.BackgroundDefault.Color,
		LayoutOrder = 1,
		ClipsDescendants = false,
		[Roact.Event.Activated] = self.onActivated,
		[Roact.Ref] = self.moreButtonRef
	}, { v13 })
end

return RoactRodux.connect(function(data, p2)
	local v10

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp
	then
		v10 = module2.GetFetchingStatus(data, p2.universeId)
	else
		v10 = apiFetchGameDetails.GetFetchingStatus(data, p2.universeId)
	end

	local v11

	if not fFlagMigrateGameInfoToStore then
		v11 = data.Personalization[gameInfosReducer.key][p2.universeId]
	end

	local overlayType = data.CentralOverlay.OverlayType

	if fFlagMigrateGameInfoToStore then
		return {
			screenWidth = data.ScreenSize.X,
			isLoading = v10 == retrievalStatus.NotStarted or v10 == retrievalStatus.Fetching,
			isFetchFailed = v10 == retrievalStatus.Failed,
			isOverlayBlocking = overlayType == centralOverlayType.GameDetailMore or overlayType == centralOverlayType.GameDetailsPlayWithFriends
		}
	end

	return {
		screenWidth = data.ScreenSize.X,
		isLoading = v10 == retrievalStatus.NotStarted or v10 == retrievalStatus.Fetching,
		isDisabled = v10 == retrievalStatus.Failed and not v11 or overlayType == centralOverlayType.GameDetailMore or overlayType == centralOverlayType.GameDetailsPlayWithFriends
	}
end, function(p2)
	return {
		openContextualMenu = function(p3, p4, p5, p6)
			if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
				p6 = nil
			end

			p2(module3(p3, p4, p5, nil, nil, p6))
		end
	}
end)(extended)
