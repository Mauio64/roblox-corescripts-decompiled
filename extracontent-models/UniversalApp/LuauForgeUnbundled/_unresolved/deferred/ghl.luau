local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module = require("@luauforge/bundled/dTM")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
require("@luauforge/bundled/dHK")

local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local focusable = RoactGamepad.Focusable

local module2 = require("@luauforge/deferred/gfc")

local module3 = require("@luauforge/deferred/gfb")
local module4 = require("@luauforge/bundled/geT")

local module5 = require("@luauforge/deferred/ghm")
local ItemsList = require("@game/CoreGui/RobloxGui/Modules/AvatarEditorPrompts/Components/ItemsList")

local module7 = require("@luauforge/bundled/dwC")
local setCurrentToastMessage = module7.Actions.SetCurrentToastMessage
local toastType = module7.Enums.ToastType

local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics

local fFlagAXAddManageOutfitClickTracking = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAddManageOutfitClickTracking

local fFlagAXCharacterToAvatarStrings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCharacterToAvatarStrings

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation

local v5 = {
	toastMessage = "Feature.Avatar.Message.AvatarDeleted",
	isLocalized = false,
	toastType = toastType.SuccessConfirmation
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.MultiAvatarDeleted",
	isLocalized = false,
	ToastType = toastType.SuccessConfirmation
}

local extended = Roact.PureComponent:extend("DeleteOutfitPrompt")

extended.validateProps = t.strictInterface({
	outfitIds = t.array(t.string),
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	avatarEditorAnalytics = t.table,
	navigation = t.table,
	outfitInfos = t.table,
	screenSize = t.Vector2,
	deleteOutfit = t.callback,
	setCurrentToastMessage = t.optional(t.callback)
})

local v7 = memoize(function(items, p2)
	local names = {}

	for k, item in items do
		if p2[item] then
			table.insert(names, p2[item].name)
		end
	end

	return names
end)

function extended:init()
	self.mounted = false

	self:setState({
		maxContentSize = 10000,
		itemListScrollable = false,
		isDeleting = false
	})

	self.middleContentRef = Roact.createRef()

	function self.closePrompt()
		module.closeOverlay(self.props.navigation)
	end

	function self.deleteOutfits()
		local v8 = {}

		for k, outfitId in self.props.outfitIds do
			v8[k] = self.props.deleteOutfit(outfitId)
		end

		self:setState({ isDeleting = true })

		if fFlagAXAddManageOutfitClickTracking then
			slotBasedEditorAnalytics.trackDeleteAvatarConfirm()
		end

		Promise.all(v8):andThen(function()
			if #self.props.outfitIds > 1 then
				self.props.setCurrentToastMessage(v6)
			else
				self.props.setCurrentToastMessage(v5)
			end

			if self.mounted then
				self.closePrompt()
			end
		end):catch(function(p2)
			self:setState({ isDeleting = false })
		end)
	end

	function self.itemListScrollableUpdated(p2)
		if self.state.itemListScrollable ~= p2 then
			self:setState({ itemListScrollable = p2 })
		end
	end

	function self.renderAlertMiddleContent()
		local v8 = v7(self.props.outfitIds, self.props.outfitInfos)

		return Roact.createElement(ItemsList, {
			items = v8,
			maxHeight = self.state.maxContentSize,
			onScrollableUpdated = self.itemListScrollableUpdated,
			[Roact.Ref] = self.middleContentRef
		})
	end

	function self.onAbsoluteSizeChanged(p2)
		local value = self.middleContentRef:getValue()

		if not value then
			return
		end

		local v8 = self.props.screenSize.Y - 60
		local y = value.AbsoluteSize.Y
		local v9 = v8 - (p2.AbsoluteSize.Y - y)

		if self.state.maxContentSize ~= v9 then
			self:setState({ maxContentSize = v9 })
		end
	end
end

function extended:renderLocalized(props2)
	local v8 = props2.deleteSingleCharacter
	local v9 = props2.singleNoLongerAvailable
	local renderAlertMiddleContent, itemListScrollable, onAbsoluteSizeChanged

	if #self.props.outfitIds > 1 then
		v8 = props2.deleteAssets
		v9 = props2.multiNoLongerAvailable

		if not fFlagAXCharacterToAvatarStrings then
			renderAlertMiddleContent = self.renderAlertMiddleContent
		end

		itemListScrollable = self.state.itemListScrollable
		onAbsoluteSizeChanged = self.onAbsoluteSizeChanged
	end

	local v11 = {
		props = { onActivated = self.closePrompt, text = props2.cancelButtonText },
		isDefaultChild = true
	}

	local v13 = if fFlagAXCharacterToAvatarStrings then buttonType.PrimaryContextual else buttonType.PrimarySystem
	local v10 = {
		v11,
		{
			buttonType = v13,
			props = {
				isLoading = self.state.isDeleting,
				onActivated = self.deleteOutfits,
				text = props2.confirmButtonText
			}
		}
	}

	return Roact.createElement(focusable.TextButton, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Selectable = false,
		[Roact.Event.Activated] = self.closePrompt,
		[Roact.Ref] = self.props.focusNavigationRef,
		inputBindings = not fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.closePrompt),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} or nil
	}, {
		Alert = Roact.createElement(interactiveAlert, {
			title = v8,
			bodyText = v9,
			buttonStackInfo = { buttons = v10 },
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = self.props.screenSize,
			defaultChildRef = self.props.defaultChildRef,
			middleContent = renderAlertMiddleContent,
			isMiddleContentFocusable = itemListScrollable,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		})
	})
end

function extended:render()
	local v8 = fFlagAXCharacterToAvatarStrings and (self.props.outfitIds and #self.props.outfitIds or 0)
		or nil

	return withLocalization({
		deleteSingleCharacter = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Title.DeleteSingleAvatar" or "Feature.Avatar.Heading.DeleteCharacter",
		singleNoLongerAvailable = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Message.DeleteAvatars" or "Feature.Avatar.Label.NoLongerAvailableInCollection",
		deleteAssets = fFlagAXCharacterToAvatarStrings and {
			"Feature.Avatar.Label.Title.DeleteMultipleAvatars",
			count = v8
		} or "Feature.Avatar.Heading.DeleteAssets",
		multiNoLongerAvailable = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Message.DeleteAvatars" or "Feature.Avatar.Label.MultiNoLongerAvailableInCollection",
		confirmButtonText = "Feature.Avatar.Action.Delete",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})(function(p2)
		return self:renderLocalized(p2)
	end)
end

function extended:didMount()
	self.mounted = true
end

function extended:willUnmount()
	self.mounted = false
end

local function mapStateToProps(p2, p3)
	return {
		outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos,
		screenSize = p2.ScreenSize
	}
end

local function mapDispatchToProps(callback)
	return {
		deleteOutfit = function(p2)
			callback(module5(p2))
		end,
		setCurrentToastMessage = function(p2)
			callback(setCurrentToastMessage(p2))
		end
	}
end

local v8 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return (module3((module2((roactServices.connect({ avatarEditorAnalytics = module4 })(v8))))))
