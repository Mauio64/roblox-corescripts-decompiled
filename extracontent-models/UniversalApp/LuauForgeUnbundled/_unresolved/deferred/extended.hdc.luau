local CorePackages = game:GetService("CorePackages")

local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger

local module = require("@luauforge/deferred/hdd")
local socialTabEntryPoint = module.Components.SocialTabEntryPoint
local context = module.Context

local extended = Roact.PureComponent:extend("SocialTabLoader")

extended.defaultProps = {
	receivedCanShowUserAlias = nil,
	showUserAlias = nil,
	renderSocialTab = function(props)
		return Roact.createElement(socialTabEntryPoint, {
			isVisible = props.isVisible,
			parameters = props.parameters,
			logger = logger,
			setTabBarVisible = props.setTabBarVisible,
			signal = props.signal,
			rnBypassActionSignalSocialTab = props.rnBypassActionSignalSocialTab,
			androidBackButtonConnection = props.androidBackButtonConnection,
			closeDrawer = props.closeDrawer,
			initialRouteName = props.initialRouteName
		})
	end
}

function extended:init()
	self.renderSocialTab = memoize(function(options)
		return Roact.createFragment({
			content = Roact.createElement(
				self.props.renderSocialTab,
				Cryo.Dictionary.join(options or {}, {
					closeDrawer = self.props.closeDrawer
				})
			)
		})
	end)
end

function extended.render(p2)
	return Roact.createElement(context.Consumer, { render = p2.renderSocialTab })
end

function extended.didMount(p2)
	p2.props.receivedCanShowUserAlias(p2.props.showUserAlias)
end

function extended.didUpdate(p2, p3)
	if p3.showUserAlias ~= p2.props.showUserAlias then
		p2.props.receivedCanShowUserAlias(p2.props.showUserAlias)
	end
end

return extended
