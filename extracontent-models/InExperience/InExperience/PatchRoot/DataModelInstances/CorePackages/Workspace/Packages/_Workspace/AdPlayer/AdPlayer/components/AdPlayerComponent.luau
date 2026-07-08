local RunService = game:GetService("RunService")
local AdPlayer = script:FindFirstAncestor("AdPlayer")
local AdPlayerParent = AdPlayer.Parent
local React = require(AdPlayerParent.React)
local Foundation = require(AdPlayerParent.Foundation)
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local ReportAdPopup = require(AdPlayerParent.AdGuiInteractivity).ReportAdPopup
local components = AdPlayer.components
local VideoOverlayComponent = require(components.VideoOverlayComponent)
local ExitConfirmationModalComponent = require(components.ExitConfirmationModalComponent)
local Flags = require(AdPlayer.Flags)
local v14 = table.freeze({
	Loading = 1,
	Paused = 2,
	Playing = 3
})

local function AdPlayerComponent(t1: {[any]: any}) -- line: 35
	-- upvalues: Flags (copy), useTokens (copy), React (copy), v14 (copy), RunService (copy), components (copy), View (copy), StateLayerAffordance (copy), ExitConfirmationModalComponent (copy), ReportAdPopup (copy), VideoOverlayComponent (copy)
	local v17 = Flags.GetEnableLuaRewardTimerUI()
	local v18 = useTokens()
	local v19, v20 = React.useState(0)
	local v21, v22 = React.useBinding(0)
	local u23 = nil
	local u24 = nil

	if v17 then
		local v25, v26 = React.useBinding(0)

		u23 = v25
		u24 = v26
	end

	local v27, v28 = React.useState(false)
	local v29, v30 = React.useState(false)
	local v31, v32 = React.useState(v14.Loading)
	local u33, u34

	if v17 then
		u33 = React.createRef()
		u34 = React.createRef()
	else
		u33 = React.useRef(nil)
		u34 = React.useRef(nil)
	end

	local durationNeededForReward = t1.durationNeededForReward

	local function dismissParentModals() -- line: 58
		-- upvalues: v28 (copy), v30 (copy)
		v28(false)
		v30(false)
	end
	local function dismissModals() -- line: 63
		-- upvalues: v28 (copy), v30 (copy), v17 (copy), u33 (ref)
		v28(false)
		v30(false)

		local v41 = if not v17 then u33:getValue() else u33.current

		if v41 then
			v41.dismissModals()
		end
	end

	React.useEffect(function() -- line: 78
		-- upvalues: v17 (copy), u34 (ref), v32 (copy), v14 (copy), v20 (copy), t1 (copy), RunService (copy), v22 (copy), durationNeededForReward (copy), u24 (ref)
		local u42 = if not v17 then u34:getValue() else u34.current

		if not u42.IsLoaded then
			u42.Loaded:Wait()
		end

		v32(v14.Playing)
		v20(u42.TimeLength)
		u42.Ended:Connect(t1.onComplete)

		local connection = RunService.RenderStepped:Connect(function() -- line: 93
			-- upvalues: u42 (ref), v22 (copy), v17 (copy), durationNeededForReward (copy), u24 (ref)
			if u42.TimeLength > 0 then
				v22(u42.TimePosition / u42.TimeLength)

				if v17 and durationNeededForReward then
					if durationNeededForReward == 0 then
						u24(1)

						return
					end

					u24((math.min(u42.TimePosition / durationNeededForReward, 1)))
				end
			end
		end)

		t1.onVideoFrameLoaded(u42)

		return function() -- line: 111
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v38 = v27 or v29
	local v39 = v31 == v14.Playing and not v38
	local v40 = nil

	if RunService:IsStudio() then
		v40 = React.createElement(require(components.TestAdDisclaimerComponent), {
			isEligible = t1.isEligible
		})
	end

	return React.createElement(View, {
		tag = "size-full",
		onActivated = function() -- line: 128
		end,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		backgroundStyle = v18.Color.Extended.Black.Black_100
	}, {
		videoFrame = React.createElement("VideoFrame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Video = t1.creativeAssetUrl,
			Playing = v39,
			Transparency = not v27 and 0 or 0.4,
			ref = u34
		}, {
			React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1.7777777777777777,
				AspectType = Enum.AspectType.FitWithinMaxSize
			}),
			testAdDisclaimer = v40,
			confirmExitModal = React.createElement(ExitConfirmationModalComponent, {
				Enabled = v27,
				onCancel = function() -- line: 152
					-- upvalues: v28 (copy)
					v28(false)
				end,
				onConfirm = t1.onCancel
			}),
			reportAdModal = React.createElement(ReportAdPopup, {
				showReportAdPopup = v29,
				onClose = function() -- line: 159
					-- upvalues: v30 (copy)
					v30(false)
				end,
				onOpen = function() -- line: 162
					-- upvalues: v30 (copy)
					v30(true)
				end,
				adInfo = t1.getReportAdInfo()
			}),
			videoOverlay = React.createElement(VideoOverlayComponent, {
				ref = u33,
				alpha = v21,
				totalDuration = v19,
				parentModalOpen = v38,
				rewardWaitTime = if not v17 then nil else durationNeededForReward,
				rewardWaitAlpha = if not v17 then nil else u23,
				dismissModals = dismissParentModals,
				parentPaused = not v39,
				showWhyThisAd = t1.showWhyThisAd,
				setPaused = function(p1) -- line: 177
					-- upvalues: v31 (copy), v14 (copy), v32 (copy)
					if v31 ~= v14.Loading then
						v32(if not p1 then v14.Playing else v14.Paused)
					end
				end,
				showReportAdModal = function() -- line: 182
					-- upvalues: v30 (copy)
					v30(true)
				end,
				showExitConfirmationModal = function() -- line: 185
					-- upvalues: Flags (copy), u23 (ref), t1 (copy), v28 (copy), v30 (copy), v17 (copy), u33 (ref)
					if Flags.GetEnableLuaRewardTimerUI() and u23:getValue() >= 1 then
						t1.onComplete()

						return
					end

					v28(false)
					v30(false)

					local v45 = if not v17 then u33:getValue() else u33.current

					if v45 then
						v45.dismissModals()
					end

					v28(true)
				end
			})
		})
	})
end

return AdPlayerComponent
