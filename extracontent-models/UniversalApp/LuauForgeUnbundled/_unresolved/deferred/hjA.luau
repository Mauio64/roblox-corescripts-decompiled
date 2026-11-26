local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module = require("@luauforge/bundled/eie")
local UIBlox = require(CorePackages.Packages.UIBlox)

local module2 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module2.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/gJz")
local module4 = require("@luauforge/bundled/egx")

local module5 = require("@luauforge/deferred/gRz")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module6 = require("@luauforge/deferred/hjB")

local module7 = require("@luauforge/deferred/hjC")

local module8 = require("@luauforge/deferred/hbc")

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow

local images = UIBlox.App.ImageSet.Images
local actionBar = UIBlox.App.Button.ActionBar
local withStyle = UIBlox.Style.withStyle
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local iconsnavigationclose = images["icons/navigation/close"]

local updateOutfitsByButtonX = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.UpdateOutfit
}

local function useFocusNavigationBindings(p2, callback)
	local v5 = ReactFocusNavigation.useEventMap(updateOutfitsByButtonX, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.UpdateOutfit] = callback and {
				handler = InputHandlers.onRelease(function(p3)
					callback()
				end)
			} or nil
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local extended = Roact.PureComponent:extend("UpdateOutfitPage")

local strictInterface = t.strictInterface
local v5 = {
	focusNavigationRef = t.table,
	selectedOutfit = t.optional(t.string),
	setSelectedOutfit = t.callback,
	networking = 0,
	navigation = 0,
	avatarRoute = 0,
	avatarEditorAnalytics = 0,
	updateSavedOutfit = 0
}
local v6 = if fFlagAXModeratedItemsFlow then t.callback else nil
v5.networking = v6

v5.navigation = t.table
v5.avatarRoute = t.table

v5.avatarEditorAnalytics = t.table

v5.updateSavedOutfit = t.callback
extended.validateProps = strictInterface(v5)

function extended:init()
	self.exitButtonRef = Roact.createRef()
	self.gridViewRef = Roact.createRef()
	self.actionBarRef = Roact.createRef()

	function self.navigateBack()
		self.props.navigation.goBack()
	end

	function self.selectedOutfitUpdated(list)
		self.props.setSelectedOutfit(list[1] or nil)
	end

	function self.updateOutfit()
		local selectedOutfit = self.props.selectedOutfit

		if not selectedOutfit then
			return
		end

		if fFlagAXModeratedItemsFlow then
			self.props.updateSavedOutfit(
				self.props.avatarEditorAnalytics,
				selectedOutfit,
				self.props.networking
			)
		else
			self.props.updateSavedOutfit(self.props.avatarEditorAnalytics, selectedOutfit)
		end

		self.navigateBack()
	end

	function self.renderExitButton()
		return withStyle(function(p2)
			local theme = p2.Theme

			return Roact.createElement(iconButton, {
				size = UDim2.new(0, 44, 1, 0),
				icon = iconsnavigationclose,
				iconSize = iconSize.Medium,
				iconColor3 = theme.SystemPrimaryDefault.Color,
				iconTransparency = theme.SystemPrimaryDefault.Transparency,
				onActivated = self.navigateBack,
				buttonRef = self.exitButtonRef,
				NextSelectionDown = self.gridViewRef
			})
		end)
	end
end

function extended:renderWithProviders(p2, p3)
	local theme = p3.Theme
	local selectedOutfit = self.props.selectedOutfit

	local createElement = Roact.createElement
	local focusNavigationRefsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[Roact.Ref] = self.props.focusNavigationRef
	}

	local createElement2 = Roact.createElement
	local v10 = {
		headerBarProps = {
			title = p2.selectToUpdate,
			renderLeft = self.renderExitButton
		},
		onDismiss = self.navigateBack
	}
	local v11 = {
		OutfitSelectionGrid = Roact.createElement(module7, {
			selectedOutfits = { selectedOutfit },
			selectionUpdated = self.selectedOutfitUpdated,
			goBack = self.navigateBack,
			pageOwner = avatarScreen.UpdateOutfitPage,
			NextSelectionUp = self.exitButtonRef,
			NextSelectionDown = self.actionBarRef,
			[Roact.Ref] = self.gridViewRef
		}),
		ActionBarBackgroundGapFiller = 0,
		ActionBarContainer = 0
	}

	local v13 = if selectedOutfit ~= nil then Roact.createElement("Frame", {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 2
	}) or nil else nil
	v11.ActionBarBackgroundGapFiller = v13
	local v14

	if selectedOutfit ~= nil then
		v14 = Roact.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3 },
				{
					ActionBar = Roact.createElement(actionBar, {
						button = {
							props = {
								text = p2.update,
								onActivated = self.updateOutfit
							}
						},
						NextSelectionUp = self.gridViewRef,
						[Roact.Ref] = self.actionBarRef
					})
				}
			)
			or nil
	end

	v11.ActionBarContainer = v14
	return createElement("Frame", focusNavigationRefsByRef, {
		NavOverlayPageContainer = createElement2(module6, v10, v11)
	})
end

function extended:render()
	return withLocalization({
		selectToUpdate = "Feature.Avatar.Heading.SelectToUpdate",
		update = "Feature.Avatar.Action.Update"
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local v9 = roactServices.connect({
	avatarEditorAnalytics = module3,
	networking = if fFlagAXModeratedItemsFlow then module4 else nil
})(extended)

local function mapDispatchToProps(callback)
	return {
		updateSavedOutfit = function(p2, p3, p4)
			if fFlagAXModeratedItemsFlow then
				callback(module8(p2, p3, nil, nil, p4))
			else
				callback(module8(p2, p3))
			end
		end
	}
end

local v10 = module5((RoactRodux.connect(nil, mapDispatchToProps)(v9)))

return function(p2)
	local v11 = module(module3)
	local v12 = if fFlagAXModeratedItemsFlow then module(module4) else nil
	local v13 = useDispatch()
	local state, setState = React.useState(nil)

	local v14 = React.useCallback(function()
		if not state then
			return
		end

		if fFlagAXModeratedItemsFlow then
			v13(module8(v11, state, nil, nil, v12))
		else
			v13(module8(v11, state))
		end

		p2.navigation.goBack()
	end, { state, p2.navigation, v11, v12 })

	if not state then
		v14 = nil
	end

	local v18 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, v14)))

	return React.createElement(
		v10,
		Cryo.Dictionary.join(p2, {
			focusNavigationRef = v18,
			selectedOutfit = state,
			setSelectedOutfit = setState
		})
	)
end
