local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local usePlayerCountText = require(CorePackages.Workspace.Packages.GameTile).usePlayerCountText
local Cryo = require(CorePackages.Packages.Cryo)
local useAbbreviatedNumberLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useAbbreviatedNumberLocalization
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local GameCardLayoutType = DiscoveryTypes.GameCardLayoutType
local GameBasicStatsLayoutType = DiscoveryTypes.GameBasicStatsLayoutType
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FitImageTextFrame = require(Modules.LuaApp.Components.FitImageTextFrame)
local v15 = Images["icons/status/games/rating_small"]
local v16 = Images["icons/status/games/people-playing_small"]
local v17 = Images["icons/status/games/sessions_large"]
local t1 = {
	[GameBasicStatsLayoutType[GameCardLayoutType.Small]] = {
		Padding = 6,
		TextSize = 14,
		IconSize = 10,
		IconTextPadding = 3
	},
	[GameBasicStatsLayoutType[GameCardLayoutType.Medium]] = {
		Padding = 12,
		TextSize = 14,
		IconSize = 10,
		IconTextPadding = 3
	},
	[GameBasicStatsLayoutType[GameCardLayoutType.Large]] = {
		Padding = 12,
		TextSize = 16,
		IconSize = 12,
		IconTextPadding = 3
	},
	[GameBasicStatsLayoutType.GameDetails] = {
		Padding = 13,
		TextSize = 22,
		IconSize = 17,
		IconTextPadding = 5
	}
}
local v19 = Roact.PureComponent:extend("GameBasicStats")

function v19.init(p1) -- line: 51
	-- upvalues: t1 (copy)
	function p1.getImageProps(p2, p3) -- line: 52
		-- upvalues: t1 (copy), p1 (copy)
		local v44 = t1[p1.props.layoutType]

		return {
			Size = UDim2.new(0, v44.IconSize, 0, v44.IconSize),
			Image = p2,
			ImageColor3 = p3.Theme.TextMuted.Color,
			ImageTransparency = p3.Theme.TextMuted.Transparency
		}
	end
	function p1.getTextProps(p4, p5) -- line: 62
		-- upvalues: t1 (copy), p1 (copy)
		local v47 = t1[p1.props.layoutType]

		return {
			Text = p4,
			Font = p5.Font.SubHeader1.Font,
			TextSize = v47.TextSize,
			TextColor3 = p5.Theme.TextMuted.Color,
			TextTransparency = p5.Theme.TextMuted.Transparency
		}
	end
end
function v19.render(p6) -- line: 74
	-- upvalues: t1 (copy), withStyle (copy), Roact (copy), FitImageTextFrame (copy), v15 (copy), v16 (copy), v17 (copy)
	local propsPosition = p6.props.Position
	local propsLayoutOrder = p6.props.LayoutOrder
	local upVotes = p6.props.upVotes
	local downVotes = p6.props.downVotes
	local showGlobalCounters = p6.props.showGlobalCounters
	local visits = p6.props.visits
	local layoutType = p6.props.layoutType

	assert(layoutType ~= nil, "GameBasicStats expects a layoutType props")

	local v30 = t1[layoutType]

	assert(v30 ~= nil, "GameBasicStats expects a supported layoutType props; was given: " .. layoutType)

	local playerCountText = p6.props.playerCountText
	local visitsText = p6.props.visitsText
	local s1 = "--"

	if upVotes == nil or upVotes < 0 then
		upVotes = 0
	end

	if downVotes == nil or downVotes < 0 then
		downVotes = 0
	end

	local v34 = upVotes + downVotes

	if v34 > 0 then
		s1 = math.floor(upVotes / v34 * 100) .. "%"
	end

	return withStyle(function(p7) -- line: 108
		-- upvalues: Roact (copy), v30 (copy), propsPosition (copy), propsLayoutOrder (copy), FitImageTextFrame (copy), p6 (copy), v15 (copy), s1 (ref), v16 (copy), playerCountText (copy), showGlobalCounters (copy), visits (copy), v17 (copy), visitsText (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 0, v30.TextSize),
			AutomaticSize = Enum.AutomaticSize.X,
			Position = propsPosition,
			LayoutOrder = propsLayoutOrder
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v30.Padding)
			}),
			VoteInfo = Roact.createElement(FitImageTextFrame, {
				LayoutOrder = 1,
				padding = v30.IconTextPadding,
				imageProps = p6.getImageProps(v15, p7),
				textProps = p6.getTextProps(s1, p7)
			}),
			PlayerCountInfo = Roact.createElement(FitImageTextFrame, {
				LayoutOrder = 2,
				padding = v30.IconTextPadding,
				imageProps = p6.getImageProps(v16, p7),
				textProps = p6.getTextProps(playerCountText, p7)
			}),
			VisitsInfo = showGlobalCounters and (visits and Roact.createElement(FitImageTextFrame, {
				LayoutOrder = 3,
				padding = v30.IconTextPadding,
				imageProps = p6.getImageProps(v17, p7),
				textProps = p6.getTextProps(visitsText, p7)
			}))
		})
	end)
end

local v20 = v19

return (RoactAppPolicy.connect(function(p8, _) -- line: 163
	return {
		showGlobalCounters = p8.getShowGlobalCounters()
	}
end)(function(p10) -- line: 146
	-- upvalues: usePlayerCountText (copy), useAbbreviatedNumberLocalization (copy), Roact (copy), v20 (copy), Cryo (copy)
	local playerCount = p10.playerCount
	local visits = p10.visits
	local v38 = usePlayerCountText(playerCount)
	local v39 = useAbbreviatedNumberLocalization(visits)

	return Roact.createElement(v20, Cryo.Dictionary.join(p10, {
		playerCountText = v38,
		visitsText = v39
	}))
end))
