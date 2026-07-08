local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local UIBlox = require(TrustedContactsParent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useScreenSize = require(TrustedContactsParent.RobloxAppHooks).useScreenSize
local FocusNavigationUtils = require(TrustedContactsParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local InputHandlers = require(TrustedContactsParent.InputHandlers)

require(TrustedContactsParent.ReactFocusNavigation)

local Responsive = require(TrustedContactsParent.Responsive)
local Foundation = require(TrustedContactsParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local FoundationText = Foundation.Text
local Button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local Sheet = Foundation.Sheet
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local OnCloseCallbackReason = Foundation.Enums.OnCloseCallbackReason
local Sources = require(TrustedContactsParent.SocialLuaAnalytics).Analytics.Enums.Sources
local SocialMetadataSection = require(TrustedContacts.Components.SocialMetadataSection)
local v32 = game:DefineFastInt("TCMountMinLoadingTimeMs", 0)
local v33 = game:DefineFastFlag("TCDialogCloseBtn", false)
local FFlagTCLearnMoreLink = require(TrustedContacts.Flags.FFlagTCLearnMoreLink)
local FFlagTrustedContactsModalFixFocusNavigation = require(TrustedContacts.Flags.FFlagTrustedContactsModalFixFocusNavigation)
local FFlagTCModalUseFoundationOverlay = require(TrustedContactsParent.SharedFlags).FFlagTCModalUseFoundationOverlay
local FFlagTrustedFriendsUseEnumCTA = require(TrustedContactsParent.SharedFlags).FFlagTrustedFriendsUseEnumCTA
local FFlagTrustedFriendsUseFoundationSheet = require(TrustedContactsParent.SharedFlags).FFlagTrustedFriendsUseFoundationSheet

require(script.Parent.useModalButtonActions)

return function(t1: {[any]: any}) -- line: 68
	-- upvalues: useLayerCollector (copy), useScreenSize (copy), Responsive (copy), FFlagTrustedContactsModalFixFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useFocusOnMount (copy), v32 (copy), useTokens (copy), Loading (copy), IconSize (copy), FFlagTrustedFriendsUseFoundationSheet (copy), Sheet (copy), FoundationText (copy), FFlagTCLearnMoreLink (copy), View (copy), SocialMetadataSection (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), FFlagTrustedFriendsUseEnumCTA (copy), Dialog (copy), DialogSize (copy), FFlagTCModalUseFoundationOverlay (copy), OnCloseCallbackReason (copy), v33 (copy), FullPageModal (copy), PartialPageModal (copy), ScrollView (copy), Foundation (copy), Sources (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local isVerticallyConstrained = t1.isVerticallyConstrained
	local v41 = useLayerCollector()
	local v42 = useScreenSize()
	local v43 = Responsive.useOrientation()
	local onCloseModal = t1.onCloseModal
	local v45 = if not FFlagTrustedContactsModalFixFocusNavigation then nil else React.useMemo(function() -- line: 76
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), onCloseModal (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 79
					-- upvalues: onCloseModal (copy)
					onCloseModal()
					p1:cancel()
				end)
			}
		}
	end, { onCloseModal })
	local v46 = if not FFlagTrustedContactsModalFixFocusNavigation then nil else useFocusOnMount()
	local v47 = v43 == Responsive.DefaultKey
	local v48, v49 = React.useState(v47)
	local v50 = React.useRef(os.clock())

	React.useEffect(function() -- line: 96
		-- upvalues: v47 (copy), v50 (copy), v32 (copy), v49 (copy)
		if not v47 then
			local v58 = os.clock() - v50.current
			local v59 = v32 / 1000

			if v58 < v59 then
				delay(v59 - v58, function() -- line: 102
					-- upvalues: v49 (copy)
					v49(false)
				end)

				return
			end

			v49(false)
		end
	end, {
		v47,
		v49
	})

	if v41 and (v41.absoluteSize and v41.absoluteSize ~= Vector2.new(0, 0)) then
		v42 = v41.absoluteSize
	end

	local v51 = v43 == Responsive.BreakpointConfig.Enum.Landscape
	local v52 = useTokens()

	if v48 then
		return React.createElement(Loading, {
			size = IconSize.Large,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	end

	local v53 = t1.modalButtonActions and t1.modalButtonActions[1] or nil
	local v54 = t1.modalButtonActions and t1.modalButtonActions[2] or nil
	local v55 = if not FFlagTrustedFriendsUseFoundationSheet then if not v51 then React.createElement(isVerticallyConstrained and FullPageModal or PartialPageModal, {
		title = t1.headerText,
		screenSize = v42,
		onCloseClicked = t1.onCloseModal
	}, {
		Contents = React.createElement(isVerticallyConstrained and ScrollView or View, {
			tag = {
				["col align-x-center size-full-0 auto-y"] = true,
				["shrink gap-medium"] = isVerticallyConstrained,
				["gap-large"] = not isVerticallyConstrained
			},
			scroll = isVerticallyConstrained and {
				scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			UIListLayout = if not FFlagTCLearnMoreLink then nil else React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			OuterPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, isVerticallyConstrained and v52.Padding.XSmall or v52.Padding.Large),
				PaddingBottom = UDim.new(0, isVerticallyConstrained and v52.Padding.Small or 0)
			}),
			TextIntro = if not FFlagTCLearnMoreLink then React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = {
					["size-full-0 auto-y text-wrap text-align-x-left"] = true,
					grow = not isVerticallyConstrained
				},
				Text = t1.descriptionText
			}) else React.createElement(View, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y",
				grow = not isVerticallyConstrained
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Text = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = {
						["size-full-0 auto-y text-wrap text-align-x-left"] = true,
						grow = not isVerticallyConstrained
					},
					Text = t1.descriptionText
				}),
				LearnMore = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-0 auto-xy text-wrap text-align-x-left",
					RichText = true,
					Text = `<u>{ t1.learnMoreText }</u>`,
					onActivated = t1.onLearnMoreClick
				})
			}),
			Insights = React.createElement(SocialMetadataSection, {
				layoutOrder = 2,
				userId = t1.userId,
				isVerticallyConstrained = isVerticallyConstrained
			}),
			ActionButtons = if not v53 and not v54 then nil else React.createElement(View, {
				LayoutOrder = 3,
				tag = "row gap-small size-full-0 auto-y padding-top-small"
			}, {
				First = v53 and React.createElement(Button, {
					LayoutOrder = 1,
					text = v53.text or "",
					onActivated = v53.onActivated,
					icon = v53.icon,
					isLoading = v53.isLoading,
					variant = ButtonVariant.Emphasis,
					fillBehavior = FillBehavior.Fill,
					ref = v46,
					isDisabled = if not FFlagTrustedFriendsUseEnumCTA then nil else v53.isDisabled
				}) or nil,
				Second = v54 and React.createElement(Button, {
					LayoutOrder = 2,
					text = v54.text or "",
					onActivated = v54.onActivated,
					icon = v54.icon,
					isLoading = v54.isLoading,
					variant = ButtonVariant.Standard,
					fillBehavior = FillBehavior.Fill,
					isDisabled = if not FFlagTrustedFriendsUseEnumCTA then nil else v54.isDisabled
				}) or nil
			})
		})
	}) else React.createElement(Dialog.Root, {
		size = DialogSize.Medium,
		onClose = if not FFlagTCModalUseFoundationOverlay then if not v33 then nil else t1.onCloseModal else function(p2) -- line: 205
			-- upvalues: OnCloseCallbackReason (copy), t1 (copy)
			if p2 == OnCloseCallbackReason.BackdropClick then
				return
			end

			t1.onCloseModal()
		end,
		hasBackdrop = not not FFlagTCModalUseFoundationOverlay or nil
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = t1.headerText
		}),
		Contents = React.createElement("ScrollingFrame", {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = isVerticallyConstrained and UDim2.new(1, -4, 0.3, 0) or UDim2.fromScale(1, 0),
			AutomaticSize = not isVerticallyConstrained and Enum.AutomaticSize.Y or nil,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = isVerticallyConstrained,
			ScrollBarThickness = if not FFlagTCModalUseFoundationOverlay or isVerticallyConstrained then nil else 0
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TextIntro = if not FFlagTCLearnMoreLink then React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y padding-bottom-large text-wrap text-align-x-left",
				Text = t1.descriptionText
			}) else React.createElement(View, {
				LayoutOrder = 1,
				tag = "col size-full-0 auto-y padding-bottom-large"
			}, {
				React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-wrap text-align-x-left",
					Text = t1.descriptionText
				}),
				LearnMore = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-0 auto-xy text-wrap text-align-x-left",
					RichText = true,
					Text = `<u>{ t1.learnMoreText }</u>`,
					onActivated = t1.onLearnMoreClick
				})
			}),
			Insights = React.createElement(SocialMetadataSection, {
				layoutOrder = 2,
				userId = t1.userId
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {
				if not v53 then nil else {
					variant = ButtonVariant.Emphasis,
					text = v53.text,
					onActivated = v53.onActivated,
					icon = v53.icon,
					isLoading = v53.isLoading,
					ref = v46,
					isDisabled = if not FFlagTrustedFriendsUseEnumCTA then nil else v53.isDisabled
				},
				if not v54 then nil else {
					variant = ButtonVariant.Standard,
					text = v54.text,
					onActivated = v54.onActivated,
					icon = v54.icon,
					isLoading = v54.isLoading,
					isDisabled = if not FFlagTrustedFriendsUseEnumCTA then nil else v54.isDisabled
				}
			}
		})
	}) else React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t1.onCloseModal
	}, {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small text-align-x-left content-default",
				Text = t1.headerText
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			TextIntro = if not FFlagTCLearnMoreLink then React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-wrap text-align-x-left",
				Text = t1.descriptionText
			}) else React.createElement(View, {
				LayoutOrder = 1,
				tag = "col gap-small size-full-0 auto-y"
			}, {
				Text = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-wrap text-align-x-left",
					Text = t1.descriptionText
				}),
				LearnMore = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-0 auto-xy text-wrap text-align-x-left",
					RichText = true,
					Text = `<u>{ t1.learnMoreText }</u>`,
					onActivated = t1.onLearnMoreClick
				})
			}),
			Insights = React.createElement(SocialMetadataSection, {
				layoutOrder = 2,
				userId = t1.userId,
				isVerticallyConstrained = isVerticallyConstrained
			})
		}),
		Actions = if not v53 and not v54 then nil else React.createElement(Sheet.Actions, nil, {
			First = v53 and React.createElement(Button, {
				LayoutOrder = 1,
				text = v53.text or "",
				onActivated = v53.onActivated,
				icon = v53.icon,
				isLoading = v53.isLoading,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				width = UDim.new(1, 0),
				ref = v46,
				isDisabled = if not FFlagTrustedFriendsUseEnumCTA then nil else v53.isDisabled
			}) or nil,
			Second = v54 and React.createElement(Button, {
				LayoutOrder = 2,
				text = v54.text or "",
				onActivated = v54.onActivated,
				icon = v54.icon,
				isLoading = v54.isLoading,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				width = UDim.new(1, 0),
				isDisabled = if not FFlagTrustedFriendsUseEnumCTA then nil else v54.isDisabled
			}) or nil
		})
	})
	local v56 = FFlagTCModalUseFoundationOverlay and v51
	local v57 = if FFlagTrustedFriendsUseFoundationSheet or not FFlagTCModalUseFoundationOverlay and t1.source ~= Sources.StreamNotification then v55 else React.createElement("TextButton", {
		Selectable = false,
		AutoButtonColor = false,
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v52.Color.Common.Scrim.Color3,
		BackgroundTransparency = if not v56 then v52.Color.Common.Scrim.Transparency else 1,
		ZIndex = if not FFlagTCModalUseFoundationOverlay then nil else 300
	}, {
		TrustedContactModalComponent = v55
	})

	if FFlagTrustedContactsModalFixFocusNavigation then
		return React.createElement(FocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			eventHandlers = v45
		}, {
			Modal = v57
		})
	end

	return v57
end
