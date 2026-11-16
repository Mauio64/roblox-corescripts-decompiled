local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UIBlox")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local comboButton = UIBlox.App.Button.ComboButton
local images = UIBlox.App.ImageSet.Images
local menuDirection = UIBlox.App.Menu.MenuDirection

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local button2 = Foundation.Button
local iconButton = Foundation.IconButton
local skeleton = Foundation.Skeleton
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius

require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameProductInfoRodux")
local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
local EarlyAccessPlusTooltip = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/EarlyAccessPlusTooltip")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags")
local fFlagLuaAppPlayButtonPrivatePT = SharedFlags.FFlagLuaAppPlayButtonPrivatePT
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = SharedFlags.FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local fFlagLuaAppJoinTextPlayableButton = SharedFlags.FFlagLuaAppJoinTextPlayableButton
local fFlagLuaAppIconPlayButton = SharedFlags.FFlagLuaAppIconPlayButton
local fFlagLuaAppPlayButtonLoadingSkeleton = SharedFlags.FFlagLuaAppPlayButtonLoadingSkeleton
local fFlagLuaAppUnifiedPlayButtonSquadMenuDirection = SharedFlags.FFlagLuaAppUnifiedPlayButtonSquadMenuDirection
local getFFlagUIBloxUseFoundationButton = SharedFlags.UIBlox.GetFFlagUIBloxUseFoundationButton
local fFlagLuaAppPlayButtonOptOutFoundationButton = SharedFlags.FFlagLuaAppPlayButtonOptOutFoundationButton
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppTextOnlyPlayButton = SharedFlags.FFlagLuaAppTextOnlyPlayButton
local fFlagLuaAppIconTextPlayButton = SharedFlags.FFlagLuaAppIconTextPlayButton
local fFlagLuaAppUpdatePlayButtonText = SharedFlags.FFlagLuaAppUpdatePlayButtonText
local fFlagLuaAppUseTokenHeightForPlayButton = SharedFlags.FFlagLuaAppUseTokenHeightForPlayButton
local fFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local v5 = fFlagLuaAppIconPlayButton and "play-xlarge" or nil
local iconscommonplay = images["icons/common/play"]
local iconsactionstruncationCollapse = images["icons/actions/truncationCollapse"]
local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]

local function fn() end

local ButtonHeightSizeKeyByInputSize = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/ButtonHeightSizeKeyByInputSize")

local function PlayButtonView(props)
	local tokens = props.tokens
	local playButtonState = props.playButtonState
	local localized = props.localized

	local v6 = nil

	local v7 = props.onPlayButtonActivated
	local v8, ref

	if fFlagEnableGameJoinEarlyAccess then
		v8 = props.showEarlyAccessTooltip == true
		local state, setState = React.useState(v8)
		ref = React.useRef(nil)

		if v8 then
			v6 = React.createElement(EarlyAccessPlusTooltip, {
				isOpen = state,
				onRequestClose = function()
					setState(false)
				end,
				anchorRef = ref
			})

			v7 = function()
				setState(false)
				props.onPlayButtonActivated()
			end
		end
	else
		v8 = false
	end

	local v9

	if fFlagLuaAppMediaGalleryGamepadSupport then
		local tag = props.tag
		local playButtonCaptureRef = props.playButtonCaptureRef
		local ref2 = React.useRef(nil)
		v9 = React.useCallback(function(current)
			local current2 = ref2.current

			if current2 ~= nil and current2 ~= current and tag ~= nil then
				CollectionService:RemoveTag(current2, tag)
			end

			ref2.current = current

			if tag ~= nil and current ~= nil then
				CollectionService:AddTag(current, tag)
			end

			if type(playButtonCaptureRef) == "function" then
				playButtonCaptureRef(current)
			elseif playButtonCaptureRef ~= nil then
				playButtonCaptureRef.current = current
			end
		end, { tag, playButtonCaptureRef })
	end

	local flag = false
	local v10 = false
	local flag2 = false
	local buttonSize = props.buttonSize or inputSize.Medium
	local v11

	if fFlagLuaAppUseTokenHeightForPlayButton then
		local v12 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
		v11 = not (tokens and tokens.Size[v12]) and 40 or tokens.Size[v12]
	end

	local v12 = if props.width then fillBehavior.Fill else props.fillBehavior
	local v13 = nil
	local v14 = nil
	local v15 = nil
	local v16 = nil
	local udim = nil

	local v17 = fFlagEnableGameJoinEarlyAccess

	if v17 then
		v17 = playButtonState == PlayButtonStates.EarlyAccessLocked and props.earlyAccessPending == true
	end

	if playButtonState == PlayButtonStates.Loading then
		if props.hideIfLoading then
			return nil
		end

		if
			fFlagLuaAppPlayButtonLoadingSkeleton
			and not props.useUIBloxButton
			and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.hasPlayButtonLoadingSkeletonIxp)
		then
			local v18

			if fFlagLuaAppUseTokenHeightForPlayButton then
				v18 = v11
			else
				local v19 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
				v18 = tokens and tokens.Size[v19]
			end

			udim = if v12 == "Fill" then UDim.new(1, 0) else UDim.new(0, v18)

			local udim2 = UDim2.new(udim, UDim.new(0, v18))

			local v19 = fFlagLuaAppUnifyPlayButtonAllSurfacesIxp
				or props.shouldLaunchWhenLoading
				or props.shouldLaunchOnReleaseAfterUnmount

			local createElement = React.createElement
			local v22 = if v19 then UDim2.fromScale(1, 1) else udim2
			v16 = createElement(skeleton, {
				Size = v22,
				radius = radius.Medium,
				ZIndex = 2
			})

			if v19 then
				v16 = React.createElement("TextButton", {
					Size = udim2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 2,
					ref = props.loadingCaptureRef,
					[React.Event.Activated] = props.onPlayButtonActivated
				}, { Skeleton = v16 })
			end

			flag2 = true
		end

		v13 = buttonVariant.Emphasis
	elseif playButtonState == PlayButtonStates.Playable then
		v13 = buttonVariant.Emphasis

		if
			fFlagLuaAppIconTextPlayButton
			or fFlagLuaAppTextOnlyPlayButton
			or fFlagLuaAppJoinTextPlayableButton
			and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.hasJoinTextPlayableButtonIxp)
		then
			v15 = props.playableText

			if not v15 then
				v15 = if fFlagLuaAppUpdatePlayButtonText then localized.play else localized.join
			end

			if fFlagLuaAppIconTextPlayButton and not props.hidePlayableIcon then
				v14 = v5
			end
		else
			v14 = not (fFlagLuaAppIconPlayButton or props.hidePlayableIcon) and "icons/common/play" or v14

			v15 = props.playableText

			if fFlagLuaAppIconPlayButton and not props.hidePlayableIcon then
				v14 = if v15 and v15 ~= "" then "icons/common/play" else v5
			end
		end
	elseif getFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		v14 = iconscommonplay

		if not props.hideOptionalText then
			v15 = localized.joinWithParty
		end

		flag = true
	elseif getFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		v14 = iconscommonplay

		if not props.hideOptionalText then
			v15 = localized.waitingForParty
		end

		flag = true
		flag2 = true
		v10 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		v15 = tostring(props.gameProductInfo and props.gameProductInfo.price or 0)
		v13 = buttonVariant.Emphasis
		v14 = "icons/common/robux"
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		v13 = buttonVariant.Emphasis
		local localizedFiatPrice = props.gameProductInfo and props.gameProductInfo.localizedFiatPrice or ""
		v15 = props.fiatText or localizedFiatPrice
	elseif playButtonState == PlayButtonStates.DemoMode then
		v13 = buttonVariant.SubEmphasis
		v15 = localized.playDemo
	elseif fFlagLuaAppPlayButtonPrivatePT and playButtonState == PlayButtonStates.Playtest then
		v13 = buttonVariant.SubEmphasis
		v15 = localized.playtest
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		v13 = buttonVariant.Emphasis
		v15 = localized.unlock
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		if props.hideIfUnplayable then
			return nil
		end

		v13 = buttonVariant.Subtle
		v14 = "icons/status/unavailable"

		if not props.hideOptionalText then
			v15 = localized.unavailable
		end

		flag2 = true
	elseif fFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked then
		v13 = buttonVariant.Subtle

		if not v17 then
			v15 = props.earlyAccessCaption or localized.earlyAccess
		end

		flag2 = true
	else
		error("invalid play button state!")
	end

	local v18

	if flag then
		if not fFlagLuaAppUseTokenHeightForPlayButton then
			local v19 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
			v11 = not (tokens and tokens.Size[v19]) and 40 or tokens.Size[v19]
		end

		local createElement = React.createElement
		local v20 = {
			size = UDim2.new(1, 0, 0, v11),
			button = {
				icon = v14,
				text = v15,
				isDisabled = flag2,
				onActivated = flag2 and function() end or v7
			},
			overflow = 0,
			testId = 0
		}

		local v22 = if fFlagLuaAppUnifiedPlayButtonSquadMenuDirection and props.squadButtonMenuDirection == menuDirection.Down then iconsactionstruncationExpand else iconsactionstruncationCollapse
		v20.overflow = {
			icon = v22,
			isDisabled = v10,
			onActivated = v10 and function() end or props.onPlaySquadButtonActivated
		}

		v20.testId = props.testId
		v18 = createElement(comboButton, v20)
	elseif props.useUIBloxButton then
		if not fFlagLuaAppUseTokenHeightForPlayButton then
			local v19 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
			v11 = not (tokens and tokens.Size[v19]) and 40 or tokens.Size[v19]
		end

		local v19 = v12 == "Fit"
		local udim2 = if v19 then UDim2.new(0, 0, 0, v11) else UDim2.new(1, 0, 0, v11)

		local v20 = playButtonState == PlayButtonStates.Loading
		local v21

		if v13 == buttonVariant.SubEmphasis then
			v21 = buttonType.PrimarySystem
		else
			v21 = if v13 == buttonVariant.Subtle then buttonType.Secondary else buttonType.PrimaryContextual
		end

		if v14 == v5 then
			v14 = iconscommonplay
		end

		if (type)(v14) == "string" then
			v14 = images[v14]
		end

		local createElement = React.createElement
		local v23 = {}
		v23.size = udim2
		v23.fitContent = v19
		v23.buttonType = v21
		v23.icon = v14
		v23.text = v15
		v23.isLoading = v20 or v17
		v23.isDisabled = flag2 or v20
		v23.userInteractionEnabled = not (flag2 or v20)

		if flag2 or v20 then
			v7 = fn
		end

		v23.onActivated = v7

		if not fFlagLuaAppMediaGalleryGamepadSupport then
			v9 = props.playButtonCaptureRef
		end

		v23.ref = v9
		local tag = React.Tag
		local v24 = if props.testId then `data-testid={props.testId}` else nil
		v23[tag] = v24
		v23.DO_NOT_USE_useUIBloxButton = (getFFlagUIBloxUseFoundationButton() or fFlagLuaAppPlayButtonOptOutFoundationButton)
			and true
			or nil
		v18 = createElement(button, v23)

		if
			(fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.shouldLaunchWhenLoading or props.shouldLaunchOnReleaseAfterUnmount)
			and v20
		then
			v16 = React.createElement("TextButton", {
				Size = udim2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = props.loadingCaptureRef,
				[React.Event.Activated] = props.onPlayButtonActivated
			})
		end
	else
		local v19 = if fFlagLuaAppIconPlayButton then (v15 == nil or v15 == "") and v14 ~= nil else nil

		if
			fFlagLuaAppIconPlayButton
			and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.hasIconPlayButtonIxp)
			and v19
		then
			local createElement = React.createElement

			if not fFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then
				udim = nil
			end

			if flag2 then
				v7 = fn
			end

			if not fFlagLuaAppMediaGalleryGamepadSupport then
				v9 = props.playButtonCaptureRef
			end

			v18 = createElement(iconButton, {
				icon = v14,
				variant = v13,
				size = buttonSize,
				width = udim,
				fillBehavior = v12,
				isDisabled = flag2,
				onActivated = v7,
				ref = v9,
				testId = props.testId
			})
		else
			local createElement = React.createElement

			if not fFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then
				udim = nil
			end

			local v21 = {
				icon = v14,
				text = v15,
				variant = v13,
				size = buttonSize,
				width = udim,
				fillBehavior = v12,
				isLoading = v17 and true or nil,
				isDisabled = flag2,
				onActivated = nil,
				ref = 0,
				testId = 0
			}

			if flag2 then
				v7 = fn
			end

			v21.onActivated = v7

			if not fFlagLuaAppMediaGalleryGamepadSupport then
				v9 = props.playButtonCaptureRef
			end

			v21.ref = v9
			v21.testId = props.testId
			v18 = createElement(button2, v21)
		end
	end

	local createElement = React.createElement

	if not (fFlagEnableGameJoinEarlyAccess and v8) then
		ref = nil
	end

	local v20 = {}
	v20.ref = ref
	v20.LayoutOrder = props.LayoutOrder
	v20.Position = props.Position
	local udim2

	if fFlagLuaAppUseTokenHeightForPlayButton then
		local newUDim2 = UDim2.new
		local v21

		if props.width then
			v21 = props.width
		else
			v21 = if v12 == "Fill" then UDim.new(1, 0) else UDim.new(0, 0)
		end

		udim2 = newUDim2(v21, UDim.new(0, v11))
	elseif props.width then
		udim2 = UDim2.new(props.width, UDim.new(0, 0))
	elseif v12 == "Fill" then
		udim2 = UDim2.new(1, 0, 1, 0)
	end

	v20.Size = udim2
	local v21

	if fFlagLuaAppUseTokenHeightForPlayButton then
		if v12 ~= "Fill" then
			v21 = Enum.AutomaticSize.X
		end
	else
		v21 = if v12 == "Fill" then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY
	end

	v20.AutomaticSize = v21

	v20.BackgroundTransparency = 1
	v20.BorderSizePixel = 0
	local tag = React.Tag
	local v22 = if not fFlagLuaAppMediaGalleryGamepadSupport then props.tag else nil
	v20[tag] = v22

	if playButtonState ~= PlayButtonStates.Loading then
		v16 = nil
	end

	if not fFlagEnableGameJoinEarlyAccess then
		v6 = nil
	end

	return createElement("Frame", v20, {
		LoadingSkeleton = v16,
		PlayButton = v18,
		EarlyAccessTooltip = v6
	})
end

return React.memo(PlayButtonView)
