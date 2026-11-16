local parent = script:FindFirstAncestor("GamePlayButton").Parent

local CollectionService = game:GetService("CollectionService")

local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ComboButton = UIBlox.App.Button.ComboButton
local Images = UIBlox.App.ImageSet.Images
local MenuDirection = UIBlox.App.Menu.MenuDirection

local Foundation = require(parent.Foundation)
local button = Foundation.Button
local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius

require(parent.GameProductInfoRodux)
local PlayButtonStates = require(script.Parent.PlayButtonStates)
local EarlyAccessPlusTooltip = require(script.Parent.EarlyAccess.EarlyAccessPlusTooltip)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags.FFlagLuaAppPlayButtonPrivatePT
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = SharedFlags.FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local FFlagLuaAppJoinTextPlayableButton = SharedFlags.FFlagLuaAppJoinTextPlayableButton
local FFlagLuaAppIconPlayButton = SharedFlags.FFlagLuaAppIconPlayButton
local FFlagLuaAppPlayButtonLoadingSkeleton = SharedFlags.FFlagLuaAppPlayButtonLoadingSkeleton
local FFlagLuaAppUnifiedPlayButtonSquadMenuDirection = SharedFlags.FFlagLuaAppUnifiedPlayButtonSquadMenuDirection
local GetFFlagUIBloxUseFoundationButton = SharedFlags.UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppPlayButtonOptOutFoundationButton = SharedFlags.FFlagLuaAppPlayButtonOptOutFoundationButton
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppTextOnlyPlayButton = SharedFlags.FFlagLuaAppTextOnlyPlayButton
local FFlagLuaAppIconTextPlayButton = SharedFlags.FFlagLuaAppIconTextPlayButton
local FFlagLuaAppUpdatePlayButtonText = SharedFlags.FFlagLuaAppUpdatePlayButtonText
local FFlagLuaAppUseTokenHeightForPlayButton = SharedFlags.FFlagLuaAppUseTokenHeightForPlayButton
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local v = FFlagLuaAppIconPlayButton and "play-xlarge" or nil
local iconscommonplay = Images["icons/common/play"]
local iconsactionstruncationCollapse = Images["icons/actions/truncationCollapse"]
local iconsactionstruncationExpand = Images["icons/actions/truncationExpand"]

local function fn() end

local ButtonHeightSizeKeyByInputSize = require(script.Parent.ButtonHeightSizeKeyByInputSize)

local function PlayButtonView(props)
	local tokens = props.tokens
	local playButtonState = props.playButtonState
	local localized = props.localized

	local earlyAccessTooltip = nil

	local onActivated = props.onPlayButtonActivated
	local v2, ref

	if FFlagEnableGameJoinEarlyAccess then
		v2 = props.showEarlyAccessTooltip == true
		local state, setState = React.useState(v2)
		ref = React.useRef(nil)

		if v2 then
			earlyAccessTooltip = React.createElement(EarlyAccessPlusTooltip, {
				isOpen = state,
				onRequestClose = function()
					setState(false)
				end,
				anchorRef = ref
			})

			onActivated = function()
				setState(false)
				props.onPlayButtonActivated()
			end
		end
	else
		v2 = false
	end

	local ref3

	if FFlagLuaAppMediaGalleryGamepadSupport then
		local tag = props.tag
		local playButtonCaptureRef = props.playButtonCaptureRef
		local ref2 = React.useRef(nil)
		ref3 = React.useCallback(function(current)
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
	local isDisabled = false
	local flag2 = false
	local buttonSize = props.buttonSize or InputSize.Medium
	local v3

	if FFlagLuaAppUseTokenHeightForPlayButton then
		local v4 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
		v3 = not (tokens and tokens.Size[v4]) and 40 or tokens.Size[v4]
	end

	local fillBehavior

	if props.width then
		fillBehavior = FillBehavior.Fill
	else
		fillBehavior = props.fillBehavior
	end

	local variant = nil
	local icon = nil
	local text = nil
	local v4 = nil
	local udim = nil

	local v5 = FFlagEnableGameJoinEarlyAccess

	if v5 then
		if playButtonState == PlayButtonStates.EarlyAccessLocked then
			v5 = props.earlyAccessPending == true
		else
			v5 = false
		end
	end

	if playButtonState == PlayButtonStates.Loading then
		if props.hideIfLoading then
			return nil
		end

		if
			FFlagLuaAppPlayButtonLoadingSkeleton
			and not props.useUIBloxButton
			and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.hasPlayButtonLoadingSkeletonIxp)
		then
			local v6

			if FFlagLuaAppUseTokenHeightForPlayButton then
				v6 = v3
			else
				local v7 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
				v6 = tokens and tokens.Size[v7]
			end

			if fillBehavior == "Fill" then
				udim = UDim.new(1, 0)
			else
				udim = UDim.new(0, v6)
			end

			local udim2 = UDim2.new(udim, UDim.new(0, v6))

			local v7 = FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
				or props.shouldLaunchWhenLoading
				or props.shouldLaunchOnReleaseAfterUnmount

			local createElement = React.createElement
			local size

			if v7 then
				size = UDim2.fromScale(1, 1)
			else
				size = udim2
			end

			v4 = createElement(Skeleton, { Size = size, radius = Radius.Medium, ZIndex = 2 })

			if v7 then
				v4 = React.createElement("TextButton", {
					Size = udim2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 2,
					ref = props.loadingCaptureRef,
					[React.Event.Activated] = props.onPlayButtonActivated
				}, { Skeleton = v4 })
			end

			flag2 = true
		end

		variant = ButtonVariant.Emphasis
	elseif playButtonState == PlayButtonStates.Playable then
		variant = ButtonVariant.Emphasis

		if
			FFlagLuaAppIconTextPlayButton
			or FFlagLuaAppTextOnlyPlayButton
			or FFlagLuaAppJoinTextPlayableButton
			and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.hasJoinTextPlayableButtonIxp)
		then
			text = props.playableText

			if not text then
				if FFlagLuaAppUpdatePlayButtonText then
					text = localized.play
				else
					text = localized.join
				end
			end

			if FFlagLuaAppIconTextPlayButton and not props.hidePlayableIcon then
				icon = v
			end
		else
			icon = not (FFlagLuaAppIconPlayButton or props.hidePlayableIcon) and "icons/common/play" or icon

			text = props.playableText

			if FFlagLuaAppIconPlayButton and not props.hidePlayableIcon then
				if text and text ~= "" then
					icon = "icons/common/play"
				else
					icon = v
				end
			end
		end
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		icon = iconscommonplay

		if not props.hideOptionalText then
			text = localized.joinWithParty
		end

		flag = true
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		icon = iconscommonplay

		if not props.hideOptionalText then
			text = localized.waitingForParty
		end

		flag = true
		flag2 = true
		isDisabled = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		text = tostring(props.gameProductInfo and props.gameProductInfo.price or 0)
		variant = ButtonVariant.Emphasis
		icon = "icons/common/robux"
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		variant = ButtonVariant.Emphasis
		local localizedFiatPrice = props.gameProductInfo and props.gameProductInfo.localizedFiatPrice or ""
		text = props.fiatText or localizedFiatPrice
	elseif playButtonState == PlayButtonStates.DemoMode then
		variant = ButtonVariant.SubEmphasis
		text = localized.playDemo
	elseif FFlagLuaAppPlayButtonPrivatePT and playButtonState == PlayButtonStates.Playtest then
		variant = ButtonVariant.SubEmphasis
		text = localized.playtest
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		variant = ButtonVariant.Emphasis
		text = localized.unlock
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		if props.hideIfUnplayable then
			return nil
		end

		variant = ButtonVariant.Subtle
		icon = "icons/status/unavailable"

		if not props.hideOptionalText then
			text = localized.unavailable
		end

		flag2 = true
	elseif FFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked then
		variant = ButtonVariant.Subtle

		if not v5 then
			text = props.earlyAccessCaption or localized.earlyAccess
		end

		flag2 = true
	else
		error("invalid play button state!")
	end

	local playButton

	if flag then
		if not FFlagLuaAppUseTokenHeightForPlayButton then
			local v6 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
			v3 = not (tokens and tokens.Size[v6]) and 40 or tokens.Size[v6]
		end

		local createElement = React.createElement
		local v6 = {
			size = UDim2.new(1, 0, 0, v3),
			button = {
				icon = icon,
				text = text,
				isDisabled = flag2,
				onActivated = flag2 and function() end or onActivated
			},
			overflow = 0,
			testId = 0
		}
		local icon2

		if FFlagLuaAppUnifiedPlayButtonSquadMenuDirection and props.squadButtonMenuDirection == MenuDirection.Down then
			icon2 = iconsactionstruncationExpand
		else
			icon2 = iconsactionstruncationCollapse
		end

		v6.overflow = {
			icon = icon2,
			isDisabled = isDisabled,
			onActivated = isDisabled and function() end or props.onPlaySquadButtonActivated
		}

		v6.testId = props.testId
		playButton = createElement(ComboButton, v6)
	elseif props.useUIBloxButton then
		if not FFlagLuaAppUseTokenHeightForPlayButton then
			local v6 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
			v3 = not (tokens and tokens.Size[v6]) and 40 or tokens.Size[v6]
		end

		local fitContent = fillBehavior == "Fit"
		local udim2

		if fitContent then
			udim2 = UDim2.new(0, 0, 0, v3)
		else
			udim2 = UDim2.new(1, 0, 0, v3)
		end

		local v6 = playButtonState == PlayButtonStates.Loading
		local buttonType

		if variant == ButtonVariant.SubEmphasis then
			buttonType = ButtonType.PrimarySystem
		elseif variant == ButtonVariant.Subtle then
			buttonType = ButtonType.Secondary
		else
			buttonType = ButtonType.PrimaryContextual
		end

		if icon == v then
			icon = iconscommonplay
		end

		if type(icon) == "string" then
			icon = Images[icon]
		end

		local createElement = React.createElement
		local v7 = {}
		v7.size = udim2
		v7.fitContent = fitContent
		v7.buttonType = buttonType
		v7.icon = icon
		v7.text = text
		v7.isLoading = v6 or v5
		v7.isDisabled = flag2 or v6
		v7.userInteractionEnabled = not (flag2 or v6)

		if flag2 or v6 then
			onActivated = fn
		end

		v7.onActivated = onActivated

		if not FFlagLuaAppMediaGalleryGamepadSupport then
			ref3 = props.playButtonCaptureRef
		end

		v7.ref = ref3
		local tag = React.Tag
		local v8

		if props.testId then
			v8 = `data-testid={props.testId}`
		end

		v7[tag] = v8
		v7.DO_NOT_USE_useUIBloxButton = (GetFFlagUIBloxUseFoundationButton() or FFlagLuaAppPlayButtonOptOutFoundationButton)
			and true
			or nil
		playButton = createElement(Button, v7)

		if
			(FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.shouldLaunchWhenLoading or props.shouldLaunchOnReleaseAfterUnmount)
			and v6
		then
			v4 = React.createElement("TextButton", {
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
		local v6

		if FFlagLuaAppIconPlayButton then
			if text == nil or text == "" then
				v6 = icon ~= nil
			else
				v6 = false
			end
		end

		if
			FFlagLuaAppIconPlayButton
			and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.hasIconPlayButtonIxp)
			and v6
		then
			local createElement = React.createElement

			if not FFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then
				udim = nil
			end

			if flag2 then
				onActivated = fn
			end

			if not FFlagLuaAppMediaGalleryGamepadSupport then
				ref3 = props.playButtonCaptureRef
			end

			playButton = createElement(IconButton, {
				icon = icon,
				variant = variant,
				size = buttonSize,
				width = udim,
				fillBehavior = fillBehavior,
				isDisabled = flag2,
				onActivated = onActivated,
				ref = ref3,
				testId = props.testId
			})
		else
			local createElement = React.createElement

			if not FFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then
				udim = nil
			end

			local v7 = {
				icon = icon,
				text = text,
				variant = variant,
				size = buttonSize,
				width = udim,
				fillBehavior = fillBehavior,
				isLoading = v5 and true or nil,
				isDisabled = flag2,
				onActivated = nil,
				ref = 0,
				testId = 0
			}

			if flag2 then
				onActivated = fn
			end

			v7.onActivated = onActivated

			if not FFlagLuaAppMediaGalleryGamepadSupport then
				ref3 = props.playButtonCaptureRef
			end

			v7.ref = ref3
			v7.testId = props.testId
			playButton = createElement(button, v7)
		end
	end

	local createElement = React.createElement

	if not (FFlagEnableGameJoinEarlyAccess and v2) then
		ref = nil
	end

	local v6 = {}
	v6.ref = ref
	v6.LayoutOrder = props.LayoutOrder
	v6.Position = props.Position
	local udim2

	if FFlagLuaAppUseTokenHeightForPlayButton then
		local v7

		if props.width then
			v7 = props.width
		elseif fillBehavior == "Fill" then
			v7 = UDim.new(1, 0)
		else
			v7 = UDim.new(0, 0)
		end

		udim2 = UDim2.new(v7, UDim.new(0, v3))
	elseif props.width then
		udim2 = UDim2.new(props.width, UDim.new(0, 0))
	elseif fillBehavior == "Fill" then
		udim2 = UDim2.new(1, 0, 1, 0)
	end

	v6.Size = udim2
	local automaticSize

	if FFlagLuaAppUseTokenHeightForPlayButton then
		if fillBehavior ~= "Fill" then
			automaticSize = Enum.AutomaticSize.X
		end
	elseif fillBehavior == "Fill" then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	v6.AutomaticSize = automaticSize

	v6.BackgroundTransparency = 1
	v6.BorderSizePixel = 0
	local tag = React.Tag
	local v7

	if not FFlagLuaAppMediaGalleryGamepadSupport then
		v7 = props.tag
	end

	v6[tag] = v7

	if playButtonState ~= PlayButtonStates.Loading then
		v4 = nil
	end

	if not FFlagEnableGameJoinEarlyAccess then
		earlyAccessTooltip = nil
	end

	return createElement("Frame", v6, {
		LoadingSkeleton = v4,
		PlayButton = playButton,
		EarlyAccessTooltip = earlyAccessTooltip
	})
end

return React.memo(PlayButtonView)
