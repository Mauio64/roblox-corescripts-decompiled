local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local parent = TiltLoadingScreen.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local TiltKeyart = require(TiltLoadingScreen.Components.TiltKeyart)
local VerifiedBadge = require(TiltLoadingScreen.Components.VerifiedBadge)
local VerifiedBadge2 = require(parent.VerifiedBadges.VerifiedBadge)
local SharedFlags = require(parent.SharedFlags)
local FFlagUnifyVerifiedBadgeComponent = SharedFlags.FFlagUnifyVerifiedBadgeComponent
local Constants = require(TiltLoadingScreen.Constants)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags2.FFlagLoadingScreenMilestones

require(TiltLoadingScreen.Types)

local TILT_DEGREES = Constants.KEYART.TILT_DEGREES

local v = {
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
	verified = { reveal = React.createBinding(1) }
}

local function clamp01(value: number) -- 4 equivalent calls inferred from this helper
	return (math.clamp(value, 0, 1))
end

local function clipWindowHeight(p) -- 2 equivalent calls inferred from this helper
	return (math.ceil(p.FontSize * p.LineHeight))
end

local function clippingFromReveal(object)
	return object:map(function(p: number): boolean
		return p < 0.999
	end)
end

local function TiltLockup(props)
	local v2 = useTokens()
	local animation = props.animation or v

	local color3 = v2.Color.Content.Emphasis.Color3
	local color3_2 = v2.Color.Content.Default.Color3
	local color3_3 = v2.Color.System.Emphasis.Color3
	local v3 = clipWindowHeight(v2.Typography.HeadingLarge) -- inferred equivalent call
	local v4 = clipWindowHeight(v2.Typography.BodyMedium) -- inferred equivalent call

	local function fn(p: number): boolean
		return p < 0.999
	end

	local mapped = animation.title.reveal:map(fn)
	local mapped2 = animation.creator.reveal:map(fn)

	local mapped3 = animation.title.reveal:map(function(value: number)
		return {
			Color3 = color3,
			Transparency = 1 - clamp01(value) -- inferred equivalent call
		}
	end)

	local mapped4 = animation.creator.reveal:map(function(value: number)
		return {
			Color3 = color3_2,
			Transparency = 1 - clamp01(value) * 0.6 -- inferred equivalent call
		}
	end)

	local mapped5 = animation.verified.reveal:map(function(value: number)
		return {
			Color3 = color3_3,
			Transparency = 1 - clamp01(value) -- inferred equivalent call
		}
	end)

	local mapped6 = animation.verified.reveal:map(function(value: number)
		return {
			Color3 = v2.Color.Content.Emphasis.Color3,
			Transparency = 1 - clamp01(value) -- inferred equivalent call
		}
	end)

	local thumbnailUrl = props.thumbnailUrl or ""

	local v5 = not FFlagLoadingScreenMilestones and "Card" or "Card_" .. thumbnailUrl
	local textWidthScale = props.textWidthScale or 0.8

	local createElement = React.createElement

	local createElement2 = React.createElement

	local v6 = {
		Card = React.createElement(TiltKeyart, {
			key = v5,
			thumbnailUrl = thumbnailUrl,
			onThumbnailLoaded = props.onThumbnailLoaded,
			keyart = animation.keyart,
			frame = animation.frame
		}),
		TitleCreator = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		tag = "col align-x-center gap-xsmall auto-y padding-y-xsmall",
		Size = UDim2.new(textWidthScale, 0, 0, 0),
		LayoutOrder = 2
	}

	local v8 = {
		TitleWrap = React.createElement(View, {
			ClipsDescendants = mapped,
			Size = UDim2.new(1, 0, 0, v3),
			padding = { top = animation.title.slide },
			LayoutOrder = 1
		}, {
			Title = React.createElement(Text, {
				tag = "size-full text-heading-large text-no-wrap text-align-x-center text-align-y-center text-truncate-end",
				Text = props.gameName or "",
				textStyle = mapped3
			})
		}),
		SubWrap = 0
	}

	local createElement4 = React.createElement
	local v9 = {
		tag = "col align-x-center align-y-center",
		ClipsDescendants = mapped2,
		Size = UDim2.new(1, 0, 0, v4),
		padding = { top = animation.creator.slide },
		LayoutOrder = 2
	}

	local createElement5 = React.createElement

	local v10 = {
		Author = React.createElement(Text, {
			tag = "shrink auto-xy text-body-medium text-no-wrap text-truncate-end",
			Text = props.creatorName or "",
			textStyle = mapped4,
			LayoutOrder = 1
		}),
		Verified = 0
	}
	local verified

	if props.isCreatorVerified then
		if FFlagUnifyVerifiedBadgeComponent then
			verified = React.createElement(VerifiedBadge2, {
				backplateStyle = mapped5,
				checkStyle = mapped6,
				LayoutOrder = 2,
				testId = "tilt-verified-badge"
			})
		else
			verified = React.createElement(VerifiedBadge, {
				backplateStyle = mapped5,
				checkStyle = mapped6,
				LayoutOrder = 2
			})
		end
	end

	v10.Verified = verified
	v8.SubWrap = createElement4(View, v9, {
		Row = createElement5(View, {
			tag = "row align-x-center align-y-center gap-xsmall size-full-0 auto-y"
		}, v10)
	})
	v6.TitleCreator = createElement3(View, v7, v8)
	return createElement(View, {
		tag = "col align-x-center gap-large size-full-0 auto-y",
		testId = "tilt-lockup"
	}, {
		ArtTitle = createElement2(
			View,
			{ tag = "col align-x-center gap-small size-full-0 auto-y", LayoutOrder = 1 },
			v6
		)
	})
end

return React.memo(TiltLockup)
