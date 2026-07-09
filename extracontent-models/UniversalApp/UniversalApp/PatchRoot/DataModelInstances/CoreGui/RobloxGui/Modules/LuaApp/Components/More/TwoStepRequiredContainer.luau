local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local TwoStepRequiredOverlay = require(script.Parent.TwoStepRequiredOverlay)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigateDownToSecuritySettings = require(Modules.LuaApp.Thunks.NavigateDownToSecuritySettings)
local v11 = Roact.PureComponent:extend(script.Name)

function v11.init(p1) -- line: 21
	function p1.closePrompt() -- line: 22
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
	function p1.navigateToSecuritySettings() -- line: 27
		-- upvalues: p1 (copy)
		p1.closePrompt()
		p1.props.navigateToSecuritySettings()
	end
end
function v11.render(p2) -- line: 33
	-- upvalues: Roact (copy), Focusable (copy), TwoStepRequiredOverlay (copy)
	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		TwoStepRequiredOverlay = Roact.createElement(TwoStepRequiredOverlay, {
			closePrompt = p2.closePrompt,
			navigateToSecuritySettings = p2.navigateToSecuritySettings,
			screenSize = p2.props.screenSize
		})
	})
end

return (withNavigation((withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(function(p3) -- line: 46
	return {
		screenSize = p3.ScreenSize
	}
end, function(p4) -- line: 50
	-- upvalues: NavigateDownToSecuritySettings (copy)
	return {
		navigateToSecuritySettings = function() -- line: 52
			-- upvalues: p4 (copy), NavigateDownToSecuritySettings (copy)
			p4(NavigateDownToSecuritySettings())
		end
	}
end)(v11))))))))
