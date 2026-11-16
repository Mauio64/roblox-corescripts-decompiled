local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent

local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact

local withLocalization = dependencies.withLocalization

local uiBlox = dependencies.UIBlox
local withStyle = uiBlox.Style.withStyle
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel

local TextKeys = require(FriendsLanding.Common.TextKeys)
local Constants = require(FriendsLanding.Common.Constants)
local Style = require(parent.Style)
local AppFonts = Style.AppFonts
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

local defineFastFlag = game:DefineFastFlag("MigrateEmptyResultsViewToFoundation", false)

local extended = roact.PureComponent:extend("EmptyResultsView")

extended.defaultProps = { layoutOrder = 0, pageLoadingTimeReport = nil }

local function loadFoundationCloudAsset(p: string) -- 1 equivalent call inferred from this helper
	preloadAsset(p)
	local asset = Assets[p]
	return asset.assetId, asset.size
end

function extended.render(p)
	return withStyle(function(p2)
		return withLocalization({
			noResultsText = "CommonUI.Messages.Response.NoResults",
			addFriendsBtn = TextKeys.ADD_FRIENDS_BTN
		})(function(p3)
			local createElement = roact.createElement
			local v = {
				Size = UDim2.new(1, 0, 1, -(Constants.TOP_BAR_HEIGHT + 45)),
				LayoutOrder = p.props.layoutOrder,
				BackgroundTransparency = 1
			}

			local createElement2 = roact.createElement
			local v2 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.4, 0),
				AnchorPoint = Vector2.new(0.5, 0.4)
			}
			local v3 = {
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
			local imagelabel

			if defineFastFlag then
				imagelabel = roact.createElement(Image, {
					Image = p.props.assetId,
					imageStyle = p.props.tokens.Color.Content.Emphasis,
					Size = UDim2.fromOffset(p.props.assetSize.X, p.props.assetSize.Y),
					LayoutOrder = 1
				})
			else
				imagelabel = roact.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Image = images["icons/status/oof_xlarge"],
					ImageColor3 = p2.Theme.TextMuted.Color,
					ImageTransparency = p2.Theme.TextMuted.Transparency,
					LayoutOrder = 1,
					Size = UDim2.new(0, 96, 0, 96)
				})
			end

			v3.Imagelabel = imagelabel

			v3.Textlabel = roact.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Font = AppFonts.default:getDefault(),
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				Text = p3.noResultsText,
				TextColor3 = p2.Theme.TextMuted.Color,
				TextSize = p2.Font.Header2.RelativeSize * p2.Font.BaseSize,
				TextTransparency = p2.Theme.TextMuted.Transparency
			})
			return createElement("Frame", v, {
				IndicatorInner = createElement2("Frame", v2, v3)
			})
		end)
	end)
end

local function EmptyResultsViewContainer(p)
	local assetId, size = loadFoundationCloudAsset("pictograms/collaborators") -- inferred equivalent call
	local tokens = useTokens()

	local assetSize = size / 3

	return roact.createElement(
		extended,
		Cryo.Dictionary.join(p, { assetSize = assetSize, assetId = assetId, tokens = tokens })
	)
end

return if defineFastFlag then EmptyResultsViewContainer else extended
