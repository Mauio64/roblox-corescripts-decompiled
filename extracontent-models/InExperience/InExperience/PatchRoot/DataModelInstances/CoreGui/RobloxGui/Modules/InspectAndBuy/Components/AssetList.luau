local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local AssetCard = require(parent.Components.AssetCard)
local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)
local SetAssetFromBundleInfo = require(parent.Actions.SetAssetFromBundleInfo)

local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

local extended = Roact.PureComponent:extend("AssetList")

function extended:calculateCanvasSize(p, p2, p3)
	local current = self.gridFrameRef.current
	local view = self.props.view

	local view2 = self.props.views[view]

	if current then
		local v = view2.TopSizeY + 15
		local v2 = math.ceil(p2 / p) * (p3 + 10) + v
		current.Parent.CanvasSize = UDim2.new(1, 0, 0, v2)
	end
end

function extended:init()
	local view = self.props.view

	local view2 = self.props.views[view]

	self.gridFrameRef = Roact.createRef()

	self.state = {
		assetCardSizeX = view2.AssetCardMaxSizeX,
		assetCardSizeY = view2.AssetCardMaxSizeY,
		assetCardsLoaded = not FFlagAddNewPlayerListMobileFocusNav and nil
	}
end

function extended:render()
	local view = self.props.view

	local view2 = self.props.views[view]

	local assets = self.props.assets
	local maxAssetCardsPerRow = view2.MaxAssetCardsPerRow
	local assetCardSizeX = self.state.assetCardSizeX
	local assetCardSizeY = self.state.assetCardSizeY
	local children = {}

	children.UIGridLayout = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(0, 10, 0, 10),
		CellSize = UDim2.new(0, assetCardSizeX, 0, assetCardSizeY),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirectionMaxCells = maxAssetCardsPerRow
	})
	local count = 0

	for _, asset in pairs(assets) do
		count += 1
		children[asset.assetId] = Roact.createElement(AssetCard, {
			assetInfo = asset,
			assetCardSizeX = assetCardSizeX
		})
	end

	if count == 0 then
		for i = 1, 30 do
			children[i] = Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, assetCardSizeX)
			})
		end
	elseif FFlagAddNewPlayerListMobileFocusNav then
		self:setState({ assetCardsLoaded = true })
	end

	self:calculateCanvasSize(maxAssetCardsPerRow, count, assetCardSizeY)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, -(2 * view2.BorderPaddingSize), 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		[Roact.Ref] = self.gridFrameRef,
		[Roact.Change.AbsoluteSize] = function(_)
			spawn(function()
				self:resize()
			end)
		end
	}, children)
end

function extended:didMount()
	self:resize()
	self.mounted = true
end

function extended:updateAssetsFromBundles()
	local bundles = self.props.bundles
	local assetBundles = self.props.assetBundles
	local assets = self.props.assets
	local keys = Cryo.Dictionary.keys(assets)

	if not bundles or Cryo.isEmpty(bundles) then
		return
	end

	local v = 1

	for _, bundle in pairs(bundles) do
		local assetIds = bundle.assetIds

		for i = 1, #assetIds do
			local v2 = tostring(assetIds[i])

			if not table.find(keys, v2) then
				continue
			end

			local v3 = assetBundles[v2] or {}

			if not (#v3 == 1 or v == 1 and #v3 > 1 and assets[v2] and assets[v2].parentBundleId == nil) then
				continue
			end

			self.props.dispatchSetAssetFromBundleInfo(v2, bundle)
		end

		v += 1
	end
end

function extended:didUpdate(data)
	if self.props.view ~= data.view then
		self:resize()
	end

	if
		self.mounted
		and self.props.gamepadEnabled
		and not self.props.detailsInformation.viewingDetails
		and self.props.visible
		and (not FFlagAddNewPlayerListMobileFocusNav or self.state.assetCardsLoaded)
	then
		GuiService.SelectedCoreObject = self.gridFrameRef.current:FindFirstChildWhichIsA("GuiObject")
	end

	if self.props.assetBundles ~= data.assetBundles or self.props.bundles ~= data.bundles then
		self:updateAssetsFromBundles()
	end
end

function extended:willUnmount()
	self.mounted = false
end

function extended:resize()
	local current = self.gridFrameRef.current
	local view = self.props.view

	local view2 = self.props.views[view]

	if current then
		local maxAssetCardsPerRow = view2.MaxAssetCardsPerRow

		local v = math.floor((current.AbsoluteSize.X - 10 * (maxAssetCardsPerRow - 1)) / maxAssetCardsPerRow)
		local assetCardSizeX = math.min(v, view2.AssetCardMaxSizeX)
		local assetCardSizeY = math.min(v / 0.68, view2.AssetCardMaxSizeY)

		if self.state.assetCardSizeX ~= assetCardSizeX or self.state.assetCardSizeY ~= assetCardSizeY then
			self:setState({ assetCardSizeX = assetCardSizeX, assetCardSizeY = assetCardSizeY })
		end
	end
end

local function AssetListWrapper(p)
	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(views)
			local joined = Cryo.Dictionary.join(p, { views = views })
			return Roact.createElement(extended, joined)
		end
	})
end

return RoactRodux.connect(function(data, _)
	return {
		view = data.view,
		visible = data.visible,
		assets = data.assets,
		bundles = data.bundles,
		assetBundles = data.assetBundles,
		detailsInformation = data.detailsInformation,
		gamepadEnabled = data.gamepadEnabled
	}
end, function(callback)
	return {
		dispatchSetAssetFromBundleInfo = function(p, p2)
			callback(SetAssetFromBundleInfo(p, p2))
		end
	}
end)(AssetListWrapper)
