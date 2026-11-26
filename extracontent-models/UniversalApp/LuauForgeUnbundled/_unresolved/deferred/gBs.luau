local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/deferred/gzS")

local module2 = require("@luauforge/deferred/gzT")
local radius = module2.Enums.Radius
local scrollBarVisibility = module2.Enums.ScrollBarVisibility
local scrollView = module2.ScrollView
local skeleton = module2.Skeleton
local useTokens = module2.Hooks.useTokens
local view = module2.View

local module3 = require("@luauforge/deferred/gAB")
local usePreferredInput = module3.usePreferredInput

local function LoadingSkeleton()
	local v5 = useTokens()
	local v6 = usePreferredInput() == module3.Input.Directional

	local y = UserInputService.StatusBarSize.Y
	local y2 = UserInputService.BottomBarSize.Y
	local v7 = GuiService:GetSafeZoneOffsets().bottom

	if y2 ~= 0 then
		v7 = y2
	end

	local createElement = module.createElement
	local v9 = {
		tag = "size-full col align-x-center align-y-center bg-surface-0",
		padding = { top = UDim.new(0, y), bottom = UDim.new(0, v7) }
	}

	local createElement2 = module.createElement

	local v14 = if v6 then Vector2.new(800, 1000) else Vector2.new(600, 800)
	return createElement(view, v9, {
		InnerContainer = createElement2(view, {
			tag = "size-full col gap-large bg-surface-100 radius-large",
			sizeConstraint = { MaxSize = v14 },
			LayoutOrder = 1
		}, {
			HeaderSection = module.createElement(
				view,
				{
					tag = "size-full-0 auto-y row flex-between items-center gap-medium padding-xxlarge",
					LayoutOrder = 1
				},
				{
					LeftContent = module.createElement(
						view,
						{ tag = "auto-xy row gap-small items-center", LayoutOrder = 1 },
						{
							IconSkeleton = module.createElement(skeleton, {
								Size = UDim2.new(0, v5.Size.Size_800, 0, v5.Size.Size_800),
								radius = radius.Circle,
								LayoutOrder = 1
							}),
							LabelSkeleton = module.createElement(skeleton, {
								Size = UDim2.new(0, v5.Size.Size_3000, 0, v5.Size.Size_700),
								radius = radius.Medium,
								LayoutOrder = 2
							})
						}
					),
					RightContent = module.createElement(view, {
						tag = "auto-xy",
						LayoutOrder = 2
					}, {
						MenuSkeleton = module.createElement(skeleton, {
							Size = UDim2.new(0, v5.Size.Size_800, 0, v5.Size.Size_800),
							radius = radius.Circle
						})
					})
				}
			),
			Content = module.createElement(view, {
				tag = "size-full-0 grow",
				LayoutOrder = 2
			}, {
				ScrollView = module.createElement(scrollView, {
					tag = "size-full",
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 1, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						VerticalScrollBarInset = Enum.ScrollBarInset.None,
						scrollBarVisibility = scrollBarVisibility.Always
					}
				}, {
					Content = module.createElement(
						view,
						{ tag = "size-full-0 auto-y col gap-xlarge padding-x-xxlarge" },
						{
							PunishmentDescription = module.createElement(skeleton, {
								Size = UDim2.new(0.8, 0, 0, v5.Size.Size_500),
								radius = radius.Medium,
								LayoutOrder = 1
							}),
							WhatHappened = module.createElement(
								view,
								{
									tag = "size-full-0 auto-y col gap-medium",
									LayoutOrder = 2
								},
								{
									Title = module.createElement(skeleton, {
										Size = UDim2.new(0.25, 0, 0, v5.Size.Size_700),
										radius = radius.Medium,
										LayoutOrder = 1
									}),
									Content = module.createElement(skeleton, {
										Size = UDim2.new(1, 0, 0, v5.Size.Size_2500),
										radius = radius.Medium,
										LayoutOrder = 2
									})
								}
							),
							ReviewedEvidence = module.createElement(
								view,
								{
									tag = "size-full-0 auto-y col gap-medium",
									LayoutOrder = 3
								},
								{
									Title = module.createElement(skeleton, {
										Size = UDim2.new(0.25, 0, 0, v5.Size.Size_700),
										radius = radius.Medium,
										LayoutOrder = 1
									}),
									Content = module.createElement(skeleton, {
										Size = UDim2.new(1, 0, 0, v5.Size.Size_3000),
										radius = radius.Medium,
										LayoutOrder = 2
									})
								}
							)
						}
					)
				})
			}),
			Footer = module.createElement(
				view,
				{
					tag = "size-full-0 auto-y padding-x-xxlarge padding-bottom-xxlarge padding-top-medium bg-surface-100 radius-large",
					LayoutOrder = 3
				},
				{
					TopCornerCover = module.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, v5.Radius.Large),
						Position = UDim2.fromOffset(0, 0),
						BackgroundColor3 = v5.Color.Surface.Surface_100.Color3,
						BorderSizePixel = 0
					}),
					ButtonSkeleton = module.createElement(skeleton, {
						Size = UDim2.new(1, 0, 0, v5.Size.Size_1100),
						radius = radius.Medium
					})
				}
			)
		})
	})
end

return module.memo(LoadingSkeleton)
