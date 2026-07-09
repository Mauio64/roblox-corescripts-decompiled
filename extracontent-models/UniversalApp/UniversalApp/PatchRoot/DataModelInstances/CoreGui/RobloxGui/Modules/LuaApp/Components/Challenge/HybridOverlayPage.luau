local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v13 = Roact.PureComponent:extend(script.Name)

function v13.init(p1) -- line: 28
	p1:setState({
		challengeDisplayed = false
	})
end
function v13.didMount(p2) -- line: 34
	p2.isMounted = true

	local t1 = {
		challengeType = p2.props.challengeType,
		challengeParameters = p2.props.challengeParameters,
		onChallengeAbandoned = p2.props.onChallengeAbandoned,
		onChallengeLoadFailed = p2.props.onChallengeLoadFailed,
		onChallengeDisplayed = function() -- line: 41
			-- upvalues: p2 (copy)
			p2:setState({
				challengeDisplayed = true
			})
		end,
		onChallengeUnmounted = function() -- line: 46
			-- upvalues: p2 (copy)
			p2.props.navigateBack()
		end,
		forceWebViewVisible = p2.props.forceWebViewVisible
	}

	p2.props.navigateToChallengeWebView(t1)
end
function v13.willUnmount(p3) -- line: 54
	p3.isMounted = false
end
function v13.render(p4) -- line: 58
	-- upvalues: Roact (copy), Loading (copy), IconSize (copy)
	local uDim2 = UDim2.fromOffset(p4.props.screenSize.X, p4.props.screenSize.Y)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0.2,
		Active = true,
		Size = uDim2
	}, {
		Spinner = Roact.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large
		})
	})
end

return (RoactRodux.connect(function(p5, _) -- line: 76
	return {
		screenSize = p5.ScreenSize
	}
end, function(p7) -- line: 80
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateBack (copy), AppPage (copy), NavigateDown (copy)
	return {
		navigateBack = function() -- line: 82
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), p7 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v12.back(true)
			end

			return p7(NavigateBack(true))
		end,
		navigateToChallengeWebView = function(p8) -- line: 89
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), p7 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.ChallengeHybridWebView,
				extraProps = p8
			}

			if FFlagSignalsNavP3Dispatch then
				return v12.down(v12.fromLegacyPage(t2), true)
			end

			return p7(NavigateDown(t2, true))
		end
	}
end)(v13))
