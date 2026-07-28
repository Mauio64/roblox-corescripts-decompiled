local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local ParentParent = TiltLoadingScreen.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local TiltKeyart = require(TiltLoadingScreen.Components.TiltKeyart)
local VerifiedBadge = require(TiltLoadingScreen.Components.VerifiedBadge)
local Constants = require(TiltLoadingScreen.Constants)

require(TiltLoadingScreen.Types)

local TILT_DEGREES = Constants.KEYART.TILT_DEGREES
local t1 = {
	keyart = {
		rotation = React.createBinding(TILT_DEGREES),
		sizeScale = React.createBinding(1),
		coverTransparency = React.createBinding(1)
	},
	frame = {
		rotation = React.createBinding(-TILT_DEGREES),
		sizeScale = React.createBinding(1),
		groupTransparency = React.createBinding(0)
	},
	title = {
		reveal = React.createBinding(1),
		slide = React.createBinding(UDim.new(0, 0))
	},
	creator = {
		reveal = React.createBinding(1),
		slide = React.createBinding(UDim.new(0, 0))
	},
	verified = {
		reveal = React.createBinding(1)
	}
}

local function clamp01(n1: number) -- line: 43
	return (math.clamp(n1, 0, 1))
end
local function TiltLockup(p1) -- line: 47
	-- upvalues: useTokens (copy), t1 (copy), React (copy), View (copy), TiltKeyart (copy), FoundationText (copy), VerifiedBadge (copy)
	local v17 = useTokens()
	local v18 = p1.animation or t1
	local EmphasisColor3 = v17.Color.Content.Emphasis.Color3
	local DefaultColor3 = v17.Color.Content.Default.Color3
	local EmphasisColor3_2 = v17.Color.System.Emphasis.Color3
	local FontSize = v17.Typography.HeadingLarge.FontSize
	local FontSize2 = v17.Typography.BodyMedium.FontSize
	local v24 = v18.title.reveal:map(function(n2: number) -- line: 57
		-- upvalues: EmphasisColor3 (copy)
		return {
			Color3 = EmphasisColor3,
			Transparency = 1 - math.clamp(n2, 0, 1)
		}
	end)
	local v25 = v18.creator.reveal:map(function(n3: number) -- line: 61
		-- upvalues: DefaultColor3 (copy)
		return {
			Color3 = DefaultColor3,
			Transparency = 1 - math.clamp(n3, 0, 1) * 0.6
		}
	end)
	local v26 = v18.verified.reveal:map(function(n4: number) -- line: 65
		-- upvalues: EmphasisColor3_2 (copy)
		return {
			Color3 = EmphasisColor3_2,
			Transparency = 1 - math.clamp(n4, 0, 1)
		}
	end)
	local v27 = v18.verified.reveal:map(function(n5: number) -- line: 69
		-- upvalues: v17 (copy)
		return {
			Color3 = v17.Color.Content.Emphasis.Color3,
			Transparency = 1 - math.clamp(n5, 0, 1)
		}
	end)
	local v28 = p1.thumbnailUrl or ""

	return React.createElement(View, {
		tag = "col align-x-center gap-large size-full-0 auto-y",
		testId = "tilt-lockup"
	}, {
		ArtTitle = React.createElement(View, {
			tag = "col align-x-center gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Card = React.createElement(TiltKeyart, {
				thumbnailUrl = v28,
				keyart = v18.keyart,
				frame = v18.frame
			}),
			TitleCreator = React.createElement(View, {
				tag = "col align-x-center gap-xsmall auto-y padding-y-xsmall",
				LayoutOrder = 2,
				Size = UDim2.new(0.8, 0, 0, 0)
			}, {
				TitleWrap = React.createElement(View, {
					tag = "clip",
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, FontSize),
					padding = {
						top = v18.title.slide
					}
				}, {
					Title = React.createElement(FoundationText, {
						tag = "size-full text-heading-large text-no-wrap text-align-x-center text-truncate-end",
						Text = p1.gameName or "",
						textStyle = v24
					})
				}),
				SubWrap = React.createElement(View, {
					tag = "col align-x-center clip",
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, FontSize2),
					padding = {
						top = v18.creator.slide
					}
				}, {
					Row = React.createElement(View, {
						tag = "row align-x-center align-y-center gap-xsmall size-full-0 auto-y"
					}, {
						Author = React.createElement(FoundationText, {
							tag = "shrink auto-xy text-body-medium text-no-wrap text-truncate-end",
							LayoutOrder = 1,
							Text = p1.creatorName or "",
							textStyle = v25
						}),
						Verified = if not p1.isCreatorVerified then nil else React.createElement(VerifiedBadge, {
							LayoutOrder = 2,
							backplateStyle = v26,
							checkStyle = v27
						})
					})
				})
			})
		})
	})
end

return React.memo(TiltLockup)
