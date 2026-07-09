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
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v16 = game:DefineFastFlag("AXFixR15PromptDismiss", false)
local v17 = Roact.PureComponent:extend("R15UpgradePrompt")

v17.validateProps = t.strictInterface({
	bodyTextKey = t.string,
	onSwitchSelected = t.optional(t.callback),
	onOverlayClosed = t.optional(t.callback),
	onOverlayClosedPostClose = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	screenSize = t.Vector2,
	setAvatarType = t.callback,
	toggleEquipAsset = t.callback
})

function v17.init(p1) -- line: 61
	-- upvalues: Constants (copy), NavigationUtils (copy)
	function p1.switchToR15() -- line: 62
		-- upvalues: p1 (copy), Constants (copy)
		p1.props.setAvatarType(Constants.AvatarType.R15)

		if p1.props.onSwitchSelected then
			p1.props.onSwitchSelected()
		end

		p1.closePrompt()
	end
	function p1.closePrompt() -- line: 70
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)

		if p1.props.onOverlayClosedPostClose then
			p1.props.onOverlayClosedPostClose()
		end
	end
end
function v17.renderLocalized(p2, p3) -- line: 78
	-- upvalues: v16 (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	if v16 then
		return Roact.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			Transparency = 1,
			Selectable = false,
			[Roact.Event.Activated] = p2.closePrompt
		}, {
			InteractiveAlert = Roact.createElement(InteractiveAlert, {
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
								onActivated = p2.switchToR15,
								text = p3.confirmButtonText
							}
						}
					}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = p2.props.screenSize,
				defaultChildRef = p2.props.defaultChildRef
			})
		})
	end

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
						onActivated = p2.switchToR15,
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
function v17.render(p4) -- line: 141
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.Avatar.Label.SwitchToR15",
		confirmButtonText = "Feature.Avatar.Action.Switch",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		bodyText = p4.props.bodyTextKey
	})(function(p5) -- line: 147
		-- upvalues: p4 (copy)
		return p4:renderLocalized(p5)
	end)
end

local function mapStateToProps(p6, _) -- line: 152
	return {
		screenSize = p6.ScreenSize
	}
end
local function mapDispatchToProps(p8) -- line: 158
	-- upvalues: SetAvatarType (copy), ToggleEquipAsset (copy)
	return {
		setAvatarType = function(p9) -- line: 160
			-- upvalues: p8 (copy), SetAvatarType (copy)
			p8(SetAvatarType(p9))
		end,
		toggleEquipAsset = function(p10, p11, p12) -- line: 163
			-- upvalues: p8 (copy), ToggleEquipAsset (copy)
			p8(ToggleEquipAsset(p10, p11, p12))
		end
	}
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v17))))))
