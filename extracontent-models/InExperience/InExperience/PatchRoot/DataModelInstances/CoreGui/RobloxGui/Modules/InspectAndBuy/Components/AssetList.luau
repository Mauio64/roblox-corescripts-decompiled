local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local AssetCard = require(ParentParent.Components.AssetCard)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local SetAssetFromBundleInfo = require(ParentParent.Actions.SetAssetFromBundleInfo)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local v13 = Roact.PureComponent:extend("AssetList")

function v13.calculateCanvasSize(p1, p2, p3, p4) -- line: 25
	local current = p1.gridFrameRef.current
	local view = p1.props.view
	local v21 = p1.props.views[view]

	if current then
		local v22 = v21.TopSizeY + 15
		local v23 = math.ceil(p3 / p2) * (p4 + 10) + v22

		current.Parent.CanvasSize = UDim2.new(1, 0, 0, v23)
	end
end
function v13.init(p5) -- line: 38
	-- upvalues: Roact (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
	local view = p5.props.view
	local v26 = p5.props.views[view]

	p5.gridFrameRef = Roact.createRef()
	p5.state = {
		assetCardSizeX = v26.AssetCardMaxSizeX,
		assetCardSizeY = v26.AssetCardMaxSizeY,
		assetCardsLoaded = not FFlagAddNewPlayerListMobileFocusNav and nil
	}
end
function v13.render(p6) -- line: 52
	-- upvalues: Roact (copy), AssetCard (copy), Skeleton (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
	local view = p6.props.view
	local v29 = p6.props.views[view]
	local assets = p6.props.assets
	local MaxAssetCardsPerRow = v29.MaxAssetCardsPerRow
	local assetCardSizeX = p6.state.assetCardSizeX
	local assetCardSizeY = p6.state.assetCardSizeY
	local t1 = {}
	local n1 = 0

	t1.UIGridLayout = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(0, 10, 0, 10),
		CellSize = UDim2.new(0, assetCardSizeX, 0, assetCardSizeY),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirectionMaxCells = MaxAssetCardsPerRow
	})

	for _, v in pairs(assets) do
		n1 += 1
		t1[v.assetId] = Roact.createElement(AssetCard, {
			assetInfo = v,
			assetCardSizeX = assetCardSizeX
		})
	end

	if n1 == 0 then
		for i = 1, 30 do
			t1[i] = Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, assetCardSizeX)
			})
		end
	elseif FFlagAddNewPlayerListMobileFocusNav then
		p6:setState({
			assetCardsLoaded = true
		})
	end

	p6:calculateCanvasSize(MaxAssetCardsPerRow, n1, assetCardSizeY)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, -(2 * v29.BorderPaddingSize), 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		[Roact.Ref] = p6.gridFrameRef,
		[Roact.Change.AbsoluteSize] = function(_) -- line: 104
			-- upvalues: p6 (copy)
			spawn(function() -- line: 105
				-- upvalues: p6 (copy)
				p6:resize()
			end)
		end
	}, t1)
end
function v13.didMount(p8) -- line: 112
	p8:resize()
	p8.mounted = true
end
function v13.updateAssetsFromBundles(p9) -- line: 126
	-- upvalues: Cryo (copy)
	local bundles = p9.props.bundles
	local assetBundles = p9.props.assetBundles
	local assets = p9.props.assets
	local v44 = Cryo.Dictionary.keys(assets)

	if not bundles or Cryo.isEmpty(bundles) then
		return
	end

	local n2 = 1

	for _, v in pairs(bundles) do
		local assetIds = v.assetIds

		for i = 1, #assetIds do
			local str = tostring(assetIds[i])

			if table.find(v44, str) then
				local v51 = assetBundles[str] or {}

				if #v51 == 1 or n2 == 1 and #v51 > 1 and assets[str] and assets[str].parentBundleId == nil then
					p9.props.dispatchSetAssetFromBundleInfo(str, v)
				end
			end
		end

		n2 += 1
	end
end
function v13.didUpdate(p10, p11) -- line: 166
	-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy), GuiService (copy)
	if p10.props.view ~= p11.view then
		p10:resize()
	end

	if p10.mounted and p10.props.gamepadEnabled and not p10.props.detailsInformation.viewingDetails and p10.props.visible and (not FFlagAddNewPlayerListMobileFocusNav or p10.state.assetCardsLoaded) then
		GuiService.SelectedCoreObject = p10.gridFrameRef.current:FindFirstChildWhichIsA("GuiObject")
	end

	if p10.props.assetBundles ~= p11.assetBundles or p10.props.bundles ~= p11.bundles then
		p10:updateAssetsFromBundles()
	end
end
function v13.willUnmount(p12) -- line: 186
	p12.mounted = false
end
function v13.resize(p13) -- line: 190
	local current = p13.gridFrameRef.current
	local view = p13.props.view
	local v58 = p13.props.views[view]

	if current then
		local MaxAssetCardsPerRow = v58.MaxAssetCardsPerRow
		local v60 = math.floor((current.AbsoluteSize.X - 10 * (MaxAssetCardsPerRow - 1)) / MaxAssetCardsPerRow)
		local v61 = math.min(v60, v58.AssetCardMaxSizeX)
		local v62 = math.min(v60 / 0.68, v58.AssetCardMaxSizeY)

		if v61 ~= p13.state.assetCardSizeX or v62 ~= p13.state.assetCardSizeY then
			p13:setState({
				assetCardSizeX = v61,
				assetCardSizeY = v62
			})
		end
	end
end

local function AssetListWrapper(p14) -- line: 212
	-- upvalues: Roact (copy), InspectAndBuyContext (copy), Cryo (copy), v13 (copy)
	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p15) -- line: 214
			-- upvalues: Cryo (copy), p14 (copy), Roact (copy), v13 (copy)
			local v69 = Cryo.Dictionary.join(p14, {
				views = p15
			})

			return Roact.createElement(v13, v69)
		end
	})
end

return RoactRodux.connect(function(p16, _) -- line: 221
	return {
		view = p16.view,
		visible = p16.visible,
		assets = p16.assets,
		bundles = p16.bundles,
		assetBundles = p16.assetBundles,
		detailsInformation = p16.detailsInformation,
		gamepadEnabled = p16.gamepadEnabled
	}
end, function(p18) -- line: 231
	-- upvalues: SetAssetFromBundleInfo (copy)
	return {
		dispatchSetAssetFromBundleInfo = function(p19, p20) -- line: 233
			-- upvalues: p18 (copy), SetAssetFromBundleInfo (copy)
			p18(SetAssetFromBundleInfo(p19, p20))
		end
	}
end)(AssetListWrapper)
