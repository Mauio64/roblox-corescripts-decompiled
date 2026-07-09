local CoreGui = game:GetService("CoreGui")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withStyle = UIBlox.Style.withStyle
local Interactable = UIBlox.Core.Control.Interactable
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local useCategoryButtonTooltip = require(Modules.AvatarExperience.Common.Components.NavBar.useCategoryButtonTooltip)
local NewItemNotification = require(Modules.AvatarExperience.Common.Components.NavBar.NewItemNotification)
local AXTooltip = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AXTooltip
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXCatalogHeadCategoryCombineIXP = require(Modules.AvatarExperience.Experiments.AXCatalogHeadCategoryCombineIXP)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local FFlagAXAddHDCatalogTooltip = AvatarExperienceFlags.FFlagAXAddHDCatalogTooltip
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local debounce = require(Modules.LuaApp.Util.debounce)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local EnumsRadius = Foundation.Enums.Radius
local v39 = Roact.PureComponent:extend("CategoryButton")

function v39.renderButtonChild(p1, p2, p3, p4, p5, p6) -- line: 64
	-- upvalues: Text (copy), FFlagAXCatalogCategoriesSDUI (copy), Roact (copy), Focusable (copy), Interactable (copy), CursorKind (copy), NewItemNotification (copy)
	local p3Font = p3.Font
	local Theme = p3.Theme
	local isSelected = p1.props.isSelected
	local Header2Font = p3Font.Header2.Font
	local v50 = p3Font.BaseSize * p3Font.Header2.RelativeSize
	local v51 = Text.GetTextWidth(if not FFlagAXCatalogCategoriesSDUI or not p1.props.localizedCategoryTitle then p2.title else p1.props.localizedCategoryTitle, Header2Font, v50)
	local v52 = isSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
	local v53 = isSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency
	local v54 = v51 + 20
	local hasNewItemNotification = p1.props.hasNewItemNotification
	local forwardRef = p1.props.forwardRef
	local frameRef = p1.props.frameRef

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, v54, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = p1.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = p5,
		[Roact.Change.AbsolutePosition] = function(p7) -- line: 100
			-- upvalues: p1 (copy), p6 (copy)
			if p1.delayedSetReadyToShowTooltip then
				p1.delayedSetReadyToShowTooltip()
			end

			if p6 then
				p6(p7)
			end
		end,
		[Roact.Ref] = frameRef
	}, {
		Button = Roact.createElement(Focusable[Interactable], {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[Roact.Event.Activated] = p1.onActivated,
			[Roact.Ref] = forwardRef,
			NextSelectionLeft = p1.props.NextSelectionLeft,
			NextSelectionRight = p1.props.NextSelectionRight,
			NextSelectionUp = p1.props.NextSelectionUp,
			NextSelectionDown = p1.props.NextSelectionDown,
			SelectionImageObject = p4(CursorKind.NavHighlight)
		}, Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = if not FFlagAXCatalogCategoriesSDUI or not p1.props.localizedCategoryTitle then p2.title else p1.props.localizedCategoryTitle,
			TextSize = v50,
			TextColor3 = v52,
			TextTransparency = v53,
			Font = Header2Font,
			Size = UDim2.new(1, 0, 1, 0)
		})),
		NewItemNotification = hasNewItemNotification and Roact.createElement(NewItemNotification, {
			isSelected = isSelected
		})
	})
end
function v39.tryDismissTooltip(p8) -- line: 150
	local readyToShowTooltipFromTimestamp = p8.state.readyToShowTooltipFromTimestamp

	if not readyToShowTooltipFromTimestamp or p8.state.isTooltipDismissed then
		return
	end

	if os.difftime(os.time(), readyToShowTooltipFromTimestamp) < 3 then
		return
	end

	if p8.props.onTooltipDismiss then
		p8.props.onTooltipDismiss()
	end

	p8:setState({
		isTooltipDismissed = true
	})
end
function v39.renderButtonWithTooltip(p9, p10, p11, p12) -- line: 170
	-- upvalues: withTooltip (copy), TooltipOrientation (copy), CoreGui (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	return withTooltip({
		useLargeDropShadow = true,
		bodyText = p9.props.tooltipTitle
	}, {
		DisplayOrder = 100,
		triggerPointName = `{ p9.props.categoryName }-Tooltip`,
		preferredOrientation = TooltipOrientation.Bottom,
		guiTarget = CoreGui,
		active = not p9.props.isHidden and (p9.state.readyToShowTooltipFromTimestamp and not p9.state.isTooltipDismissed)
	}, function(p13) -- line: 182
		-- upvalues: Roact (copy), p9 (copy), p10 (copy), p11 (copy), p12 (copy), ExternalEventConnection (copy), UserInputService (copy)
		return Roact.createFragment({
			CategoryButton = p9:renderButtonChild(p10, p11, p12, p13, p13),
			OnInputBegan = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputBegan,
				callback = function() -- line: 193
					-- upvalues: p9 (copy)
					p9:tryDismissTooltip()
				end
			})
		})
	end)
end
function v39.renderWithLocalized(p14, p15) -- line: 201
	-- upvalues: Text (copy), FFlagAXCatalogCategoriesSDUI (copy), withSelectionCursorProvider (copy), FFlagAXMigrateCategoryTooltip (copy), Roact (copy), Popover (copy), Focusable (copy), Interactable (copy), CursorKind (copy), NewItemNotification (copy), PopoverAlign (copy), PopoverSide (copy), EnumsRadius (copy), Foundation (copy), AXCatalogHeadCategoryCombineIXP (copy), AXTooltip (copy), FFlagAXAddHDCatalogTooltip (copy), withStyle (copy)
	return withStyle(function(p16) -- line: 202
		-- upvalues: p14 (copy), Text (copy), FFlagAXCatalogCategoriesSDUI (copy), p15 (copy), withSelectionCursorProvider (copy), FFlagAXMigrateCategoryTooltip (copy), Roact (copy), Popover (copy), Focusable (copy), Interactable (copy), CursorKind (copy), NewItemNotification (copy), PopoverAlign (copy), PopoverSide (copy), EnumsRadius (copy), Foundation (copy), AXCatalogHeadCategoryCombineIXP (copy), AXTooltip (copy), FFlagAXAddHDCatalogTooltip (copy)
		local p16Font = p16.Font
		local Theme = p16.Theme
		local isSelected = p14.props.isSelected
		local Header2Font = p16Font.Header2.Font
		local v86 = p16Font.BaseSize * p16Font.Header2.RelativeSize
		local v87 = Text.GetTextWidth(if not FFlagAXCatalogCategoriesSDUI or not p14.props.localizedCategoryTitle then p15.title else p14.props.localizedCategoryTitle, Header2Font, v86)
		local v88 = isSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
		local v89 = isSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency
		local v90 = v87 + 20
		local hasNewItemNotification = p14.props.hasNewItemNotification
		local forwardRef = p14.props.forwardRef
		local frameRef = p14.props.frameRef

		return withSelectionCursorProvider(function(p17) -- line: 227
			-- upvalues: FFlagAXMigrateCategoryTooltip (copy), p14 (copy), Roact (copy), v90 (copy), frameRef (copy), Popover (copy), Focusable (copy), Interactable (copy), forwardRef (copy), CursorKind (copy), FFlagAXCatalogCategoriesSDUI (copy), p15 (copy), v86 (copy), v88 (copy), v89 (copy), Header2Font (copy), hasNewItemNotification (copy), NewItemNotification (copy), isSelected (copy), PopoverAlign (copy), PopoverSide (copy), EnumsRadius (copy), Foundation (copy), AXCatalogHeadCategoryCombineIXP (copy), p16 (copy), AXTooltip (copy), FFlagAXAddHDCatalogTooltip (copy)
			if not FFlagAXMigrateCategoryTooltip and p14.props.tooltipOpen then
				return Roact.createElement("Frame", {
					Size = UDim2.new(0, v90, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = p14.props.layoutOrder,
					[Roact.Ref] = frameRef
				}, Roact.createElement(Popover.Root, {
					isOpen = true
				}, {
					Anchor = Roact.createElement(Popover.Anchor, nil, {
						Button = Roact.createElement(Focusable[Interactable], {
							AnchorPoint = Vector2.new(0, 0),
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(0, v90, 0, p14.props.navBarHeight),
							BackgroundTransparency = 1,
							[Roact.Event.Activated] = p14.onActivated,
							ref = forwardRef,
							NextSelectionLeft = p14.props.NextSelectionLeft,
							NextSelectionRight = p14.props.NextSelectionRight,
							NextSelectionUp = p14.props.NextSelectionUp,
							NextSelectionDown = p14.props.NextSelectionDown,
							SelectionImageObject = p17(CursorKind.NavHighlight)
						}, Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = if not FFlagAXCatalogCategoriesSDUI or not p14.props.localizedCategoryTitle then p15.title else p14.props.localizedCategoryTitle,
							TextSize = v86,
							TextColor3 = v88,
							TextTransparency = v89,
							Font = Header2Font,
							Size = UDim2.new(1, 0, 1, 0)
						})),
						NewItemNotification = hasNewItemNotification and Roact.createElement(NewItemNotification, {
							isSelected = isSelected
						})
					}),
					Content = Roact.createElement(Popover.Content, {
						align = PopoverAlign.Center,
						side = PopoverSide.Top,
						backgroundStyle = p14.props.foundationTokens.Color.System.Contrast,
						radius = EnumsRadius.Medium
					}, { Roact.createElement(Foundation.View, {
						tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
					}, {
						CategoryButtonTooltipTitle = Roact.createElement(Foundation.Text, {
							tag = "auto-xy text-title-medium content-inverse-emphasis",
							Text = p15.tooltipTitle
						}, {
							TooltipOverlayButton = Roact.createElement("TextButton", {
								Transparency = 1,
								[Roact.Event.Activated] = p14.props.tooltipActivated,
								Size = UDim2.fromScale(1, 1)
							})
						})
					}) })
				}))
			end

			if AXCatalogHeadCategoryCombineIXP.isEnabled() and p14.enableHeadCategoryCombine and p14.props.tooltipTitle and not p14.props.isSpatial then
				return p14:renderButtonWithTooltip(p15, p16, p17)
			end

			return Roact.createElement("Frame", {
				Size = UDim2.new(0, v90, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = p14.props.layoutOrder,
				[Roact.Ref] = frameRef
			}, {
				Button = Roact.createElement(Focusable[Interactable], {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p14.onActivated,
					[Roact.Ref] = forwardRef,
					NextSelectionLeft = p14.props.NextSelectionLeft,
					NextSelectionRight = p14.props.NextSelectionRight,
					NextSelectionUp = p14.props.NextSelectionUp,
					NextSelectionDown = p14.props.NextSelectionDown,
					SelectionImageObject = p17(CursorKind.NavHighlight)
				}, {
					AXTooltip = FFlagAXMigrateCategoryTooltip and Roact.createElement(AXTooltip, {
						popoverSide = not FFlagAXAddHDCatalogTooltip and "Top" or p14.props.popoverSide,
						tooltipLocalizationKey = p14.props.categoryTooltipLocalizationKey,
						tooltipStorageKey = p14.props.categoryTooltipKey or "",
						dismissTooltipRef = p14.props.dismissTooltipRef,
						showTooltip = p14.props.showTooltip,
						localizedText = if not FFlagAXCatalogCategoriesSDUI then nil else p14.props.categoryLocalizedTooltipBody
					}),
					Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = if not FFlagAXCatalogCategoriesSDUI or not p14.props.localizedCategoryTitle then p15.title else p14.props.localizedCategoryTitle,
						TextSize = v86,
						TextColor3 = v88,
						TextTransparency = v89,
						Font = Header2Font,
						Size = UDim2.new(1, 0, 1, 0)
					})
				}),
				NewItemNotification = hasNewItemNotification and Roact.createElement(NewItemNotification, {
					isSelected = isSelected
				})
			})
		end)
	end)
end
function v39.render(p18) -- line: 367
	-- upvalues: withLocalization (copy), FFlagAXCatalogCategoriesSDUI (copy)
	return withLocalization({
		title = if not FFlagAXCatalogCategoriesSDUI or not p18.props.localizedCategoryTitle then p18.props.categoryTitle else nil,
		tooltipTitle = p18.props.tooltipText
	})(function(p19) -- line: 373
		-- upvalues: p18 (copy)
		return p18:renderWithLocalized(p19)
	end)
end
function v39.init(p20) -- line: 378
	-- upvalues: AXCatalogHeadCategoryCombineIXP (copy), IxpUtils (copy), debounce (copy), FFlagAXMigrateCategoryTooltip (copy)
	if AXCatalogHeadCategoryCombineIXP.isEnabled() then
		p20.enableHeadCategoryCombine = IxpUtils.readTestVariable(AXCatalogHeadCategoryCombineIXP.EnableHeadCategoryCombination)
		p20.state = {
			readyToShowTooltipFromTimestamp = nil,
			isTooltipDismissed = false
		}
		p20.delayedSetReadyToShowTooltip = debounce(function() -- line: 389
			-- upvalues: p20 (copy)
			if p20.state.readyToShowTooltipFromTimestamp then
				return
			end

			p20:setState({
				readyToShowTooltipFromTimestamp = os.time()
			})
		end, 0.5)
	end

	function p20.onActivated() -- line: 398
		-- upvalues: FFlagAXMigrateCategoryTooltip (copy), p20 (copy)
		if FFlagAXMigrateCategoryTooltip and p20.props.dismissTooltipRef.current then
			p20.props.dismissTooltipRef.current()
		end

		if p20.props.shouldUseCategoryId then
			p20.props.onActivate(p20.props.categoryId)

			return
		end

		p20.props.onActivate(p20.props.categoryIndex)
	end
end

return Roact.forwardRef(function(p21, p22) -- line: 412
	-- upvalues: useIsSpatial (copy), FFlagAXAddHDCatalogTooltip (copy), useSelector (copy), selectIsPortrait (copy), FFlagAXMigrateCategoryTooltip (copy), useCategoryButtonTooltip (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), FFlagAXCatalogCategoryTooltip (copy), useTokens (copy), Roact (copy), FFlagAXCatalogCategoriesSDUI (copy), v39 (copy), Cryo (copy)
	local v70 = useIsSpatial()
	local v71 = if not FFlagAXAddHDCatalogTooltip then nil else useSelector(selectIsPortrait)
	local v72 = nil
	local v73 = nil
	local v74 = nil
	local v75 = nil

	if not FFlagAXMigrateCategoryTooltip then
		v72, v73, v75 = useCategoryButtonTooltip(if not FFlagAXRemoveCatalogCategoryNavKey then p21.navigationKey else p21.categoryId, p21.avatarScreenOfOrigin, if not FFlagAXCatalogCategoryTooltip then nil else p21.categoryTooltipKey)
		v74 = useTokens()
	end

	local v76 = nil
	local v77 = nil

	if FFlagAXMigrateCategoryTooltip then
		v76 = Roact.createRef()
		v77 = p21.categoryTooltipKey ~= nil and p21.categoryTooltipLocalizationKey ~= nil

		if FFlagAXCatalogCategoriesSDUI then
			v77 = v77 and (p21.categoryLocalizedTooltipBody ~= nil or p21.categoryTooltipLocalizationKey ~= nil)
		end
	end

	local v78 = not FFlagAXAddHDCatalogTooltip and "Top" or (not v71 and "Bottom" or "Top")

	return Roact.createElement(v39, Cryo.Dictionary.join(p21, {
		forwardRef = p22,
		isSpatial = v70,
		tooltipOpen = if FFlagAXMigrateCategoryTooltip then nil else v72,
		tooltipActivated = if FFlagAXMigrateCategoryTooltip then nil else v73,
		foundationTokens = if FFlagAXMigrateCategoryTooltip then nil else v74,
		tooltipText = if FFlagAXMigrateCategoryTooltip then nil else v75,
		dismissTooltipRef = if not FFlagAXMigrateCategoryTooltip then nil else v76,
		showTooltip = if not FFlagAXMigrateCategoryTooltip then nil else v77,
		popoverSide = if not FFlagAXAddHDCatalogTooltip then nil else v78
	}))
end)
