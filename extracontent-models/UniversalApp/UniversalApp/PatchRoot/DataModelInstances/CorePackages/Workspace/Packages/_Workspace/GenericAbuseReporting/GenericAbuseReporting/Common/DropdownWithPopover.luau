local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local CoreGui = game:GetService("CoreGui")
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local InputHandlers = require(GenericAbuseReportingParent.InputHandlers)
local React = require(GenericAbuseReportingParent.React)
local ReactFocusNavigation = require(GenericAbuseReportingParent.ReactFocusNavigation)
local UIBlox = require(GenericAbuseReportingParent.UIBlox)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local OverlayProvider = Foundation.OverlayProvider
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)
local useScrollbarOffset = require(GenericAbuseReporting.Common.useScrollbarOffset)

local function DropdownWithPopover(t1: {[any]: any}) -- line: 44
	-- upvalues: useLayerCollector (copy), useTokens (copy), React (copy), useScrollbarOffset (copy), ReactFocusNavigation (copy), CoreGui (copy), View (copy), FoundationText (copy), OverlayProvider (copy), Popover (copy), SideModalDropdownButton (copy), PopoverAlign (copy), PopoverSide (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local v27 = useLayerCollector()
	local v28 = useTokens()
	local absoluteSize = v27.absoluteSize
	local v30, v31 = React.useState(false)
	local v32, v33 = React.useState({})
	local v34, v35 = React.useState(Vector2.new(0, 0))
	local v36, v37 = React.useState(Vector2.new(0, 0))
	local v38, v39 = React.useState(Vector2.new(0, 0))
	local v40, v41 = React.useState(Vector2.new(0, 0))
	local v42 = useScrollbarOffset(v38, v40)
	local v43 = ReactFocusNavigation.useFocusGuiObject()
	local v44 = React.useRef(nil)
	local v45 = React.useRef(nil)
	local VRCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local v47 = if not VRCentralOverlay then nil else VRCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	local v48 = React.useCallback(function() -- line: 68
		-- upvalues: v47 (copy), v43 (copy), v44 (copy), v31 (copy)
		if not v47 then
			v43(v44.current)
		end

		v31(false)
	end, {
		v44.current,
		v43,
		v47
	})
	local v49 = React.useMemo(function() -- line: 76
		-- upvalues: t1 (copy), v33 (copy), v48 (copy), React (copy), View (copy), v32 (copy), FoundationText (copy)
		local t2 = {}

		for _, v in ipairs(t1.cellDatas) do
			table.insert(t2, React.createElement(View, {
				onActivated = function() -- line: 79
					-- upvalues: t1 (copy), v (copy), v33 (copy), v48 (copy)
					t1.onChange(if v.value ~= nil then v.value else v.text)
					v33(v)
					v48()
				end,
				selection = {
					Selectable = true
				},
				tag = {
					["size-full-0"] = true,
					["auto-y"] = true,
					["padding-small"] = true,
					["radius-medium"] = true,
					["bg-shift-200"] = v == v32
				}
			}, {
				TextContainer = React.createElement(View, {
					tag = "size-full-0 auto-y"
				}, {
					Text = React.createElement(FoundationText, {
						TextWrapped = true,
						tag = "auto-xy",
						Text = v.text,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			}))
		end

		return t2
	end, {
		t1.cellDatas,
		v32,
		t1.onChange,
		v48
	})
	local v50 = React.useCallback(function() -- line: 116
		-- upvalues: v31 (copy), v30 (copy)
		v31(not v30)
	end, { v30 })

	return React.createElement(OverlayProvider, {
		gui = v47
	}, {
		DropdownWithPopover = React.createElement(View, {
			tag = "size-full-0 auto-y",
			ref = v44,
			onAbsoluteSizeChanged = function(p1) -- line: 126
				-- upvalues: v35 (copy)
				v35(p1.AbsoluteSize)
			end,
			LayoutOrder = t1.layoutOrder
		}, {
			Popover = React.createElement(Popover.Root, {
				isOpen = v30
			}, {
				Anchor = React.createElement(Popover.Anchor, nil, React.createElement(View, {
					Size = UDim2.new(0, v34.X, 0, v34.Y)
				}, {
					DropdownButton = React.createElement(SideModalDropdownButton, {
						onActivated = v50,
						text = if not v32.text or not (#v32.text > 0) then t1.placeholder else v32.text,
						isDropdownError = t1.errorState
					})
				})),
				Content = React.createElement(Popover.Content, {
					hasArrow = false,
					align = PopoverAlign.Center,
					side = PopoverSide.Bottom,
					onPressedOutside = v48,
					selection = {
						Selectable = true
					}
				}, {
					DropdownPopup = React.createElement(View, {
						tag = "auto-xy"
					}, {
						AppFocusRoot = React.createElement(AppFocusRoot, {
							surfaceIdentifier = if not v30 then FocusNavigableSurfaceIdentifierEnum.PopUp else FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
							isIsolated = v30,
							customEventHandlers = {
								[FocusNavigationEventNameEnum.NavigateBack] = {
									handler = InputHandlers.onRelease(v48)
								}
							}
						}, { React.createElement(ScrollView, {
							gradientHeight = 15,
							Size = UDim2.new(0, math.min(absoluteSize.X, v36.X + v42), 0, (math.min(absoluteSize.Y, v36.Y))),
							scroll = {
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								CanvasSize = UDim2.new(1, 0, 0, 0),
								ScrollingDirection = Enum.ScrollingDirection.Y,
								scrollBarVisibility = ScrollBarVisibility.Always
							},
							onAbsoluteCanvasSizeChanged = function(p2) -- line: 194
								-- upvalues: v39 (copy)
								v39(p2.AbsoluteCanvasSize)
							end,
							onAbsoluteWindowSizeChanged = function(p3) -- line: 197
								-- upvalues: v41 (copy)
								v41(p3.AbsoluteWindowSize)
							end
						}, {
							BaseMenu = React.createElement(View, {
								tag = "auto-y col align-y-center gap-xsmall padding-xsmall",
								Size = UDim2.new(0, v34.X + v28.Stroke.Standard * 2, 0, 0),
								onAbsoluteSizeChanged = function(p4) -- line: 204
									-- upvalues: v37 (copy)
									v37(p4.AbsoluteSize)
								end,
								ref = v45
							}, v49)
						}) })
					})
				})
			})
		})
	})
end

return React.memo(DropdownWithPopover)
