local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local withLocalization = dependencies.withLocalization
local UIBlox = dependencies.UIBlox
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TextKeys = require(FriendsLanding.Common.TextKeys)
local Constants = require(FriendsLanding.Common.Constants)
local AppFonts = require(FriendsLandingParent.Style).AppFonts
local Cryo = require(FriendsLandingParent.Cryo)
local Foundation = require(FriendsLandingParent.Foundation)
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local FoundationCloudAssets = require(FriendsLandingParent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset
local v20 = game:DefineFastFlag("MigrateEmptyResultsViewToFoundation", false)
local FFlagConnectionsToFriendsRename = require(FriendsLandingParent.SharedFlags).FFlagConnectionsToFriendsRename
local v22 = Roact.PureComponent:extend("EmptyResultsView")

v22.defaultProps = {
	layoutOrder = 0,
	pageLoadingTimeReport = nil
}

local function loadFoundationCloudAsset(s1: string) -- line: 45
	-- upvalues: preloadAsset (copy), Assets (copy)
	preloadAsset(s1)

	local v26 = Assets[s1]

	return v26.assetId, v26.size
end

function v22.render(p1) -- line: 51
	-- upvalues: withStyle (copy), withLocalization (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), Roact (copy), Constants (copy), v20 (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), AppFonts (copy)
	return withStyle(function(p2) -- line: 52
		-- upvalues: withLocalization (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), Roact (copy), Constants (copy), p1 (copy), v20 (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), AppFonts (copy)
		return withLocalization({
			noResultsText = "CommonUI.Messages.Response.NoResults",
			addFriendsBtn = if not FFlagConnectionsToFriendsRename then TextKeys.ADD_CONNECTIONS_BTN else TextKeys.ADD_FRIENDS_BTN
		})(function(p3) -- line: 58
			-- upvalues: Roact (copy), Constants (copy), p1 (copy), v20 (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), p2 (copy), AppFonts (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -(Constants.TOP_BAR_HEIGHT + 45)),
				LayoutOrder = p1.props.layoutOrder
			}, {
				IndicatorInner = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(0.5, 0, 0.4, 0),
					AnchorPoint = Vector2.new(0.5, 0.4)
				}, {
					UIList = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 0)
					}),
					Imagelabel = if not v20 then Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Image = Images["icons/status/oof_xlarge"],
						ImageColor3 = p2.Theme.TextMuted.Color,
						ImageTransparency = p2.Theme.TextMuted.Transparency,
						Size = UDim2.new(0, 96, 0, 96)
					}) else Roact.createElement(FoundationImage, {
						LayoutOrder = 1,
						Image = p1.props.assetId,
						Size = UDim2.fromOffset(p1.props.assetSize.X, p1.props.assetSize.Y)
					}),
					Textlabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						Font = AppFonts.default:getDefault(),
						Size = UDim2.new(0, 0, 0, 0),
						Text = p3.noResultsText,
						TextColor3 = p2.Theme.TextMuted.Color,
						TextSize = p2.Font.Header2.RelativeSize * p2.Font.BaseSize,
						TextTransparency = p2.Theme.TextMuted.Transparency
					})
				})
			})
		end)
	end)
end

local function EmptyResultsViewContainer(p4) -- line: 109
	-- upvalues: preloadAsset (copy), Assets (copy), useTokens (copy), Roact (copy), v22 (copy), Cryo (copy)
	preloadAsset("pictograms/collaborators")

	local v29 = Assets["pictograms/collaborators"]
	local assetId = v29.assetId
	local size = v29.size
	local v32 = useTokens()
	local v33 = size / 3

	return Roact.createElement(v22, Cryo.Dictionary.join(p4, {
		assetSize = v33,
		assetId = assetId,
		tokens = v32
	}))
end

if v20 then
	return EmptyResultsViewContainer
end

return v22
