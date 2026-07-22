local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ComboButton = UIBlox.App.Button.ComboButton
local Images = UIBlox.App.ImageSet.Images
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Foundation = require(Parent.Foundation)
local Button2 = Foundation.Button
local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius

require(Parent.GameProductInfoRodux)

local PlayButtonStates = require(script.Parent.PlayButtonStates)
local SharedFlags = require(Parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = SharedFlags.FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local FFlagLuaAppJoinTextPlayableButton = SharedFlags.FFlagLuaAppJoinTextPlayableButton
local FFlagLuaAppIconPlayButton = SharedFlags.FFlagLuaAppIconPlayButton
local FFlagLuaAppPlayButtonLoadingSkeleton = SharedFlags.FFlagLuaAppPlayButtonLoadingSkeleton
local FFlagUpdateActionNeededPlayButtonUi = SharedFlags.FFlagUpdateActionNeededPlayButtonUi
local FFlagLuaAppUnifiedPlayButtonSquadMenuDirection = SharedFlags.FFlagLuaAppUnifiedPlayButtonSquadMenuDirection
local GetFFlagUIBloxUseFoundationButton = SharedFlags.UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppPlayButtonOptOutFoundationButton = SharedFlags.FFlagLuaAppPlayButtonOptOutFoundationButton
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagLuaAppTextOnlyPlayButton = SharedFlags.FFlagLuaAppTextOnlyPlayButton
local FFlagLuaAppIconTextPlayButton = SharedFlags.FFlagLuaAppIconTextPlayButton
local FFlagLuaAppUpdatePlayButtonText = SharedFlags.FFlagLuaAppUpdatePlayButtonText
local FFlagLuaAppUseTokenHeightForPlayButton = SharedFlags.FFlagLuaAppUseTokenHeightForPlayButton
local FFlagLuaAppDemoModePlayButton = SharedFlags.FFlagLuaAppDemoModePlayButton
local v34 = if not FFlagLuaAppIconPlayButton then nil else "play-xlarge"
local v35 = Images["icons/common/play"]
local v36 = Images["icons/actions/truncationCollapse"]
local v37 = Images["icons/actions/truncationExpand"]

local function v38() -- line: 56
end

local v39 = if not FFlagLuaAppDemoModePlayButton then {
	[InputSize.XSmall] = "Size_600",
	[InputSize.Small] = "Size_800",
	[InputSize.Medium] = "Size_1000",
	[InputSize.Large] = "Size_1200"
} else require(script.Parent.ButtonHeightSizeKeyByInputSize)

local function PlayButtonView(t1: {[any]: any}) -- line: 112
	-- upvalues: InputSize (copy), FFlagLuaAppUseTokenHeightForPlayButton (copy), v39 (copy), FillBehavior (copy), PlayButtonStates (copy), FFlagLuaAppPlayButtonLoadingSkeleton (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), React (copy), Skeleton (copy), EnumsRadius (copy), ButtonVariant (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppJoinTextPlayableButton (copy), FFlagLuaAppUpdatePlayButtonText (copy), v34 (copy), FFlagLuaAppIconPlayButton (copy), GetFFlagIsSquadEnabled (copy), v35 (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagUpdateActionNeededPlayButtonUi (copy), ComboButton (copy), FFlagLuaAppUnifiedPlayButtonSquadMenuDirection (copy), MenuDirection (copy), v37 (copy), v36 (copy), ButtonType (copy), Images (copy), Button (copy), v38 (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy), IconButton (copy), Button2 (copy), FFlagSduiExperienceDetailsSupport (copy)
	local tokens = t1.tokens
	local playButtonState = t1.playButtonState
	local localized = t1.localized
	local v45 = false
	local v46 = false
	local v47 = false
	local v48 = t1.buttonSize or InputSize.Medium
	local v49 = nil

	if FFlagLuaAppUseTokenHeightForPlayButton then
		local v50 = v39[v48] or "Size_1000"

		v49 = (not tokens or not tokens.Size[v50]) and 40 or tokens.Size[v50]
	end

	local v51 = if not t1.width then t1.fillBehavior else FillBehavior.Fill
	local Emphasis = nil
	local v53 = nil
	local v54 = nil
	local v55 = nil
	local v56 = nil

	if playButtonState == PlayButtonStates.Loading then
		if t1.hideIfLoading then
			return nil
		end

		if FFlagLuaAppPlayButtonLoadingSkeleton and (not t1.useUIBloxButton and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or t1.hasPlayButtonLoadingSkeletonIxp)) then
			local v57

			if FFlagLuaAppUseTokenHeightForPlayButton then
				v57 = v49
			else
				local v58 = v39[v48] or "Size_1000"

				v57 = tokens and tokens.Size[v58]
			end

			v56 = if v51 ~= "Fill" then UDim.new(0, v57) else UDim.new(1, 0)

			local uDim2 = UDim2.new(v56, UDim.new(0, v57))
			local v60 = FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or (t1.shouldLaunchWhenLoading or t1.shouldLaunchOnReleaseAfterUnmount)
			local v61 = React.createElement(Skeleton, {
				ZIndex = 2,
				Size = if not v60 then uDim2 else UDim2.fromScale(1, 1),
				radius = EnumsRadius.Medium
			})

			v55 = if not v60 then v61 else React.createElement("TextButton", {
				Size = uDim2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = t1.loadingCaptureRef,
				[React.Event.Activated] = t1.onPlayButtonActivated
			}, {
				Skeleton = v61
			})
			v47 = true
		end

		Emphasis = ButtonVariant.Emphasis
	elseif playButtonState == PlayButtonStates.Playable then
		Emphasis = ButtonVariant.Emphasis

		if FFlagLuaAppIconTextPlayButton or (FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppJoinTextPlayableButton and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or t1.hasJoinTextPlayableButtonIxp)) then
			v54 = t1.playableText or if not FFlagLuaAppUpdatePlayButtonText then localized.join else localized.play

			if FFlagLuaAppIconTextPlayButton and not t1.hidePlayableIcon then
				v53 = v34
			end
		else
			if not FFlagLuaAppIconPlayButton and not t1.hidePlayableIcon then
				v53 = "icons/common/play"
			end

			v54 = t1.playableText

			if FFlagLuaAppIconPlayButton and not t1.hidePlayableIcon then
				v53 = if not v54 or v54 == "" then v34 else "icons/common/play"
			end
		end
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		v53 = v35
		v54 = if not t1.hideOptionalText then localized.joinWithParty else nil
		v45 = true
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		v53 = v35
		v54 = if not t1.hideOptionalText then localized.waitingForParty else nil
		v47 = true
		v46 = true
		v45 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		v54 = tostring(t1.gameProductInfo and t1.gameProductInfo.price or 0)
		Emphasis = ButtonVariant.Emphasis
		v53 = "icons/common/robux"
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		Emphasis = ButtonVariant.Emphasis

		local v62 = t1.gameProductInfo and t1.gameProductInfo.localizedFiatPrice or ""

		v54 = t1.fiatText or v62
	elseif FFlagLuaAppDemoModePlayButton and playButtonState == PlayButtonStates.DemoMode then
		Emphasis = ButtonVariant.SubEmphasis
		v54 = localized.playDemo
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		if FFlagUpdateActionNeededPlayButtonUi then
			Emphasis = ButtonVariant.Emphasis
			v54 = localized.unlock
		else
			Emphasis = ButtonVariant.SubEmphasis
			v53 = "icons/status/private"
			v54 = if not t1.hideOptionalText then localized.join else nil
		end
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		if t1.hideIfUnplayable then
			return nil
		end

		Emphasis = ButtonVariant.Subtle
		v53 = "icons/status/unavailable"
		v54 = if not t1.hideOptionalText then localized.unavailable else nil
		v47 = true
	else
		error("invalid play button state!")
	end

	local v64

	if v45 then
		if not FFlagLuaAppUseTokenHeightForPlayButton then
			local v63 = v39[v48] or "Size_1000"

			v49 = (not tokens or not tokens.Size[v63]) and 40 or tokens.Size[v63]
		end

		v64 = React.createElement(ComboButton, {
			size = UDim2.new(1, 0, 0, v49),
			button = {
				icon = v53,
				text = v54,
				isDisabled = v47,
				onActivated = v47 and function() -- line: 274
				end or t1.onPlayButtonActivated
			},
			overflow = {
				icon = if not FFlagLuaAppUnifiedPlayButtonSquadMenuDirection or t1.squadButtonMenuDirection ~= MenuDirection.Down then v36 else v37,
				isDisabled = v46,
				onActivated = v46 and function() -- line: 282
				end or t1.onPlaySquadButtonActivated
			},
			testId = t1.testId
		})
	elseif t1.useUIBloxButton then
		if not FFlagLuaAppUseTokenHeightForPlayButton then
			local v65 = v39[v48] or "Size_1000"

			v49 = (not tokens or not tokens.Size[v65]) and 40 or tokens.Size[v65]
		end

		local v66 = v51 == "Fit"
		local v67 = if not v66 then UDim2.new(1, 0, 0, v49) else UDim2.new(0, 0, 0, v49)
		local v68 = playButtonState == PlayButtonStates.Loading
		local v69 = if Emphasis ~= ButtonVariant.SubEmphasis then if Emphasis ~= ButtonVariant.Subtle then ButtonType.PrimaryContextual else ButtonType.Secondary else ButtonType.PrimarySystem
		local v70 = if v53 ~= v34 then v53 else v35

		if type(v70) == "string" then
			v70 = Images[v70]
		end

		v64 = React.createElement(Button, {
			size = v67,
			fitContent = v66,
			buttonType = v69,
			icon = v70,
			text = v54,
			isLoading = v68,
			isDisabled = v47 or v68,
			userInteractionEnabled = not (v47 or v68),
			onActivated = if v47 or v68 then v38 else t1.onPlayButtonActivated,
			ref = t1.playButtonCaptureRef,
			[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`,
			DO_NOT_USE_useUIBloxButton = GetFFlagUIBloxUseFoundationButton() and true or (not not FFlagLuaAppPlayButtonOptOutFoundationButton or nil)
		})

		if (FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or t1.shouldLaunchWhenLoading or t1.shouldLaunchOnReleaseAfterUnmount) and v68 then
			v55 = React.createElement("TextButton", {
				Size = v67,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = t1.loadingCaptureRef,
				[React.Event.Activated] = t1.onPlayButtonActivated
			})
		end
	else
		local v71 = if not FFlagLuaAppIconPlayButton then nil else (v54 == nil or v54 == "") and v53 ~= nil

		v64 = if not FFlagLuaAppIconPlayButton or (FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not t1.hasIconPlayButtonIxp or not v71) then React.createElement(Button2, {
			icon = v53,
			text = v54,
			variant = Emphasis,
			size = v48,
			width = if not FFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then nil else v56,
			fillBehavior = v51,
			isDisabled = v47,
			onActivated = if v47 then v38 else t1.onPlayButtonActivated,
			ref = t1.playButtonCaptureRef,
			testId = t1.testId
		}) else React.createElement(IconButton, {
			icon = v53,
			variant = Emphasis,
			size = v48,
			width = if not FFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then nil else v56,
			fillBehavior = v51,
			isDisabled = v47,
			onActivated = if v47 then v38 else t1.onPlayButtonActivated,
			ref = t1.playButtonCaptureRef,
			testId = t1.testId
		})
	end

	return React.createElement("Frame", {
		LayoutOrder = t1.LayoutOrder,
		Position = t1.Position,
		Size = if not FFlagLuaAppUseTokenHeightForPlayButton then if not t1.width then if v51 ~= "Fill" then nil else UDim2.new(1, 0, 1, 0) else UDim2.new(t1.width, UDim.new(0, 0)) else UDim2.new(if not t1.width then if v51 ~= "Fill" then UDim.new(0, 0) else UDim.new(1, 0) else t1.width, UDim.new(0, v49)),
		AutomaticSize = if not FFlagLuaAppUseTokenHeightForPlayButton then if v51 ~= "Fill" then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y else if v51 ~= "Fill" then Enum.AutomaticSize.X else nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Tag] = if not FFlagSduiExperienceDetailsSupport then nil else t1.tag
	}, {
		LoadingSkeleton = if playButtonState ~= PlayButtonStates.Loading then nil else v55,
		PlayButton = v64
	})
end

return React.memo(PlayButtonView)
