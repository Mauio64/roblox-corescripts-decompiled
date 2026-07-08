local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)
local PromptPurchase = require(ParentParent.Thunks.PromptPurchase)
local getSelectionImageObjectRounded = require(ParentParent.getSelectionImageObjectRounded)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local v13 = Roact.PureComponent:extend("BuyButton")

function v13.init(p1) -- line: 21
	-- upvalues: getSelectionImageObjectRounded (copy), GuiService (copy)
	p1.selectedImage = getSelectionImageObjectRounded()
	p1.connections = {}
	p1.lastGamepadFocus = nil

	function p1.onPromptPurchaseFinished() -- line: 26
		-- upvalues: p1 (copy), GuiService (copy)
		if p1.props.gamepadEnabled and p1.props.visible then
			GuiService.SelectedCoreObject = p1.lastGamepadFocus
		end
	end
end
function v13.render(p2) -- line: 34
	-- upvalues: UtilityFunctions (copy), Roact (copy), Colors (copy), GuiService (copy), AppFonts (copy)
	local itemType = p2.props.itemType
	local itemId = p2.props.itemId
	local showRobuxIcon = p2.props.showRobuxIcon
	local forSale = p2.props.forSale
	local promptPurchase = p2.props.promptPurchase
	local buyText = p2.props.buyText
	local buyButtonRef = p2.props.buyButtonRef
	local collectibleItemId = p2.props.collectibleItemId
	local collectibleLowestAvailableResaleProductId = p2.props.collectibleLowestAvailableResaleProductId
	local collectibleLowestAvailableResaleItemInstanceId = p2.props.collectibleLowestAvailableResaleItemInstanceId
	local collectibleLowestResalePrice = p2.props.collectibleLowestResalePrice
	local v27 = UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(p2.props.assetInfo)
	local uDim2 = UDim2.new(0, p2:getBuyButtonTextSize(buyText), 1, 0)
	local n1 = 0

	if not forSale then
		n1 = 0.5
	end

	return Roact.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, -32, 0, 44),
		Image = "rbxasset://textures/ui/InspectMenu/Button_white.png",
		ImageColor3 = Colors.Green,
		SelectionImageObject = p2.selectedImage,
		LayoutOrder = 3,
		ImageTransparency = n1,
		[Roact.Ref] = buyButtonRef,
		[Roact.Event.Activated] = function() -- line: 66
			-- upvalues: forSale (copy), p2 (copy), GuiService (copy), promptPurchase (copy), itemId (copy), itemType (copy), collectibleItemId (copy), collectibleLowestAvailableResaleProductId (copy), collectibleLowestAvailableResaleItemInstanceId (copy), collectibleLowestResalePrice (copy), v27 (copy)
			if forSale then
				if p2.props.gamepadEnabled and p2.props.visible then
					p2.lastGamepadFocus = GuiService.SelectedCoreObject
					GuiService.SelectedCoreObject = nil
				end

				promptPurchase(itemId, itemType, collectibleItemId, collectibleLowestAvailableResaleProductId, collectibleLowestAvailableResaleItemInstanceId, collectibleLowestResalePrice, v27)
			end
		end
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		RobuxIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/common/robux_small.png",
			LayoutOrder = 1,
			Size = UDim2.new(0, 16, 0, 16),
			ImageTransparency = n1,
			ImageColor3 = Colors.White,
			Visible = showRobuxIcon
		}),
		BuyText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextSize = 16,
			LayoutOrder = 2,
			Size = uDim2,
			Text = tostring(buyText),
			Font = AppFonts.default:getDefault(),
			TextColor3 = Colors.White,
			TextTransparency = n1,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	})
end
function v13.didMount(p3) -- line: 114
	-- upvalues: MarketplaceService (copy)
	local connection = MarketplaceService.PromptPurchaseFinished:Connect(p3.onPromptPurchaseFinished)
	local connection2 = MarketplaceService.PromptBundlePurchaseFinished:Connect(p3.onPromptPurchaseFinished)

	table.insert(p3.connections, connection)
	table.insert(p3.connections, connection2)
end
function v13.willUnmount(p4) -- line: 122
	for _, v in pairs(p4.connections) do
		v:Disconnect()
	end
end
function v13.getBuyButtonTextSize(p5, p6) -- line: 128
	-- upvalues: TextService (copy), AppFonts (copy)
	if p5.props.buyButtonRef.current then
		local TextSize = TextService:GetTextSize(tostring(p6), 16, AppFonts.default:getDefault(), Vector2.new(p5.props.buyButtonRef.current.AbsoluteSize.X, 5000))

		p5.props.buyButtonRef.Size = UDim2.new(0, 1, 0, TextSize.Y)

		return TextSize.X > 32 and TextSize.X or 32
	end

	return 0
end

return RoactRodux.UNSTABLE_connect2(function(p7, _) -- line: 143
	local assetId = p7.detailsInformation.assetId

	return {
		locale = p7.locale,
		view = p7.view,
		assetInfo = p7.assets[assetId],
		gamepadEnabled = p7.gamepadEnabled,
		visible = p7.visible
	}
end, function(p9) -- line: 153
	-- upvalues: PromptPurchase (copy)
	return {
		promptPurchase = function(p10, p11, p12, p13, p14, p15, p16) -- line: 155
			-- upvalues: p9 (copy), PromptPurchase (copy)
			p9(PromptPurchase(p10, p11, p12, p13, p14, p15, p16))
		end
	}
end)(v13)
