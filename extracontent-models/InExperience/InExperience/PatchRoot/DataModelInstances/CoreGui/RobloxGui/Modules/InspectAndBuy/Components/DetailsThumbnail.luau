local CorePackages = game:GetService("CorePackages")
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local ParentParent = script.Parent.Parent
local LimitedLabel = require(ParentParent.Components.LimitedLabel)
local Constants = require(ParentParent.Constants)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local GetFFlagDisplayCollectiblesIcon = require(ParentParent.Flags.GetFFlagDisplayCollectiblesIcon)
local GetFFlagIBEnableCollectiblesSystemSupport = require(ParentParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local v13 = game:DefineFastFlag("FixBundleThumbnailOnDetailPage", false)
local v14 = Roact.PureComponent:extend("DetailsThumbnail")

local function isPartOfBundleAndOffsale(p1) -- line: 24
	return not not p1 and (p1.parentBundleId ~= nil or false)
end

function v14.getUrl(p2) -- line: 28
	-- upvalues: UtilityFunctions (copy), v13 (copy)
	local assetInfo = p2.props.assetInfo
	local detailsInformation = p2.props.detailsInformation
	local bundles = p2.props.bundles
	local v21 = UtilityFunctions.getBundleId(assetInfo)

	if not not assetInfo and (assetInfo.parentBundleId ~= nil or false) and (bundles[v21] and bundles[v21].costumeId) then
		if v13 then
			return "rbxthumb://type=BundleThumbnail&id=" .. tostring(v21) .. "&w=420&h=420"
		end

		return "rbxthumb://type=Outfit&id=" .. bundles[v21].costumeId .. "&w=420&h=420"
	end

	return "rbxthumb://type=Asset&id=" .. detailsInformation.assetId .. "&w=420&h=420"
end
function v14.render(p3) -- line: 53
	-- upvalues: Images (copy), Roact (copy), InspectAndBuyContext (copy), GetFFlagDisplayCollectiblesIcon (copy), UtilityFunctions (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy), Constants (copy), RobloxTranslator (copy), LimitedLabel (copy)
	local view = p3.props.view
	local detailsInformation = p3.props.detailsInformation
	local tryingOnInfo = p3.props.tryingOnInfo
	local locale = p3.props.locale
	local assetInfo = p3.props.assetInfo
	local v28 = Images["icons/status/item/limited"]
	local v29 = v28 and v28.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p4) -- line: 63
			-- upvalues: view (copy), GetFFlagDisplayCollectiblesIcon (copy), UtilityFunctions (copy), assetInfo (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy), Constants (copy), v29 (copy), RobloxTranslator (copy), locale (copy), Roact (copy), tryingOnInfo (copy), detailsInformation (copy), p3 (copy), LimitedLabel (copy)
			local v34 = p4[view]
			local v35 = GetFFlagDisplayCollectiblesIcon() and UtilityFunctions.isCollectibles(assetInfo)
			local v36 = nil
			local uDim2 = nil
			local v38 = nil

			if GetFFlagIBEnableCollectiblesSystemSupport() and assetInfo then
				v36 = UtilityFunctions.hasLimitedQuantity(assetInfo)

				local v39 = UtilityFunctions.isLimited1Point0_LimitedUnique(assetInfo) or UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(assetInfo)
				local v40 = if not v39 then Constants.LimitedIconFrameSizeXOffset else Constants.LimitedIconFrameSizeXOffset * 2

				uDim2 = UDim2.new(0, v29.X + v40, 0, v29.Y + Constants.LimitedIconFrameSizeYOffset)
				v38 = if not v39 then "    " .. RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.LimitedItems", locale) else "#" .. "    " .. RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.LimitedItems", locale)
			end

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Position = v34.DetailsThumbnailFramePosition,
				Size = UDim2.new(1, 0, 0, GetFFlagDisplayCollectiblesIcon() and Constants.DetailsThumbnailFrameHeight or 300),
				Visible = not tryingOnInfo.tryingOn
			}, {
				Thumbnail = detailsInformation.viewingDetails and Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Position = v34.DetailsThumbnailPosition,
					AnchorPoint = v34.DetailsThumbnailAnchorPoint,
					Size = UDim2.new(1, 0, 1, 0),
					Image = p3:getUrl()
				}, {
					AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = 1,
						AspectType = Enum.AspectType.FitWithinMaxSize,
						DominantAxis = v34.DetailsThumbnailARDominantAxis
					})
				}),
				LimitedLabel = ((if not GetFFlagIBEnableCollectiblesSystemSupport() then v35 else v36)) and Roact.createElement(LimitedLabel, {
					frameSize = if not GetFFlagIBEnableCollectiblesSystemSupport() then UDim2.new(0, v29.X + 18, 0, v29.Y + 6) else uDim2,
					framePosition = UDim2.new(0, 0, 0, Constants.DetailsThumbnailFrameHeight - v29.Y - 8),
					imageSize = UDim2.new(0, v29.X, 0, v29.Y),
					imagePosition = UDim2.new(0, 4, 0, 3),
					textSize = UDim2.new(0, 4 + v29.X, 0, v29.Y),
					textPosition = UDim2.new(0, 5 + v29.X, 0, 3),
					text = if not GetFFlagIBEnableCollectiblesSystemSupport() then "#" .. "    " .. RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.LimitedItems", locale) else v38
				})
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p5, _) -- line: 138
	local assetId = p5.detailsInformation.assetId

	return {
		view = p5.view,
		tryingOnInfo = p5.tryingOnInfo,
		detailsInformation = p5.detailsInformation,
		assetInfo = p5.assets[assetId],
		locale = p5.locale,
		bundles = p5.bundles
	}
end)(v14)
