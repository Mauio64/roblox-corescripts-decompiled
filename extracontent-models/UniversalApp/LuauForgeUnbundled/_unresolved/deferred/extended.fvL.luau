local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/deferred/fvM")

local fFlagSignalsNavP3aWrapAppPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3aWrapAppPage
local getLegacyNavigationStore

if fFlagSignalsNavP3aWrapAppPage then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local extended = Roact.PureComponent:extend("AndroidBackButtonNavigationHandler")

extended.defaultProps = {
	androidBackButtonConnection = function()
		return module()
	end
}

function extended:init()
	self.androidBackButtonConnection = self.props.androidBackButtonConnection()

	function self.onBackButtonPressed()
		if self.props.disabled then
			return
		end

		if self.props.canGoBackInRN and self.props.navigateBackInRN then
			self.props.navigateBackInRN()
			return
		end

		local v5

		if fFlagSignalsNavP3aWrapAppPage then
			v5 = getLegacyNavigationStore(false).getCanGoBack(false)
		else
			v5 = self.props.canGoBackInAppRoute
		end

		if v5 then
			self.props.navigateBackInAppRoute()
		else
			self.androidBackButtonConnection.showExitDialog()
		end
	end
end

function extended.didMount(p2)
	p2.androidBackButtonConnection.connect(p2.onBackButtonPressed)
end

function extended.didUpdate(data, p2)
	if p2.isVisible or not data.props.isVisible then
		if p2.isVisible and not data.props.isVisible then
			data.androidBackButtonConnection.disconnect()
		end
	else
		data.androidBackButtonConnection.connect(data.onBackButtonPressed)
	end
end

function extended.willUnmount(p2)
	p2.androidBackButtonConnection.disconnect()
end

function extended.render(p2): nil
	return nil
end

return extended
