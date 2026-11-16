local RunService = game:GetService("RunService")

local AdPlayer = script:FindFirstAncestor("AdPlayer")
local parent = AdPlayer.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local AdGuiInteractivity = require(parent.AdGuiInteractivity)
local ReportAdPopup = AdGuiInteractivity.ReportAdPopup
local components = AdPlayer.components
local VideoOverlayComponent = require(components.VideoOverlayComponent)
local ExitConfirmationModalComponent = require(components.ExitConfirmationModalComponent)

local frozen = table.freeze({ Loading = 1, Paused = 2, Playing = 3 })

local function AdPlayerComponent(props)
	local v = useTokens()
	local state, setState = React.useState(0)
	local alpha, v2 = React.useBinding(0)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(frozen.Loading)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local function dismissParentModals() -- 1 equivalent call inferred from this helper
		setState2(false)
		setState3(false)
	end

	local function dismissModals() -- 1 equivalent call inferred from this helper
		dismissParentModals() -- inferred equivalent call
		local value = ref:getValue()

		if value then
			value.dismissModals()
		end
	end

	React.useEffect(function()
		local value = ref2:getValue()

		if not value.IsLoaded then
			value.Loaded:Wait()
		end

		setState4(frozen.Playing)
		setState(value.TimeLength)
		value.Ended:Connect(props.onComplete)

		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			if value.TimeLength > 0 then
				v2(value.TimePosition / value.TimeLength)
			end
		end)

		props.onVideoFrameLoaded(value)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, {})

	local parentModalOpen = state2 or state3
	local playing

	if state4 == frozen.Playing then
		playing = not parentModalOpen
	else
		playing = false
	end

	local testAdDisclaimer

	if RunService:IsStudio() then
		local createElement = React.createElement
		local TestAdDisclaimerComponent = require(components.TestAdDisclaimerComponent)
		testAdDisclaimer = createElement(TestAdDisclaimerComponent, {
			isEligible = props.isEligible
		})
	end

	return React.createElement(View, {
		tag = "size-full",
		onActivated = function() end,
		stateLayer = { affordance = StateLayerAffordance.None },
		backgroundStyle = v.Color.Extended.Black.Black_100
	}, {
		videoFrame = React.createElement("VideoFrame", {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Video = props.creativeAssetUrl,
			Playing = playing,
			BorderSizePixel = 0,
			Transparency = state2 and 0.4 or 0,
			ref = ref2
		}, {
			React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 16 / 9,
				AspectType = Enum.AspectType.FitWithinMaxSize
			}),
			testAdDisclaimer = testAdDisclaimer,
			confirmExitModal = React.createElement(ExitConfirmationModalComponent, {
				Enabled = state2,
				onCancel = function()
					setState2(false)
				end,
				onConfirm = props.onCancel
			}),
			reportAdModal = React.createElement(ReportAdPopup, {
				showReportAdPopup = state3,
				onClose = function()
					setState3(false)
				end,
				onOpen = function()
					setState3(true)
				end,
				adInfo = props.getReportAdInfo()
			}),
			videoOverlay = React.createElement(VideoOverlayComponent, {
				ref = ref,
				alpha = alpha,
				totalDuration = state,
				parentModalOpen = parentModalOpen,
				dismissModals = dismissParentModals,
				parentPaused = not playing,
				showWhyThisAd = props.showWhyThisAd,
				setPaused = function(p)
					if state4 ~= frozen.Loading then
						local v3

						if p then
							v3 = frozen.Paused
						else
							v3 = frozen.Playing
						end

						setState4(v3)
					end
				end,
				showReportAdModal = function()
					setState3(true)
				end,
				showExitConfirmationModal = function()
					dismissModals() -- inferred equivalent call
					setState2(true)
				end
			})
		})
	})
end

return AdPlayerComponent
