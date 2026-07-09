local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local GetDuplicateOutfit = require(Modules.AvatarExperience.AvatarEditor.Selectors.GetDuplicateOutfit)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavOverlayContainer = require(Modules.AvatarExperience.Common.Components.NavOverlayContainer)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v16 = GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("AXOutfitMenuUpdatesForSlotBasedEditor2", false)
local SlotBasedEditorAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics
local FFlagAXAddManageOutfitClickTracking = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAddManageOutfitClickTracking
local FFlagAXRemoveCreateOrUpdateOutfitMenuGamepadBindings = require(Modules.AvatarExperience.Flags.FFlagAXRemoveCreateOrUpdateOutfitMenuGamepadBindings)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local v23 = Roact.PureComponent:extend("CreateOrUpdateOutfitMenu")

v23.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	duplicateOutfitId = t.optional(t.string),
	navigation = t.table,
	focusController = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback),
	saveTilePosition = t.Vector2,
	defaultChildRef = t.optional(t.table)
})

function v23.init(p1) -- line: 68
	-- upvalues: FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), NavigationUtils (copy), AvatarScreen (copy), Roact (copy)
	function p1.saveOutfitAsNew() -- line: 69
		-- upvalues: FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), p1 (copy), NavigationUtils (copy), AvatarScreen (copy)
		if FFlagAXAddManageOutfitClickTracking then
			SlotBasedEditorAnalytics.trackAddNewAvatarClick()
		end

		if p1.props.duplicateOutfitId then
			NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.DuplicateOutfitInfoPrompt, {
				saveAsNew = true,
				duplicateOutfitId = p1.props.duplicateOutfitId
			})

			return
		end

		NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.SaveOutfitPrompt)
	end
	function p1.updateExistingOutfit() -- line: 85
		-- upvalues: FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), p1 (copy), NavigationUtils (copy), AvatarScreen (copy)
		if FFlagAXAddManageOutfitClickTracking then
			SlotBasedEditorAnalytics.trackUpdateAvatarClick()
		end

		if p1.props.duplicateOutfitId then
			NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.DuplicateOutfitInfoPrompt, {
				saveAsNew = false,
				duplicateOutfitId = p1.props.duplicateOutfitId
			})

			return
		end

		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.UpdateOutfitPage)
	end
	function p1.manageCharacters() -- line: 101
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.ManageOutfitPage)
	end
	function p1.closePrompt() -- line: 105
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end

	p1:setState({
		useFullWidth = false
	})

	function p1.onNavOverlaySizeChanged(p2) -- line: 113
		-- upvalues: p1 (copy)
		if p2.AbsoluteSize.X < 640 then
			if not p1.state.useFullWidth then
				p1:setState({
					useFullWidth = true
				})

				return
			end
		elseif p1.state.useFullWidth then
			p1:setState({
				useFullWidth = false
			})
		end
	end

	local v26, v27 = Roact.createBinding(UDim2.fromOffset(0, 0))

	p1.positionOffset = v26
	p1.updatePositionOffset = v27

	function p1.onNavOverlayPositionChanged(p3) -- line: 131
		-- upvalues: p1 (copy)
		p1.updatePositionOffset(UDim2.fromOffset(-p3.AbsolutePosition.X, -p3.AbsolutePosition.Y))
	end
end
function v23.renderLocalized(p4, p5) -- line: 136
	-- upvalues: MenuDirection (copy), Roact (copy), NavOverlayContainer (copy), Focusable (copy), FFlagAXRemoveCreateOrUpdateOutfitMenuGamepadBindings (copy), RoactGamepad (copy), ContextualMenu (copy)
	local t1 = {}

	table.insert(t1, {
		inputBindingKey = "CommonUI.Controls.Action.Confirm",
		text = p5.saveAsNew,
		onActivated = p4.saveOutfitAsNew
	})
	table.insert(t1, {
		inputBindingKey = "CommonUI.Controls.Action.Confirm",
		text = p5.updateExistingCharacter,
		onActivated = p4.updateExistingOutfit
	})
	table.insert(t1, {
		inputBindingKey = "CommonUI.Controls.Action.Confirm",
		text = p5.manageCharacters,
		onActivated = p4.manageCharacters
	})

	local v31 = p4.props.saveTilePosition.Y + 25
	local Down = MenuDirection.Down

	if v31 + #t1 * 56 + 12 > p4.props.screenSize.Y then
		v31 = p4.props.saveTilePosition.Y - 25
		Down = MenuDirection.Up
	end

	local uDim2 = UDim2.fromOffset(p4.props.saveTilePosition.X - 42, 0)
	local uDim2_2 = UDim2.new(0, 324, 1, 0)

	if p4.state.useFullWidth then
		uDim2 = UDim2.fromOffset(0, 0)
		uDim2_2 = UDim2.fromScale(1, 1)
	end

	return Roact.createElement(NavOverlayContainer, {
		onAbsoluteSizeChanged = p4.onNavOverlaySizeChanged,
		onAbsolutePositionChanged = p4.onNavOverlayPositionChanged
	}, {
		SizeFrame = Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			Position = uDim2,
			Size = uDim2_2,
			[Roact.Ref] = p4.props.defaultChildRef,
			inputBindings = if not FFlagAXRemoveCreateOrUpdateOutfitMenuGamepadBindings then {
				NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p4.closePrompt)
			} else nil
		}, {
			PositionOffsetFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = not p4.state.useFullWidth and p4.positionOffset or nil,
				Size = UDim2.fromScale(1, 1)
			}, {
				ContextMenu = Roact.createElement(ContextualMenu, {
					open = true,
					closeBackgroundVisible = true,
					buttonProps = t1,
					menuDirection = Down,
					openPositionY = UDim.new(0, v31),
					screenSize = p4.props.screenSize,
					onDismiss = p4.closePrompt
				})
			})
		})
	})
end
function v23.render(p6) -- line: 210
	-- upvalues: withLocalization (copy), v16 (copy), GetFFlagAXEnableSlotBasedEditor (copy)
	return withLocalization({
		saveAsNew = not v16 and "Feature.Avatar.Action.SaveAsNew" or "Feature.Avatar.Label.Title.AddNewAvatar",
		updateExistingCharacter = not v16 and "Feature.Avatar.Action.UpdateExistingCharacter" or "Feature.Avatar.Label.Title.UpdateAvatar",
		manageCharacters = not GetFFlagAXEnableSlotBasedEditor() and "Feature.Avatar.Action.ManageCharacters" or "Feature.Avatar.Label.Title.ManageAvatars"
	})(function(p7) -- line: 221
		-- upvalues: p6 (copy)
		return p6:renderLocalized(p7)
	end)
end

local function mapStateToProps(p8, _) -- line: 226
	-- upvalues: GetDuplicateOutfit (copy)
	return {
		duplicateOutfitId = GetDuplicateOutfit(p8),
		screenSize = p8.ScreenSize
	}
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(mapStateToProps, nil)(v23))))))
