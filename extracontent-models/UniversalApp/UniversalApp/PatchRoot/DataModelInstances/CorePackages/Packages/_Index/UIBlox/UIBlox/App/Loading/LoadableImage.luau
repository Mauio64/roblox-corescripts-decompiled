local v = nil

pcall(function()
	local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
	v = RbxAnalyticsService
end)

local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local core = parent3.Core

local Roact = require(parent4.Roact)
local t = require(parent4.t)
local Cryo = require(parent4.Cryo)
local Foundation = require(parent4.Foundation)

local Skeleton = Foundation.Skeleton
local DebugProps = require(parent.Enum.DebugProps)
local LoadingStrategy = require(parent.Enum.LoadingStrategy)
local withStyle = require(parent3.Core.Style.withStyle)
local getClosestRadius = require(parent2.Loading.getClosestRadius)

local Images = require(parent3.App.ImageSet.Images)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local validateImageSetData = require(core.ImageSet.Validator.validateImageSetData)

local ContentProvider = require(parent3.App.Context.ContentProvider)

local extended = Roact.PureComponent:extend("LoadableImage")

extended.validateProps = t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	BackgroundColor3 = t.optional(t.Color3),
	BackgroundTransparency = t.optional(t.number),
	cornerRadius = t.optional(t.UDim),
	Image = t.optional(t.union(t.string, validateImageSetData)),
	ImageColor3 = t.optional(t.Color3),
	ImageTransparency = t.optional(t.number),
	ImageRectOffset = t.optional(t.union(t.Vector2, t.table)),
	ImageRectSize = t.optional(t.union(t.Vector2, t.table)),
	LayoutOrder = t.optional(t.integer),
	loadingImage = t.optional(t.union(t.string, t.table)),
	loadingStrategy = t.optional(LoadingStrategy.isEnumValue),
	loadingTimeout = t.optional(t.numberPositive),
	renderOnLoading = t.optional(t.callback),
	renderOnFailed = t.optional(t.callback),
	MaxSize = t.optional(t.Vector2),
	MinSize = t.optional(t.Vector2),
	onLoaded = t.optional(t.callback),
	Position = t.optional(t.UDim2),
	ScaleType = t.optional(t.enum(Enum.ScaleType)),
	Size = t.UDim2,
	TileSize = t.optional(t.UDim2),
	useShimmerAnimationWhileLoading = t.optional(t.boolean),
	showFailedStateWhenLoadingFailed = t.optional(t.boolean),
	ZIndex = t.optional(t.integer),
	shouldHandleReloads = t.optional(t.boolean),
	contentProvider = t.union(t.instanceOf("ContentProvider"), t.table),
	[DebugProps.forceLoading] = t.optional(t.boolean),
	[DebugProps.forceFailed] = t.optional(t.boolean)
})

extended.defaultProps = {
	BackgroundTransparency = 0,
	cornerRadius = UDim.new(0, 0),
	MaxSize = Vector2.new(1e999, 1e999),
	MinSize = Vector2.new(0, 0),
	useShimmerAnimationWhileLoading = false,
	showFailedStateWhenLoadingFailed = false,
	loadingStrategy = LoadingStrategy.Default,
	loadingTimeout = 30,
	shouldHandleReloads = false
}

function extended:init()
	self.currentImageLoadIndex = 0
	self:setState({ eagerRetrying = false })

	self.imageRef = Roact.createRef()
	self._isMounted = false
end

function extended:renderShimmer(p, uiSizeConstraint, p2)
	return Roact.createElement("Frame", {
		AnchorPoint = self.props.AnchorPoint,
		BorderSizePixel = 0,
		BackgroundColor3 = p.PlaceHolder.Color,
		BackgroundTransparency = p.PlaceHolder.Transparency,
		LayoutOrder = self.props.LayoutOrder,
		Position = self.props.Position,
		Size = self.props.Size,
		ZIndex = self.props.ZIndex
	}, {
		Shimmer = Roact.createElement(Skeleton, {
			Size = UDim2.fromScale(1, 1),
			radius = getClosestRadius({
				None = p2.Radius.None,
				Small = p2.Radius.Small,
				Medium = p2.Radius.Medium,
				Large = p2.Size.Size_300,
				XLarge = p2.Radius.Large,
				Circle = p2.Radius.Circle
			}, self.props.cornerRadius)
		}),
		UISizeConstraint = uiSizeConstraint,
		UICorner = Roact.createElement("UICorner", { CornerRadius = self.props.cornerRadius }) or nil
	})
end

function extended:defaultRenderOnFail(p, uiSizeConstraint)
	local cornerRadius = self.props.cornerRadius

	local iconsstatusimageunavailable = Images["icons/status/imageunavailable"]
	local v2 = iconsstatusimageunavailable.ImageRectSize / Images.ImagesResolutionScale

	local createElement = Roact.createElement
	local v3 = {
		AnchorPoint = self.props.AnchorPoint,
		BorderSizePixel = 0,
		BackgroundColor3 = p.PlaceHolder.Color,
		BackgroundTransparency = p.PlaceHolder.Transparency,
		LayoutOrder = self.props.LayoutOrder,
		Position = self.props.Position,
		Size = self.props.Size,
		ZIndex = self.props.ZIndex
	}

	local createElement2 = Roact.createElement
	local label = ImageSetComponent.Label
	local v4 = {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = iconsstatusimageunavailable,
		ImageColor3 = p.UIDefault.Color,
		ImageTransparency = p.UIDefault.Transparency,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, v2.X, 0, v2.Y)
	}
	local uiCorner

	if cornerRadius ~= UDim.new(0, 0) then
		uiCorner = Roact.createElement("UICorner", { CornerRadius = cornerRadius }) or nil
	end

	local v5 = {
		EmptyIcon = createElement2(label, v4, { UICorner = uiCorner }),
		UISizeConstraint = uiSizeConstraint,
		UICorner = 0
	}
	local uiCorner2

	if cornerRadius ~= UDim.new(0, 0) then
		uiCorner2 = Roact.createElement("UICorner", { CornerRadius = cornerRadius }) or nil
	end

	v5.UICorner = uiCorner2
	return createElement("Frame", v3, v5)
end

function extended:isImageNonNil(): boolean
	return self.props.Image ~= Roact.None and self.props.Image ~= nil
end

function extended:getCurrentImageAssetFetchStatus(p)
	local currentImageAssetFetchStatus = p[self:getAssetFetchStatusStateKey(self.currentImageLoadIndex)]

	if currentImageAssetFetchStatus == nil then
		currentImageAssetFetchStatus = Enum.AssetFetchStatus.None
	end

	return currentImageAssetFetchStatus
end

function extended:isLoadingComplete(p): boolean
	local currentImageAssetFetchStatus = self:getCurrentImageAssetFetchStatus(p)

	if
		currentImageAssetFetchStatus == Enum.AssetFetchStatus.None
		or currentImageAssetFetchStatus == Enum.AssetFetchStatus.Loading
		or (currentImageAssetFetchStatus == Enum.AssetFetchStatus.Failure or currentImageAssetFetchStatus == Enum.AssetFetchStatus.TimedOut)
		and p.eagerRetrying
	then
		return false
	end

	return true
end

function extended:render()
	local anchorPoint = self.props.AnchorPoint
	local layoutOrder = self.props.LayoutOrder
	local size = self.props.Size
	local position = self.props.Position
	local backgroundColor3 = self.props.BackgroundColor3
	local backgroundTransparency = self.props.BackgroundTransparency
	local cornerRadius = self.props.cornerRadius
	local scaleType = self.props.ScaleType
	local zIndex = self.props.ZIndex
	local image = self.props.Image
	local imageTransparency = self.props.ImageTransparency
	local imageRectOffset = self.props.ImageRectOffset
	local imageRectSize = self.props.ImageRectSize
	local imageColor3 = self.props.ImageColor3
	local maxSize = self.props.MaxSize
	local minSize = self.props.MinSize
	local renderOnLoading = self.props.renderOnLoading
	local renderOnFailed = self.props.renderOnFailed
	local loadingImage = self.props.loadingImage
	local loadingStrategy = self.props.loadingStrategy
	local useShimmerAnimationWhileLoading = self.props.useShimmerAnimationWhileLoading
	local showFailedStateWhenLoadingFailed = self.props.showFailedStateWhenLoadingFailed
	local v2 = self:isImageNonNil() and self:isLoadingComplete(self.state)

	local currentImageAssetFetchStatus = self:getCurrentImageAssetFetchStatus(self.state)
	local v3 = currentImageAssetFetchStatus ~= Enum.AssetFetchStatus.None
	local v4 = currentImageAssetFetchStatus == Enum.AssetFetchStatus.Failure

	if self.props[DebugProps.forceLoading] then
		v2 = false
	end

	local v5 = self.props[DebugProps.forceFailed] and true or v4

	local uiSizeConstraint = (maxSize.X ~= 1e999 or maxSize.Y ~= 1e999 or minSize.X ~= 0 or minSize.Y ~= 0 or false)
		and Roact.createElement("UISizeConstraint", { MaxSize = maxSize, MinSize = minSize })

	return withStyle(function(p)
		local theme = p.Theme
		local tokens = p.Tokens

		if v5 and renderOnFailed then
			return renderOnFailed()
		end

		if v5 and showFailedStateWhenLoadingFailed then
			return self:defaultRenderOnFail(theme, uiSizeConstraint)
		end

		if not v2 and renderOnLoading and loadingStrategy ~= LoadingStrategy.Default then
			return renderOnLoading()
		end

		if not v2 and useShimmerAnimationWhileLoading and loadingStrategy ~= LoadingStrategy.Default then
			return self:renderShimmer(theme, uiSizeConstraint, tokens)
		end

		local v6 = v2 or loadingStrategy == LoadingStrategy.Default
		local onLoading

		if not (v2 or not renderOnLoading or loadingStrategy ~= LoadingStrategy.Default) then
			onLoading = renderOnLoading()
		end

		local shimmer

		if not (v2 or not useShimmerAnimationWhileLoading or loadingStrategy ~= LoadingStrategy.Default or not v3) then
			shimmer = self:renderShimmer(theme, uiSizeConstraint, tokens)
		end

		local createElement = Roact.createElement
		local label = ImageSetComponent.Label
		local imageRefsByRef = {
			AnchorPoint = anchorPoint,
			BackgroundColor3 = backgroundColor3 or theme.PlaceHolder.Color,
			BackgroundTransparency = backgroundTransparency or theme.PlaceHolder.Transparency,
			BorderSizePixel = 0,
			Image = v6 and image or loadingImage,
			ImageTransparency = imageTransparency,
			ImageRectOffset = imageRectOffset,
			ImageRectSize = imageRectSize,
			ImageColor3 = v6 and imageColor3 or nil,
			LayoutOrder = layoutOrder,
			Position = position,
			ScaleType = scaleType,
			TileSize = self.props.TileSize,
			Size = size,
			ZIndex = zIndex,
			[Roact.Ref] = self.imageRef
		}
		local v7 = { UISizeConstraint = uiSizeConstraint, UICorner = 0, OnLoading = 0, Shimmer = 0 }
		local uiCorner

		if cornerRadius ~= UDim.new(0, 0) then
			uiCorner = Roact.createElement("UICorner", { CornerRadius = cornerRadius }) or nil
		end

		v7.UICorner = uiCorner

		v7.OnLoading = onLoading
		v7.Shimmer = shimmer
		return createElement(label, imageRefsByRef, v7)
	end)
end

function extended:maybeCallOnLoaded(p)
	if self.props.onLoaded then
		local loadingComplete = self:isLoadingComplete(p)
		local loadingComplete2 = self:isLoadingComplete(self.state)

		if not loadingComplete and loadingComplete2 then
			self.props.onLoaded()
		end
	end
end

function extended:didUpdate(p, p2)
	if p.Image ~= self.props.Image then
		self:loadImage()
	end

	self:maybeCallOnLoaded(p2)
end

function extended:didMount()
	self._isMounted = true

	self:loadImage()
end

function extended:willUnmount()
	self._isMounted = false
	self:dropConnections()
end

function extended:isTerminalStatus(p): boolean
	return p == Enum.AssetFetchStatus.Success
		or p == Enum.AssetFetchStatus.Failure
		or p == Enum.AssetFetchStatus.TimedOut
end

function extended:getImageUri()
	if not self.props.Image then
		return nil
	end

	if typeof(self.props.Image) == "string" then
		return self.props.Image
	end

	return self.props.Image.Image
end

function extended:awaitImageLoaded(p, p2)
	if self:isTerminalStatus(p2) then
		return
	end

	local imageUri = self:getImageUri()

	local function fn(success) -- 1 equivalent call inferred from this helper
		self:updateAssetFetchStatusForImageLoadIndex(success, p, imageUri)
		self:maybeReportCounter("Await", success)

		if self:isTerminalStatus(success) and self.awaitImageLoadedConnection then
			self.awaitImageLoadedConnection:Disconnect()
			self.awaitImageLoadedConnection = nil
		end
	end

	if imageUri ~= "" then
		self.awaitImageLoadedConnection = self.props.contentProvider:GetAssetFetchStatusChangedSignal(imageUri):Connect(fn)
		return
	end

	fn(Enum.AssetFetchStatus.Success) -- inferred equivalent call
end

function extended:maybeReportCounter(p, p2)
	pcall(function()
		local v2 = "UIBlox_LoadableImage_" .. p .. "_" .. tostring(p2)
		v:ReportCounter(v2)
	end)
end

function extended:preloadImageWithRetryLogic(p)
	local imageUri = self:getImageUri()

	local v2 = Enum.AssetFetchStatus.None
	local count = 0

	while self._isMounted do
		if count > 0 then
			task.wait(math.pow(2, count - 1) * 1.5)
		end

		self.props.contentProvider:PreloadAsync({ imageUri }, function(_, p2)
			local imageUri2 = self:getImageUri()

			if self._isMounted and imageUri2 == imageUri then
				self:maybeReportCounter("PreloadAsync", p2)
				v2 = p2
				self:updateAssetFetchStatusForImageLoadIndex(p2, p, imageUri)
			end
		end)

		local imageUri2 = self:getImageUri()

		if not self._isMounted or imageUri2 ~= imageUri then
			break
		end

		if v2 ~= Enum.AssetFetchStatus.Success then
			count += 1

			if
				(v2 ~= Enum.AssetFetchStatus.Failure or not (count > 3))
				and (v2 ~= Enum.AssetFetchStatus.TimedOut or not (count > 5))
			then
				self:setState({ eagerRetrying = true })
				continue
			end
		end

		self:setState({ eagerRetrying = false })
		break
	end
end

function extended:getAssetFetchStatusStateKey(p)
	return "assetFetchStatus_" .. tostring(p)
end

function extended:updateAssetFetchStatusForImageLoadIndex(p, p2, _)
	self:setState({ [self:getAssetFetchStatusStateKey(p2)] = p })
end

function extended:dropConnections()
	if self.listenForReloadsConnection then
		self.listenForReloadsConnection:Disconnect()
		self.listenForReloadsConnection = nil
	end

	if self.awaitImageLoadedConnection then
		self.awaitImageLoadedConnection:Disconnect()
		self.awaitImageLoadedConnection = nil
	end
end

function extended:loadImage()
	local currentImageLoadIndex = self.currentImageLoadIndex + 1
	self.currentImageLoadIndex = currentImageLoadIndex

	local imageUri = self:getImageUri()
	local loadingStrategy = self.props.loadingStrategy

	self:dropConnections()

	if imageUri == nil then
		self:updateAssetFetchStatusForImageLoadIndex(Enum.AssetFetchStatus.Success, currentImageLoadIndex, imageUri)

		self:setState({ eagerRetrying = false })
	else
		local assetFetchStatus = self.props.contentProvider:GetAssetFetchStatus(imageUri)
		self:maybeReportCounter("InitialStatus", assetFetchStatus)
		self:updateAssetFetchStatusForImageLoadIndex(assetFetchStatus, currentImageLoadIndex, imageUri)

		if self.props.shouldHandleReloads then
			self.listenForReloadsConnection = self.props.contentProvider:GetAssetFetchStatusChangedSignal(imageUri):Connect(function(p, _)
				self:maybeReportCounter("Reloads", p)
				self:updateAssetFetchStatusForImageLoadIndex(p, currentImageLoadIndex, imageUri)
			end)
		end

		if loadingStrategy == LoadingStrategy.Eager then
			task.spawn(function()
				self:preloadImageWithRetryLogic(currentImageLoadIndex)
			end)
		elseif loadingStrategy == LoadingStrategy.Default then
			self:awaitImageLoaded(currentImageLoadIndex, assetFetchStatus)
		end
	end
end

return function(p)
	return Roact.createElement(ContentProvider.Consumer, {
		render = function(contentProvider)
			local joined = Cryo.Dictionary.join(p, { contentProvider = contentProvider })

			return Roact.createElement(extended, joined)
		end
	})
end
