local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local module = require("@luauforge/bundled/dCp")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module3 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local extended = Roact.PureComponent:extend("HybridOverlayPage")

function extended.init(object)
	object:setState({ challengeDisplayed = false })
end

function extended:didMount()
	self.isMounted = true
	local v5 = {
		challengeType = self.props.challengeType,
		challengeParameters = self.props.challengeParameters,
		onChallengeAbandoned = self.props.onChallengeAbandoned,
		onChallengeLoadFailed = self.props.onChallengeLoadFailed,
		onChallengeDisplayed = function()
			self:setState({ challengeDisplayed = true })
		end,
		onChallengeUnmounted = function()
			self.props.navigateBack()
		end,
		forceWebViewVisible = self.props.forceWebViewVisible
	}

	self.props.navigateToChallengeWebView(v5)
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(p2)
	local udim = UDim2.fromOffset(p2.props.screenSize.X, p2.props.screenSize.Y)

	return Roact.createElement("Frame", {
		Size = udim,
		BackgroundTransparency = 0.2,
		Active = true
	}, {
		Spinner = Roact.createElement(loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = iconSize.Large
		})
	})
end

return (RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back(true)
			end

			return callback(RobloxAppToastsRodux(true))
		end,
		navigateToChallengeWebView = function(p2)
			local v5 = { name = module.ChallengeHybridWebView, extraProps = p2 }

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v5), true)
			end

			return callback(module3(v5, true))
		end
	}
end)(extended))
