local AvatarCreationService = game:GetService("AvatarCreationService")

local parent = script:FindFirstAncestor("SelfieQr").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local Http = require(parent.Http)
local Localization = require(parent.Localization)
local Promise = require(parent.Promise)
local QRCodeDisplay = require(parent.QRCodeDisplay)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local Image = Foundation.Image
local Icon = Foundation.Icon
local Url = Http.Url
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("AdoptStyleTokens", false)
local defineFastFlag2 = game:DefineFastFlag("AllowQrEnlargeUniversally", false)
local defineFastFlag3 = game:DefineFastFlag("ConsoleCloseAffordanceFix", false)
local defineFastFlag4 = game:DefineFastFlag("EnableTimeoutUI", false)
local defineFastInt = game:DefineFastInt("SelfieQrTimeoutSeconds", 120)

local defineFastString = game:DefineFastString("DebugAvatarGenerationStaticApiKey", "NOT_SET")

local navigateBacksByButtonB = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function SelfieQRCodeView(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		Size = props.outerSize,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = 0,
		ClipsDescendants = true
	}
	local backgroundColor

	if defineFastFlag4 and props.errorOccurred then
		backgroundColor = v.Color.Extended.Gray.Gray_1000.Color3
	elseif defineFastFlag then
		backgroundColor = v.Color.Extended.White.White_0.Color3
	else
		backgroundColor = Color3.fromRGB(255, 255, 255)
	end

	v2.BackgroundColor3 = backgroundColor
	local qrContainer

	if not (defineFastFlag4 and props.errorOccurred) then
		qrContainer = React.createElement("Frame", {
			Size = UDim2.fromOffset(props.sideLength, props.sideLength),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = not defineFastFlag and 1 or v.Color.None.Transparency
		}, {
			DisplayQRCode = React.createElement(DisplayQRCode, {
				toEncode = props.url,
				ecLevel = QRCodeDisplay.ECLevels.EC_LEVEL_4,
				sideLength = props.sideLength
			})
		})
	end

	local logoContainer

	if not (defineFastFlag4 and props.errorOccurred) then
		local createElement2 = React.createElement
		local v3 = {
			Size = UDim2.new(0.3, 0, 0.3, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = 0,
			ZIndex = 10,
			ClipsDescendants = true
		}
		local backgroundColor2

		if defineFastFlag then
			backgroundColor2 = v.Color.Extended.Black.Black_0.Color3
		else
			backgroundColor2 = Color3.fromRGB(0, 0, 0)
		end

		v3.BackgroundColor3 = backgroundColor2

		local v4 = {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.125, 0) }),
			Stroke = React.createElement("UIStroke", {
				Color = v.Color.Extended.White.White_0.Color3,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Round
			}),
			Icon = 0
		}

		local createElement3 = React.createElement
		local size

		if defineFastFlag then
			size = UDim2.fromScale(1, 1)
		else
			size = UDim2.new(0.75, 0, 0.75, 0)
		end

		v4.Icon = createElement3(Image, {
			Size = size,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = not defineFastFlag and 1 or nil,
			Image = defineFastFlag and "rbxasset://textures/ui/LuaApp/ExternalSite/roblox@3x.png" or "icons/logo/block",
			ZIndex = 11
		})
		logoContainer = createElement2("Frame", v3, v4)
	end

	return createElement("Frame", v2, {
		QRContainer = qrContainer,
		LogoContainer = logoContainer,
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.065, 0) }),
		Constraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		})
	})
end

local function getJobStatus(callback, p)
	return callback(p, "GET", {
		headers = { ["X-Static-Api-Key"] = defineFastString }
	}):andThen(function(p2)
		local responseBody = p2.responseBody

		if responseBody then
			return responseBody
		end

		return Promise.reject("Invalid response from getJobStatus")
	end)
end

return function(props)
	local state, setState = React.useState(false)
	local v = Responsive.usePreferredInput() == Responsive.Input.Directional
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local v2 = useRoactService(RoactNetworking)
	local v3 = useTokens()

	local v4 = useLocalization({
		title = {
			"AvatarGeneration.SelfieConsent.QRTitle",
			fontStart = "<font weight=\"heavy\" size=\"24\">",
			fontEnd = "</font>"
		},
		body = {
			"AvatarGeneration.SelfieConsent.QRBody",
			fontStart = "<font size=\"18\">",
			fontEnd = "</font>"
		},
		errorTitle = {
			"AvatarGeneration.SelfieConsent.QRErrorTitle",
			fontStart = "<font weight=\"heavy\" size=\"24\">",
			fontEnd = "</font>"
		},
		errorBody = {
			"AvatarGeneration.SelfieConsent.QRErrorBody",
			fontStart = "<font size=\"18\">",
			fontEnd = "</font>"
		}
	})

	local function handleError() -- 3 equivalent calls inferred from this helper
		setState3(true)
		setState(false)
		setState2(false)
	end

	React.useEffect(function()
		local thread = nil
		local thread2 = task.delay(defineFastInt, function()
			if defineFastFlag4 then
				handleError() -- inferred equivalent call
			else
				props.displaySelfieQRCode(false)
				AvatarCreationService:HandleSelfieQRResult(false, "job not completed within time limit")
			end
		end)
		local function poll(p)
			getJobStatus(v2, p):andThen(function(p2)
				if p2.status == "done" then
					local v5 = p2.fileIds and p2.fileIds[1]
					props.displaySelfieQRCode(false)
					AvatarCreationService:HandleSelfieQRResult(true, v5)
				elseif p2.status ~= "cancelled" and p2.status ~= "error" then
					thread = task.delay(1, function()
						poll(p)
					end)
				elseif defineFastFlag4 then
					handleError() -- inferred equivalent call
				else
					props.displaySelfieQRCode(false)
					AvatarCreationService:HandleSelfieQRResult(false, "job polling failed")
				end
			end):catch(function(_)
				if defineFastFlag4 then
					handleError() -- inferred equivalent call
				else
					props.displaySelfieQRCode(false)
					AvatarCreationService:HandleSelfieQRResult(false, "job polling failed")
				end
			end)
		end

		poll((string.format("%sml-runtime-gateway/v0.2/jobs/%s", Url.APIS_URL, props.jobId)))

		return function()
			if thread then
				task.cancel(thread)
			end

			if thread2 then
				task.cancel(thread2)
			end
		end
	end, {})

	local v5 = { size = DialogSize.Medium, ZIndex = 2 }

	if not v then
		function v5.onClose(_)
			props.displaySelfieQRCode(false)

			if defineFastFlag4 then
				AvatarCreationService:HandleSelfieQRResult(
					false,
					"QR code closed before job completed or session expired"
				)
			else
				AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed")
			end
		end
	end

	local v6

	if defineFastFlag3 then
		v6 = ReactFocusNavigation.useEventMap(navigateBacksByButtonB)
	end

	local v7 = React.useCallback(function(object)
		local eventData = object.eventData

		if eventData and eventData.UserInputState == Enum.UserInputState.End then
			object:cancel()

			if state then
				setState(false)
				return
			end

			props.displaySelfieQRCode(false)

			if defineFastFlag4 then
				AvatarCreationService:HandleSelfieQRResult(
					false,
					"QR code closed before job completed or session expired"
				)
			else
				AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed")
			end
		end
	end, { state, props.displaySelfieQRCode })
	local ref

	if defineFastFlag3 then
		ref = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v7, nil, v6)
	end

	if state then
		local createElement = React.createElement

		if not defineFastFlag3 then
			ref = nil
		end

		local v8 = {
			ref = ref,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			ZIndex = 7
		}
		local backgroundColor

		if defineFastFlag then
			backgroundColor = v3.Color.Extended.Black.Black_60.Color3
		else
			backgroundColor = Color3.fromRGB(0, 0, 0)
		end

		v8.BackgroundColor3 = backgroundColor

		v8.BackgroundTransparency = not defineFastFlag and 0.4 or v3.Color.Extended.Black.Black_60.Transparency

		local children = {
			InvisibleCloseButton = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = not defineFastFlag and 1 or v3.Color.ActionUtility.Background.Transparency,
				Text = "",
				ZIndex = not defineFastFlag3 and 5 or nil,
				[React.Event.Activated] = defineFastFlag2 and not v and function()
					setState(false)
				end or not defineFastFlag3 and function()
					setState(false)
				end or nil
			}),
			QRCodeArea = 0
		}

		local createElement2 = React.createElement
		local v9 = {
			url = props.url,
			sideLength = 500,
			outerSize = UDim2.fromOffset(600, 600),
			errorOccurred = 0
		}

		if not defineFastFlag4 then
			state3 = nil
		end

		v9.errorOccurred = state3
		children.QRCodeArea = createElement2(SelfieQRCodeView, v9)
		return createElement("Frame", v8, children)
	else
		local createElement = React.createElement

		if not defineFastFlag3 then
			ref = nil
		end

		local v8 = {
			ref = ref,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			ZIndex = 0
		}
		local backgroundColor

		if defineFastFlag then
			backgroundColor = v3.Color.Extended.Black.Black_0.Color3
		else
			backgroundColor = Color3.fromRGB(0, 0, 0)
		end

		v8.BackgroundColor3 = backgroundColor

		v8.BackgroundTransparency = not defineFastFlag and 1 or v3.Color.None.Transparency
		local invisibleCloseButton

		if not defineFastFlag3 then
			invisibleCloseButton = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = not defineFastFlag and 1 or v3.Color.ActionUtility.Background.Transparency,
				Text = "",
				ZIndex = 1,
				[React.Event.Activated] = function()
					props.displaySelfieQRCode(false)
					AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed")
				end
			})
		end

		local createElement2 = React.createElement
		local root = Dialog.Root
		local createElement3 = React.createElement
		local content = Dialog.Content
		local createElement4 = React.createElement
		local v9 = {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = 0
		}
		local padding

		if defineFastFlag then
			padding = UDim.new(0, v3.Padding.Small)
		else
			padding = UDim.new(0, 10)
		end

		v9.Padding = padding
		local children = {
			Layout = createElement4("UIListLayout", v9),
			TopSpacer = 0,
			HoverFrame = 0,
			BottomSpacer = 0,
			TextContainerWrapper = 0
		}

		local createElement5 = React.createElement
		local size

		if defineFastFlag then
			size = UDim2.fromOffset(0, 56)
		else
			size = UDim2.new(0, 0, 0, 50)
		end

		children.TopSpacer = createElement5("Frame", {
			Size = size,
			BackgroundTransparency = not defineFastFlag and 1 or v3.Color.None.Transparency,
			LayoutOrder = 0
		})

		local createElement6 = React.createElement
		local v10 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v11 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			InteractiveArea = 0
		}

		local createElement7 = React.createElement
		local v12 = {
			Text = "",
			Size = UDim2.new(0.65, 0, 0, 0),
			BackgroundTransparency = not defineFastFlag and 1 or v3.Color.ActionUtility.Background.Transparency,
			AutoButtonColor = false,
			[React.Event.MouseEnter] = function()
				if defineFastFlag4 and state3 then
					return
				end

				if defineFastFlag2 or v then
					setState2(true)
				end
			end,
			[React.Event.MouseLeave] = function()
				setState2(false)
			end,
			[React.Event.Activated] = function()
				if defineFastFlag4 and state3 then
					return
				end

				if defineFastFlag2 or v then
					setState(true)

					if defineFastFlag4 then
						setState2(false)
					end
				end
			end
		}
		local children2 = {
			Constraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			BorderFrame = 0,
			QRCodeArea = 0
		}

		local createElement8 = React.createElement
		local v13 = {
			Size = UDim2.new(0.98, 0, 0.98, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = v3.Color.ActionEmphasis.Border.Transparency
		}

		local createElement9 = React.createElement
		local color

		if defineFastFlag then
			color = v3.Color.Extended.White.White_0.Color3
		else
			color = Color3.fromRGB(255, 255, 255)
		end

		children2.BorderFrame = createElement8("Frame", v13, {
			Stroke = createElement9("UIStroke", {
				Color = color,
				Thickness = 3,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Round,
				Transparency = not defineFastFlag and (state2 and 0 or 1) or state2 and v3.Color.ActionEmphasis.Foreground.Transparency or v3.Color.ActionEmphasis.Border.Transparency
			}),
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.075, 0) })
		})

		local createElement10 = React.createElement
		local v14 = {
			url = props.url,
			sideLength = 225,
			outerSize = UDim2.new(0.95, 0, 0.95, 0),
			errorOccurred = 0
		}
		local errorOccurred

		if defineFastFlag4 then
			errorOccurred = state3
		end

		v14.errorOccurred = errorOccurred
		children2.QRCodeArea = createElement10(SelfieQRCodeView, v14)
		v11.InteractiveArea = createElement7("TextButton", v12, children2)
		children.HoverFrame = createElement6("Frame", v10, v11)

		local createElement11 = React.createElement
		local size2

		if defineFastFlag then
			size2 = UDim2.fromOffset(0, v3.Gap.XXLarge)
		else
			size2 = UDim2.new(0, 0, 0, 30)
		end

		children.BottomSpacer = createElement11("Frame", {
			Size = size2,
			BackgroundTransparency = not defineFastFlag and 1 or v3.Color.None.Transparency,
			LayoutOrder = 2
		})

		local createElement12 = React.createElement
		local v15 = {
			Size = UDim2.new(1, 0, 0, v3.Size.Size_2000),
			BackgroundTransparency = v3.Color.None.Transparency,
			LayoutOrder = 3
		}
		local layout

		if not defineFastFlag4 then
			layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			})
		end

		local textAndIconContainer

		if defineFastFlag4 then
			local createElement13 = React.createElement
			local v16 = {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = v3.Color.None.Transparency
			}

			local createElement14 = React.createElement
			local fillDirection

			if state3 then
				fillDirection = Enum.FillDirection.Horizontal
			else
				fillDirection = Enum.FillDirection.Vertical
			end

			local children3 = {
				Layout = createElement14("UIListLayout", {
					FillDirection = fillDirection,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, v3.Gap.Medium)
				}),
				WarningIcon = 0,
				TextContent = 0
			}
			local warningIcon

			if state3 then
				warningIcon = React.createElement(Icon, {
					name = Foundation.Enums.IconName.TriangleExclamation,
					size = v3.Size.Size_700,
					BackgroundTransparency = v3.Color.None.Transparency,
					LayoutOrder = 1
				})
			end

			children3.WarningIcon = warningIcon

			local createElement15 = React.createElement
			local size3

			if state3 then
				size3 = UDim2.new(1, -48, 0, 0)
			else
				size3 = UDim2.fromScale(1, 0)
			end

			local v17 = {
				Size = size3,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = v3.Color.None.Transparency,
				LayoutOrder = 2
			}

			local children4 = {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v3.Gap.Small)
				}),
				TitleText = 0,
				DialogText = 0
			}

			local createElement16 = React.createElement
			local text = Dialog.Text
			local text2 = if state3 then v4.errorTitle else v4.title
			local textXAlignment

			if state3 then
				textXAlignment = Enum.TextXAlignment.Left
			else
				textXAlignment = Enum.TextXAlignment.Center
			end

			children4.TitleText = createElement16(text, {
				Text = text2,
				LayoutOrder = 3,
				TextXAlignment = textXAlignment,
				Font = Enum.Font.SourceSansBold
			})

			children4.DialogText = React.createElement(Dialog.Text, {
				Text = not state3 and "" or v4.errorBody,
				LayoutOrder = 4,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			children3.TextContent = createElement15("Frame", v17, children4)
			textAndIconContainer = createElement13("Frame", v16, children3)
		end

		local titleText

		if not defineFastFlag4 then
			titleText = React.createElement(Dialog.Text, {
				Text = v4.title,
				LayoutOrder = 3,
				Font = Enum.Font.SourceSansBold
			})
		end

		local dialogText

		if not defineFastFlag4 then
			dialogText = React.createElement(Dialog.Text, { Text = v4.body, LayoutOrder = 4 })
		end

		children.TextContainerWrapper = createElement12("Frame", v15, {
			Layout = layout,
			TextAndIconContainer = textAndIconContainer,
			TitleText = titleText,
			DialogText = dialogText
		})
		return createElement("Frame", v8, {
			InvisibleCloseButton = invisibleCloseButton,
			Dialog = createElement2(root, v5, {
				DialogContent = createElement3(content, nil, children)
			})
		})
	end
end
