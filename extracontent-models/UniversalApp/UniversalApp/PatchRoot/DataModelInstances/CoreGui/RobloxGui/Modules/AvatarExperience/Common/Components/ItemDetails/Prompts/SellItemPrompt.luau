local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local RemoveAvailableToSellAsset = require(Modules.AvatarExperience.Catalog.Thunks.RemoveAvailableToSellAsset)
local GetMarketplaceFee = require(Modules.AvatarExperience.Catalog.Thunks.GetMarketplaceFee)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local IconTextBox = require(Modules.AvatarExperience.Catalog.Components.IconTextBox)
local RobuxAmountDisplay = require(Modules.AvatarExperience.Common.Components.ItemDetails.RobuxAmountDisplay)
local FFlagAXRemoveSellPageAndChildrenGamepadBindings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRemoveSellPageAndChildrenGamepadBindings
local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local v40 = Images["icons/common/robux"]
local v41 = Roact.PureComponent:extend("SellItemPrompt")

function v41.init(p1) -- line: 73
	-- upvalues: UserInputService (copy), withStyle (copy), Roact (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), NavigationUtils (copy)
	p1.isMounted = false
	p1.state = {
		isKeyboardRepositioned = false,
		priceInRobux = 0
	}

	function p1.changeText(p2) -- line: 80
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		local priceInRobux = p1.state.priceInRobux
		local p2Text = p2.Text
		local v86 = if priceInRobux ~= 0 then priceInRobux else ""

		if string.len(p2Text) > 10 then
			p2.Text = v86

			return
		end

		if priceInRobux ~= 0 and (p2Text == nil or p2Text == "") then
			p1:setState({
				priceInRobux = 0
			})

			return
		end

		if string.match(p2Text, "^[0-9]+$") then
			p1:setState({
				priceInRobux = p2Text
			})

			return
		end

		p2.Text = v86
	end
	function p1.sellItem() -- line: 106
		-- upvalues: p1 (copy)
		local priceInRobux = p1.state.priceInRobux

		if not priceInRobux or tonumber(priceInRobux) <= 0 then
			return
		end

		local networking = p1.props.networking
		local itemId = p1.props.itemId
		local userAssetId = p1.props.userAssetId
		local num = tonumber(priceInRobux)

		p1.props.sellAsset(networking, itemId, userAssetId, num)
	end
	function p1.getMarketplaceFee() -- line: 123
		-- upvalues: p1 (copy)
		local networking = p1.props.networking

		return p1.props.getMarketplaceFee(networking)
	end

	p1.keyboardConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function() -- line: 128
		-- upvalues: p1 (copy), UserInputService (copy)
		if not p1.isMounted then
			return
		end

		if not p1.state.isKeyboardRepositioned and UserInputService.OnScreenKeyboardVisible then
			p1:setState({
				isKeyboardRepositioned = true
			})
		end
	end)

	function p1.getMiddleContent(p3) -- line: 140
		-- upvalues: withStyle (copy), p1 (copy), Roact (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy)
		return function() -- line: 141
			-- upvalues: withStyle (copy), p1 (copy), p3 (copy), Roact (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy)
			return Roact.createElement(LoadingStateContainer, {
				dataStatus = RetrievalStatus2.fromRawValue(p1.props.marketPlaceFeeFetchingState),
				onRetry = p1.getMarketplaceFee,
				renderOnLoaded = function() -- line: 142
					-- upvalues: withStyle (copy), p1 (copy), p3 (copy)
					return withStyle(function(p4) -- line: 143
						-- upvalues: p1 (copy), p3 (copy)
						return p1:renderOnLoaded(p3, p4)
					end)
				end
			})
		end
	end
	function p1.closePrompt() -- line: 156
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v41.didMount(p5) -- line: 161
	-- upvalues: RetrievalStatus (copy)
	p5.isMounted = true

	if p5.props.marketPlaceFeeFetchingState ~= RetrievalStatus.Fetching then
		p5.getMarketplaceFee()
	end
end
function v41.willUpdate(p6, p7, _) -- line: 169
	-- upvalues: Utils (copy)
	if Utils.isFetchingDoneOrFailed(p6.props.sellFetchingState, p7.sellFetchingState) then
		p6.closePrompt()
	end
end
function v41.renderOnLoaded(p9, p10, p11) -- line: 175
	-- upvalues: NumberLocalization (copy), CatalogUtils (copy), Roact (copy), FitFrameVertical (copy), Focusable (copy), IconTextBox (copy), v40 (copy), FitTextLabel (copy), FitFrameHorizontal (copy), ImageSetLabel (copy), RobuxAmountDisplay (copy)
	local marketplaceFee = p9.props.marketplaceFee
	local averagePrice = p9.props.averagePrice
	local localization = p9.props.localization
	local priceInRobux = p9.state.priceInRobux
	local taxRate = marketplaceFee.taxRate
	local minimumFee = marketplaceFee.minimumFee
	local v57 = averagePrice and NumberLocalization.localize(averagePrice, localization:GetLocale()) or ""
	local n1 = 0
	local n2 = 0
	local v60 = true
	local num = tonumber(priceInRobux)

	if num and num > 0 then
		v60 = false

		local v62 = CatalogUtils.Round(taxRate * num)

		n1 = minimumFee < v62 and v62 or minimumFee

		local v63 = string.format("%.0f", CatalogUtils.Round(num - n1))

		n2 = NumberLocalization.localize(v63, localization:GetLocale())
	end

	local v64 = p10.robloxFeeText:gsub("({feePercentage})", taxRate * 100)
	local v65 = string.format("%.0f", n1)
	local v66 = NumberLocalization.localize(v65, localization:GetLocale())
	local p11Font = p11.Font
	local Theme = p11.Theme
	local v69 = p11Font.BaseSize * p11Font.Body.RelativeSize
	local v70 = v69 + 2

	return Roact.createElement(FitFrameVertical, {
		BackgroundTransparency = 1,
		contentPadding = UDim.new(0, 6),
		width = UDim.new(1, 0),
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	}, {
		PriceTextBox = Roact.createElement(Focusable[IconTextBox], {
			LayoutOrder = 1,
			PlaceholderText = p10.placeholderText,
			Image = v40,
			TextInputType = Enum.TextInputType.Number,
			[Roact.Change.Text] = p9.changeText
		}),
		WarningText = v60 and Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextWrapped = true,
			width = UDim.new(1, 0),
			Text = p10.minimumWarningText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 20),
			TextColor3 = Theme.Alert.Color,
			Font = p11Font.Body.Font,
			TextSize = p11Font.Body.RelativeSize * p11Font.BaseSize
		}),
		RobuxFeeContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v70)
		}, {
			RobloxFeeLabel = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = FitTextLabel.Width.FitToText,
				Font = p11Font.Body.Font,
				Text = v64,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				TextSize = v69,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(0, 0, 1, 0)
			}),
			RobuxContainer = Roact.createElement(FitFrameHorizontal, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				height = UDim.new(1, 0),
				contentPadding = UDim.new(0, 6),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0)
			}, {
				MinusText = Roact.createElement(FitTextLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "-",
					width = FitTextLabel.Width.FitToText,
					Font = p11Font.Body.Font,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					TextSize = v69
				}),
				Image = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, v69, 0, v69),
					Image = v40,
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency
				}),
				Text = Roact.createElement(FitTextLabel, {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					width = FitTextLabel.Width.FitToText,
					Text = v66,
					Font = p11Font.Body.Font,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					TextSize = v69
				})
			})
		}),
		YouEarnContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, v70)
		}, {
			YouEarnLabel = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = FitTextLabel.Width.FitToText,
				Font = p11Font.Body.Font,
				Text = p10.sellCutText,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextSize = v69,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(0, 0, 1, 0)
			}),
			RobuxContainer = Roact.createElement(FitFrameHorizontal, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				height = UDim.new(1, 0),
				contentPadding = UDim.new(0, 6),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0)
			}, {
				Image = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, v69, 0, v69),
					Image = v40,
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency
				}),
				Text = Roact.createElement(FitTextLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					width = FitTextLabel.Width.FitToText,
					Text = tostring(n2),
					Font = p11Font.Body.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextSize = v69
				})
			})
		}),
		AverageSellPriceContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, v70)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 12),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			AverageSellPriceLabel = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				width = FitTextLabel.Width.FitToText,
				Font = p11Font.Body.Font,
				Text = p10.averageSellPriceText,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				TextSize = v69
			}),
			RobuxContainer = Roact.createElement(RobuxAmountDisplay, {
				padding = 6,
				robuxAmountText = v57,
				iconSize = v69,
				textSize = v69
			})
		})
	})
end
function v41.render(p12) -- line: 387
	-- upvalues: withLocalization (copy), UserInputService (copy), Roact (copy), Focusable (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), InteractiveAlert (copy), ButtonType (copy), RetrievalStatus (copy)
	return withLocalization({
		titleText = "Feature.Catalog.Heading.SellItem",
		robloxFeeText = "Feature.Catalog.Label.RobuxFee",
		sellCutText = "Feature.Catalog.Label.SellCut",
		averageSellPriceText = "Feature.Catalog.Label.AveragePrice",
		placeholderText = "Feature.Catalog.Label.Price",
		minimumWarningText = "Feature.Catalog.Label.MinimumAmount",
		minimumWarningTextWithPrice = "Feature.Catalog.Label.MinimumAmountCustom",
		confirmButtonText = "Feature.Catalog.Action.Sell",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p13) -- line: 398
		-- upvalues: p12 (copy), UserInputService (copy), Roact (copy), Focusable (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), InteractiveAlert (copy), ButtonType (copy), RetrievalStatus (copy)
		local screenSize = p12.props.screenSize
		local num = tonumber(p12.state.priceInRobux)
		local v97 = not num or num == 0
		local uDim2 = UDim2.new(0.5, 0, 0.5, 0)

		if p12.state.isKeyboardRepositioned then
			uDim2 = UDim2.new(0.5, 0, 0, (screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2)
		end

		return Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			inputBindings = if not FFlagAXRemoveSellPageAndChildrenGamepadBindings then {
				SellItem = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, p12.sellItem, {
					key = "Feature.Catalog.Action.Sell",
					disabled = v97
				})
			} else nil
		}, {
			InteractiveAlert = Roact.createElement(InteractiveAlert, {
				isMiddleContentFocusable = true,
				title = p13.titleText,
				buttonStackInfo = {
					buttons = {
						{
							isDefaultChild = true,
							props = {
								onActivated = p12.closePrompt,
								text = p13.cancelButtonText
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								isDisabled = v97,
								isLoading = p12.props.sellFetchingState == RetrievalStatus.Fetching or p12.props.marketPlaceFeeFetchingState == RetrievalStatus.Fetching,
								onActivated = p12.sellItem,
								text = p13.confirmButtonText
							}
						}
					}
				},
				middleContent = p12.getMiddleContent(p13),
				position = uDim2,
				screenSize = p12.props.screenSize,
				defaultChildRef = p12.props.defaultChildRef
			})
		})
	end)
end
function v41.willUnmount(p14) -- line: 457
	p14.keyboardConnection:disconnect()
	p14.keyboardConnection = nil
	p14.isMounted = false
end

local v42 = RoactRodux.connect(function(p15, p16) -- line: 463
	-- upvalues: ItemData (copy), PerformFetch (copy), CatalogConstants (copy)
	local itemId = p16.itemId
	local itemType = p16.itemType
	local userAssetId = p16.userAssetId
	local v78 = ItemData(p15.AvatarExperience.Common, itemId, itemType)
	local v79 = v78 and v78.averagePrice
	local v80 = v78 and v78.collectibleItemId
	local v81 = p15.AvatarExperience.Catalog.CollectibleMarketplaceResaleParameters and (not not p15.AvatarExperience.Catalog.CollectibleMarketplaceResaleParameters[v80] and p15.AvatarExperience.Catalog.CollectibleMarketplaceResaleParameters[v80].priceFloor) or 0

	return {
		screenSize = p15.ScreenSize,
		averagePrice = v79,
		sellFetchingState = PerformFetch.GetStatus(p15, CatalogConstants.RemoveAvailableToSellAssetKey .. tostring(userAssetId)),
		marketPlaceFeeFetchingState = PerformFetch.GetStatus(p15, CatalogConstants.GetMarketplaceFeeKey),
		marketplaceFee = p15.AvatarExperience.Catalog.MarketplaceFee,
		collectibleItemId = v80,
		priceFloor = v81
	}
end, function(p17) -- line: 487
	-- upvalues: GetMarketplaceFee (copy), RemoveAvailableToSellAsset (copy)
	return {
		getMarketplaceFee = function(p18) -- line: 489
			-- upvalues: p17 (copy), GetMarketplaceFee (copy)
			return p17(GetMarketplaceFee(p18))
		end,
		sellAsset = function(p19, p20, p21, p22) -- line: 492
			-- upvalues: p17 (copy), RemoveAvailableToSellAsset (copy)
			return p17(RemoveAvailableToSellAsset(p19, p20, p21, p22))
		end
	}
end)(v41)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking,
	localization = RoactLocalization
})(v42))))))
