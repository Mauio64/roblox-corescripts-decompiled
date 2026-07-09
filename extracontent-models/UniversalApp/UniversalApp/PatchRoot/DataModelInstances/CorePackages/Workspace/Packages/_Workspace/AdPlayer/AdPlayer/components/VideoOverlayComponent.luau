local AdPlayer = script:FindFirstAncestor("AdPlayer")
local AdPlayerParent = AdPlayer.Parent
local React = require(AdPlayerParent.React)
local AdGuiInteractivity = require(AdPlayerParent.AdGuiInteractivity)
local ReactOtter = require(AdPlayerParent.ReactOtter)
local Foundation = require(AdPlayerParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local Flags = require(AdPlayer.Flags)
local components = script:FindFirstAncestor("components")
local AdLabelComponent = require(components.AdLabelComponent)
local LinearProgressComponent = require(components.LinearProgressComponent)
local AdDropdownMenu = AdGuiInteractivity.AdDropdownMenu
local GetRewardInComponent = require(components.GetRewardInComponent)
local v18 = Flags.GetAdDropdownButtonDefault()
local v19 = Flags.GetAdDropdownButtonOpen()
local v20 = Flags.GetAdPlayerExitButton()
local font = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local function ExitButtonComponent(p1) -- line: 30
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationImage (copy), v20 (copy)
	local v29 = useTokens()

	return React.createElement(View, {
		tag = "size-900 radius-circle",
		backgroundStyle = v29.Color.Common.Scrim,
		onActivated = p1.showExitConfirmationModal
	}, {
		icon = React.createElement(FoundationImage, {
			tag = "size-600 radius-circle position-center-center anchor-center-center",
			Image = v20
		})
	})
end
local function TimerComponent(p2) -- line: 45
	-- upvalues: React (copy), FoundationText (copy), font (copy)
	return React.createElement(FoundationText, {
		tag = "size-0-500 auto-x content-emphasis",
		LayoutOrder = 2,
		Text = p2.alpha:map(function(p3) -- line: 49
			-- upvalues: p2 (copy)
			local v49 = math.ceil((1 - p3) * p2.totalDuration)
			local v50 = v49 // 60
			local v51 = v49 % 60

			return string.format("%02i:%02i", v50, v51)
		end),
		fontStyle = {
			FontSize = 14,
			Font = font
		}
	})
end
local function ScrimComponent(p4) -- line: 63
	-- upvalues: useTokens (copy), ReactOtter (copy), React (copy), View (copy)
	local v32 = useTokens()
	local v33, v34 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 67
		-- upvalues: p4 (copy), v34 (copy), ReactOtter (copy)
		if p4.showScrim then
			v34(ReactOtter.instant(0))

			return nil
		end

		local u52 = false

		task.delay(2, function() -- line: 72
			-- upvalues: u52 (ref), v34 (copy), ReactOtter (copy)
			if not u52 then
				v34(ReactOtter.spring(1))
			end
		end)

		return function() -- line: 78
			-- upvalues: u52 (ref)
			u52 = true
		end
	end, { p4.showScrim })

	local v35 = table.clone(p4.children or {})

	v35.scrim = React.createElement(View, {
		tag = "size-full",
		ZIndex = -1,
		backgroundStyle = v32.Color.Common.Scrim
	})

	return React.createElement(View, {
		tag = "size-full",
		ZIndex = 0,
		GroupTransparency = v33
	}, v35)
end
local function TopContainer(p5) -- line: 100
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full-1500 anchor-top-center position-top-center padding-x-medium padding-y-medium"
	}, p5.children)
end
local function BottomContainer(p6) -- line: 106
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full-700 anchor-bottom-center padding-x-medium",
		Position = UDim2.new(0.5, 0, 1, -24)
	}, p6.children)
end
local function BottomContainerListContainer(t1: {[any]: any}) -- line: 113
	-- upvalues: Flags (copy), React (copy), View (copy)
	local v39 = not Flags.GetEnableLuaRewardTimerUI() and "size-full-500 row align-x-left align-y-center gap-medium" or `size-full-500 row { not t1.isRightAligned and "align-x-left" or "align-x-right" } align-y-bottom gap-medium`

	return React.createElement(View, {
		Position = if not Flags.GetEnableLuaRewardTimerUI() then nil else UDim2.fromOffset(0, t1.yOffset or 0),
		tag = v39
	}, t1.children)
end

return (React.forwardRef(function(t2: {[any]: any}, p7) -- line: 142
	-- upvalues: React (copy), useTokens (copy), View (copy), StateLayerAffordance (copy), BottomContainer (copy), AdDropdownMenu (copy), BottomContainerListContainer (copy), AdLabelComponent (copy), v19 (copy), v18 (copy), Flags (copy), GetRewardInComponent (copy), ScrimComponent (copy), LinearProgressComponent (copy), TimerComponent (copy), TopContainer (copy), ExitButtonComponent (copy)
	local v42, v43 = React.useState(false)
	local v44, v45 = React.useState(false)
	local v46 = useTokens()

	local function dismissModals() -- line: 147
		-- upvalues: t2 (copy), v43 (copy)
		t2.setPaused(false)
		t2.dismissModals()
		v43(false)
	end

	React.useImperativeHandle(p7, function() -- line: 162
		-- upvalues: dismissModals (copy)
		return {
			dismissModals = dismissModals
		}
	end)
	React.useEffect(function() -- line: 168
		-- upvalues: v44 (copy), v45 (copy)
		if v44 then
			v45(false)
		end
	end, { v44 })

	return React.createElement(View, {
		tag = "size-full",
		onActivated = function() -- line: 176
			-- upvalues: t2 (copy), v43 (copy), v45 (copy)
			t2.setPaused(false)
			t2.dismissModals()
			v43(false)
			v45(true)
		end,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		persistentBottom = React.createElement(BottomContainer, {}, {
			adDropdownMenu = React.createElement(AdDropdownMenu, {
				transparency = 0.2,
				showDropDownMenu = v42,
				onWhyThisAdActivated = t2.showWhyThisAd,
				onReportAdActivated = t2.showReportAdModal,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromOffset(0, -v46.Padding.Small)
			}),
			leftBottomListContainer = React.createElement(BottomContainerListContainer, {}, {
				adLabel = React.createElement(AdLabelComponent, {
					Image = if not v42 then v18 else v19,
					handleToggleAdsModal = function() -- line: 153
						-- upvalues: t2 (copy), v43 (copy), v42 (copy)
						t2.setPaused(false)
						t2.dismissModals()
						v43(false)

						if not v42 then
							t2.setPaused(true)
							v43(true)
						end
					end
				})
			}),
			rightBottomListContainer = if not Flags.GetEnableLuaRewardTimerUI() then nil else React.createElement(BottomContainerListContainer, {
				isRightAligned = true,
				yOffset = -4
			}, {
				getRewardInComponent = if not t2.rewardWaitTime then nil else React.createElement(GetRewardInComponent, {
					rewardWaitTime = t2.rewardWaitTime,
					rewardWaitAlpha = t2.rewardWaitAlpha
				})
			})
		}),
		scrim = React.createElement(ScrimComponent, {
			showScrim = v42 or (t2.parentModalOpen or v44)
		}, {
			fadingBottom = React.createElement(BottomContainer, {}, {
				progressBar = React.createElement(LinearProgressComponent, {
					alpha = t2.alpha,
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.fromScale(0.5, 1),
					AnchorPoint = Vector2.new(0.5, 1)
				}),
				bottomListContainer = React.createElement(BottomContainerListContainer, {}, {
					dummyAdLabel = React.createElement(AdLabelComponent, {
						Visible = false
					}),
					timer = React.createElement(TimerComponent, {
						alpha = t2.alpha,
						totalDuration = t2.totalDuration
					})
				})
			}),
			top = React.createElement(TopContainer, {}, {
				closeButton = React.createElement(ExitButtonComponent, {
					showExitConfirmationModal = t2.showExitConfirmationModal
				})
			})
		})
	})
end))
