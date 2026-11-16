local CorePackages = game:GetService("CorePackages")
local parent = script.Parent.Parent
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local Colors = require(parent.Colors)
local Constants = require(parent.Constants)
local SetDetailsInformation = require(parent.Actions.SetDetailsInformation)
local getSelectionImageObjectRegular = require(parent.getSelectionImageObjectRegular)
local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)
local LimitedLabel = require(parent.Components.LimitedLabel)
local UtilityFunctions = require(parent.UtilityFunctions)

local GetFFlagDisplayCollectiblesIcon = require(parent.Flags.GetFFlagDisplayCollectiblesIcon)

local GetFFlagIBEnableCollectiblesSystemSupport = require(parent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)

local extended = Roact.Component:extend("AssetCard")

function extended:init()
	self.selectedImage = getSelectionImageObjectRegular()
end

function extended.render(p)
	local view = p.props.view
	local equipped = p.props.equipped
	local assetInfo = p.props.assetInfo
	local openDetails = p.props.openDetails
	local assetCardSizeX = p.props.assetCardSizeX
	local iconsstatusitemlimited = Images["icons/status/item/limited"]
	local v = iconsstatusitemlimited and iconsstatusitemlimited.ImageRectSize / Images.ImagesResolutionScale
		or Vector2.new(0, 0)

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2)
			local v2 = p2[view]
			local limitedLabel = GetFFlagDisplayCollectiblesIcon() and UtilityFunctions.isCollectibles(assetInfo)
			local v3, v4, udim

			if GetFFlagIBEnableCollectiblesSystemSupport() then
				v3 = UtilityFunctions.hasLimitedQuantity(assetInfo)
				v4 = UtilityFunctions.isLimited1Point0_LimitedUnique(assetInfo)
					or UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(assetInfo)
				local v5

				if v4 then
					v5 = Constants.LimitedIconFrameSizeXOffset * 2
				else
					v5 = Constants.LimitedIconFrameSizeXOffset
				end

				udim = UDim2.new(0, v.X + v5, 0, v.Y + Constants.LimitedIconFrameSizeYOffset)
			end

			local createElement = Roact.createElement
			local v5 = {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				BackgroundColor3 = Colors.Gray2,
				Selectable = true,
				SelectionImageObject = p.selectedImage,
				[Roact.Event.Activated] = function()
					openDetails(assetInfo.assetId)
				end
			}
			local children = {
				AssetThumbnail = Roact.createElement("ImageButton", {
					Size = UDim2.new(1, 0, 0, assetCardSizeX),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = Colors.Graphite,
					Selectable = false,
					AutoButtonColor = false,
					Image = "rbxthumb://type=Asset&id=" .. assetInfo.assetId .. "&w=150&h=150",
					[Roact.Event.Activated] = function()
						openDetails(assetInfo.assetId)
					end
				}),
				AssetNameBackground = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, -assetCardSizeX),
					Position = UDim2.new(0, 0, 0, assetCardSizeX),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(44, 45, 47)
				}, {
					AssetName = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -10, 1, -10),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Position = UDim2.new(0, 5, 0, 5),
						TextWrapped = true,
						Text = assetInfo.name or "",
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextSize = 12,
						TextScaled = true,
						Font = AppFonts.default:getDefault(),
						TextColor3 = Color3.new(1, 1, 1)
					}, {
						UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
							MaxTextSize = v2.AssetTextMaxSize
						})
					})
				}),
				EquippedFrame = Roact.createElement("ImageLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,
					Visible = equipped,
					Image = "rbxasset://textures/ui/InspectMenu/gr-item-selector.png",
					ImageColor3 = Colors.Green,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2.5, 2.5, 2.5, 2.5)
				}),
				Corner = Roact.createElement("ImageLabel", {
					Position = UDim2.new(1, -25, 0, 0),
					Size = UDim2.new(0, 25, 0, 25),
					BackgroundTransparency = 1,
					ZIndex = 2,
					Visible = equipped,
					Image = "rbxasset://textures/ui/InspectMenu/gr-item-selector-triangle.png",
					ImageColor3 = Colors.Green
				}),
				LimitedLabel = 0
			}

			if GetFFlagIBEnableCollectiblesSystemSupport() then
				limitedLabel = v3
			end

			if limitedLabel then
				local createElement2 = Roact.createElement

				if not GetFFlagIBEnableCollectiblesSystemSupport() then
					udim = UDim2.new(0, v.X + 18, 0, v.Y + 4)
				end

				limitedLabel = createElement2(LimitedLabel, {
					frameSize = udim,
					framePosition = UDim2.new(0, 16, 0, assetCardSizeX - v.Y - 20),
					imageSize = UDim2.new(0, v.X, 0, v.Y),
					imagePosition = UDim2.new(0, 5, 0, 2),
					textSize = UDim2.new(0, v.X, 0, v.Y),
					textPosition = UDim2.new(0, 5 + v.X, 0, 2),
					text = (not GetFFlagIBEnableCollectiblesSystemSupport() or v4) and "#" or nil
				})
			end

			children.LimitedLabel = limitedLabel
			return createElement("ImageButton", v5, children)
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, p)
	local assetId = p.assetInfo.assetId

	return {
		view = data.view,
		equipped = data.equippedAssets[assetId] == true,
		locale = data.locale
	}
end, function(callback)
	return {
		openDetails = function(p)
			callback(SetDetailsInformation(true, p))
		end
	}
end)(extended)
