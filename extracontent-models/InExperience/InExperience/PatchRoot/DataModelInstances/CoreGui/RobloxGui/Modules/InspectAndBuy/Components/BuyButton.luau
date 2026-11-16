local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local parent = script.Parent.Parent
local Colors = require(parent.Colors)
local PromptPurchase = require(parent.Thunks.PromptPurchase)
local getSelectionImageObjectRounded = require(parent.getSelectionImageObjectRounded)

local UtilityFunctions = require(parent.UtilityFunctions)

local extended = Roact.PureComponent:extend("BuyButton")

function extended:init()
	self.selectedImage = getSelectionImageObjectRounded()
	self.connections = {}
	self.lastGamepadFocus = nil

	function self.onPromptPurchaseFinished()
		if self.props.gamepadEnabled and self.props.visible then
			GuiService.SelectedCoreObject = self.lastGamepadFocus
		end
	end
end

function extended:render()
	local itemType = self.props.itemType
	local itemId = self.props.itemId
	local showRobuxIcon = self.props.showRobuxIcon
	local forSale = self.props.forSale
	local promptPurchase = self.props.promptPurchase
	local buyText = self.props.buyText
	local buyButtonRef = self.props.buyButtonRef
	local collectibleItemId = self.props.collectibleItemId
	local collectibleLowestAvailableResaleProductId = self.props.collectibleLowestAvailableResaleProductId
	local collectibleLowestAvailableResaleItemInstanceId = self.props.collectibleLowestAvailableResaleItemInstanceId
	local collectibleLowestResalePrice = self.props.collectibleLowestResalePrice

	local limited2Point0_Or_LimitedCollectible = UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(self.props.assetInfo)
	local udim = UDim2.new(0, self:getBuyButtonTextSize(buyText), 1, 0)
	local v = forSale and 0 or 0.5
	return Roact.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, -32, 0, 44),
		Image = "rbxasset://textures/ui/InspectMenu/Button_white.png",
		ImageColor3 = Colors.Green,
		SelectionImageObject = self.selectedImage,
		LayoutOrder = 3,
		ImageTransparency = v,
		[Roact.Ref] = buyButtonRef,
		[Roact.Event.Activated] = function()
			if forSale then
				if self.props.gamepadEnabled and self.props.visible then
					self.lastGamepadFocus = GuiService.SelectedCoreObject
					GuiService.SelectedCoreObject = nil
				end

				promptPurchase(
					itemId,
					itemType,
					collectibleItemId,
					collectibleLowestAvailableResaleProductId,
					collectibleLowestAvailableResaleItemInstanceId,
					collectibleLowestResalePrice,
					limited2Point0_Or_LimitedCollectible
				)
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
			Size = UDim2.new(0, 16, 0, 16),
			Image = "rbxasset://textures/ui/common/robux_small.png",
			ImageTransparency = v,
			ImageColor3 = Colors.White,
			LayoutOrder = 1,
			Visible = showRobuxIcon
		}),
		BuyText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = udim,
			Text = tostring(buyText),
			Font = AppFonts.default:getDefault(),
			TextSize = 16,
			TextColor3 = Colors.White,
			TextTransparency = v,
			LayoutOrder = 2,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	})
end

function extended.didMount(p)
	local promptPurchaseFinishedConnection = MarketplaceService.PromptPurchaseFinished:Connect(p.onPromptPurchaseFinished)

	local promptBundlePurchaseFinishedConnection = MarketplaceService.PromptBundlePurchaseFinished:Connect(p.onPromptPurchaseFinished)
	table.insert(p.connections, promptPurchaseFinishedConnection)
	table.insert(p.connections, promptBundlePurchaseFinishedConnection)
end

function extended.willUnmount(p)
	for _, connection in pairs(p.connections) do
		connection:Disconnect()
	end
end

function extended:getBuyButtonTextSize(p)
	if not self.props.buyButtonRef.current then
		return 0
	end

	local textSize = TextService:GetTextSize(
		tostring(p),
		16,
		AppFonts.default:getDefault(),
		Vector2.new(self.props.buyButtonRef.current.AbsoluteSize.X, 5000)
	)

	self.props.buyButtonRef.Size = UDim2.new(0, 1, 0, textSize.Y)
	return textSize.X > 32 and textSize.X or 32
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		locale = data.locale,
		view = data.view,
		assetInfo = data.assets[assetId],
		gamepadEnabled = data.gamepadEnabled,
		visible = data.visible
	}
end, function(callback)
	return {
		promptPurchase = function(p, p2, p3, p4, p5, p6, p7)
			callback(PromptPurchase(p, p2, p3, p4, p5, p6, p7))
		end
	}
end)(extended)
