local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Common = Modules.Common
local Roact = require(Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local SocialMediaButton = require(Modules.LuaApp.Components.GameDetails.SocialMediaButton)
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp
local v9 = Roact.PureComponent:extend("SocialMediaGroup")

function v9.render(p1) -- line: 20
	-- upvalues: Roact (copy), SocialMediaButton (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy)
	local propsLayoutOrder = p1.props.LayoutOrder
	local socialLinks = p1.props.socialLinks

	if not socialLinks or #socialLinks == 0 then
		return nil
	end

	local t1 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 20)
		})
	}

	for i, v in ipairs(p1.props.socialLinks) do
		t1["SocialButton_" .. v.type] = Roact.createElement(SocialMediaButton, {
			Size = UDim2.new(0, 44, 0, 44),
			LayoutOrder = i,
			socialType = v.type,
			socialUrl = v.url,
			index = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else i,
			impressionsTag = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else p1.props.impressionsTag,
			universeId = if not FFlagLuaAppAddSocialLinkClickTelemetryToEdp then nil else p1.props.universeId
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 44),
		LayoutOrder = propsLayoutOrder
	}, t1)
end

return RoactRodux.connect(function(p2, p3) -- line: 59
	local v18 = p2.GameSocialLinks[p3.universeId]

	return {
		socialLinks = v18 and v18.externalLinks
	}
end)(v9)
