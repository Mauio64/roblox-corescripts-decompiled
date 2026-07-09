local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local CommunityLinkBanner = require(script.Parent.CommunityLinkBanner)

require(script.Parent.Parent.Models.CommunityInfo)

local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local function ExperienceCommunityLink(t1: {[any]: any}) -- line: 23
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), StyledTextLabel (copy), CommunityLinkBanner (copy)
	local v10 = useStyle()
	local v11 = useLocalization({
		CommunityTitle = "Feature.CommunityLinks.Heading.CommunityTitle"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8)
		}),
		Title = React.createElement(StyledTextLabel, {
			richText = false,
			fluidSizing = false,
			layoutOrder = 1,
			text = v11.CommunityTitle,
			size = UDim2.fromScale(1, 0),
			fontStyle = v10.Font.Header1,
			colorStyle = v10.Theme.TextEmphasis,
			automaticSize = Enum.AutomaticSize.Y
		}),
		Banner = React.createElement(CommunityLinkBanner, {
			layoutOrder = 2,
			size = UDim2.fromScale(1, 0),
			communityInfo = t1.communityInfo,
			linkedEntityName = t1.experienceName,
			universeId = t1.universeId
		})
	})
end

return ExperienceCommunityLink
