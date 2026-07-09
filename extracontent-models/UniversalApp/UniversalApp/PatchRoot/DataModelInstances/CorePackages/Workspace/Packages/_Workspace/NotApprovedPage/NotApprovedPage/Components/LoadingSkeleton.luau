local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput

local function LoadingSkeleton() -- line: 25
	-- upvalues: useTokens (copy), usePreferredInput (copy), Responsive (copy), UserInputService (copy), GuiService (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local v15 = useTokens()
	local v16 = usePreferredInput() == Responsive.Input.Directional
	local StatusBarSizeY = UserInputService.StatusBarSize.Y
	local BottomBarSizeY = UserInputService.BottomBarSize.Y
	local bottom = GuiService:GetSafeZoneOffsets().bottom
	local v20 = if BottomBarSizeY ~= 0 then BottomBarSizeY else bottom

	return React.createElement(View, {
		tag = "size-full col align-x-center align-y-center bg-surface-0",
		padding = {
			top = UDim.new(0, StatusBarSizeY),
			bottom = UDim.new(0, v20)
		}
	}, {
		InnerContainer = React.createElement(View, {
			tag = "size-full col gap-large bg-surface-100 radius-large",
			LayoutOrder = 1,
			sizeConstraint = {
				MaxSize = if not v16 then Vector2.new(600, 800) else Vector2.new(800, 1000)
			}
		}, {
			HeaderSection = React.createElement(View, {
				tag = "size-full-0 auto-y row flex-between items-center gap-medium padding-xxlarge",
				LayoutOrder = 1
			}, {
				LeftContent = React.createElement(View, {
					tag = "auto-xy row gap-small items-center",
					LayoutOrder = 1
				}, {
					IconSkeleton = React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0, v15.Size.Size_800, 0, v15.Size.Size_800),
						radius = EnumsRadius.Circle
					}),
					LabelSkeleton = React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0, v15.Size.Size_3000, 0, v15.Size.Size_700),
						radius = EnumsRadius.Medium
					})
				}),
				RightContent = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 2
				}, {
					MenuSkeleton = React.createElement(Skeleton, {
						Size = UDim2.new(0, v15.Size.Size_800, 0, v15.Size.Size_800),
						radius = EnumsRadius.Circle
					})
				})
			}),
			Content = React.createElement(View, {
				tag = "size-full-0 grow",
				LayoutOrder = 2
			}, {
				ScrollView = React.createElement(ScrollView, {
					tag = "size-full",
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 1, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						VerticalScrollBarInset = Enum.ScrollBarInset.None,
						scrollBarVisibility = ScrollBarVisibility.Always
					}
				}, {
					Content = React.createElement(View, {
						tag = "size-full-0 auto-y col gap-xlarge padding-x-xxlarge"
					}, {
						PunishmentDescription = React.createElement(Skeleton, {
							LayoutOrder = 1,
							Size = UDim2.new(0.8, 0, 0, v15.Size.Size_500),
							radius = EnumsRadius.Medium
						}),
						WhatHappened = React.createElement(View, {
							tag = "size-full-0 auto-y col gap-medium",
							LayoutOrder = 2
						}, {
							Title = React.createElement(Skeleton, {
								LayoutOrder = 1,
								Size = UDim2.new(0.25, 0, 0, v15.Size.Size_700),
								radius = EnumsRadius.Medium
							}),
							Content = React.createElement(Skeleton, {
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, v15.Size.Size_2500),
								radius = EnumsRadius.Medium
							})
						}),
						ReviewedEvidence = React.createElement(View, {
							tag = "size-full-0 auto-y col gap-medium",
							LayoutOrder = 3
						}, {
							Title = React.createElement(Skeleton, {
								LayoutOrder = 1,
								Size = UDim2.new(0.25, 0, 0, v15.Size.Size_700),
								radius = EnumsRadius.Medium
							}),
							Content = React.createElement(Skeleton, {
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, v15.Size.Size_3000),
								radius = EnumsRadius.Medium
							})
						})
					})
				})
			}),
			Footer = React.createElement(View, {
				tag = "size-full-0 auto-y padding-x-xxlarge padding-bottom-xxlarge padding-top-medium bg-surface-100 radius-large",
				LayoutOrder = 3
			}, {
				TopCornerCover = React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, v15.Radius.Large),
					Position = UDim2.fromOffset(0, 0),
					BackgroundColor3 = v15.Color.Surface.Surface_100.Color3
				}),
				ButtonSkeleton = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, v15.Size.Size_1100),
					radius = EnumsRadius.Medium
				})
			})
		})
	})
end

return React.memo(LoadingSkeleton)
