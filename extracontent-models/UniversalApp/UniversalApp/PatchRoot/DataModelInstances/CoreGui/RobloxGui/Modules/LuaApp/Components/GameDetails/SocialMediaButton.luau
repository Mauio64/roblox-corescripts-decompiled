local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Cryo = require(CorePackages.Packages.Cryo)
local DiscoveryAnalytics = require(CorePackages.Workspace.Packages.DiscoveryAnalytics)
local sendSocialLinkClickEvent = DiscoveryAnalytics.Events.sendSocialLinkClickEvent
local sendOpenLeavingRobloxModalEvent = DiscoveryAnalytics.Events.sendOpenLeavingRobloxModalEvent
local SocialMediaType = require(Modules.LuaApp.Enum.SocialMediaType)
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local Common = Modules.Common
local React = require(CorePackages.Packages.React)
local Roact = require(Common.Roact)
local RoactRodux = require(Common.RoactRodux)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImpressionsTagUtility = require(CorePackages.Workspace.Packages.Impressions).ImpressionsTagUtility
local FFlagLuaAppAmazonSocialLinkEdp = require(Modules.Personalization.Flags.FFlagLuaAppAmazonSocialLinkEdp)
local FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local t1 = {
	[SocialMediaType.Twitter] = Images["icons/brands/x"],
	[SocialMediaType.Facebook] = Images["icons/brands/facebook"],
	[SocialMediaType.Discord] = Images["icons/brands/discord"],
	[SocialMediaType.RobloxGroup] = Images["icons/logo/block"],
	[SocialMediaType.YouTube] = Images["icons/brands/youtube"],
	[SocialMediaType.Twitch] = Images["icons/brands/twitch"],
	[SocialMediaType.Guilded] = Images["icons/brands/guilded"],
	[SocialMediaType.Amazon] = if not FFlagLuaAppAmazonSocialLinkEdp then nil else Images["icons/brands/amazon_simple"]
}
local v27 = Roact.PureComponent:extend("SocialMediaButton")

function v27.init(p1) -- line: 48
	-- upvalues: FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendOpenLeavingRobloxModalEvent (copy), SocialMediaType (copy), sendSocialLinkClickEvent (copy)
	p1.state = {
		buttonPressed = false
	}

	function p1.onInputBegan(_, p3) -- line: 53
		-- upvalues: p1 (copy)
		if p3.UserInputState == Enum.UserInputState.Begin and ((p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1) and not p1.state.buttonPressed) then
			p1:setState({
				buttonPressed = true
			})
		end
	end
	function p1.onInputEnded() -- line: 69
		-- upvalues: p1 (copy)
		if p1.state.buttonPressed then
			p1:setState({
				buttonPressed = false
			})
		end
	end
	function p1.onActivated() -- line: 77
		-- upvalues: FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendOpenLeavingRobloxModalEvent (copy), p1 (copy)
		if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
			sendOpenLeavingRobloxModalEvent({
				assignment_type = "game",
				social_link_display_type = "badge",
				assignment_id = tonumber(p1.props.universeId),
				social_link_type = p1.props.socialType
			})
		end

		p1.props.openLeaveRobloxAlertUIBlox(p1.openUrl)
	end
	function p1.getUriParams() -- line: 89
		-- upvalues: p1 (copy), SocialMediaType (copy)
		if p1.props.socialType == SocialMediaType.Twitter then
			local v45 = p1.props.socialUrl:match("twitter.com/+([a-zA-Z0-9_]+)/*")

			if v45 ~= nil then
				return {
					app_uri = "twitter://user?screen_name=" .. v45,
					web_uri = p1.props.socialUrl
				}
			end
		end

		return {
			app_uri = p1.props.socialUrl,
			web_uri = p1.props.socialUrl
		}
	end
	function p1.openUrl() -- line: 108
		-- upvalues: FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), p1 (copy)
		if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
			sendSocialLinkClickEvent({
				assignment_type = "game",
				social_link_display_type = "badge",
				assignment_id = tonumber(p1.props.universeId),
				social_link_type = p1.props.socialType,
				social_link_url = p1.props.socialUrl
			})
		end

		local v46 = p1.getUriParams()

		p1.props.linking:openURL(v46.app_uri):andThen(function(p4) -- line: 119
			-- upvalues: p1 (copy), v46 (copy)
			if p4 == false then
				p1.props.linking:openURL(v46.web_uri)
			end
		end)
		p1.props.closeAlert()
	end
end
function v27.render(p5) -- line: 129
	-- upvalues: Roact (copy), ImageSetButton (copy), t1 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagLuaAppAmazonSocialLinkEdp (copy)
	local propsSize = p5.props.Size
	local socialType = p5.props.socialType
	local propsLayoutOrder = p5.props.LayoutOrder
	local buttonPressed = p5.state.buttonPressed
	local SocialMediaButton = p5.props.appTheme.GameDetails.SocialMediaButton

	return Roact.createElement(ImageSetButton, {
		Size = propsSize,
		LayoutOrder = propsLayoutOrder,
		Image = t1[socialType],
		ImageTransparency = buttonPressed and SocialMediaButton.OnPressTransparency or SocialMediaButton.Transparency,
		ImageColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p5.props.designTokens.Semantic.Color.Ui.Emphasis else p5.props.designTokens.Color.Shift.Shift_400)).Color3,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = p5.onActivated,
		[Roact.Event.InputBegan] = p5.onInputBegan,
		[Roact.Event.InputEnded] = p5.onInputEnded,
		[Roact.Ref] = if not FFlagLuaAppAmazonSocialLinkEdp then nil else p5.props.forwardRef
	})
end

local v28 = withTheme_DEPRECATED(v27)
local v29 = RoactRodux.connect(function(_) -- line: 156
end, function(p7) -- line: 156
	-- upvalues: OpenCentralOverlayForLeaveRobloxAlert (copy), CloseCentralOverlay (copy)
	return {
		openLeaveRobloxAlertUIBlox = function(p8) -- line: 158
			-- upvalues: p7 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			p7(OpenCentralOverlayForLeaveRobloxAlert(p8))
		end,
		closeAlert = function() -- line: 161
			-- upvalues: p7 (copy), CloseCentralOverlay (copy)
			p7(CloseCentralOverlay())
		end
	}
end)(v28)

return RoactServices.connect({
	linking = AppLinking
})(function(p9) -- line: 168
	-- upvalues: useDesignTokens (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), React (copy), ImpressionsTagUtility (copy), Cryo (copy), Roact (copy), v29 (copy)
	local v40 = useDesignTokens()
	local u41 = nil

	if FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then
		u41 = React.useRef(nil)
		React.useEffect(function() -- line: 174
			-- upvalues: ImpressionsTagUtility (copy), u41 (ref), p9 (copy)
			ImpressionsTagUtility.AddTag(u41, p9.impressionsTag, p9.index)

			return function() -- line: 176
				-- upvalues: ImpressionsTagUtility (copy), u41 (ref), p9 (copy)
				ImpressionsTagUtility.RemoveTag(u41, p9.impressionsTag, p9.index)
			end
		end, {
			u41,
			p9.impressionsTag,
			p9.index
		})
	end

	local v42 = Cryo.Dictionary.join(p9, {
		designTokens = v40,
		forwardRef = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else u41
	})

	return Roact.createElement(v29, v42)
end)
