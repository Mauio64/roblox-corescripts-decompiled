local AvatarCreationService = game:GetService("AvatarCreationService")
local Parent = script:FindFirstAncestor("SelfieQr").Parent
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local Foundation = require(Parent.Foundation)
local Http = require(Parent.Http)
local Localization = require(Parent.Localization)
local Promise = require(Parent.Promise)
local QRCodeDisplay = require(Parent.QRCodeDisplay)
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local Responsive = require(Parent.Responsive)
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FoundationImage = Foundation.Image
local Icon = Foundation.Icon
local Url = Http.Url
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local v23 = game:DefineFastFlag("AdoptStyleTokens", false)
local v24 = game:DefineFastFlag("AllowQrEnlargeUniversally", false)
local v25 = game:DefineFastFlag("ConsoleCloseAffordanceFix", false)
local v26 = game:DefineFastFlag("EnableTimeoutUI", false)
local v27 = game:DefineFastInt("SelfieQrTimeoutSeconds", 120)
local v28 = game:DefineFastString("DebugAvatarGenerationStaticApiKey", "NOT_SET")
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function SelfieQRCodeView(t2: {[any]: any}) -- line: 60
	-- upvalues: useTokens (copy), React (copy), v26 (copy), v23 (copy), DisplayQRCode (copy), QRCodeDisplay (copy), FoundationImage (copy)
	local v33 = useTokens()

	return React.createElement("Frame", {
		ClipsDescendants = true,
		Size = t2.outerSize,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = if not v26 or not t2.errorOccurred then if not v23 then Color3.fromRGB(255, 255, 255) else v33.Color.Extended.White.White_0.Color3 else v33.Color.Extended.Gray.Gray_1000.Color3
	}, {
		QRContainer = if not not v26 and t2.errorOccurred then nil else React.createElement("Frame", {
			Size = UDim2.fromOffset(t2.sideLength, t2.sideLength),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = not v23 and 1 or v33.Color.None.Transparency
		}, {
			DisplayQRCode = React.createElement(DisplayQRCode, {
				toEncode = t2.url,
				ecLevel = QRCodeDisplay.ECLevels.EC_LEVEL_4,
				sideLength = t2.sideLength
			})
		}),
		LogoContainer = if not not v26 and t2.errorOccurred then nil else React.createElement("Frame", {
			ZIndex = 10,
			ClipsDescendants = true,
			Size = UDim2.new(0.3, 0, 0.3, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = if not v23 then Color3.fromRGB(0, 0, 0) else v33.Color.Extended.Black.Black_0.Color3
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0)
			}),
			Stroke = React.createElement("UIStroke", {
				Thickness = 1,
				Color = v33.Color.Extended.White.White_0.Color3,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Round
			}),
			Icon = React.createElement(FoundationImage, {
				ZIndex = 11,
				Size = if not v23 then UDim2.new(0.75, 0, 0.75, 0) else UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = not v23 and 1 or nil,
				Image = not v23 and "icons/logo/block" or "rbxasset://textures/ui/LuaApp/ExternalSite/roblox@3x.png"
			})
		}),
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.065, 0)
		}),
		Constraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		})
	})
end
local function getJobStatus(p1, p2) -- line: 133
	-- upvalues: v28 (copy), Promise (copy)
	return p1(p2, "GET", {
		headers = {
			["X-Static-Api-Key"] = v28
		}
	}):andThen(function(p3) -- line: 135
		-- upvalues: Promise (copy)
		local responseBody = p3.responseBody

		if not responseBody then
			return Promise.reject("Invalid response from getJobStatus")
		end

		return responseBody
	end)
end

return function(t3: {[any]: any}) -- line: 146
	-- upvalues: React (copy), Responsive (copy), useRoactService (copy), RoactNetworking (copy), useTokens (copy), useLocalization (copy), v27 (copy), v26 (copy), AvatarCreationService (copy), getJobStatus (copy), Url (copy), DialogSize (copy), v25 (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), v23 (copy), v24 (copy), SelfieQRCodeView (copy), Dialog (copy), Icon (copy), Foundation (copy)
	local v37, v38 = React.useState(false)
	local v39 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v40, v41 = React.useState(false)
	local v42, v43 = React.useState(false)
	local v44 = useRoactService(RoactNetworking)
	local v45 = useTokens()
	local v46 = useLocalization({
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

	local function handleError() -- line: 178
		-- upvalues: v43 (copy), v38 (copy), v41 (copy)
		v43(true)
		v38(false)
		v41(false)
	end

	React.useEffect(function() -- line: 185
		-- upvalues: v27 (copy), v26 (copy), v43 (copy), v38 (copy), v41 (copy), t3 (copy), AvatarCreationService (copy), getJobStatus (copy), v44 (copy), Url (copy)
		local thread = nil
		local thread2 = task.delay(v27, function() -- line: 187
			-- upvalues: v26 (copy), v43 (copy), v38 (copy), v41 (copy), t3 (copy), AvatarCreationService (copy)
			if v26 then
				v43(true)
				v38(false)
				v41(false)

				return
			end

			t3.displaySelfieQRCode(false)
			AvatarCreationService:HandleSelfieQRResult(false, "job not completed within time limit")
		end)

		local function poll(p4) -- line: 196
			-- upvalues: getJobStatus (copy), v44 (copy), t3 (copy), AvatarCreationService (copy), v26 (copy), v43 (copy), v38 (copy), v41 (copy), thread (ref), poll (copy)
			getJobStatus(v44, p4):andThen(function(p5) -- line: 198
				-- upvalues: t3 (copy), AvatarCreationService (copy), v26 (copy), v43 (copy), v38 (copy), v41 (copy), thread (ref), poll (copy), p4 (copy)
				if p5.status == "done" then
					local v62 = p5.fileIds and p5.fileIds[1]

					t3.displaySelfieQRCode(false)
					AvatarCreationService:HandleSelfieQRResult(true, v62)

					return
				end

				if p5.status == "cancelled" or p5.status == "error" then
					if v26 then
						v43(true)
						v38(false)
						v41(false)

						return
					end

					t3.displaySelfieQRCode(false)
					AvatarCreationService:HandleSelfieQRResult(false, "job polling failed")

					return
				end

				thread = task.delay(1, function() -- line: 211
					-- upvalues: poll (copy), p4 (copy)
					poll(p4)
				end)
			end):catch(function(_) -- line: 216
				-- upvalues: v26 (copy), v43 (copy), v38 (copy), v41 (copy), t3 (copy), AvatarCreationService (copy)
				if v26 then
					v43(true)
					v38(false)
					v41(false)

					return
				end

				t3.displaySelfieQRCode(false)
				AvatarCreationService:HandleSelfieQRResult(false, "job polling failed")
			end)
		end

		poll((string.format("%sml-runtime-gateway/v0.2/jobs/%s", Url.APIS_URL, t3.jobId)))

		return function() -- line: 229
			-- upvalues: thread (ref), thread2 (copy)
			if thread then
				task.cancel(thread)
			end

			if thread2 then
				task.cancel(thread2)
			end
		end
	end, {})

	local t4 = {
		ZIndex = 2,
		size = DialogSize.Medium
	}

	if not v39 then
		function t4.onClose(_) -- line: 245
			-- upvalues: t3 (copy), v26 (copy), AvatarCreationService (copy)
			t3.displaySelfieQRCode(false)

			if v26 then
				AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed or session expired")

				return
			end

			AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed")
		end
	end

	local v49 = if not v25 then nil else ReactFocusNavigation.useEventMap(t1)
	local v50 = React.useCallback(function(p8) -- line: 259
		-- upvalues: v37 (copy), v38 (copy), t3 (copy), v26 (copy), AvatarCreationService (copy)
		local eventData = p8.eventData

		if eventData and eventData.UserInputState == Enum.UserInputState.End then
			p8:cancel()

			if v37 then
				v38(false)

				return
			end

			t3.displaySelfieQRCode(false)

			if v26 then
				AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed or session expired")

				return
			end

			AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed")
		end
	end, {
		v37,
		t3.displaySelfieQRCode
	})
	local v51 = if not v25 then nil else ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v50, nil, v49)

	if v37 then
		return React.createElement("Frame", {
			ZIndex = 7,
			ref = if not v25 then nil else v51,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = if not v23 then Color3.fromRGB(0, 0, 0) else v45.Color.Extended.Black.Black_60.Color3,
			BackgroundTransparency = not v23 and 0.4 or v45.Color.Extended.Black.Black_60.Transparency
		}, {
			InvisibleCloseButton = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = not v23 and 1 or v45.Color.ActionUtility.Background.Transparency,
				Text = "",
				ZIndex = if v25 then nil else 5,
				[React.Event.Activated] = if not (not not v24 and not v39) and v25 then nil else function() -- line: 311
					-- upvalues: v38 (copy)
					v38(false)
				end
			}),
			QRCodeArea = React.createElement(SelfieQRCodeView, {
				sideLength = 500,
				url = t3.url,
				outerSize = UDim2.fromOffset(600, 600),
				errorOccurred = if not v26 then nil else v42
			})
		})
	end

	return React.createElement("Frame", {
		ZIndex = 0,
		ref = if not v25 then nil else v51,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = if not v23 then Color3.fromRGB(0, 0, 0) else v45.Color.Extended.Black.Black_0.Color3,
		BackgroundTransparency = not v23 and 1 or v45.Color.None.Transparency
	}, {
		InvisibleCloseButton = if v25 then nil else React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = not v23 and 1 or v45.Color.ActionUtility.Background.Transparency,
			Text = "",
			ZIndex = 1,
			[React.Event.Activated] = function() -- line: 344
				-- upvalues: t3 (copy), AvatarCreationService (copy)
				t3.displaySelfieQRCode(false)
				AvatarCreationService:HandleSelfieQRResult(false, "QR code closed before job completed")
			end
		}),
		Dialog = React.createElement(Dialog.Root, t4, {
			DialogContent = React.createElement(Dialog.Content, nil, {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = if not v23 then UDim.new(0, 10) else UDim.new(0, v45.Padding.Small)
				}),
				TopSpacer = React.createElement("Frame", {
					LayoutOrder = 0,
					Size = if not v23 then UDim2.new(0, 0, 0, 50) else UDim2.fromOffset(0, 56),
					BackgroundTransparency = not v23 and 1 or v45.Color.None.Transparency
				}),
				HoverFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					InteractiveArea = React.createElement("TextButton", {
						Text = "",
						Size = UDim2.new(0.65, 0, 0, 0),
						BackgroundTransparency = not v23 and 1 or v45.Color.ActionUtility.Background.Transparency,
						AutoButtonColor = false,
						[React.Event.MouseEnter] = function() -- line: 386
							-- upvalues: v26 (copy), v42 (copy), v24 (copy), v39 (copy), v41 (copy)
							if v26 and v42 then
								return
							end

							if v24 or v39 then
								v41(true)
							end
						end,
						[React.Event.MouseLeave] = function() -- line: 394
							-- upvalues: v41 (copy)
							v41(false)
						end,
						[React.Event.Activated] = function() -- line: 397
							-- upvalues: v26 (copy), v42 (copy), v24 (copy), v39 (copy), v38 (copy), v41 (copy)
							if v26 and v42 then
								return
							end

							if v24 or v39 then
								v38(true)

								if v26 then
									v41(false)
								end
							end
						end
					}, {
						Constraint = React.createElement("UIAspectRatioConstraint", {
							AspectRatio = 1,
							AspectType = Enum.AspectType.ScaleWithParentSize,
							DominantAxis = Enum.DominantAxis.Width
						}),
						BorderFrame = React.createElement("Frame", {
							Size = UDim2.new(0.98, 0, 0.98, 0),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = v45.Color.ActionEmphasis.Border.Transparency
						}, {
							Stroke = React.createElement("UIStroke", {
								Thickness = 3,
								Color = if not v23 then Color3.fromRGB(255, 255, 255) else v45.Color.Extended.White.White_0.Color3,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								LineJoinMode = Enum.LineJoinMode.Round,
								Transparency = if not v23 then not v40 and 1 or 0 else v40 and v45.Color.ActionEmphasis.Foreground.Transparency or v45.Color.ActionEmphasis.Border.Transparency
							}),
							Corner = React.createElement("UICorner", {
								CornerRadius = UDim.new(0.075, 0)
							})
						}),
						QRCodeArea = React.createElement(SelfieQRCodeView, {
							sideLength = 225,
							url = t3.url,
							outerSize = UDim2.new(0.95, 0, 0.95, 0),
							errorOccurred = if not v26 then nil else v42
						})
					})
				}),
				BottomSpacer = React.createElement("Frame", {
					LayoutOrder = 2,
					Size = if not v23 then UDim2.new(0, 0, 0, 30) else UDim2.fromOffset(0, v45.Gap.XXLarge),
					BackgroundTransparency = not v23 and 1 or v45.Color.None.Transparency
				}),
				TextContainerWrapper = React.createElement("Frame", {
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v45.Size.Size_2000),
					BackgroundTransparency = v45.Color.None.Transparency
				}, {
					Layout = if v26 then nil else React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					TextAndIconContainer = if not v26 then nil else React.createElement("Frame", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = v45.Color.None.Transparency
					}, {
						Layout = React.createElement("UIListLayout", {
							FillDirection = if not v42 then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							Padding = UDim.new(0, v45.Gap.Medium)
						}),
						WarningIcon = if not v42 then nil else React.createElement(Icon, {
							LayoutOrder = 1,
							name = Foundation.Enums.IconName.TriangleExclamation,
							size = v45.Size.Size_700,
							BackgroundTransparency = v45.Color.None.Transparency
						}),
						TextContent = React.createElement("Frame", {
							LayoutOrder = 2,
							Size = if not v42 then UDim2.fromScale(1, 0) else UDim2.new(1, -48, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = v45.Color.None.Transparency
						}, {
							Layout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								Padding = UDim.new(0, v45.Gap.Small)
							}),
							TitleText = React.createElement(Dialog.Text, {
								LayoutOrder = 3,
								Text = if not v42 then v46.title else v46.errorTitle,
								TextXAlignment = if not v42 then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left,
								Font = Enum.Font.SourceSansBold
							}),
							DialogText = React.createElement(Dialog.Text, {
								LayoutOrder = 4,
								Text = not v42 and "" or v46.errorBody,
								TextXAlignment = Enum.TextXAlignment.Left
							})
						})
					}),
					TitleText = if v26 then nil else React.createElement(Dialog.Text, {
						LayoutOrder = 3,
						Text = v46.title,
						Font = Enum.Font.SourceSansBold
					}),
					DialogText = if v26 then nil else React.createElement(Dialog.Text, {
						LayoutOrder = 4,
						Text = v46.body
					})
				})
			})
		})
	})
end
