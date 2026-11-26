local CorePackages = game:GetService("CorePackages")

local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dzG")
local sendSocialLinkClickEvent = module.Events.sendSocialLinkClickEvent
local sendOpenLeavingRobloxModalEvent = module.Events.sendOpenLeavingRobloxModalEvent
local module2 = require("@luauforge/deferred/gBS")
local module3 = require("@luauforge/bundled/fAJ")
local module4 = require("@luauforge/bundled/fCM")

local React = require(CorePackages.Packages.React)
local module5 = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module7 = require("@luauforge/bundled/gsj")

local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local impressionsTagUtility = require("@luauforge/bundled/egA").ImpressionsTagUtility

local module8 = require("@luauforge/deferred/gCQ")

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp

local v5 = {
	[module2.Twitter] = images["icons/brands/x"],
	[module2.Facebook] = images["icons/brands/facebook"],
	[module2.Discord] = images["icons/brands/discord"],
	[module2.RobloxGroup] = images["icons/logo/block"],
	[module2.YouTube] = images["icons/brands/youtube"],
	[module2.Twitch] = images["icons/brands/twitch"],
	[module2.Guilded] = images["icons/brands/guilded"]
}
local amazon = module2.Amazon
local v6 = if module8 then images["icons/brands/amazon_simple"] else nil
v5[amazon] = v6

local extended = module5.PureComponent:extend("SocialMediaButton")

function extended:init()
	self.state = { buttonPressed = false }

	function self.onInputBegan(p2, p3)
		if
			p3.UserInputState == Enum.UserInputState.Begin
			and (p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1)
			and not self.state.buttonPressed
		then
			self:setState({ buttonPressed = true })
		end
	end

	function self.onInputEnded()
		if self.state.buttonPressed then
			self:setState({ buttonPressed = false })
		end
	end

	function self.onActivated()
		if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then
			sendOpenLeavingRobloxModalEvent({
				assignment_id = tonumber(self.props.universeId),
				assignment_type = "game",
				social_link_type = self.props.socialType,
				social_link_display_type = "badge"
			})
		end

		self.props.openLeaveRobloxAlertUIBlox(self.openUrl)
	end

	function self.getUriParams()
		if self.props.socialType == module2.Twitter then
			local match = self.props.socialUrl:match("twitter.com/+([a-zA-Z0-9_]+)/*")

			if match ~= nil then
				return {
					app_uri = "twitter://user?screen_name=" .. match,
					web_uri = self.props.socialUrl
				}
			end
		end

		return { app_uri = self.props.socialUrl, web_uri = self.props.socialUrl }
	end

	function self.openUrl()
		if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then
			sendSocialLinkClickEvent({
				assignment_id = tonumber(self.props.universeId),
				assignment_type = "game",
				social_link_type = self.props.socialType,
				social_link_url = self.props.socialUrl,
				social_link_display_type = "badge"
			})
		end

		local uriParams = self.getUriParams()
		self.props.linking:openURL(uriParams.app_uri):andThen(function(p2)
			if p2 == false then
				self.props.linking:openURL(uriParams.web_uri)
			end
		end)
		self.props.closeAlert()
	end
end

function extended.render(props)
	local size = props.props.Size
	local socialType = props.props.socialType
	local layoutOrder = props.props.LayoutOrder
	local buttonPressed = props.state.buttonPressed
	local socialMediaButton = props.props.appTheme.GameDetails.SocialMediaButton

	local createElement = module5.createElement
	local v8 = {
		Size = size,
		LayoutOrder = layoutOrder,
		Image = v5[socialType],
		ImageTransparency = buttonPressed and socialMediaButton.OnPressTransparency or socialMediaButton.Transparency,
		ImageColor3 = props.props.designTokens.Color.Shift.Shift_400.Color3,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		[module5.Event.Activated] = props.onActivated,
		[module5.Event.InputBegan] = props.onInputBegan,
		[module5.Event.InputEnded] = props.onInputEnded
	}
	local ref = module5.Ref
	local v9 = if module8 then props.props.forwardRef else nil
	v8[ref] = v9
	return createElement(imageSetButton, v8)
end

local v7 = module7(extended)

local v8 = useSheetNavigation.connect(function(p2) end, function(callback)
	return {
		openLeaveRobloxAlertUIBlox = function(p2)
			callback(module3(p2))
		end,
		closeAlert = function()
			callback(module4())
		end
	}
end)(v7)

return roactServices.connect({ linking = appLinking })(function(p2)
	local v9 = useDesignTokens()

	local ref = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref, p2.impressionsTag, p2.index)
		return function()
			impressionsTagUtility.RemoveTag(ref, p2.impressionsTag, p2.index)
		end
	end, { ref, p2.impressionsTag, p2.index })
	local joined = Cryo.Dictionary.join(p2, { designTokens = v9, forwardRef = ref })

	return module5.createElement(v8, joined)
end)
