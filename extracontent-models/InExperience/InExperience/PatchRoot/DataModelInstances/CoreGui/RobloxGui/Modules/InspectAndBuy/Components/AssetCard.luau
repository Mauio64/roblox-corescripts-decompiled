local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local Colors = require(ParentParent.Colors)
local Constants = require(ParentParent.Constants)
local SetDetailsInformation = require(ParentParent.Actions.SetDetailsInformation)
local getSelectionImageObjectRegular = require(ParentParent.getSelectionImageObjectRegular)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local LimitedLabel = require(ParentParent.Components.LimitedLabel)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local GetFFlagDisplayCollectiblesIcon = require(ParentParent.Flags.GetFFlagDisplayCollectiblesIcon)
local GetFFlagIBEnableCollectiblesSystemSupport = require(ParentParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local v16 = Roact.Component:extend("AssetCard")

function v16.init(p1) -- line: 24
	-- upvalues: getSelectionImageObjectRegular (copy)
	p1.selectedImage = getSelectionImageObjectRegular()
end
function v16.render(p2) -- line: 28
	-- upvalues: Images (copy), Roact (copy), InspectAndBuyContext (copy), GetFFlagDisplayCollectiblesIcon (copy), UtilityFunctions (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy), Constants (copy), Colors (copy), AppFonts (copy), LimitedLabel (copy)
	local view = p2.props.view
	local equipped = p2.props.equipped
	local assetInfo = p2.props.assetInfo
	local openDetails = p2.props.openDetails
	local assetCardSizeX = p2.props.assetCardSizeX
	local v24 = Images["icons/status/item/limited"]
	local v25 = v24 and v24.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p3) -- line: 38
			-- upvalues: view (copy), GetFFlagDisplayCollectiblesIcon (copy), UtilityFunctions (copy), assetInfo (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy), Constants (copy), v25 (copy), Roact (copy), Colors (copy), p2 (copy), openDetails (copy), assetCardSizeX (copy), AppFonts (copy), equipped (copy), LimitedLabel (copy)
			local v31 = p3[view]
			local v32 = GetFFlagDisplayCollectiblesIcon() and UtilityFunctions.isCollectibles(assetInfo)
			local v33 = nil
			local v34 = nil
			local uDim2 = nil

			if GetFFlagIBEnableCollectiblesSystemSupport() then
				v33 = UtilityFunctions.hasLimitedQuantity(assetInfo)
				v34 = UtilityFunctions.isLimited1Point0_LimitedUnique(assetInfo) or UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(assetInfo)

				local v36 = if not v34 then Constants.LimitedIconFrameSizeXOffset else Constants.LimitedIconFrameSizeXOffset * 2

				uDim2 = UDim2.new(0, v25.X + v36, 0, v25.Y + Constants.LimitedIconFrameSizeYOffset)
			end

			return Roact.createElement("ImageButton", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				BackgroundColor3 = Colors.Gray2,
				Selectable = true,
				SelectionImageObject = p2.selectedImage,
				[Roact.Event.Activated] = function() -- line: 66
					-- upvalues: openDetails (copy), assetInfo (copy)
					openDetails(assetInfo.assetId)
				end
			}, {
				AssetThumbnail = Roact.createElement("ImageButton", {
					Size = UDim2.new(1, 0, 0, assetCardSizeX),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = Colors.Graphite,
					Selectable = false,
					AutoButtonColor = false,
					Image = "rbxthumb://type=Asset&id=" .. assetInfo.assetId .. "&w=150&h=150",
					[Roact.Event.Activated] = function() -- line: 78
						-- upvalues: openDetails (copy), assetInfo (copy)
						openDetails(assetInfo.assetId)
					end
				}),
				AssetNameBackground = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, -assetCardSizeX),
					Position = UDim2.new(0, 0, 0, assetCardSizeX),
					BackgroundColor3 = Color3.fromRGB(44, 45, 47)
				}, {
					AssetName = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						TextSize = 12,
						TextScaled = true,
						Size = UDim2.new(1, -10, 1, -10),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Position = UDim2.new(0, 5, 0, 5),
						Text = assetInfo.name or "",
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = AppFonts.default:getDefault(),
						TextColor3 = Color3.new(1, 1, 1)
					}, {
						UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
							MaxTextSize = v31.AssetTextMaxSize
						})
					})
				}),
				EquippedFrame = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Image = "rbxasset://textures/ui/InspectMenu/gr-item-selector.png",
					Size = UDim2.new(1, 0, 1, 0),
					Visible = equipped,
					ImageColor3 = Colors.Green,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2.5, 2.5, 2.5, 2.5)
				}),
				Corner = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Image = "rbxasset://textures/ui/InspectMenu/gr-item-selector-triangle.png",
					Position = UDim2.new(1, -25, 0, 0),
					Size = UDim2.new(0, 25, 0, 25),
					Visible = equipped,
					ImageColor3 = Colors.Green
				}),
				LimitedLabel = ((if not GetFFlagIBEnableCollectiblesSystemSupport() then v32 else v33)) and Roact.createElement(LimitedLabel, {
					frameSize = if not GetFFlagIBEnableCollectiblesSystemSupport() then UDim2.new(0, v25.X + 18, 0, v25.Y + 4) else uDim2,
					framePosition = UDim2.new(0, 16, 0, assetCardSizeX - v25.Y - 20),
					imageSize = UDim2.new(0, v25.X, 0, v25.Y),
					imagePosition = UDim2.new(0, 5, 0, 2),
					textSize = UDim2.new(0, v25.X, 0, v25.Y),
					textPosition = UDim2.new(0, 5 + v25.X, 0, 2),
					text = (not GetFFlagIBEnableCollectiblesSystemSupport() or v34) and "#" or nil
				})
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p4, p5) -- line: 146
	local assetId = p5.assetInfo.assetId

	return {
		view = p4.view,
		equipped = p4.equippedAssets[assetId] == true,
		locale = p4.locale
	}
end, function(p6) -- line: 154
	-- upvalues: SetDetailsInformation (copy)
	return {
		openDetails = function(p7) -- line: 156
			-- upvalues: p6 (copy), SetDetailsInformation (copy)
			p6(SetDetailsInformation(true, p7))
		end
	}
end)(v16)
