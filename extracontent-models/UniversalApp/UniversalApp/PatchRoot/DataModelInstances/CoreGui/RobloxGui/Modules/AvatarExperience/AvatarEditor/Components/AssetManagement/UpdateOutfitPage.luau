local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local NavOverlayPageContainer = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.NavOverlayPageContainer)
local OutfitSelectionGrid = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitSelectionGrid)
local UpdateSavedOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.UpdateSavedOutfit)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local Images = UIBlox.App.ImageSet.Images
local ActionBar = UIBlox.App.Button.ActionBar
local withStyle = UIBlox.Style.withStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Focusable = RoactGamepad.Focusable
local v35 = Images["icons/navigation/close"]
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.UpdateOutfit
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)?) -- line: 65
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v44 = ReactFocusNavigation.useEventMap(t1, p1)
	local v45 = React.useMemo(function() -- line: 67
		-- upvalues: FocusNavigationEventNameEnum (copy), p2 (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.UpdateOutfit] = if not p2 then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 71
					-- upvalues: p2 (copy)
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v45, v44)
end

local v38 = Roact.PureComponent:extend("UpdateOutfitPage")

v38.validateProps = t.strictInterface({
	focusNavigationRef = t.table,
	selectedOutfit = t.optional(t.string),
	setSelectedOutfit = t.callback,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.optional(t.table) else nil,
	networking = if not FFlagAXModeratedItemsFlow then nil else t.callback,
	navigation = t.table,
	avatarRoute = t.table,
	avatarEditorAnalytics = t.table,
	updateSavedOutfit = t.callback
})

function v38.init(p4) -- line: 101
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), Roact (copy), FFlagAXModeratedItemsFlow (copy), withStyle (copy), IconButton (copy), v35 (copy), IconSize (copy)
	p4.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p4.props.focusController or RoactGamepad.createFocusController() else nil
	p4.exitButtonRef = Roact.createRef()
	p4.gridViewRef = Roact.createRef()
	p4.actionBarRef = Roact.createRef()

	function p4.navigateBack() -- line: 110
		-- upvalues: p4 (copy)
		p4.props.navigation.goBack()
	end
	function p4.selectedOutfitUpdated(p5) -- line: 114
		-- upvalues: p4 (copy)
		p4.props.setSelectedOutfit(p5[1] or nil)
	end
	function p4.updateOutfit() -- line: 118
		-- upvalues: p4 (copy), FFlagAXModeratedItemsFlow (copy)
		local selectedOutfit = p4.props.selectedOutfit

		if not selectedOutfit then
			return
		end

		if FFlagAXModeratedItemsFlow then
			p4.props.updateSavedOutfit(p4.props.avatarEditorAnalytics, selectedOutfit, p4.props.networking)
		else
			p4.props.updateSavedOutfit(p4.props.avatarEditorAnalytics, selectedOutfit)
		end

		p4.navigateBack()
	end
	function p4.renderExitButton() -- line: 134
		-- upvalues: withStyle (copy), Roact (copy), IconButton (copy), v35 (copy), IconSize (copy), p4 (copy)
		return withStyle(function(p6) -- line: 135
			-- upvalues: Roact (copy), IconButton (copy), v35 (copy), IconSize (copy), p4 (copy)
			local Theme = p6.Theme

			return Roact.createElement(IconButton, {
				size = UDim2.new(0, 44, 1, 0),
				icon = v35,
				iconSize = IconSize.Medium,
				iconColor3 = Theme.SystemPrimaryDefault.Color,
				iconTransparency = Theme.SystemPrimaryDefault.Transparency,
				onActivated = p4.navigateBack,
				buttonRef = p4.exitButtonRef,
				NextSelectionDown = p4.gridViewRef
			})
		end)
	end
end
function v38.renderWithProviders(p7, p8, p9) -- line: 152
	-- upvalues: Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), BoundInputsUpdater (copy), NavOverlayPageContainer (copy), OutfitSelectionGrid (copy), AvatarScreen (copy), ActionBar (copy)
	local Theme = p9.Theme
	local selectedOutfit = p7.props.selectedOutfit

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p7.focusController else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p7.gridViewRef else nil,
		[Roact.Ref] = p7.props.focusNavigationRef
	}, {
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil,
		NavOverlayPageContainer = Roact.createElement(NavOverlayPageContainer, {
			headerBarProps = {
				title = p8.selectToUpdate,
				renderLeft = p7.renderExitButton
			},
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p7.focusController else nil,
			onDismiss = p7.navigateBack
		}, {
			OutfitSelectionGrid = Roact.createElement(OutfitSelectionGrid, {
				selectedOutfits = { selectedOutfit },
				selectionUpdated = p7.selectedOutfitUpdated,
				goBack = p7.navigateBack,
				pageOwner = AvatarScreen.UpdateOutfitPage,
				NextSelectionUp = p7.exitButtonRef,
				NextSelectionDown = p7.actionBarRef,
				[Roact.Ref] = p7.gridViewRef
			}),
			ActionBarBackgroundGapFiller = selectedOutfit ~= nil and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1, 0, 0, 48)
			}) or nil,
			ActionBarContainer = selectedOutfit ~= nil and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 3,
				Size = UDim2.fromScale(1, 1)
			}, {
				ActionBar = Roact.createElement(ActionBar, {
					button = {
						props = {
							text = p8.update,
							onActivated = p7.updateOutfit
						}
					},
					NextSelectionUp = p7.gridViewRef,
					[Roact.Ref] = p7.actionBarRef
				})
			}) or nil
		})
	})
end
function v38.render(p10) -- line: 217
	-- upvalues: withLocalization (copy), withStyle (copy)
	return withLocalization({
		selectToUpdate = "Feature.Avatar.Heading.SelectToUpdate",
		update = "Feature.Avatar.Action.Update"
	})(function(p11) -- line: 221
		-- upvalues: withStyle (copy), p10 (copy)
		return withStyle(function(p12) -- line: 222
			-- upvalues: p10 (copy), p11 (copy)
			return p10:renderWithProviders(p11, p12)
		end)
	end)
end

local v39 = RoactServices.connect({
	avatarEditorAnalytics = Analytics,
	networking = if not FFlagAXModeratedItemsFlow then nil else RoactNetworking
})(v38)

local function mapDispatchToProps(p13) -- line: 233
	-- upvalues: FFlagAXModeratedItemsFlow (copy), UpdateSavedOutfit (copy)
	return {
		updateSavedOutfit = function(p14, p15, p16) -- line: 235
			-- upvalues: FFlagAXModeratedItemsFlow (copy), p13 (copy), UpdateSavedOutfit (copy)
			if FFlagAXModeratedItemsFlow then
				p13(UpdateSavedOutfit(p14, p15, nil, nil, p16))

				return
			end

			p13(UpdateSavedOutfit(p14, p15))
		end
	}
end

local u41 = withStackVisibilityWrapper((RoactRodux.connect(nil, mapDispatchToProps)(v39)))

return function(p17) -- line: 249
	-- upvalues: useRoactService (copy), Analytics (copy), FFlagAXModeratedItemsFlow (copy), RoactNetworking (copy), useDispatch (copy), React (copy), UpdateSavedOutfit (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), u41 (ref), Cryo (copy)
	local v55 = useRoactService(Analytics)
	local v56 = if not FFlagAXModeratedItemsFlow then nil else useRoactService(RoactNetworking)
	local v57 = useDispatch()
	local v58, v59 = React.useState(nil)
	local v60 = React.useCallback(function() -- line: 255
		-- upvalues: v58 (copy), FFlagAXModeratedItemsFlow (copy), v57 (copy), UpdateSavedOutfit (copy), v55 (copy), v56 (copy), p17 (copy)
		if not v58 then
			return
		end

		if FFlagAXModeratedItemsFlow then
			v57(UpdateSavedOutfit(v55, v58, nil, nil, v56))
		else
			v57(UpdateSavedOutfit(v55, v58))
		end

		p17.navigation.goBack()
	end, {
		v58,
		p17.navigation,
		v55,
		v56
	})
	local v61 = useFocusNavigationBindings(nil, if not v58 then nil else v60)
	local v62 = useTableWrappedCallbackRef(v61)

	return React.createElement(u41, Cryo.Dictionary.join(p17, {
		focusNavigationRef = v62,
		selectedOutfit = v58,
		setSelectedOutfit = v59
	}))
end
