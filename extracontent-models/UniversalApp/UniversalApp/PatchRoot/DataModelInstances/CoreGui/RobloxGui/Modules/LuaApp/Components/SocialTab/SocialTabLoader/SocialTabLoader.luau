local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local SocialTab = require(script:FindFirstAncestor("SocialTab").SocialTab)
local SocialTabEntryPoint = SocialTab.Components.SocialTabEntryPoint
local Context = SocialTab.Context
local v9 = Roact.PureComponent:extend("SocialTabLoader")

v9.defaultProps = {
	receivedCanShowUserAlias = nil,
	showUserAlias = nil,
	renderSocialTab = function(p1) -- line: 18
		-- upvalues: Roact (copy), SocialTabEntryPoint (copy), Logger (copy)
		return Roact.createElement(SocialTabEntryPoint, {
			isVisible = p1.isVisible,
			parameters = p1.parameters,
			logger = Logger,
			setTabBarVisible = p1.setTabBarVisible,
			signal = p1.signal,
			rnBypassActionSignalSocialTab = p1.rnBypassActionSignalSocialTab,
			androidBackButtonConnection = p1.androidBackButtonConnection,
			closeDrawer = p1.closeDrawer,
			initialRouteName = p1.initialRouteName
		})
	end
}

function v9.init(p2) -- line: 33
	-- upvalues: memoize (copy), Roact (copy), Cryo (copy)
	p2.renderSocialTab = memoize(function(p3) -- line: 34
		-- upvalues: Roact (copy), p2 (copy), Cryo (copy)
		return Roact.createFragment({
			content = Roact.createElement(p2.props.renderSocialTab, Cryo.Dictionary.join(p3 or {}, {
				closeDrawer = p2.props.closeDrawer
			}))
		})
	end)
end
function v9.render(p4) -- line: 46
	-- upvalues: Roact (copy), Context (copy)
	return Roact.createElement(Context.Consumer, {
		render = p4.renderSocialTab
	})
end
function v9.didMount(p5) -- line: 52
	p5.props.receivedCanShowUserAlias(p5.props.showUserAlias)
end
function v9.didUpdate(p6, p7) -- line: 56
	if p7.showUserAlias ~= p6.props.showUserAlias then
		p6.props.receivedCanShowUserAlias(p6.props.showUserAlias)
	end
end

return v9
