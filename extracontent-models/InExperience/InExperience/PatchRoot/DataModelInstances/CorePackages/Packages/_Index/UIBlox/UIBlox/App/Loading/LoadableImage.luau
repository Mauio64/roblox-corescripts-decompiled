local RbxAnalyticsService = nil

pcall(function() -- line: 5
	-- upvalues: RbxAnalyticsService (ref)
	RbxAnalyticsService = game:GetService("RbxAnalyticsService")
end)

local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Core = scriptParentParentParent.Core
local Roact = require(scriptParentParentParentParent.Roact)
local t = require(scriptParentParentParentParent.t)
local Cryo = require(scriptParentParentParentParent.Cryo)
local Skeleton = require(scriptParentParentParentParent.Foundation).Skeleton
local DebugProps = require(scriptParent.Enum.DebugProps)
local LoadingStrategy = require(scriptParent.Enum.LoadingStrategy)
local withStyle = require(scriptParentParentParent.Core.Style.withStyle)
local getClosestRadius = require(scriptParentParent.Loading.getClosestRadius)
local Images = require(scriptParentParentParent.App.ImageSet.Images)
local ImageSetComponent = require(scriptParentParentParent.Core.ImageSet.ImageSetComponent)
local validateImageSetData = require(Core.ImageSet.Validator.validateImageSetData)
local ContentProvider = require(scriptParentParentParent.App.Context.ContentProvider)
local v19 = Roact.PureComponent:extend("LoadableImage")

v19.validateProps = t.strictInterface({
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
v19.defaultProps = {
	BackgroundTransparency = 0,
	useShimmerAnimationWhileLoading = false,
	showFailedStateWhenLoadingFailed = false,
	loadingTimeout = 30,
	shouldHandleReloads = false,
	cornerRadius = UDim.new(0, 0),
	MaxSize = Vector2.new(1e999, 1e999),
	MinSize = Vector2.new(0, 0),
	loadingStrategy = LoadingStrategy.Default
}

function v19.init(p1) -- line: 114
	-- upvalues: Roact (copy)
	p1.currentImageLoadIndex = 0
	p1:setState({
		eagerRetrying = false
	})
	p1.imageRef = Roact.createRef()
	p1._isMounted = false
end
function v19.renderShimmer(p2, p3, p4, p5) -- line: 124
	-- upvalues: Roact (copy), Skeleton (copy), getClosestRadius (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = p2.props.AnchorPoint,
		BackgroundColor3 = p3.PlaceHolder.Color,
		BackgroundTransparency = p3.PlaceHolder.Transparency,
		LayoutOrder = p2.props.LayoutOrder,
		Position = p2.props.Position,
		Size = p2.props.Size,
		ZIndex = p2.props.ZIndex
	}, {
		Shimmer = Roact.createElement(Skeleton, {
			Size = UDim2.fromScale(1, 1),
			radius = getClosestRadius(p5.Semantic.Radius, p2.props.cornerRadius)
		}),
		UISizeConstraint = p4,
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = p2.props.cornerRadius
		}) or nil
	})
end
function v19.defaultRenderOnFail(p6, p7, p8) -- line: 146
	-- upvalues: Images (copy), Roact (copy), ImageSetComponent (copy)
	local cornerRadius = p6.props.cornerRadius
	local v29 = Images["icons/status/imageunavailable"]
	local v30 = v29.ImageRectSize / Images.ImagesResolutionScale

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = p6.props.AnchorPoint,
		BackgroundColor3 = p7.PlaceHolder.Color,
		BackgroundTransparency = p7.PlaceHolder.Transparency,
		LayoutOrder = p6.props.LayoutOrder,
		Position = p6.props.Position,
		Size = p6.props.Size,
		ZIndex = p6.props.ZIndex
	}, {
		EmptyIcon = Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = v29,
			ImageColor3 = p7.UIDefault.Color,
			ImageTransparency = p7.UIDefault.Transparency,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, v30.X, 0, v30.Y)
		}, {
			UICorner = cornerRadius ~= UDim.new(0, 0) and Roact.createElement("UICorner", {
				CornerRadius = cornerRadius
			}) or nil
		}),
		UISizeConstraint = p8,
		UICorner = cornerRadius ~= UDim.new(0, 0) and Roact.createElement("UICorner", {
			CornerRadius = cornerRadius
		}) or nil
	})
end
function v19.isImageNonNil(p9) -- line: 182
	-- upvalues: Roact (copy)
	return p9.props.Image ~= Roact.None and p9.props.Image ~= nil
end
function v19.getCurrentImageAssetFetchStatus(p10, p11) -- line: 186
	local v34 = p11[p10:getAssetFetchStatusStateKey(p10.currentImageLoadIndex)]

	if v34 == nil then
		v34 = Enum.AssetFetchStatus.None
	end

	return v34
end
function v19.isLoadingComplete(p12, p13) -- line: 196
	local v37 = p12:getCurrentImageAssetFetchStatus(p13)

	if v37 == Enum.AssetFetchStatus.None or v37 == Enum.AssetFetchStatus.Loading then
		return false
	end

	if (v37 == Enum.AssetFetchStatus.Failure or v37 == Enum.AssetFetchStatus.TimedOut) and p13.eagerRetrying then
		return false
	end

	return true
end
function v19.render(p14) -- line: 209
	-- upvalues: DebugProps (copy), Roact (copy), withStyle (copy), LoadingStrategy (copy), ImageSetComponent (copy)
	local propsAnchorPoint = p14.props.AnchorPoint
	local propsLayoutOrder = p14.props.LayoutOrder
	local propsSize = p14.props.Size
	local propsPosition = p14.props.Position
	local propsBackgroundColor3 = p14.props.BackgroundColor3
	local propsBackgroundTransparency = p14.props.BackgroundTransparency
	local cornerRadius = p14.props.cornerRadius
	local propsScaleType = p14.props.ScaleType
	local propsZIndex = p14.props.ZIndex
	local propsImage = p14.props.Image
	local propsImageTransparency = p14.props.ImageTransparency
	local ImageRectOffset = p14.props.ImageRectOffset
	local ImageRectSize = p14.props.ImageRectSize
	local propsImageColor3 = p14.props.ImageColor3
	local MaxSize = p14.props.MaxSize
	local MinSize = p14.props.MinSize
	local renderOnLoading = p14.props.renderOnLoading
	local renderOnFailed = p14.props.renderOnFailed
	local loadingImage = p14.props.loadingImage
	local loadingStrategy = p14.props.loadingStrategy
	local useShimmerAnimationWhileLoading = p14.props.useShimmerAnimationWhileLoading
	local showFailedStateWhenLoadingFailed = p14.props.showFailedStateWhenLoadingFailed
	local u61 = p14:isImageNonNil() and p14:isLoadingComplete(p14.state)
	local v62 = p14:getCurrentImageAssetFetchStatus(p14.state)
	local v63 = v62 ~= Enum.AssetFetchStatus.None
	local u64 = v62 == Enum.AssetFetchStatus.Failure
	local v65 = false

	if p14.props[DebugProps.forceLoading] then
		u61 = false
	end

	if p14.props[DebugProps.forceFailed] then
		u64 = true
	end

	if MaxSize.X ~= 1e999 or MaxSize.Y ~= 1e999 or MinSize.X ~= 0 or MinSize.Y ~= 0 then
		v65 = true
	end

	local v66 = v65 and Roact.createElement("UISizeConstraint", {
		MaxSize = MaxSize,
		MinSize = MinSize
	})

	return withStyle(function(p15) -- line: 257
		-- upvalues: u64 (ref), renderOnFailed (copy), showFailedStateWhenLoadingFailed (copy), p14 (copy), v66 (copy), u61 (ref), renderOnLoading (copy), loadingStrategy (copy), LoadingStrategy (copy), useShimmerAnimationWhileLoading (copy), v63 (copy), Roact (copy), ImageSetComponent (copy), propsAnchorPoint (copy), propsBackgroundColor3 (copy), propsBackgroundTransparency (copy), propsImage (copy), loadingImage (copy), propsImageTransparency (copy), ImageRectOffset (copy), ImageRectSize (copy), propsImageColor3 (copy), propsLayoutOrder (copy), propsPosition (copy), propsScaleType (copy), propsSize (copy), propsZIndex (copy), cornerRadius (copy)
		local Theme = p15.Theme
		local Tokens = p15.Tokens

		if u64 and renderOnFailed then
			return renderOnFailed()
		end

		if u64 and showFailedStateWhenLoadingFailed then
			return p14:defaultRenderOnFail(Theme, v66)
		end

		if not u61 and renderOnLoading and loadingStrategy ~= LoadingStrategy.Default then
			return renderOnLoading()
		end

		if not u61 and useShimmerAnimationWhileLoading and loadingStrategy ~= LoadingStrategy.Default then
			return p14:renderShimmer(Theme, v66, Tokens)
		end

		local v110 = u61 or loadingStrategy == LoadingStrategy.Default
		local v111 = nil

		if not u61 and renderOnLoading and loadingStrategy == LoadingStrategy.Default then
			v111 = renderOnLoading()
		end

		local v112 = nil

		if not u61 and useShimmerAnimationWhileLoading and loadingStrategy == LoadingStrategy.Default and v63 then
			v112 = p14:renderShimmer(Theme, v66, Tokens)
		end

		return Roact.createElement(ImageSetComponent.Label, {
			AnchorPoint = propsAnchorPoint,
			BackgroundColor3 = propsBackgroundColor3 or Theme.PlaceHolder.Color,
			BackgroundTransparency = propsBackgroundTransparency or Theme.PlaceHolder.Transparency,
			BorderSizePixel = 0,
			Image = v110 and propsImage or loadingImage,
			ImageTransparency = propsImageTransparency,
			ImageRectOffset = ImageRectOffset,
			ImageRectSize = ImageRectSize,
			ImageColor3 = v110 and propsImageColor3 or nil,
			LayoutOrder = propsLayoutOrder,
			Position = propsPosition,
			ScaleType = propsScaleType,
			TileSize = p14.props.TileSize,
			Size = propsSize,
			ZIndex = propsZIndex,
			[Roact.Ref] = p14.imageRef
		}, {
			UISizeConstraint = v66,
			UICorner = cornerRadius ~= UDim.new(0, 0) and Roact.createElement("UICorner", {
				CornerRadius = cornerRadius
			}) or nil,
			OnLoading = v111,
			Shimmer = v112
		})
	end)
end
function v19.maybeCallOnLoaded(p16, p17) -- line: 321
	if p16.props.onLoaded then
		local v69 = p16:isLoadingComplete(p17)
		local v70 = p16:isLoadingComplete(p16.state)

		if not v69 and v70 then
			p16.props.onLoaded()
		end
	end
end
function v19.didUpdate(p18, p19, p20) -- line: 331
	if p19.Image ~= p18.props.Image then
		p18:loadImage()
	end

	p18:maybeCallOnLoaded(p20)
end
function v19.didMount(p21) -- line: 338
	p21._isMounted = true
	p21:loadImage()
end
function v19.willUnmount(p22) -- line: 346
	p22._isMounted = false
	p22:dropConnections()
end
function v19.isTerminalStatus(_, p24) -- line: 351
	return p24 == Enum.AssetFetchStatus.Success or (p24 == Enum.AssetFetchStatus.Failure or p24 == Enum.AssetFetchStatus.TimedOut)
end
function v19.getImageUri(p25) -- line: 361
	if p25.props.Image then
		if typeof(p25.props.Image) == "string" then
			return p25.props.Image
		end

		return p25.props.Image.Image
	end

	return nil
end
function v19.awaitImageLoaded(p26, p27, p28) -- line: 375
	if p26:isTerminalStatus(p28) then
		return
	end

	local v82 = p26:getImageUri()

	if v82 == "" then
		local Success = Enum.AssetFetchStatus.Success

		p26:updateAssetFetchStatusForImageLoadIndex(Success, p27, v82)
		p26:maybeReportCounter("Await", Success)

		if p26:isTerminalStatus(Success) and p26.awaitImageLoadedConnection then
			p26.awaitImageLoadedConnection:Disconnect()
			p26.awaitImageLoadedConnection = nil
		end

		return
	end

	p26.awaitImageLoadedConnection = p26.props.contentProvider:GetAssetFetchStatusChangedSignal(v82):Connect(function(p29) -- line: 386
		-- upvalues: p26 (copy), p27 (copy), v82 (copy)
		p26:updateAssetFetchStatusForImageLoadIndex(p29, p27, v82)
		p26:maybeReportCounter("Await", p29)

		if p26:isTerminalStatus(p29) and p26.awaitImageLoadedConnection then
			p26.awaitImageLoadedConnection:Disconnect()
			p26.awaitImageLoadedConnection = nil
		end
	end)
end
function v19.maybeReportCounter(_, p31, p32) -- line: 404
	-- upvalues: RbxAnalyticsService (ref)
	pcall(function() -- line: 407
		-- upvalues: p31 (copy), p32 (copy), RbxAnalyticsService (ref)
		local v114 = "UIBlox_LoadableImage_" .. p31 .. "_" .. tostring(p32)

		RbxAnalyticsService:ReportCounter(v114)
	end)
end
function v19.preloadImageWithRetryLogic(p33, p34) -- line: 419
	local v89 = p33:getImageUri()
	local n1 = 0
	local None = Enum.AssetFetchStatus.None
	local g93 = nil

	while p33._isMounted do
		if n1 > 0 then
			task.wait(math.pow(2, n1 - 1) * 1.5)
		end

		p33.props.contentProvider:PreloadAsync({ v89 }, function(_, p36) -- line: 434
			-- upvalues: p33 (copy), v89 (copy), None (ref), p34 (copy)
			local v117 = p33:getImageUri()

			if p33._isMounted and v117 == v89 then
				p33:maybeReportCounter("PreloadAsync", p36)
				None = p36
				p33:updateAssetFetchStatusForImageLoadIndex(p36, p34, v89)
			end
		end)

		local v92 = p33:getImageUri()

		if not p33._isMounted or v92 ~= v89 then
			return
		end

		repeat
			if g93 or None == Enum.AssetFetchStatus.Success then
				g93 = false
				p33:setState({
					eagerRetrying = false
				})

				return
			end

			n1 += 1

			if None == Enum.AssetFetchStatus.Failure and n1 > 3 or None == Enum.AssetFetchStatus.TimedOut and n1 > 5 then
				g93 = true
			end
		until not g93

		p33:setState({
			eagerRetrying = true
		})
	end
end
function v19.getAssetFetchStatusStateKey(_, p38) -- line: 481
	return "assetFetchStatus_" .. tostring(p38)
end
function v19.updateAssetFetchStatusForImageLoadIndex(p39, p40, p41, _) -- line: 485
	p39:setState({
		[p39:getAssetFetchStatusStateKey(p41)] = p40
	})
end
function v19.dropConnections(p43) -- line: 492
	if p43.listenForReloadsConnection then
		p43.listenForReloadsConnection:Disconnect()
		p43.listenForReloadsConnection = nil
	end

	if p43.awaitImageLoadedConnection then
		p43.awaitImageLoadedConnection:Disconnect()
		p43.awaitImageLoadedConnection = nil
	end
end
function v19.loadImage(p44) -- line: 503
	-- upvalues: LoadingStrategy (copy)
	local v102 = p44.currentImageLoadIndex + 1

	p44.currentImageLoadIndex = v102

	local v103 = p44:getImageUri()
	local loadingStrategy = p44.props.loadingStrategy

	p44:dropConnections()

	if v103 == nil then
		p44:updateAssetFetchStatusForImageLoadIndex(Enum.AssetFetchStatus.Success, v102, v103)
		p44:setState({
			eagerRetrying = false
		})

		return
	end

	local AssetFetchStatus = p44.props.contentProvider:GetAssetFetchStatus(v103)

	p44:maybeReportCounter("InitialStatus", AssetFetchStatus)
	p44:updateAssetFetchStatusForImageLoadIndex(AssetFetchStatus, v102, v103)

	if p44.props.shouldHandleReloads then
		p44.listenForReloadsConnection = p44.props.contentProvider:GetAssetFetchStatusChangedSignal(v103):Connect(function(p45, _) -- line: 534
			-- upvalues: p44 (copy), v102 (copy), v103 (copy)
			p44:maybeReportCounter("Reloads", p45)
			p44:updateAssetFetchStatusForImageLoadIndex(p45, v102, v103)
		end)
	end

	if loadingStrategy == LoadingStrategy.Eager then
		task.spawn(function() -- line: 543
			-- upvalues: p44 (copy), v102 (copy)
			p44:preloadImageWithRetryLogic(v102)
		end)

		return
	end

	if loadingStrategy == LoadingStrategy.Default then
		p44:awaitImageLoaded(v102, AssetFetchStatus)
	end
end

return function(p47) -- line: 551
	-- upvalues: Roact (copy), ContentProvider (copy), Cryo (copy), v19 (copy)
	return Roact.createElement(ContentProvider.Consumer, {
		render = function(p48) -- line: 553
			-- upvalues: Cryo (copy), p47 (copy), Roact (copy), v19 (copy)
			local v121 = Cryo.Dictionary.join(p47, {
				contentProvider = p48
			})

			return Roact.createElement(v19, v121)
		end
	})
end
