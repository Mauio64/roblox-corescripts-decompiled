local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local SetAvatarType = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarType)
local RemoveLayeredClothing = require(Modules.AvatarExperience.AvatarEditor.Thunks.RemoveLayeredClothing)
local RemoveMakeup = require(Modules.AvatarExperience.AvatarEditor.Actions.RemoveMakeup)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local FFlagAXBlockMakeupEquipR6 = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBlockMakeupEquipR6
local v18 = Roact.PureComponent:extend("LayeredClothingR6SwitchPrompt")

v18.validateProps = t.strictInterface({
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	screenSize = t.Vector2,
	setAvatarType = t.callback,
	removeLayeredClothing = t.callback,
	removeMakeup = if not FFlagAXBlockMakeupEquipR6 then nil else t.callback
})

function v18.init(p1) -- line: 60
	-- upvalues: FFlagAXBlockMakeupEquipR6 (copy), Constants (copy), NavigationUtils (copy)
	function p1.switchToR6() -- line: 61
		-- upvalues: p1 (copy), FFlagAXBlockMakeupEquipR6 (copy), Constants (copy)
		p1.props.removeLayeredClothing()

		if FFlagAXBlockMakeupEquipR6 then
			p1.props.removeMakeup()
		end

		p1.props.setAvatarType(Constants.AvatarType.R6)
		p1.closePrompt()
	end
	function p1.closePrompt() -- line: 70
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v18.renderLocalized(p2, p3) -- line: 75
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p3.titleText,
		bodyText = p3.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p2.closePrompt,
						text = p3.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p2.switchToR6,
						text = p3.confirmButtonText
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end
function v18.render(p4) -- line: 103
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Common.AlertsAndOptions.Title.Warning",
		bodyText = "Feature.Avatar.Label.LayeredClothingSwitchR6Warning",
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})(function(p5) -- line: 109
		-- upvalues: p4 (copy)
		return p4:renderLocalized(p5)
	end)
end

local function mapStateToProps(p6, _) -- line: 114
	return {
		screenSize = p6.ScreenSize
	}
end
local function mapDispatchToProps(p8) -- line: 120
	-- upvalues: SetAvatarType (copy), RemoveLayeredClothing (copy), FFlagAXBlockMakeupEquipR6 (copy), RemoveMakeup (copy)
	return {
		setAvatarType = function(p9) -- line: 122
			-- upvalues: p8 (copy), SetAvatarType (copy)
			p8(SetAvatarType(p9))
		end,
		removeLayeredClothing = function() -- line: 125
			-- upvalues: p8 (copy), RemoveLayeredClothing (copy)
			p8(RemoveLayeredClothing())
		end,
		removeMakeup = if not FFlagAXBlockMakeupEquipR6 then nil else function() -- line: 129
			-- upvalues: p8 (copy), RemoveMakeup (copy)
			p8(RemoveMakeup())
		end
	}
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v18))))))
