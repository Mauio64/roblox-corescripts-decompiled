local AdPlayer = script:FindFirstAncestor("AdPlayer")
local parent = AdPlayer.Parent
local React = require(parent.React)
local AdGuiInteractivity = require(parent.AdGuiInteractivity)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local Flags = require(AdPlayer.Flags)
local components = script:FindFirstAncestor("components")
local AdLabelComponent = require(components.AdLabelComponent)
local LinearProgressComponent = require(components.LinearProgressComponent)
local AdDropdownMenu = AdGuiInteractivity.AdDropdownMenu

local adDropdownButtonDefault = Flags.GetAdDropdownButtonDefault()
local adDropdownButtonOpen = Flags.GetAdDropdownButtonOpen()
local adPlayerExitButton = Flags.GetAdPlayerExitButton()

local rbxassetfontsfamiliesInconsolatajson = Font.new(
	"rbxasset://fonts/families/Inconsolata.json",
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal
)

local function ExitButtonComponent(p)
	local v = useTokens()

	return React.createElement(
		View,
		{
			tag = "size-900 radius-circle",
			backgroundStyle = v.Color.Common.Scrim,
			onActivated = p.showExitConfirmationModal
		},
		{
			icon = React.createElement(Image, {
				tag = "size-600 radius-circle position-center-center anchor-center-center",
				Image = adPlayerExitButton
			})
		}
	)
end

local function TimerComponent(p)
	return React.createElement(Text, {
		tag = "size-0-500 auto-x content-emphasis",
		LayoutOrder = 2,
		Text = p.alpha:map(function(p2)
			local v = math.ceil((1 - p2) * p.totalDuration)
			local v2 = v // 60
			local v3 = v % 60

			return string.format("%02i:%02i", v2, v3)
		end),
		fontStyle = { Font = rbxassetfontsfamiliesInconsolatajson, FontSize = 14 }
	})
end

local function ScrimComponent(p)
	local v = useTokens()

	local groupTransparency, v2 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		if p.showScrim then
			v2(ReactOtter.instant(0))

			return nil
		end

		local v3 = false
		task.delay(2, function()
			if not v3 then
				v2(ReactOtter.spring(1))
			end
		end)

		return function()
			v3 = true
		end
	end, { p.showScrim })

	local clone = table.clone(p.children or {})
	clone.scrim = React.createElement(View, {
		tag = "size-full",
		backgroundStyle = v.Color.Common.Scrim,
		ZIndex = -1
	})

	return React.createElement(View, {
		tag = "size-full",
		GroupTransparency = groupTransparency,
		ZIndex = 0
	}, clone)
end

local function TopContainer(p)
	return React.createElement(
		View,
		{
			tag = "size-full-1500 anchor-top-center position-top-center padding-x-medium padding-y-medium"
		},
		p.children
	)
end

local function BottomContainer(p)
	return React.createElement(
		View,
		{
			tag = "size-full-700 anchor-bottom-center padding-x-medium",
			Position = UDim2.new(0.5, 0, 1, -24)
		},
		p.children
	)
end

local function BottomContainerListContainer(p)
	return React.createElement(View, {
		tag = "size-full-500 row align-x-left align-y-center gap-medium"
	}, p.children)
end

return (React.forwardRef(function(props, p)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v = useTokens()

	local function dismissModals() -- 2 equivalent calls inferred from this helper
		props.setPaused(false)
		props.dismissModals()
		setState(false)
	end

	React.useImperativeHandle(p, function()
		return { dismissModals = dismissModals }
	end)

	React.useEffect(function()
		if state2 then
			setState2(false)
		end
	end, { state2 })

	local createElement = React.createElement
	local v2 = {
		tag = "size-full",
		onActivated = function()
			dismissModals() -- inferred equivalent call
			setState2(true)
		end,
		stateLayer = { affordance = StateLayerAffordance.None }
	}

	local createElement2 = React.createElement
	local v3 = {
		adDropdownMenu = React.createElement(AdDropdownMenu, {
			showDropDownMenu = state,
			onWhyThisAdActivated = props.showWhyThisAd,
			onReportAdActivated = props.showReportAdModal,
			transparency = 0.2,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromOffset(0, -v.Padding.Small)
		}),
		leftBottomListContainer = 0
	}

	local createElement3 = React.createElement
	local createElement4 = React.createElement
	local image

	if state then
		image = adDropdownButtonOpen
	else
		image = adDropdownButtonDefault
	end

	v3.leftBottomListContainer = createElement3(BottomContainerListContainer, {}, {
		adLabel = createElement4(AdLabelComponent, {
			Image = image,
			handleToggleAdsModal = function()
				dismissModals() -- inferred equivalent call

				if not state then
					props.setPaused(true)
					setState(true)
				end
			end
		})
	})
	return createElement(View, v2, {
		persistentBottom = createElement2(BottomContainer, {}, v3),
		scrim = React.createElement(ScrimComponent, {
			showScrim = state or props.parentModalOpen or state2
		}, {
			fadingBottom = React.createElement(BottomContainer, {}, {
				progressBar = React.createElement(LinearProgressComponent, {
					alpha = props.alpha,
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.fromScale(0.5, 1),
					AnchorPoint = Vector2.new(0.5, 1)
				}),
				bottomListContainer = React.createElement(BottomContainerListContainer, {}, {
					dummyAdLabel = React.createElement(AdLabelComponent, { Visible = false }),
					timer = React.createElement(TimerComponent, {
						alpha = props.alpha,
						totalDuration = props.totalDuration
					})
				})
			}),
			top = React.createElement(TopContainer, {}, {
				closeButton = React.createElement(ExitButtonComponent, {
					showExitConfirmationModal = props.showExitConfirmationModal
				})
			})
		})
	})
end))
