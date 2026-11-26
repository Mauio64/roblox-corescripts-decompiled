local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local UIBlox = require(CorePackages.Packages.UIBlox)
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local module2 = require("@luauforge/deferred/gBI")

local module3 = require("@luauforge/deferred/gBV")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local udim = UDim2.new(0, 44, 0, 44)

local udim2 = UDim2.new(0, 37, 0, 37)

local rect = Rect.new(8, 8, 9, 9)

local extended = Roact.PureComponent:extend("GameDetailsPlayWithFriendsButton")

local strictInterface = t.strictInterface
local v5 = {
	universeId = t.string,
	leftPadding = t.number,
	shouldHydrateLegacyIxp = 0,
	screenWidth = 0,
	isLoading = 0,
	isFetchFailed = 0,
	isOverlayBlocking = 0,
	openContextualMenu = 0
}
local v6 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v5.shouldHydrateLegacyIxp = v6

v5.screenWidth = t.number
v5.isLoading = t.boolean
v5.isFetchFailed = t.boolean
v5.isOverlayBlocking = t.boolean

v5.openContextualMenu = t.callback
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

	local v7 = current.AbsolutePosition.X + current.AbsoluteSize.X / 2
	local y = current.AbsolutePosition.Y

	local v8 = (screenWidth - 300) / 2
	local v9

	if screenWidth < 600 then
		v9 = 0
	else
		v9 = if v7 < leftPadding + 150 then leftPadding - v8 else v7 - 150 - v8
	end

	local v10 = y - 15

	return UDim2.new(0, v9, 0, v10)
end

function extended:init()
	self.moreButtonRef = Roact.createRef()
	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none
			})
		end
	})

	local openContextualMenu = self.props.openContextualMenu

	function self.onActivated()
		local universeId = self.props.universeId
		local v7

		if self.props.isFetchFailed then
			local gameInfo = self.state.gameInfo
			v7 = gameInfo == nil or gameInfo.rootPlaceId == nil or self.props.isOverlayBlocking
		else
			v7 = self.props.isOverlayBlocking
		end

		if v7 then
			return
		end

		local moreMenuPosition = self:getMoreMenuPosition()

		local v9 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		openContextualMenu(universeId, moreMenuPosition, v9)
	end
end

function extended.didUpdate(p2)
	p2.gameInfoSubscription.update(p2.props.universeId)
end

function extended.willUnmount(p2)
	p2.gameInfoSubscription.dispose()
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

function extended:renderWithStyle(p2)
	local theme = p2.Theme
	local isLoading = self.props.isLoading
	local v7

	if self.props.isFetchFailed then
		local gameInfo = self.state.gameInfo
		v7 = gameInfo == nil or gameInfo.rootPlaceId == nil or self.props.isOverlayBlocking
	else
		v7 = self.props.isOverlayBlocking
	end

	local v8 = (isLoading or v7) and 0.5 or theme.BackgroundDefault.Transparency

	return Roact.createElement(imageSetButton, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = udim,
		Image = images["component_assets/circle_17"],
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = v8,
		ImageColor3 = theme.BackgroundDefault.Color,
		LayoutOrder = 1,
		ClipsDescendants = false,
		[Roact.Event.Activated] = self.onActivated,
		[Roact.Ref] = self.moreButtonRef
	}, {
		Icon = Roact.createElement(imageSetLabel, {
			Size = udim2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Image = images["icons/actions/friends/friendsplaying"],
			ImageTransparency = theme.IconEmphasis.Transparency,
			ImageColor3 = theme.IconEmphasis.Color
		})
	})
end

return RoactRodux.connect(function(p2, p3)
	local fetchingStatus = module2.GetFetchingStatus(p2, p3.universeId)

	local overlayType = p2.CentralOverlay.OverlayType
	return {
		screenWidth = p2.ScreenSize.X,
		isLoading = fetchingStatus == retrievalStatus.NotStarted or fetchingStatus == retrievalStatus.Fetching,
		isFetchFailed = fetchingStatus == retrievalStatus.Failed,
		isOverlayBlocking = overlayType == centralOverlayType.GameDetailMore or overlayType == centralOverlayType.GameDetailsPlayWithFriends
	}
end, function(p2)
	return {
		openContextualMenu = function(p3, p4, p5)
			if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
				p5 = nil
			end

			p2(module3(p3, p4, nil, p5))
		end
	}
end)(extended)
