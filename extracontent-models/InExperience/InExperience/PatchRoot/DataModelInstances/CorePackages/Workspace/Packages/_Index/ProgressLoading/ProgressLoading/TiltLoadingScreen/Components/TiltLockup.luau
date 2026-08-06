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

local function clamp01(n1: number) -- line: 47
	return (math.clamp(n1, 0, 1))
end
local function clipWindowHeight(t2: {[any]: any}) -- line: 51
	return (math.ceil(t2.FontSize * t2.LineHeight))
end
local function clippingFromReveal(p1) -- line: 55
	return p1:map(function(n2: number) -- line: 56
		return n2 < 0.999
	end)
end
local function TiltLockup(p2) -- line: 61
	-- upvalues: useTokens (copy), t1 (copy), React (copy), View (copy), TiltKeyart (copy), FoundationText (copy), VerifiedBadge (copy)
	local v21 = useTokens()
	local v22 = p2.animation or t1
	local EmphasisColor3 = v21.Color.Content.Emphasis.Color3
	local DefaultColor3 = v21.Color.Content.Default.Color3
	local EmphasisColor3_2 = v21.Color.System.Emphasis.Color3
	local HeadingLarge = v21.Typography.HeadingLarge
	local v27 = math.ceil(HeadingLarge.FontSize * HeadingLarge.LineHeight)
	local BodyMedium = v21.Typography.BodyMedium
	local v29 = math.ceil(BodyMedium.FontSize * BodyMedium.LineHeight)
	local v30 = v22.title.reveal:map(function(n3: number) -- line: 56
		return n3 < 0.999
	end)
	local v31 = v22.creator.reveal:map(function(n4: number) -- line: 56
		return n4 < 0.999
	end)
	local v32 = v22.title.reveal:map(function(n5: number) -- line: 74
		-- upvalues: EmphasisColor3 (copy)
		return {
			Color3 = EmphasisColor3,
			Transparency = 1 - math.clamp(n5, 0, 1)
		}
	end)
	local v33 = v22.creator.reveal:map(function(n6: number) -- line: 78
		-- upvalues: DefaultColor3 (copy)
		return {
			Color3 = DefaultColor3,
			Transparency = 1 - math.clamp(n6, 0, 1) * 0.6
		}
	end)
	local v34 = v22.verified.reveal:map(function(n7: number) -- line: 82
		-- upvalues: EmphasisColor3_2 (copy)
		return {
			Color3 = EmphasisColor3_2,
			Transparency = 1 - math.clamp(n7, 0, 1)
		}
	end)
	local v35 = v22.verified.reveal:map(function(n8: number) -- line: 86
		-- upvalues: v21 (copy)
		return {
			Color3 = v21.Color.Content.Emphasis.Color3,
			Transparency = 1 - math.clamp(n8, 0, 1)
		}
	end)
	local v36 = p2.thumbnailUrl or ""

	return React.createElement(View, {
		tag = "col align-x-center gap-large size-full-0 auto-y",
		testId = "tilt-lockup"
	}, {
		ArtTitle = React.createElement(View, {
			tag = "col align-x-center gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Card = React.createElement(TiltKeyart, {
				thumbnailUrl = v36,
				keyart = v22.keyart,
				frame = v22.frame
			}),
			TitleCreator = React.createElement(View, {
				tag = "col align-x-center gap-xsmall auto-y padding-y-xsmall",
				LayoutOrder = 2,
				Size = UDim2.new(0.8, 0, 0, 0)
			}, {
				TitleWrap = React.createElement(View, {
					LayoutOrder = 1,
					ClipsDescendants = v30,
					Size = UDim2.new(1, 0, 0, v27),
					padding = {
						top = v22.title.slide
					}
				}, {
					Title = React.createElement(FoundationText, {
						tag = "size-full text-heading-large text-no-wrap text-align-x-center text-align-y-center text-truncate-end",
						Text = p2.gameName or "",
						textStyle = v32
					})
				}),
				SubWrap = React.createElement(View, {
					tag = "col align-x-center align-y-center",
					LayoutOrder = 2,
					ClipsDescendants = v31,
					Size = UDim2.new(1, 0, 0, v29),
					padding = {
						top = v22.creator.slide
					}
				}, {
					Row = React.createElement(View, {
						tag = "row align-x-center align-y-center gap-xsmall size-full-0 auto-y"
					}, {
						Author = React.createElement(FoundationText, {
							tag = "shrink auto-xy text-body-medium text-no-wrap text-truncate-end",
							LayoutOrder = 1,
							Text = p2.creatorName or "",
							textStyle = v33
						}),
						Verified = if not p2.isCreatorVerified then nil else React.createElement(VerifiedBadge, {
							LayoutOrder = 2,
							backplateStyle = v34,
							checkStyle = v35
						})
					})
				})
			})
		})
	})
end

return React.memo(TiltLockup)
