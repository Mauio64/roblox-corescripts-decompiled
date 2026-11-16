local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local roact = dependencies.Roact

local withLocalization = dependencies.withLocalization

local uiBlox = dependencies.UIBlox
local withStyle = uiBlox.Style.withStyle
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Common/TextKeys")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Common/Constants")
local appFonts = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Style").AppFonts
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation")
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FoundationCloudAssets")
local assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

local defineFastFlag = game:DefineFastFlag("MigrateEmptyResultsViewToFoundation", false)

local extended = roact.PureComponent:extend("EmptyResultsView")

extended.defaultProps = { layoutOrder = 0, pageLoadingTimeReport = nil }

local function loadFoundationCloudAsset(p2)
	preloadAsset(p2)
	local asset = assets[p2]
	return asset.assetId, asset.size
end

function extended.render(p2)
	return withStyle(function(p3)
		return withLocalization({
			noResultsText = "CommonUI.Messages.Response.NoResults",
			addFriendsBtn = TextKeys.ADD_FRIENDS_BTN
		})(function(p4)
			local createElement = roact.createElement
			local v6 = {
				Size = UDim2.new(1, 0, 1, -(Constants.TOP_BAR_HEIGHT + 45)),
				LayoutOrder = p2.props.layoutOrder,
				BackgroundTransparency = 1
			}

			local createElement2 = roact.createElement
			local v9 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.4, 0),
				AnchorPoint = Vector2.new(0.5, 0.4)
			}
			local v10 = {
				UIList = roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 0)
				}),
				Imagelabel = 0,
				Textlabel = 0
			}
			local v11

			if defineFastFlag then
				v11 = roact.createElement(image, {
					Image = p2.props.assetId,
					imageStyle = p2.props.tokens.Color.Content.Emphasis,
					Size = UDim2.fromOffset(p2.props.assetSize.X, p2.props.assetSize.Y),
					LayoutOrder = 1
				})
			else
				v11 = roact.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Image = images["icons/status/oof_xlarge"],
					ImageColor3 = p3.Theme.TextMuted.Color,
					ImageTransparency = p3.Theme.TextMuted.Transparency,
					LayoutOrder = 1,
					Size = UDim2.new(0, 96, 0, 96)
				})
			end

			v10.Imagelabel = v11

			v10.Textlabel = roact.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Font = appFonts.default:getDefault(),
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				Text = p4.noResultsText,
				TextColor3 = p3.Theme.TextMuted.Color,
				TextSize = p3.Font.Header2.RelativeSize * p3.Font.BaseSize,
				TextTransparency = p3.Theme.TextMuted.Transparency
			})
			return createElement("Frame", v6, {
				IndicatorInner = createElement2("Frame", v9, v10)
			})
		end)
	end)
end

local function EmptyResultsViewContainer(p2)
	preloadAsset("pictograms/collaborators")
	local pictogramscollaborators = assets["pictograms/collaborators"]
	local assetId = pictogramscollaborators.assetId
	local size = pictogramscollaborators.size

	local v5 = useTokens()

	local v6 = size / 3

	return roact.createElement(
		extended,
		Cryo.Dictionary.join(p2, { assetSize = v6, assetId = assetId, tokens = v5 })
	)
end

if defineFastFlag then
	return EmptyResultsViewContainer
end

return extended
