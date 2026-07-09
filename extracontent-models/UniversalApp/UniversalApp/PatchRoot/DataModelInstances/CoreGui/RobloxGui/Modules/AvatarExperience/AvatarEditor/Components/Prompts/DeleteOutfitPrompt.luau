local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Focusable = RoactGamepad.Focusable
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local DeleteOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.DeleteOutfit)
local ItemsBulletList = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.ItemsBulletList)
local ToastRodux = require(CorePackages.Workspace.Packages.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local ToastType = ToastRodux.Enums.ToastType
local SlotBasedEditorAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics
local FFlagAXAddManageOutfitClickTracking = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAddManageOutfitClickTracking
local FFlagAXCharacterToAvatarStrings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCharacterToAvatarStrings
local FFlagAXUpdateSlotBasedEditorToastAndPrompts = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUpdateSlotBasedEditorToastAndPrompts
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXFixDeselectOutfitInManage = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixDeselectOutfitInManage
local t1 = {
	toastMessage = "Feature.Avatar.Message.AvatarDeleted",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.Avatar.Message.MultiAvatarDeleted",
	isLocalized = false,
	ToastType = ToastType.SuccessConfirmation
}
local v32 = Roact.PureComponent:extend("DeleteOutfitPrompt")

v32.validateProps = t.strictInterface({
	outfitIds = t.array(t.string),
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	avatarEditorAnalytics = t.table,
	navigation = t.table,
	outfitInfos = t.table,
	screenSize = t.Vector2,
	deleteOutfit = t.callback,
	setCurrentToastMessage = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else t.optional(t.callback)
})

local v33 = memoize(function(t3: {[any]: any}, p1) -- line: 94
	local t4 = {}

	for _, v41 in t3 do
		if p1[v41] then
			table.insert(t4, p1[v41].name)
		end
	end

	return t4
end)

function v32.init(p2) -- line: 105
	-- upvalues: Roact (copy), NavigationUtils (copy), FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), Promise (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), t2 (copy), t1 (copy), v33 (copy), ItemsBulletList (copy)
	p2.mounted = false
	p2:setState({
		maxContentSize = 10000,
		itemListScrollable = false,
		isDeleting = false
	})
	p2.middleContentRef = Roact.createRef()

	function p2.closePrompt() -- line: 116
		-- upvalues: NavigationUtils (copy), p2 (copy)
		NavigationUtils.closeOverlay(p2.props.navigation)
	end
	function p2.deleteOutfits() -- line: 120
		-- upvalues: p2 (copy), FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), Promise (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), t2 (copy), t1 (copy)
		local t5 = {}

		for v59, v60 in p2.props.outfitIds do
			t5[v59] = p2.props.deleteOutfit(v60)
		end

		p2:setState({
			isDeleting = true
		})

		if FFlagAXAddManageOutfitClickTracking then
			SlotBasedEditorAnalytics.trackDeleteAvatarConfirm()
		end

		Promise.all(t5):andThen(function() -- line: 135
			-- upvalues: FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), p2 (copy), t2 (copy), t1 (copy)
			if FFlagAXUpdateSlotBasedEditorToastAndPrompts then
				if #p2.props.outfitIds > 1 then
					p2.props.setCurrentToastMessage(t2)
				else
					p2.props.setCurrentToastMessage(t1)
				end
			end

			if p2.mounted then
				p2.closePrompt()
			end
		end):catch(function(_) -- line: 147
			-- upvalues: p2 (copy)
			p2:setState({
				isDeleting = false
			})
		end)
	end
	function p2.itemListScrollableUpdated(p4) -- line: 154
		-- upvalues: p2 (copy)
		if p4 ~= p2.state.itemListScrollable then
			p2:setState({
				itemListScrollable = p4
			})
		end
	end
	function p2.renderAlertMiddleContent() -- line: 162
		-- upvalues: v33 (copy), p2 (copy), Roact (copy), ItemsBulletList (copy)
		local v62 = v33(p2.props.outfitIds, p2.props.outfitInfos)

		return Roact.createElement(ItemsBulletList, {
			items = v62,
			maxHeight = p2.state.maxContentSize,
			onScrollableUpdated = p2.itemListScrollableUpdated,
			[Roact.Ref] = p2.middleContentRef
		})
	end
	function p2.onAbsoluteSizeChanged(p5) -- line: 173
		-- upvalues: p2 (copy)
		local v64 = p2.middleContentRef:getValue()

		if not v64 then
			return
		end

		local v65 = p2.props.screenSize.Y - 60
		local AbsoluteSizeY = v64.AbsoluteSize.Y
		local v67 = v65 - (p5.AbsoluteSize.Y - AbsoluteSizeY)

		if v67 ~= p2.state.maxContentSize then
			p2:setState({
				maxContentSize = v67
			})
		end
	end
end
function v32.renderLocalized(p6, p7) -- line: 194
	-- upvalues: FFlagAXCharacterToAvatarStrings (copy), ButtonType (copy), Roact (copy), FFlagAXFixDeselectOutfitInManage (copy), Focusable (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), RoactGamepad (copy), InteractiveAlert (copy)
	local deleteSingleCharacter = p7.deleteSingleCharacter
	local singleNoLongerAvailable = p7.singleNoLongerAvailable
	local v47 = nil
	local itemListScrollable = nil
	local onAbsoluteSizeChanged = nil

	if #p6.props.outfitIds > 1 then
		deleteSingleCharacter = p7.deleteAssets
		singleNoLongerAvailable = p7.multiNoLongerAvailable
		v47 = if not FFlagAXCharacterToAvatarStrings then p6.renderAlertMiddleContent else nil
		itemListScrollable = p6.state.itemListScrollable
		onAbsoluteSizeChanged = p6.onAbsoluteSizeChanged
	end

	local t6 = {
		{
			isDefaultChild = true,
			props = {
				onActivated = p6.closePrompt,
				text = p7.cancelButtonText
			}
		},
		{
			buttonType = if not FFlagAXCharacterToAvatarStrings then ButtonType.PrimarySystem else ButtonType.PrimaryContextual,
			props = {
				isLoading = p6.state.isDeleting,
				onActivated = p6.deleteOutfits,
				text = p7.confirmButtonText
			}
		}
	}

	return Roact.createElement(if not FFlagAXFixDeselectOutfitInManage then Focusable.Frame else Focusable.TextButton, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = not FFlagAXFixDeselectOutfitInManage and nil,
		Text = if not FFlagAXFixDeselectOutfitInManage then nil else "",
		Selectable = not FFlagAXFixDeselectOutfitInManage and nil,
		[Roact.Event.Activated] = if not FFlagAXFixDeselectOutfitInManage then nil else p6.closePrompt,
		[Roact.Ref] = p6.props.focusNavigationRef,
		inputBindings = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p6.closePrompt),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 243
			end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} else nil
	}, {
		Alert = Roact.createElement(InteractiveAlert, {
			title = deleteSingleCharacter,
			bodyText = singleNoLongerAvailable,
			buttonStackInfo = {
				buttons = t6
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = p6.props.screenSize,
			defaultChildRef = p6.props.defaultChildRef,
			middleContent = v47,
			isMiddleContentFocusable = itemListScrollable,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		})
	})
end
function v32.render(p8) -- line: 264
	-- upvalues: FFlagAXCharacterToAvatarStrings (copy), withLocalization (copy)
	local v52 = if not FFlagAXCharacterToAvatarStrings then nil else not p8.props.outfitIds and 0 or #p8.props.outfitIds

	return withLocalization({
		confirmButtonText = "Feature.Avatar.Action.Delete",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		deleteSingleCharacter = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Heading.DeleteCharacter" or "Feature.Avatar.Label.Title.DeleteSingleAvatar",
		singleNoLongerAvailable = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.NoLongerAvailableInCollection" or "Feature.Avatar.Label.Message.DeleteAvatars",
		deleteAssets = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Heading.DeleteAssets" or {
			"Feature.Avatar.Label.Title.DeleteMultipleAvatars",
			count = v52
		},
		multiNoLongerAvailable = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.MultiNoLongerAvailableInCollection" or "Feature.Avatar.Label.Message.DeleteAvatars"
	})(function(p9) -- line: 287
		-- upvalues: p8 (copy)
		return p8:renderLocalized(p9)
	end)
end
function v32.didMount(p10) -- line: 292
	p10.mounted = true
end
function v32.willUnmount(p11) -- line: 296
	p11.mounted = false
end

local function mapStateToProps(p12, _) -- line: 300
	return {
		outfitInfos = p12.AvatarExperience.AvatarEditor.OutfitInfos,
		screenSize = p12.ScreenSize
	}
end
local function mapDispatchToProps(p14) -- line: 307
	-- upvalues: DeleteOutfit (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), SetCurrentToastMessage (copy)
	return {
		deleteOutfit = function(p15) -- line: 309
			-- upvalues: p14 (copy), DeleteOutfit (copy)
			p14(DeleteOutfit(p15))
		end,
		setCurrentToastMessage = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else function(p16) -- line: 313
			-- upvalues: p14 (copy), SetCurrentToastMessage (copy)
			p14(SetCurrentToastMessage(p16))
		end
	}
end

local v36 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v32)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	avatarEditorAnalytics = Analytics
})(v36))))))
