local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local parent = script.Parent.Parent
local LimitedLabel = require(parent.Components.LimitedLabel)
local Constants = require(parent.Constants)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UtilityFunctions = require(parent.UtilityFunctions)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)

local GetFFlagDisplayCollectiblesIcon = require(parent.Flags.GetFFlagDisplayCollectiblesIcon)

local GetFFlagIBEnableCollectiblesSystemSupport = require(parent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local defineFastFlag = game:DefineFastFlag("FixBundleThumbnailOnDetailPage", false)

local extended = Roact.PureComponent:extend("DetailsThumbnail")

local function isPartOfBundleAndOffsale(assetInfo) -- 1 equivalent call inferred from this helper
	return assetInfo and assetInfo.parentBundleId ~= nil and true or false
end

function extended:getUrl()
	local assetInfo = self.props.assetInfo
	local detailsInformation = self.props.detailsInformation
	local bundles = self.props.bundles
	local bundleId = UtilityFunctions.getBundleId(assetInfo)

	if not (isPartOfBundleAndOffsale(assetInfo) and bundles[bundleId] and bundles[bundleId].costumeId) then -- inferred equivalent call
		return "rbxthumb://type=Asset&id=" .. detailsInformation.assetId .. "&w=420&h=420"
	end

	if defineFastFlag then
		return "rbxthumb://type=BundleThumbnail&id=" .. tostring(bundleId) .. "&w=420&h=420"
	end

	return "rbxthumb://type=Outfit&id=" .. bundles[bundleId].costumeId .. "&w=420&h=420"
end

function extended:render()
	local view = self.props.view
	local detailsInformation = self.props.detailsInformation
	local tryingOnInfo = self.props.tryingOnInfo
	local locale = self.props.locale
	local assetInfo = self.props.assetInfo
	local iconsstatusitemlimited = Images["icons/status/item/limited"]
	local v = iconsstatusitemlimited and iconsstatusitemlimited.ImageRectSize / Images.ImagesResolutionScale
		or Vector2.new(0, 0)

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p)
			local v2 = p[view]
			local limitedLabel = GetFFlagDisplayCollectiblesIcon() and UtilityFunctions.isCollectibles(assetInfo)
			local v3, udim, text

			if GetFFlagIBEnableCollectiblesSystemSupport() and assetInfo then
				v3 = UtilityFunctions.hasLimitedQuantity(assetInfo)
				local v4 = UtilityFunctions.isLimited1Point0_LimitedUnique(assetInfo)
					or UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(assetInfo)
				local v5

				if v4 then
					v5 = Constants.LimitedIconFrameSizeXOffset * 2
				else
					v5 = Constants.LimitedIconFrameSizeXOffset
				end

				udim = UDim2.new(0, v.X + v5, 0, v.Y + Constants.LimitedIconFrameSizeYOffset)

				if v4 then
					text = "#" .. "    " .. RobloxTranslator:FormatByKeyForLocale(
						"InGame.InspectMenu.Label.LimitedItems",
						locale
					)
				else
					text = "    " .. RobloxTranslator:FormatByKeyForLocale(
						"InGame.InspectMenu.Label.LimitedItems",
						locale
					)
				end
			end

			local createElement = Roact.createElement
			local v4 = {
				Position = v2.DetailsThumbnailFramePosition,
				Size = UDim2.new(
					1,
					0,
					0,
					GetFFlagDisplayCollectiblesIcon() and Constants.DetailsThumbnailFrameHeight or 300
				),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Visible = not tryingOnInfo.tryingOn
			}
			local v5 = {
				Thumbnail = detailsInformation.viewingDetails and Roact.createElement("ImageLabel", {
					Position = v2.DetailsThumbnailPosition,
					AnchorPoint = v2.DetailsThumbnailAnchorPoint,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = self:getUrl()
				}, {
					AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = 1,
						AspectType = Enum.AspectType.FitWithinMaxSize,
						DominantAxis = v2.DetailsThumbnailARDominantAxis
					})
				}),
				LimitedLabel = 0
			}

			if GetFFlagIBEnableCollectiblesSystemSupport() then
				limitedLabel = v3
			end

			if limitedLabel then
				local createElement2 = Roact.createElement

				if not GetFFlagIBEnableCollectiblesSystemSupport() then
					udim = UDim2.new(0, v.X + 18, 0, v.Y + 6)
				end

				local v6 = {
					frameSize = udim,
					framePosition = UDim2.new(0, 0, 0, Constants.DetailsThumbnailFrameHeight - v.Y - 8),
					imageSize = UDim2.new(0, v.X, 0, v.Y),
					imagePosition = UDim2.new(0, 4, 0, 3),
					textSize = UDim2.new(0, 4 + v.X, 0, v.Y),
					textPosition = UDim2.new(0, 5 + v.X, 0, 3),
					text = 0
				}

				if not GetFFlagIBEnableCollectiblesSystemSupport() then
					text = "#" .. "    " .. RobloxTranslator:FormatByKeyForLocale(
						"InGame.InspectMenu.Label.LimitedItems",
						locale
					)
				end

				v6.text = text
				limitedLabel = createElement2(LimitedLabel, v6)
			end

			v5.LimitedLabel = limitedLabel
			return createElement("Frame", v4, v5)
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		view = data.view,
		tryingOnInfo = data.tryingOnInfo,
		detailsInformation = data.detailsInformation,
		assetInfo = data.assets[assetId],
		locale = data.locale,
		bundles = data.bundles
	}
end)(extended)
