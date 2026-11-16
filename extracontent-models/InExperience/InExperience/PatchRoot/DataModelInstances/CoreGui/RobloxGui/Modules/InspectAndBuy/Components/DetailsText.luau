local CorePackages = game:GetService("CorePackages")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Notification = require(parent.Components.Notification)
local Favorites = require(parent.Components.Favorites)
local UtilityFunctions = require(parent.UtilityFunctions)
local Colors = require(parent.Colors)
local Constants = require(parent.Constants)
local getSelectionImageObjectRegular = require(parent.getSelectionImageObjectRegular)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)

local iconsstatuspremium = Images["icons/status/premium"]

local extended = Roact.PureComponent:extend("DetailsText")

function extended:init()
	self.name = ""
	self.creator = ""
	self.selectedImage = getSelectionImageObjectRegular()
end

function extended:setText()
	local assetInfo = self.props.assetInfo or {}
	local v = assetInfo.parentBundleId ~= nil

	local bundleInfo = self.props.bundleInfo or {}

	if v then
		local bundleId = UtilityFunctions.getBundleId(assetInfo)

		if bundleInfo[bundleId] then
			self.name = bundleInfo[bundleId].name or ""
			self.creator = bundleInfo[bundleId].creatorName or ""
		end
	elseif assetInfo then
		self.name = assetInfo.name or ""
		self.creator = assetInfo.creatorName or ""
	end
end

function extended:render()
	self:setText()
	local view = self.props.view
	local showFavoritesCount = self.props.showFavoritesCount
	local assetInfo = self.props.assetInfo or {}
	local v = assetInfo.parentBundleId ~= nil
	local assetBundle = self.props.assetBundles[assetInfo.assetId]
	local v2 = v and #assetBundle > 1

	local v3 = assetInfo.premiumPricing ~= nil
	local v4 = v3 and IconSize.Regular + 5 or 0
	local v5

	if Constants.LayeredAssetTypes[assetInfo.assetTypeId] == nil then
		v5 = false
	else
		v5 = self.props.localPlayerModel and self.props.localPlayerModel.Humanoid.RigType == Enum.HumanoidRigType.R6
	end

	local limited1Point0 = UtilityFunctions.isLimited1Point0(assetInfo)

	local noticeKey = nil

	if v2 then
		noticeKey = Constants.NotificationKeys.MultipleBundleNoticeKey
	elseif v then
		noticeKey = Constants.NotificationKeys.SingleBundleNoticeKey
	elseif limited1Point0 then
		noticeKey = Constants.NotificationKeys.LimitedItemNoticeKey
	elseif v5 then
		noticeKey = Constants.NotificationKeys.LayeredClothingOnR6Key
	end

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p)
			local v6 = p[view]
			return Roact.createElement(
				"Frame",
				{
					Position = v6.DetailsFramePosition,
					Size = UDim2.new(1, 0, 0, 131),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						FillDirection = Enum.FillDirection.Vertical
					}),
					Notification = noticeKey and Roact.createElement(Notification, {
						noticeKey = noticeKey
					}),
					AssetName = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -10, 0, 50),
							LayoutOrder = 1
						},
						{
							PremiumIcon = v3 and Roact.createElement(
								"ImageLabel",
								Cryo.Dictionary.join(iconsstatuspremium, {
									AnchorPoint = Vector2.new(0, 0.5),
									Position = UDim2.new(0, 0, 0.5, 0),
									BackgroundTransparency = 1,
									Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
									ImageColor3 = Color3.new(1, 1, 1)
								})
							) or nil,
							PlayerName = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Position = UDim2.new(0, v4, 0, 0),
								Size = UDim2.new(1, v4, 0, 50),
								LayoutOrder = 1,
								Text = self.name or "",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextScaled = true,
								TextSize = 20,
								Font = AppFonts.default:getBold(),
								TextColor3 = Colors.White
							}, {
								UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
									MaxTextSize = 32
								})
							})
						}
					) or Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -10, 0, 50),
						LayoutOrder = 1,
						Text = self.name or "",
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextScaled = true,
						TextSize = 20,
						Font = AppFonts.default:getBold(),
						TextColor3 = Colors.White
					}, {
						UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
							MaxTextSize = 32
						})
					}),
					FavoriteContainer = showFavoritesCount and Roact.createElement(Favorites)
				}
			)
		end
	})
end

return RoactRodux.connect(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		view = data.view,
		locale = data.locale,
		assetInfo = data.assets[assetId],
		bundleInfo = data.bundles,
		assetBundles = data.assetBundles,
		showFavoritesCount = not data.isSubjectToChinaPolicies
	}
end)(extended)
