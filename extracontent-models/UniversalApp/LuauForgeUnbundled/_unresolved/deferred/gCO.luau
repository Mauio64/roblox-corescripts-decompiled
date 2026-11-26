local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module3 = require("@luauforge/deferred/gCP")

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp

local extended = module.PureComponent:extend("SocialMediaGroup")

function extended.render(p2)
	local layoutOrder = p2.props.LayoutOrder
	local socialLinks = p2.props.socialLinks

	if not socialLinks or #socialLinks == 0 then
		return nil
	end

	local children = {
		ListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 20)
		})
	}

	for i, socialLink in ipairs(p2.props.socialLinks) do
		local v5 = "SocialButton_" .. socialLink.type
		local createElement = module.createElement
		local v7 = {
			Size = UDim2.new(0, 44, 0, 44),
			LayoutOrder = i,
			socialType = socialLink.type,
			socialUrl = socialLink.url,
			index = i,
			impressionsTag = p2.props.impressionsTag,
			universeId = 0
		}
		local v8 = if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then p2.props.universeId else nil
		v7.universeId = v8
		children[v5] = createElement(module3, v7)
	end

	return module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		},
		children
	)
end

return useSheetNavigation.connect(function(p2, p3)
	local gameSocialLink = p2.GameSocialLinks[p3.universeId]
	return {
		socialLinks = gameSocialLink and gameSocialLink.externalLinks
	}
end)(extended)
