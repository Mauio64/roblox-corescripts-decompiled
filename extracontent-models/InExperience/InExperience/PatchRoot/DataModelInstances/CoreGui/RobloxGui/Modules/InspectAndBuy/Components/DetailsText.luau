local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Notification = require(ParentParent.Components.Notification)
local Favorites = require(ParentParent.Components.Favorites)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local Colors = require(ParentParent.Colors)
local Constants = require(ParentParent.Constants)
local getSelectionImageObjectRegular = require(ParentParent.getSelectionImageObjectRegular)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local v17 = Images["icons/status/premium"]
local v18 = Roact.PureComponent:extend("DetailsText")

function v18.init(p1) -- line: 29
	-- upvalues: getSelectionImageObjectRegular (copy)
	p1.name = ""
	p1.creator = ""
	p1.selectedImage = getSelectionImageObjectRegular()
end
function v18.setText(p2) -- line: 39
	-- upvalues: UtilityFunctions (copy)
	local v21 = p2.props.assetInfo or {}
	local v22 = v21.parentBundleId ~= nil
	local v23 = p2.props.bundleInfo or {}

	if v22 then
		local v24 = UtilityFunctions.getBundleId(v21)

		if v23[v24] then
			p2.name = v23[v24].name or ""
			p2.creator = v23[v24].creatorName or ""

			return
		end
	elseif v21 then
		p2.name = v21.name or ""
		p2.creator = v21.creatorName or ""
	end
end
function v18.render(p3) -- line: 58
	-- upvalues: IconSize (copy), Constants (copy), UtilityFunctions (copy), Roact (copy), InspectAndBuyContext (copy), Notification (copy), Cryo (copy), v17 (copy), AppFonts (copy), Colors (copy), Favorites (copy)
	p3:setText()

	local view = p3.props.view
	local showFavoritesCount = p3.props.showFavoritesCount
	local v28 = p3.props.assetInfo or {}
	local v29 = v28.parentBundleId ~= nil
	local v30 = p3.props.assetBundles[v28.assetId]
	local v31 = v29 and #v30 > 1
	local v32 = v28.premiumPricing ~= nil
	local v33 = v32 and IconSize.Regular + 5 or 0
	local v34 = Constants.LayeredAssetTypes[v28.assetTypeId] ~= nil and (p3.props.localPlayerModel and p3.props.localPlayerModel.Humanoid.RigType == Enum.HumanoidRigType.R6)
	local v35 = UtilityFunctions.isLimited1Point0(v28)
	local MultipleBundleNoticeKey = nil

	if v31 then
		MultipleBundleNoticeKey = Constants.NotificationKeys.MultipleBundleNoticeKey
	elseif v29 then
		MultipleBundleNoticeKey = Constants.NotificationKeys.SingleBundleNoticeKey
	elseif v35 then
		MultipleBundleNoticeKey = Constants.NotificationKeys.LimitedItemNoticeKey
	elseif v34 then
		MultipleBundleNoticeKey = Constants.NotificationKeys.LayeredClothingOnR6Key
	end

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p4) -- line: 87
			-- upvalues: view (copy), Roact (copy), MultipleBundleNoticeKey (ref), Notification (copy), v32 (copy), Cryo (copy), v17 (copy), IconSize (copy), v33 (copy), p3 (copy), AppFonts (copy), Colors (copy), showFavoritesCount (copy), Favorites (copy)
			local v41 = p4[view]

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Position = v41.DetailsFramePosition,
				Size = UDim2.new(1, 0, 0, 131)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Notification = MultipleBundleNoticeKey and Roact.createElement(Notification, {
					noticeKey = MultipleBundleNoticeKey
				}),
				AssetName = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, -10, 0, 50)
				}, {
					PremiumIcon = v32 and Roact.createElement("ImageLabel", Cryo.Dictionary.join(v17, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
						ImageColor3 = Color3.new(1, 1, 1)
					})) or nil,
					PlayerName = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						TextScaled = true,
						TextSize = 20,
						Position = UDim2.new(0, v33, 0, 0),
						Size = UDim2.new(1, v33, 0, 50),
						Text = p3.name or "",
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = AppFonts.default:getBold(),
						TextColor3 = Colors.White
					}, {
						UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
							MaxTextSize = 32
						})
					})
				}) or Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					TextScaled = true,
					TextSize = 20,
					Size = UDim2.new(1, -10, 0, 50),
					Text = p3.name or "",
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Font = AppFonts.default:getBold(),
					TextColor3 = Colors.White
				}, {
					UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MaxTextSize = 32
					})
				}),
				FavoriteContainer = showFavoritesCount and Roact.createElement(Favorites)
			})
		end
	})
end

return RoactRodux.connect(function(p5, _) -- line: 158
	local assetId = p5.detailsInformation.assetId

	return {
		view = p5.view,
		locale = p5.locale,
		assetInfo = p5.assets[assetId],
		bundleInfo = p5.bundles,
		assetBundles = p5.assetBundles,
		showFavoritesCount = not p5.isSubjectToChinaPolicies
	}
end)(v18)
