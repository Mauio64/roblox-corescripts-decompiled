local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.EquipOutfit)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v17 = Roact.PureComponent:extend("EquipOutfitConfirmation")
local GetFFlagFixAvatarCostumeChange = require(Modules.AvatarExperience.Flags.GetFFlagFixAvatarCostumeChange)

v17.validateProps = t.strictInterface({
	outfitInfo = t.table,
	onOverlayClosed = t.optional(t.callback),
	onEquip = t.optional(t.callback),
	screenSize = t.Vector2,
	equipOutfit = t.callback,
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	analytics = t.optional(t.table),
	navigation = t.table
})

function v17.init(p1) -- line: 47
	-- upvalues: GetFFlagFixAvatarCostumeChange (copy), NavigationUtils (copy)
	function p1.equipCostume() -- line: 48
		-- upvalues: p1 (copy), GetFFlagFixAvatarCostumeChange (copy)
		local outfitInfo = p1.props.outfitInfo
		local analytics = p1.props.analytics
		local navigation = p1.props.navigation

		if GetFFlagFixAvatarCostumeChange() then
			p1.closePrompt()

			local v30 = p1.props.equipOutfit(outfitInfo, analytics, navigation, nil)

			if p1.props.onEquip then
				p1.props.onEquip(v30)

				return
			end
		else
			local v31 = p1.props.equipOutfit(outfitInfo, analytics, navigation, nil)

			if p1.props.onEquip then
				p1.props.onEquip(v31)
			end

			p1.closePrompt()
		end
	end
	function p1.closePrompt() -- line: 69
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v17.renderLocalized(p2, p3) -- line: 74
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p3.titleText,
		bodyText = p3.messageText,
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
						onActivated = p2.equipCostume,
						text = p3.confirmButtonText
					}
				}
			}
		},
		screenSize = p2.props.screenSize,
		defaultChildRef = p2.props.defaultChildRef
	})
end
function v17.render(p4) -- line: 101
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.Avatar.Action.Switch",
		messageText = "Feature.Avatar.Message.EquipCostumeConfirmation",
		confirmButtonText = "Feature.Avatar.Action.Switch",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p5) -- line: 107
		-- upvalues: p4 (copy)
		return p4:renderLocalized(p5)
	end)
end

local v19 = withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(function(p6, _) -- line: 112
	return {
		screenSize = p6.ScreenSize
	}
end, function(p8) -- line: 116
	-- upvalues: EquipOutfit (copy)
	return {
		equipOutfit = function(p9, p10, p11, p12) -- line: 118
			-- upvalues: p8 (copy), EquipOutfit (copy)
			local t1 = {
				outfitInfo = p9,
				analytics = p10,
				navigation = p11,
				isSelected = p12
			}

			return p8(EquipOutfit(t1))
		end
	}
end)(v17)))))

return (RoactServices.connect({
	analytics = Analytics
})(v19))
